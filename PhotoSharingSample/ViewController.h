//
//  ViewController.h
//  PhotoSharingSample
//
//  Created by Saravana vijaya kumar Amirthalingam on 18/02/14.
//  Copyright (c) 2014 debuggify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)btnSelectImgClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSelectImg;
@property (weak, nonatomic) IBOutlet UIButton *btnShareonFB;
- (IBAction)btnShareonFBClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
