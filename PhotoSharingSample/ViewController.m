//
//  ViewController.m
//  PhotoSharingSample
//
//  Created by Saravana vijaya kumar Amirthalingam on 18/02/14.
//  Copyright (c) 2014 debuggify. All rights reserved.
//

#import "ViewController.h"

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
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Image" message:@"Please select an image from Photos Library" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
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
