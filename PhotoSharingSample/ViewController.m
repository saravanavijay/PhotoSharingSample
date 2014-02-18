//
//  ViewController.m
//  PhotoSharingSample
//
//  Created by Saravana vijaya kumar Amirthalingam on 18/02/14.
//  Copyright (c) 2014 debuggify. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSelectImgClick:(id)sender {
    
    //Asks permissions for the first time and opens up the Native Gallery
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];

    
}

- (IBAction)btnShareonFBClick:(id)sender {
    
    if (imageView.image) {
        [FBSession openActiveSessionWithReadPermissions:@[@"email", @"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Image" message:@"Please select an image from Photos Library" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
      switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions",@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                    if (FBSession.activeSession.isOpen && !error) {
                        [self ShareImageToFaceBook:imageView.image];
                    }
                    else if(error)
                    {
                        [self AuthenticationFailed:error];
                    }
                }];
            }
            else
            {
                [self AuthenticationFailed:error];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [self AuthenticationFailed:error];
            break;
        default:
            break;
    }
}
-(void)AuthenticationFailed:(NSError *)error{
    if (error) {
        NSString *alertTitle;
        NSString *alertMessage;
        
        if (error.fberrorShouldNotifyUser) {
            if ([[error userInfo][FBErrorLoginFailedReason]
                 isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue]) {
                alertTitle = @"Permission Denied";
                alertMessage = @"Go to Settings > Facebook and Reset Permission for Photo Sharing.";
            } else {
                alertTitle = @"Something Went Wrong";
                alertMessage = error.fberrorUserMessage;
            }
        } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
            alertTitle = @"Facebook Issue";
            alertMessage = @"Your Facebook account was recently changed. Open your device’s settings, click on Facebook, and confirm your password.";
            NSLog(@"user cancelled login");
        }else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertTitle = @"Session Error";
            alertMessage = @"Your current session is no longer valid. Please log in again.";
        } else {
            alertTitle  = @"Unknown Error";
            alertMessage = @"Error. Please try again later.";
            NSLog(@"Unexpected error:%@", error);
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:alertTitle
                                  message:alertMessage
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView setTag: 9457];
        [alertView show];
    }
}

-(void)ShareImageToFaceBook:(UIImage *)image
{
    NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         UIImagePNGRepresentation(image),@"source",
                                         @"#PhotoSharing",@"message",
                                         nil];
    
    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:photosParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
         
         UIAlertView *alertView;
         if (error) {
            alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
         }
         else
         {
             alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your Photo has been posted in Facebook" delegate:nil                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
         }
        [alertView show];
         
     }];
}

#pragma mark ImagePickeDelegate Methods
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = nil;
    
    //Get edited image from delegate method
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    imageView.image = image;
    
}
@end
