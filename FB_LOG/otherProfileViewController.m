//
//  otherProfileViewController.m
//  FB_LOG
//
//  Created by Earther on 11/12/2013.
//  Copyright (c) 2013 Patipat. All rights reserved.
//

#import "otherProfileViewController.h"
#import "FeedDetailViewController.h"

@interface otherProfileViewController ()
{
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSArray* imglist;
    NSMutableData *data;
    NSString *gbImgName;
}
@end

@implementation otherProfileViewController
@synthesize uid,name,img,collectionView;
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
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    if (![uid isEqualToString:@""]) {
        [self loadPic];
        NSString *query =[NSString stringWithFormat:@"SELECT pic FROM user WHERE uid = %@",uid];
        // Set up the query parameter
        
        NSDictionary *queryParam = @{ @"q": query };
        // Make the API request that uses FQL
        [FBRequestConnection startWithGraphPath:@"/fql"
                                     parameters:queryParam
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  NSLog(@"Load uid : %@",result);
                                  if (error) {
                                      //NSLog(@"Error: %@", [error localizedDescription]);
                                  } else {
                                      NSString* t = result[@"data"][0][@"pic"];
                                      ////NSLog(t);
                                      self.img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:t]]];
                                  }
                                  
                              }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    recipeImageView.clipsToBounds = NO;*/
    //[cell addSubview:pgv];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imglist objectAtIndex:indexPath.row]]];
    //  NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
    if (tttImg == nil) {
        //NSLog(@"Not found %@",filePath);
        //tttImg = [UIImage imageNamed:@"not.png"];
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

-(void)loadPic
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/feed-profile.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"uid=%@&permission=0&caller=%@",uid,user.id];
         
    //NSLog(uid);
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
                                                               
                                                                                                                          }
                                                           
                                                       }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [dataTask resume];
    
    NSString *query =[NSString stringWithFormat:@"SELECT name FROM user WHERE uid = %@",uid];
    // Set up the query parameter
    
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              //NSLog(@"Load uid : %@",uid);
                              if (error) {
                                  //NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSString* t = result[@"data"][0][@"name"];
                                  ////NSLog(t);
                                  self.name.text = t;
                                  
                                  //NSLog(group.name);
                              }
                              
                          }];
     }];
    
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
        tmpdata.name = name.text;
        NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        tmpdata.imgpath = tmpdata.imgpath_b = [imglist objectAtIndex:index.row];
        FeedDetailViewController *view = [segue destinationViewController];
        
        view.data = tmpdata;
    }
}

@end
