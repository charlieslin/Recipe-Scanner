//
//  ViewController.h
//  Recipe Scanner
//
//  Created by Charlie Lin on 6/25/13.
//  Copyright (c) 2013 Charlie Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Tesseract.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GPUImage.h"

@interface ViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *capturedImage;
    UITextView *ocrText;
}

@property (strong, nonatomic) IBOutlet UITextView *ocrText;
@property (strong, nonatomic) IBOutlet UIImageView* capturedImage;

- (IBAction)startCamera:(id)sender;

-(void)showActionSheet:(UIActionSheet*) actionSheet;

-(BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                  usingDelegate: (id <UIImagePickerControllerDelegate,
                                                  UINavigationControllerDelegate>) delegate sourceType:(UIImagePickerControllerSourceType)sourceType;

-(void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;

-(void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info;

@end
