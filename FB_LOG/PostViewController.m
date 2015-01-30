//
//  PostViewController.m
//  FB_LOG
//
//  Created by Patipat on 12/6/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import "PostViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Toast+UIView.h"
@interface PostViewController ()<UITextFieldDelegate,FBLoginViewDelegate>
@end

@implementation PostViewController
@synthesize imgg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   }

-(void)viewWillAppear:(BOOL)animated
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if(user.id!=nil)
         {
             
             /*
             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
             picker.delegate = self;
             picker.allowsEditing = YES;
             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
             UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
             [button setTitle:@"Library" forState:UIControlStateNormal];
             [button setBackgroundColor:[UIColor darkGrayColor]];
             [button addTarget:self action:@selector(gotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
             
             [picker.view addSubview:button];
             [self presentViewController:picker animated:YES completion:NULL];
              */
         }
         else
         {
             [self.view.window makeToast:@"Please login frist!!"];
             [self.navigationController popToRootViewControllerAnimated:YES];
             [self.tabBarController setSelectedIndex:0];
         }
     }];
    
    //[self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imgg.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.tabBarController setSelectedIndex:1];


}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)upload:(id)sender {
    [self.cap resignFirstResponder];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
             [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
             [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
             self.cap.enabled = NO;
             self.btupload.enabled = NO;
             
             [self.view makeToastActivity];
             NSString *uid = user.id;
             NSString *capt = self.cap.text;
             
             // Build the request body
             NSString *boundary = @"PuzzleApp";
             NSMutableData *body = [NSMutableData data];
             // uid
             [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"uid"] dataUsingEncoding:NSUTF8StringEncoding]];
             [body appendData:[[NSString stringWithFormat:@"%@\r\n", uid] dataUsingEncoding:NSUTF8StringEncoding]];
             //capt
             [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"caption"] dataUsingEncoding:NSUTF8StringEncoding]];
             [body appendData:[[NSString stringWithFormat:@"%@\r\n", capt] dataUsingEncoding:NSUTF8StringEncoding]];
             // Body part for the attachament. This is an image.
             NSData *imageData = UIImageJPEGRepresentation(imgg.image, 1);
             if (imageData) {
                 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:imageData];
                 [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
             }
             [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             
             // Setup the session
             NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
             sessionConfiguration.HTTPAdditionalHeaders = @{
                                                            @"api-key"       : @"55e76dc4bbae25b066cb",
                                                            @"Accept"        : @"application/json",
                                                            @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
                                                            };
             
             // Create the session
             // We can use the delegate to track upload progress
             NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
             
             // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
             NSURL *url = [NSURL URLWithString:@"http://www.s2td.com/upload-ios.php"];
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
             request.HTTPMethod = @"POST";
             request.HTTPBody = body;
             NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                 // Process the response
                 NSString *charlieSendString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 [self.view hideToastActivity];
                 NSLog(charlieSendString);
                 if([charlieSendString isEqualToString:@"DONE"])
                 {
                    [self.view.window  makeToast:@"Upload Successful" duration:2.0 position:@"bottom"];
                     self.cap.text = @"";
                     self.imgg.image = [UIImage imageNamed:@"uppic.jpg"];
                     [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
                     [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
                     [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
                     self.cap.enabled = YES;
                     self.btupload.enabled = YES;
                     //[self.tabBarController setSelectedIndex:1];
                 }
                 else
                 {
                     [self.view.window  makeToast:@"Uppload Failed" duration:2.0 position:@"bottom"];
                     //[self.tabBarController setSelectedIndex:1];
                 }
                 
             }];
             [uploadTask resume];

         }
     }];

    }
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}
- (IBAction)edit:(id)sender {
    int count = [self.cap.text length];
    if(count >20)
    {
        [self.view.window  makeToast:@"Maximum caption is 20 letter." duration:2.0 position:@"top"];
        NSString *newString = [self.cap.text substringToIndex:20];
        self.cap.text = newString;
        count = [self.cap.text length];
    }
    self.counter.text = [NSString stringWithFormat:@"%d / 20",count];
}
- (IBAction)callActionSheet:(id)sender {
    UIActionSheet *aceSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take photo" otherButtonTitles:@"Camera Roll", nil];
    [aceSheet showFromTabBar:self.tabBarController.tabBar];
}
@end
