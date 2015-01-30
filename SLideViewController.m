//
//  SLideViewController.m
//  FB_LOG
//
//  Created by Patipat on 11/5/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import "SLideViewController.h"
#import "Group.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DetailCell.h"
#import "PostViewController.h"
#import "Toast+UIView.h"
#import "prepareViewController.h"
#import "FeedDetailViewController.h"
#import "otherProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>

@interface SLideViewController ()
{
    NSURLConnection *connection;
    NSNumber *filesize;
    NSMutableData *data;
    NSMutableArray *image;
    NSNumber *gbTag;
    NSString *gbImgName;
    NSMutableArray* imageLoaded;
    NSMutableArray *groups;
    BOOL loadingData;
    NSMutableArray *namecache;
    NSMutableArray *uidcache;
    NSMutableArray *uidpiccache;
}

@end

@implementation SLideViewController
{
NSString *text2;
NSMutableArray *foo;
    UIImage *imgg;
}
@synthesize progressline;
//@synthesize imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    uidcache = nil;
    uidpiccache = nil;
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
    if(user.id!=nil)
    {
    [self getFriend];
       // //NSLog([NSString stringWithFormat:@"F:%@",user.id]);
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    loadingData = NO;
    
    NSString *extension = @"png";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }*/
	// Do any additional setup after loading the view.
    //[self loadData];
    //foo = [[NSMutableArray alloc] initWithArray:[text2 componentsSeparatedByString:@"/"]];
   // NSString* day = [foo objectAtIndex: 0];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.75 constant:-63.0115 + 10]];

}

-(void)loadAllImage{
    //[self loadImg:@"1.png"];
    //for (int i=0; i<[groups count]; i++) {
    
        [NSThread detachNewThreadSelector:@selector(loadImageArray) toTarget:self withObject:nil];
    [self.tableView reloadData];
    //}
}
-(NSString*)getFriend{
    //NSLog(@"Getting friends List !!!!");
    __block NSString* result=@"";
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        NSString *list=@"";
        for (NSDictionary<FBGraphUser>* friend in friends) {
            list = [list stringByAppendingFormat:@",%@",friend.id];
            
           
        }
        list = [list substringFromIndex:1];
       // //NSLog(list);
        
        [self loadData:list];}];
    ////NSLog(Flist);
        return result;
}
-(void)loadImageArray{
    //imageLoaded = [[NSMutableArray alloc] initWithCapacity:[groups count]];
    for (int i=0; i<[groups count]; i++) {
     //   //NSLog([[groups objectAtIndex:i] l3]);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[groups objectAtIndex:i] imgpath_b]]];
        //  //NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
        UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
        if (tttImg == nil){
            gbTag = [NSNumber numberWithInt:i];
            gbImgName = [[groups objectAtIndex:i] imgpath_b];
            [self loadImg:[[groups objectAtIndex:i] imgpath_b]];
        }
    }
}
/*
-(NSString*)getFName:(NSString*)uid
{
    //NSLog(@"Getting friends list !!!!!");
    __weak __block NSString* name;
    // Query to fetch the active user's friends, limit to 25.
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
                              if (error) {
                                  //NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                 NSString* t = result[@"data"][0][@"name"];
                                  //NSLog(@"%@",t);
                              }
                              
                          }];

    //NSLog(@"%@",[NSString stringWithFormat:@"%@",name]);
    return name;
}*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = indexPath.row+10;
    Group *group = groups[indexPath.row];
    //cell.nameBL.tag = indexPath.row+20;
    if (group.name == Nil) {
        [cell.nameBL.titleLabel setText:@"Loading..."];
        cell.userInteractionEnabled = NO;
    }else{
        [cell.nameBL.titleLabel setText:group.name];
        [cell.btownpic.titleLabel setText:group.name];
        cell.userInteractionEnabled = YES;
        //NSLog(@"Setting row : %i ",indexPath.row);
        [cell.comment setText:[NSString stringWithFormat:@"%@ Comment",group.commentcount]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromString;
        // voila!
        dateFromString = [dateFormatter dateFromString:group.timeupload];
        NSDate* currentDate = [NSDate date];
        NSTimeInterval diff = [currentDate timeIntervalSinceDate:dateFromString];
        NSString *outtime;
        //NSLog([NSString stringWithFormat:@"%f",diff]);
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
        [cell.l1 setText:outtime];
        [cell.like setText:[NSString stringWithFormat:@"%@ Likes",group.likecount]];
        
        
        
        cell.ownerpic.layer.cornerRadius = 25.0;
        cell.ownerpic.layer.masksToBounds = YES;
        
        cell.ownerpic.layer.borderColor = [UIColor grayColor].CGColor;
        cell.ownerpic.layer.borderWidth = 0.5;
        cell.ownerpic.image = nil;
        NSString *savepath = [self convertIntoMD5:[group ownerpicpath]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",savepath]];
        //  //NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
        UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"Setting url to cell : %@",savepath);
        if (tttImg != nil) {
            cell.ownerpic.image = tttImg;
        }
        /*
        NSString *query =[NSString stringWithFormat:@"SELECT pic FROM user WHERE uid = %@",group.ownerid];
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
                                      cell.ownerpic.layer.cornerRadius = 25.0;
                                      cell.ownerpic.layer.masksToBounds = YES;
                                      
                                      cell.ownerpic.layer.borderColor = [UIColor grayColor].CGColor;
                                      cell.ownerpic.layer.borderWidth = 0.5;
                                      
                                      
                                      
                                      cell.ownerpic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:t]]];
                                  }
                                  
                              }];
        */
    /*
    NSString* uid = group.ownerid;
    // Query to fetch the active user's friends, limit to 25.
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
                              if (error) {
                                  //NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSString* t = result[@"data"][0][@"name"];
                                  ////NSLog(t);
                                  NSString *tt = [NSString stringWithFormat:@"%@ : %@",t,queryParam];
                                  DetailCell *ce = [self.tableView viewWithTag:indexPath.row+10];
                                  //NSLog(@"Setting row : %i to %@",indexPath.row,tt);
                                  [ce.nameBL.titleLabel setText:t];
    
                              }
                              
                          }];*/
    }
   // [cell.nameBL.titleLabel setText:group.l1];
 //   [cell.l2 setText:group.l2];
    /*UIImage *tempimg=[self loadIMG:group.l3];
    if(tempimg==nil)
    {
        tempimg = [UIImage imageNamed:@"not.png"];
    }
    cell.img.image = tempimg;*/
    //UIProgressView *pgv = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    //pgv.progress = 0.0;
    //pgv.tag = 1919;
    cell.progressView.progress = 0.0;
    
    //[cell addSubview:pgv];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",group.imgpath_b]];
  //  //NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
    if (tttImg == nil) {
        ////NSLog(@"Not found!!!!!!!!!!!!!!!!!!!!!!!!!!");
        //tttImg = [UIImage imageNamed:@"not.png"];
    }else{
        cell.img.image = tttImg;
        cell.progressView.hidden = YES;
    }
    
    cell.img.layer.cornerRadius = 5.0;
    cell.img.layer.masksToBounds = YES;
    
    cell.img.layer.borderColor = [UIColor grayColor].CGColor;
    cell.img.layer.borderWidth = 0.5;
    /*
    UIImage *tmpImg;
    
    
    if ([imageLoaded count]>0) {
        tmpImg = [imageLoaded objectAtIndex:indexPath.row];
        if (tmpImg==nil) {
            tmpImg = [UIImage imageNamed:@"not.png"];
        }
    }
    
    cell.img.image = tmpImg;*/
    //cell.img.image = [self loadIMG:[[groups objectAtIndex:indexPath.row] l3]];
    //[cell addSubview:pgv];
    //[NSThread detachNewThreadSelector:@selector(loadImg:) toTarget:self withObject:[[groups objectAtIndex:indexPath.row] l3]];
    ////NSLog([[groups objectAtIndex:indexPath.row] l3]);
    //[self loadImg:group.l3];
    ////NSLog(group.l1);
    ////NSLog(@"Setting cell tag : %i",cell.tag);
    return cell;
}



////////////////////////////////////////
- (void)loadImg:(NSString*)link
{
    NSString *tString = [NSString stringWithFormat:@"http://s2td.com/iosimg/%@",link];
    //NSLog(@"Load url %@",tString);
    NSURL *url = [NSURL URLWithString:tString];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    connection = nil;
    [[NSRunLoop currentRunLoop] run];
    
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self->filesize = [NSNumber numberWithUnsignedInteger:[response expectedContentLength]];
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)recievedData {
    if (data==nil) {
		data =	[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:recievedData];
    NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[data length]]; //MAGIC
    ////NSLog(@"%lu",(unsigned long)[data length]);
    float progress = [resourceLength floatValue] / [self->filesize floatValue];
    
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
    DetailCell *pg = [self.tableView viewWithTag:[gbTag intValue]+10];
        pg.progressView.progress = progress;
    });
    ////NSLog([[self.tableView viewWithTag:1] description]);
    //UIProgressView *tmppg = [[self.tableView viewWithTag:1] viewWithTag:1];
    //tmppg.progress = progress;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    //NSLog(@"Load Success");
    connection=nil;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
    //[imageLoaded insertObject:[UIImage imageWithData:data] atIndex:[gbTag intValue]];
    //DetailCell *ce = [self.view viewWithTag:1];
    //ce.img = imageView;
    ////NSLog([gbTag description]);
    //DetailCell *cells =[self.tableView viewWithTag:[gbTag intValue]];
    
    //dispatch_sync(dispatch_get_main_queue(), ^{
    //cells.img.image = [UIImage imageWithData:data];
    //});
    
    //[self.tableView reloadData];
    ////NSLog([self.view description]);
    
    NSData *pngData = UIImagePNGRepresentation([UIImage imageWithData:data]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",gbImgName]]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
        //NSLog(@"CANT");

    //[pngData writeToFile:filePath atomically:YES]; //Write the file
    //NSLog(@"Write file to : %@",filePath);
    
    data=nil;
    //[self.tableView reloadData];
}

///////////////////////////////////////

-(void)loadData:(NSString*)list
{
    loadingData = YES;
    //NSLog(@"Loading Feed Data... ");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/feed.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"uid=%@",list];
    NSLog(@"Load List :  %@",s);
    NSString * params =s;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    __block NSMutableArray *tmpgroups;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSString *charlieSendString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                          NSLog(@"JSON Response:%@ %@\n", charlieSendString, error);
                                                           if(error == nil)
                                                           {
                                                               NSError *jsonError;
                                                               
                                                               // 2
                                                               NSDictionary *notesJSON =
                                                               [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:NSJSONReadingAllowFragments
                                                                                                 error:&jsonError];
                                                               
                                                           //    NSMutableArray *notesFound = [[NSMutableArray alloc] init];
                                                               
                                                               if (!jsonError) {                    
                                                                   tmpgroups = [[NSMutableArray alloc] init];
                                                                   
                                                                   NSArray *results = [notesJSON valueForKey:@"results"];
                                                                  // //NSLog(@"Count %d", results.count);
                                                                   
                                                                   for (NSDictionary *groupDic in results) {
                                                                       Group *group = [[Group alloc] init];
                                                                       
                                                                       for (NSString *key in groupDic) {
                                                                          // //NSLog([groupDic valueForKey:key]);
                                                                           if ([group respondsToSelector:NSSelectorFromString(key)]) {
                                                                               [group setValue:[groupDic valueForKey:key] forKey:key];
                                                                           }
                                                                           NSString* uid = group.ownerid;
                                                                           if (uid != nil) {
                                                                           if (![self isLoadingUid:uid]) {
                                                                               
                                                                           
                                                                           // Query to fetch the active user's friends, limit to 25.
                                                                           NSString *query =[NSString stringWithFormat:@"SELECT name,pic FROM user WHERE uid = %@",uid];
                                                                           // Set up the query parameter
                                                                           
                                                                           NSDictionary *queryParam = @{ @"q": query };
                                                                           // Make the API request that uses FQL
                                                                           [FBRequestConnection startWithGraphPath:@"/fql"
                                                                                                        parameters:queryParam
                                                                                                        HTTPMethod:@"GET"
                                                                                                 completionHandler:^(FBRequestConnection *connection,
                                                                                                                     id result,
                                                                                                                     NSError *error) {
                                                                                                     NSLog(@"Load uid : %@",uid);
                                                                                                     if (error) {
                                                                                                         NSLog(@"Error: %@", [error localizedDescription]);
                                                                                                     } else {
                                                                                                         NSString* t = result[@"data"][0][@"name"];
                                                                                                         NSString *p = result[@"data"][0][@"pic"];
                                                                                                         ////NSLog(t);
                                                                                                         [self loadOwnerPicFrompath:p];
                                                                                                         [self setName:t AtFacebookUid:uid];
                                                                                                         [self setOwnerPic:p AtFacebookUid:uid];
                                                                                                         //group.name = t;
                                                                                                         //group.ownerpicpath = result[@"data"][0][@"pic"];
                                                                                                         [self.tableView reloadData];
                                                                                                         //NSLog(group.name);
                                                                                                     }
                                                                                                     
                                                                                                 }];
                                                                           }
                                                                           }

                                                                       }
                                                                       
                                                                       [tmpgroups addObject:group];
                                                                   }
                                                                   
                                                                   //NSLog(@"Load uid sucesses !!!");
                                                               }
                                                               loadingData = NO;
                                                               groups = tmpgroups;
                                                               //NSLog(@"Load data sucesses !!!");
                                                               [self.tableView reloadData];
                                                               [self loadAllImage];
                                                              
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groups count];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        //NSLog(@"load more rows");
    }
}

- (IBAction)debug:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   /*
    if ([segue.identifier isEqualToString:@"preparegame"]) {
       prepareViewController *view = [segue destinationViewController];
       NSIndexPath *selectIndex = [self.tableView indexPathForSelectedRow];
       view.data = [groups objectAtIndex:selectIndex.row];
       
    }*/
    if ([segue.identifier isEqualToString:@"preparegame"]) {
        FeedDetailViewController *view = [segue destinationViewController];
        NSIndexPath *selectIndex = [self.tableView indexPathForSelectedRow];
        view.data = [groups objectAtIndex:selectIndex.row];
        
    }else if ([segue.identifier isEqualToString:@"profiledetail"]) {
        otherProfileViewController *view = [segue destinationViewController];
        //NSIndexPath *selectIndex = [self.tableView indexPathForSelectedRow];
        //view.uid = [[groups objectAtIndex:selectIndex.row] ownerid];
        UIButton * bt = sender;
        view.uid = [self getUidFromName:bt.titleLabel.text];
    }
}

-(BOOL)isLoadingUid:(NSString *)uid{
    if (uidcache == Nil) {
        uidcache = [[NSMutableArray alloc] initWithArray:nil];
    }
    if ([uidcache containsObject:uid]) {
        return YES;
    }else{
        [uidcache addObject:uid];
    }
    return NO;
}
-(void)setName:(NSString *)name AtFacebookUid:(NSString *)uid{
    for(int i=0;i<[groups count];i++){
        if ([[[groups objectAtIndex:i] ownerid] isEqualToString:uid]){
            Group *g = [groups objectAtIndex:i];
            g.name = name;
            //NSLog(@"uid %@ is pic path : %@",g.ownerid,g.ownerpicpath);
        }
    }
}
-(void)setOwnerPic:(NSString *)path AtFacebookUid:(NSString *)uid{
    
    for(int i=0;i<[groups count];i++){
        if ([[[groups objectAtIndex:i] ownerid] isEqualToString:uid]){
            Group *g = [groups objectAtIndex:i];
            g.ownerpicpath = path;
            NSLog(@"uid %@ is pic path : %@",g.ownerid,g.ownerpicpath);
        }
    }
}
- (IBAction)refreshfeed:(id)sender {
    uidcache = nil;
    [self getFriend];
}
-(NSString *)getUidFromName:(NSString *)name{
    for (Group *data in groups) {
        if ([[data name] isEqualToString:name]) {
            return data.ownerid;
        }
    }
    return nil;
}
-(void)loadOwnerPicFrompath:(NSString *)path{
    NSString *savepath = [self convertIntoMD5:path];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",savepath]];
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
    if (tttImg == nil ){
        UIImage * tmpimg = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
        NSData *pngData = UIImagePNGRepresentation(tmpimg);
        if([pngData writeToFile:filePath atomically:YES]){
        UIImage *tttImg = [[UIImage alloc] initWithContentsOfFile:filePath];
        }else{
        NSLog(@"can't write to %@",filePath);
        }
    }
    //  //NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
    /*
    for (int i=0; i<[groups count]; i++) {
        Group *data = [groups objectAtIndex:i];
        //   //NSLog([[groups objectAtIndex:i] l3]);
        if (![self isLoadingUidPic:data.ownerid]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[groups objectAtIndex:i] ownerpicpath]]];
        //  //NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
        UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
        if (tttImg == nil ){
            NSString *query =[NSString stringWithFormat:@"SELECT pic FROM user WHERE uid = %@",[data ownerid]];
            // Set up the query parameter
            
            NSDictionary *queryParam = @{ @"q": query };
            [FBRequestConnection startWithGraphPath:@"/fql"
                                         parameters:queryParam
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                                      NSLog(@"Load Picture for Uid : %@",result);
                                      if (error) {
                                          //NSLog(@"Error: %@", [error localizedDescription]);
                                      } else {
                                          NSString* t = result[@"data"][0][@"pic"];
                                          [self setOwnerPic:filePath AtFacebookUid:data.ownerid];
                                          ////NSLog(t);
                                          UIImage * tmpimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:t]]];
                                          NSData *pngData = UIImagePNGRepresentation(tmpimg);
                                          [pngData writeToFile:filePath atomically:YES];
                                          [self.tableView reloadData];
                                      }
                                      
                                  }];
        }
        }
    }*/
}

-(BOOL)isLoadingUidPic:(NSString *)uid{
    if (uidpiccache == Nil) {
        uidpiccache = [[NSMutableArray alloc] initWithArray:nil];
    }
    if ([uidpiccache containsObject:uid]) {
        return YES;
    }else{
        [uidpiccache addObject:uid];
    }
    return NO;
}

- (NSString *)convertIntoMD5:(NSString *) string{
    const char *cStr = [string UTF8String];
    unsigned char digest[16];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *resultString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [resultString appendFormat:@"%02x", digest[i]];
    return  resultString;
}
@end
