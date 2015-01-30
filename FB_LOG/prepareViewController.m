//
//  prepareViewController.m
//  FB_LOG
//
//  Created by Earther on 10/12/2013.
//  Copyright (c) 2013 Patipat. All rights reserved.
//

#import "prepareViewController.h"
#import "Toast+UIView.h"
#import <FacebookSDK/FacebookSDK.h>

@interface prepareViewController ()
{
    NSMutableArray *ImageCrop;
    UIImage *OriginalImage;
    NSMutableArray *indexcheck;
    int seletedImage;
    BOOL selected;
    int swapcount;
    CGPoint originposition;
    BOOL timer;
    NSTimer *gametimer;
    double playtime;
}

@end

@implementation prepareViewController
@synthesize data;
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
    NSString *tString = [NSString stringWithFormat:@"http://s2td.com/iosimg/%@",data.imgpath];
    self.view.multipleTouchEnabled = NO;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",data.imgpath]];
    //  NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];

    if (tttImg != nil) {
        OriginalImage = tttImg;
        [self CropImage];
    }else{
        NSLog(tString);
        OriginalImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tString]]];
        [self CropImage];
    }
    NSLog([data name]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:data.timeupload];
    NSDate* currentDate = [NSDate date];
    NSTimeInterval diff = [currentDate timeIntervalSinceDate:dateFromString];
    NSString *outtime;
    NSLog([NSString stringWithFormat:@"%f",diff]);
    if(diff<60)
    {
        outtime = [NSString stringWithFormat:@"a secound ago"];
    }
    else if (diff>=60 && diff<3600)
    {
        double diffm = diff/60;
        outtime = [NSString stringWithFormat:@"%d minute ago",(int)diffm];
        
    }
    else if (diff>=3600 &&diff <86400)
    {
        double diffh = diff/3600;
        outtime = [NSString stringWithFormat:@"%d hour ago",(int)diffh];
    }
    else
    {
        double diffd = diff/86400;
        outtime = [NSString stringWithFormat:@"%d day ago",(int)diffd];
    }

    self.time.text = @"Waiting for Start..";
    self.like.text = [NSString stringWithFormat:@"%@ Like",data.likecount];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swapImage:(int)x And:(int)y{
    float aa,bb;
    aa = [[indexcheck objectAtIndex:x] intValue];
    bb = [[indexcheck objectAtIndex:y] intValue];
    [indexcheck replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:bb]];
    [indexcheck replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:aa]];
    
    UIImageView *a;
    UIImageView *b;
    UIImage *c;
    a = [self getUIImageView:x];
    c = [a image];
    b = [self getUIImageView:y];
    a.image = [b image];
    b.image = c;
}

-(UIImageView *)getUIImageView:(int)tag{
    for (UIView *subview in self.view.subviews) {
		if(subview.tag==tag)
            if ([subview isKindOfClass:[UIImageView class]]) {
                return subview;
            }
	}
    return nil;
}

-(void)swapRandomPosition{
    for (int i=0; i<16; i++) {
        [self swapImage:arc4random()%16 And:arc4random()%16];
    }
}


/*-(void)actionHandleTapOnImageView:(id)sender
{
    UIGestureRecognizer *tmp = sender;
    int sendTag = [[sender view] tag];
    if (seletedImage==-1) {
        seletedImage = sendTag;
        [self getUIImageView:sendTag].alpha = 0.3;
    }else{
        [self getUIImageView:seletedImage].alpha = 1;
        if (seletedImage != sendTag) {
            swapcount++;
            [self swapImage:seletedImage And:sendTag];
        }
        seletedImage = -1; // deselect
    }
    [self checkComplete];
    NSLog(@"actionHandleTapOnImageView %i",tmp.view.tag);
    
}*/

-(void)CropImage{
    playtime = 0;
    seletedImage = -1;
    swapcount = 0;
    timer = NO;
    self.time.text = @"Waiting for Start..";
    //indexcheck = [[NSMutableArray alloc]initWithCapacity:10];
    
    [[self getUIImageView:100] removeFromSuperview];
    CGPoint startPosition = CGPointMake(20, 22);
    indexcheck = [[NSMutableArray alloc]initWithCapacity:17];
    
    
    //UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(startPosition.x, startPosition.y, 90, 90)];
    CGFloat imageWidth = (OriginalImage.size.width/4);
    CGFloat imageHeight = (OriginalImage.size.height/4);
    CGPoint startCrop = CGPointMake(0, 0-imageHeight);
    CGRect newSize;
    CGImageRef tmp;
    UIImage *newImage;
    
    
    for (int i=0; i<16; i++) {
        if (i%4 == 0) {
            startPosition.x = 20;
            startPosition.y +=70;
            startCrop.x = 0;
            startCrop.y += imageHeight;
        }
        UIImageView *imageHolder;
        if ([self getUIImageView:i] == nil) {
            imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(startPosition.x, startPosition.y, 70, 70)];
            imageHolder.userInteractionEnabled = YES;
            imageHolder.multipleTouchEnabled =NO;
        }else{
            imageHolder = [self getUIImageView:i];
        }
        /*
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(actionHandleTapOnImageView:)];
        [singleTap setNumberOfTouchesRequired:1];
        singleTap.view.tag = i;
        imageHolder.userInteractionEnabled = YES;
        */
        newSize = CGRectMake(startCrop.x, startCrop.y, imageWidth, imageHeight);
        tmp = CGImageCreateWithImageInRect([OriginalImage CGImage], newSize);
        newImage = [UIImage imageWithCGImage:tmp];
        // Be good memory citizens and release the memory
        CGImageRelease(tmp);
        imageHolder.image = newImage;
        //imageHolder.image = [self imageWithBorderFromImage:newImage];
        // optional:
        // [imageHolder sizeToFit];
        imageHolder.tag = i;
        imageHolder.userInteractionEnabled = YES;
        //[imageHolder.layer setShadowOffset:CGSizeMake(-1, -1)];
        //[imageHolder.layer setShadowOpacity:0.5];
        /*
        imageHolder.layer.shadowColor = [UIColor blackColor].CGColor;
        imageHolder.layer.shadowOffset = CGSizeMake(0, 1);
        imageHolder.layer.shadowOpacity = 1;
        imageHolder.layer.shadowRadius = 1.0;
        imageHolder.clipsToBounds = NO;
        */
        
        imageHolder.layer.borderColor = [[[UIColor alloc] initWithWhite:1 alpha:0.5] CGColor];
        imageHolder.layer.borderWidth = 1;
        //[imageHolder addGestureRecognizer:singleTap];
        [indexcheck addObject:[NSNumber numberWithInt:i]];
        [self.view addSubview:imageHolder];
        [ImageCrop addObject:imageHolder];
        startPosition.x += 70;
        startCrop.x += imageWidth;
        //startPosition.y += 90;
        //NSLog(@"X: %f",startPosition.x);
    }
    [self swapRandomPosition];
}
-(bool)isCorrectImage{
    int i;
    for (i=0; i<16; i++) {
        if([[indexcheck objectAtIndex:i] integerValue] != i)
            break;
    }
    if (i==16) {
        return YES;
    }else{
        return NO;
    }
}
-(void)checkComplete{
    if ([self isCorrectImage]) {
        [gametimer invalidate];
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {

        double scores = 100000/(playtime*0.8+swapcount*0.2);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/addios.php"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *s = [NSString stringWithFormat:@"type=addscore&uid=%@&imgno=%@&score=%.f",user.id,data.imgno,scores];
        NSLog(s);
        NSString * params =s;
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(data.imgpath);
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *datas, NSURLResponse *response, NSError *error) {
                                                               NSString *charlieSendString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
                                                               NSLog(@"Response:%@ %@\n", charlieSendString, error);
                                                               if(error == nil)
                                                               {
                                                                   if([charlieSendString isEqualToString:@"ADDSCORE"])
                                                                      {
                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good Job !!!" message:[NSString stringWithFormat:@"You WIN with %.0f score",scores] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                          [alert show];
                                                                      }
                                                                      else
                                                                      {
                                                                          [self.view.window  makeToast:@"Cannot upload your score.." duration:2.0 position:@"buttom"];

                                                                          
                                                                      }
                                                               }
                                                               
                                                               NSLog(@"Load data sucesses !!!");
                                                               
                                                               /////////// Default DATA type
                                                               /*NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                foo = [[text componentsSeparatedByString:@","]mutableCopy];
                                                                [self.tableView reloadData];*/
                                                               ////////////
                                                           }];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [dataTask resume];

         }];
        [self displayFullImage];
        [self removeUIImageView];
    }
}

-(void)removeUIImageView{
    for (int i=0; i<16; i++) {
        [[self getUIImageView:i] removeFromSuperview];
    }
}
-(void)displayFullImage{
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(20, 92, 280, 280)];
    imageHolder.image = OriginalImage;
    imageHolder.tag = 100;
    [self.view addSubview:imageHolder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[UIImageView class]])
    {
        if (!timer) {
            timer = TRUE;
            gametimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
        }
        //add your code for image touch here
        originposition = touch.view.center;
        touch.view.alpha = 0.3;
        
        NSLog(@"Touch %@",[touch.view description]);
        for (int j=0; j<16; j++) {
            UIImageView *imgview = [self getUIImageView:j];
            if (imgview.tag != touch.view.tag) {
                imgview.userInteractionEnabled = NO;
            }
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if ([touch.view isKindOfClass:[UIImageView class]])
    {
        //add your code for image touch here
        NSLog(@"Untouch X:%f  Y:%f %@",(touchLocation.x-20)/92,(touchLocation.y-92)/92,touch.view);
        int x = (touchLocation.x-20)/70;
        int y = (touchLocation.y-70)/70;
        int destSwap = x+y*4;
        int tag = touch.view.tag;
        if (destSwap>=0 && destSwap<=16) {
            if(destSwap != tag){
                swapcount++;
                [self swapImage:tag And:destSwap];
                [self checkComplete];
            }
        }
        touch.view.alpha = 1.0;
        touch.view.center = originposition;
        for (int j=0; j<16; j++) {
            UIImageView *imgview = [self getUIImageView:j];
            imgview.userInteractionEnabled = YES;
            
        }
        NSLog(@"Untouch on %i",x+y*3);
    
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if ([touch.view isKindOfClass:[UIImageView class]])
    {
        //add your code for image touch here
        touch.view.center = touchLocation;
        [self.view bringSubviewToFront:touch.view];
        //NSLog(@"Touch %@",[touch.view description]);
    }
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

- (IBAction)exit:(id)sender {
    UIActionSheet *ach = [[UIActionSheet alloc] initWithTitle:@"Are you sure ?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Exit" otherButtonTitles:nil, nil];
    ach.tag = 111222;
    [ach showInView:self.view];
}

- (IBAction)replay:(id)sender {
    UIActionSheet *ach = [[UIActionSheet alloc] initWithTitle:@"Do you want to replay ?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Replay" otherButtonTitles:nil, nil];
    ach.tag = 222111;
    [ach showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 111222) {
        if (buttonIndex==0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (actionSheet.tag == 222111) {
        if (buttonIndex==0) {
            [gametimer invalidate];
            
            [self CropImage];
        }
    }
}
- (void)increaseTimerCount
{
    self.time.text = [NSString stringWithFormat:@"%.1f Secounds", playtime+=0.1];
}
@end
