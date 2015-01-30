//
//  ViewController.m
//  FB_LOG
//
//  Created by Patipat on 10/29/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Group.h"
#import "FeedDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString *uid;
    NSArray* imglist;
    
    NSMutableData *data;
    NSString *gbImgName;
}

@end

@implementation ViewController
@synthesize collectionView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
     //self.profilePictureView.profileID = @"ca.abernathy";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(uid!=nil)
    [self loadPic];
   }
-(void)loadPic
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/feed-profile.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"uid=%@&permission=1",uid];
    NSLog(uid);
    NSString * params =s;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableArray *tmpgroups;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSString *charlieSendString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                           NSLog(@"Response:%@ %@\n", charlieSendString, error);
                                                           if(error == nil)
                                                           {
                                                               imglist =  [charlieSendString componentsSeparatedByString:@","];
                                                               [self loadAllImage];
                                                              
                                                              // NSLog(charlieSendString);
                                                               
                                                               /////////// Default DATA type
                                                               /*NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                foo = [[text componentsSeparatedByString:@","]mutableCopy];
                                                                [self.tableView reloadData];*/
                                                               ////////////
                                                           }
                                                           
                                                       }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [dataTask resume];

}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];
    return YES;
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.publishButton.hidden = NO;
    [self loadPic];
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.name.text = @"";
    self.publishButton.hidden = YES;
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
   // NSLog(@"FFF");
    self.profilePictureView.profileID = user.id;
    self.name.text = [NSString stringWithFormat:
                                @"%@", user.name];
    uid=user.id;
    [self loadPic];
 //   NSLog(uid);
    ///// get freind id and name
  /* FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", friends.count);
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
        }
    }];*/
    ///////////
}
- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures since they can happen
        // outside of the app. You can inspect the error for more context
        // but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imglist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tString = [NSString stringWithFormat:@"http://s2td.com/iosimg/%@",[imglist objectAtIndex:indexPath.row]];
    NSLog(@"Setting cell at row : %li",(long)indexPath.row);
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    recipeImageView.layer.cornerRadius = 5.0;
    recipeImageView.layer.masksToBounds = YES;
    
    recipeImageView.layer.borderColor = [UIColor grayColor].CGColor;
    recipeImageView.layer.borderWidth = 0.5;
    
    /*
    recipeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    recipeImageView.layer.shadowOffset = CGSizeMake(0, 1);
    recipeImageView.layer.shadowOpacity = 1;
    recipeImageView.layer.shadowRadius = 1.0;
    recipeImageView.clipsToBounds = NO;
     */
    //[cell addSubview:pgv];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imglist objectAtIndex:indexPath.row]]];
    //  NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
    if (tttImg == nil) {
        //NSLog(@"Not found %@",filePath);
        //tttImg = [UIImage imageNamed:@"spinner.jpg"];
    }
        recipeImageView.image = tttImg;
    

    
    
    //recipeImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tString]]];
    //recipeImageView.image = [UIImage imageNamed:@"not.png"];
    //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    //recipeImageView.image = [UIImage imageNamed:@"not.jpg"];
    //[self.view bringSubviewToFront:recipeImageView];
    //NSLog([[cell viewWithTag:100] description]);
    return cell;
}

- (void)loadImg:(NSString*)link
{
    NSString *tString = [NSString stringWithFormat:@"http://s2td.com/iosimg/%@",link];
    NSLog(@"Load url %@",tString);
    NSURL *url = [NSURL URLWithString:tString];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    connection = nil;
    [[NSRunLoop currentRunLoop] run];
    
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    NSData *pngData = UIImageJPEGRepresentation([UIImage imageWithData:data],1.0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",gbImgName]]; //Add the file name
    
    if([pngData writeToFile:filePath atomically:YES]) //Write the file
    NSLog(@"Write file to : %@",filePath);
    else
        NSLog(@"CANT");
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
    if (tttImg == nil) {
        NSLog(@"Not found %@",filePath);
        //tttImg = [UIImage imageNamed:@"not.png"];
    }

    [collectionView reloadData];
    data=nil;

}
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)recievedData {
    if (data==nil) {
		data =	[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:recievedData];
}
-(void)loadImageArray{
    //imageLoaded = [[NSMutableArray alloc] initWithCapacity:[groups count]];
    for (int i=0; i<[imglist count]; i++) {
        //   NSLog([[groups objectAtIndex:i] l3]);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imglist objectAtIndex:i]]];
        //  NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
        UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"FOUND");
        if (tttImg == nil){
            gbImgName = [imglist objectAtIndex:i];
            [self loadImg:[imglist objectAtIndex:i]];
        }
    }
}
-(void)loadAllImage{
    //[self loadImg:@"1.png"];
    //for (int i=0; i<[groups count]; i++) {
    
    [NSThread detachNewThreadSelector:@selector(loadImageArray) toTarget:self withObject:nil];
    [collectionView reloadData];
    //}
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"preparegame"]) {
        Group *tmpdata =[[Group alloc] init] ;
        tmpdata.timeupload = @"-1";
        tmpdata.name = _name.text;
        NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        tmpdata.imgpath = tmpdata.imgpath_b = [imglist objectAtIndex:index.row];
        FeedDetailViewController *view = [segue destinationViewController];
       
        view.data = tmpdata;
    }
}
- (IBAction)refreshprofile:(id)sender {
    NSString *extension = @"jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory     stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    [self loadPic];
}

@end
