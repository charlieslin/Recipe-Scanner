//
//  ViewController.m
//  Recipe Scanner
//
//  Created by Charlie Lin on 6/25/13.
//  Copyright (c) 2013 Charlie Lin. All rights reserved.
//

#import "ViewController.h"

using namespace std;
using namespace cv;

@interface ViewController ()

@end

@implementation ViewController

@synthesize capturedImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.capturedImage = nil;
    // Dispose of any resources that can be recreated.
}

- (void)showActionSheet:(UIActionSheet *)actionSheet {
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)startCamera:(id)sender {
    UIActionSheet *chooseCameraOrPhoto = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Choose from library", nil];
    
    [self showActionSheet:chooseCameraOrPhoto];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)  {
        case 0: [self startCameraControllerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1: [self startCameraControllerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            break;
        case 2: //myalert = [[UIAlertView alloc] initWithTitle:@"story -> text" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            break;
    }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate sourceType:(UIImagePickerControllerSourceType)sourceType {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          sourceType] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate = self;
    cameraUI.sourceType = sourceType;
    
    //allow only still images
    cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    
    cameraUI.allowsEditing = YES;
    
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSLog(@"finished capturing");
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;

    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"];
    
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)  {
            // Save the new image (original or edited) to the Camera Roll
            //UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        }
    }
    
    [self.capturedImage setImage:imageToSave];
    [tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]];
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}


@end
