//
//  FeedDetailViewController.m
//  FB_LOG
//
//  Created by Earther on 11/12/2013.
//  Copyright (c) 2013 Patipat. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "prepareViewController.h"
#import "Toast+UIView.h"
#import "comment.h"
#import <FacebookSDK/FacebookSDK.h>
#import "otherProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface FeedDetailViewController ()
{
    NSMutableArray *dataarray;
    NSMutableArray *groups;
    NSMutableArray *namecache;
    NSMutableArray *uidcache;
    NSMutableArray *topscore;
}

@end

@implementation FeedDetailViewController
@synthesize data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",data.imgpath_b]];
    //  NSLog(@"%@",[NSString stringWithFormat:@"Load Image from : %@",filePath]);
    UIImage *tttImg = [UIImage imageWithContentsOfFile:filePath];
    if (tttImg == nil) {
        //NSLog(@"Not found!!!!!!!!!!!!!!!!!!!!!!!!!!");
        tttImg = [UIImage imageNamed:@"not.png"];
    }
    
    //UIImageView *tmpimgview = [[UIImageView alloc] initWithFrame:self.thumnail.frame];
    self.thumnail.image = tttImg;
    self.thumnail.layer.cornerRadius = 10.0;
    self.thumnail.layer.masksToBounds = YES;
    
    self.thumnail.layer.borderColor = [UIColor grayColor].CGColor;
    self.thumnail.layer.borderWidth = 0.5;
    
    //self.thumnail = tmpimgview;
    
    [self.lbOwner setTitle:data.name forState:UIControlStateNormal];
    if([data.timeupload isEqualToString:@"-1"])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/feed-pro.php"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *s = [NSString stringWithFormat:@"imgpath=%@",data.imgpath];
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
                                                                   dataarray = [charlieSendString componentsSeparatedByString:@"[|@!@#]"];
                                                                   data.imgno = [dataarray objectAtIndex:0];
                                                                   data.ownerid = [dataarray objectAtIndex:1];
                                                                   data.likecount = [dataarray objectAtIndex:2];
                                                                   data.commentcount = [dataarray objectAtIndex:3];
                                                                   data.timeupload = [dataarray objectAtIndex:4];
                                                                   data.caption = [dataarray objectAtIndex:5];
                                                                   data.imgpath = [dataarray objectAtIndex:6];
                                                                  // NSLog(data.timeupload);
                                                                 
                                                                       NSLog(@"Load uid sucesses !!!");
                                                                   }
        
                                                                   NSLog(@"Load data sucesses !!!");
                                                                   /////////// Default DATA type
                                                                   /*NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                    foo = [[text componentsSeparatedByString:@","]mutableCopy];
                                                                    [self.tableView reloadData];*/
                                                                   ////////////
                                                               [self loadscore];
                                                               [self loadcomment];
                                                               
                                                               [self setlabel];
                                                           }];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [dataTask resume];
    }
    else
    {
        [self loadscore];
        [self loadcomment];
        
        [self setlabel];
    }
}
-(void)loadscore
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/loadscore.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(data.imgno);
    NSString *s = [NSString stringWithFormat:@"imgno=%@",data.imgno];
    //NSLog(s);
    NSString * params =s;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(data.imgpath);
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *datas, NSURLResponse *response, NSError *error) {
                                                           NSString *charlieSendString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
                                                           NSLog(@"oOResponse:%@ %@\n", charlieSendString, error);
                                                           if(error == nil)
                                                           {
                                                            NSMutableArray *tmpA = [charlieSendString componentsSeparatedByString:@"[|@!@#]"];
                                                               if ([tmpA count]==1) {
                                                                   topscore = nil;
                                                               }else{
                                                                   topscore = tmpA;
                                                               }
                                                               [self.tbView reloadData];
                                                               NSLog(@"Load uid sucesses !!!");
                                                           }
                                                           
                                                           NSLog(@"Load data sucesses !!!");
                                                           /////////// Default DATA type
                                                           /*NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            foo = [[text componentsSeparatedByString:@","]mutableCopy];
                                                            [self.tableView reloadData];*/
                                                           ////////////
                                                           //[self loadcomment];
                                                           [self setlabel];
                                                       }];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [dataTask resume];

}
-(void)loadcomment
{
    uidcache = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/feed-comment.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"imgno=%@",data.imgno];
    ////NSLog(s);
    NSString * params =s;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    __block NSMutableArray *tmpgroups;
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSString *charlieSendString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                           NSLog(@"Response:%@ %@\n", charlieSendString, error);
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
                                                                        comment *group = [[comment alloc] init];
                                                                       
                                                                       for (NSString *key in groupDic) {
                                                                           //NSLog(@"%@ :>> %@",key,[groupDic valueForKey:key]);
                                                                           if ([group respondsToSelector:NSSelectorFromString(key)]) {
                                                                               [group setValue:[groupDic valueForKey:key] forKey:key];
                                                                           }
                                                                           NSString* uid = group.ownerid;
                                                                           if (![self isLoadingUid:uid]) {
                                                                               
                                                                           
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
                                                                                                     NSLog(@"Load uid : %@",uid);
                                                                                                     if (error) {
                                                                                                         //NSLog(@"Error: %@", [error localizedDescription]);
                                                                                                     } else {
                                                                                                         NSString* t = result[@"data"][0][@"name"];
                                                                                                         [self setName:t AtFacebookUid:uid];
                                                                                                         ////NSLog(t);
                                                                                                         group.name = t;
                                                                                                         [self.tbView reloadData];
                                                                                                         //NSLog(group.name);
                                                                                                     }
                                                                                                     
                                                                                                 }];
                                                                           }
                                                                           
                                                                       }
                                                                       
                                                                       [tmpgroups addObject:group];
                                                                   }
                                                                   
                                                                   //NSLog(@"Load uid sucesses !!!");
                                                               }
                                                               //loadingData = NO;
                                                               groups = tmpgroups;
                                                               //NSLog(@"Load data sucesses !!!");
                                                               //[self.tbView reloadData];
                                                             //  [self loadAllImage];
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
-(void)setlabel
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/addios.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"type=chkl&uid=%@&imgno=%@",user.id,data.imgno];
    //NSLog(s);
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
                                                               int ii = [data.likecount integerValue];
                                                               if ([charlieSendString isEqualToString:@"notyet_like"]) {
                                                                   [self.lbLike setTitle:@" Like" forState:UIControlStateNormal];
                                                                 [self.lbLike setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];                                                               }else if ([charlieSendString isEqualToString:@"already_like"]) {
                                                                   [self.lbLike setTitle:@" Like" forState:UIControlStateNormal];
                                                                   [self.lbLike setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];                                                               }
                                                               NSLog(@"Load uid sucesses !!!");
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

    self.lbhlike.text=[NSString stringWithFormat:@"%@ Likes",data.likecount];
    //[self.lbLike setTitle:data.likecount forState:UIControlStateNormal];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    //NSLog([NSString stringWithFormat:@"FFFFFSSS%@",data.timeupload]);
    dateFromString = [dateFormatter dateFromString:data.timeupload];
    NSDate* currentDate = [NSDate date];
    NSTimeInterval diff = [currentDate timeIntervalSinceDate:dateFromString];
    NSString *outtime;
         self.caption.text = data.caption;
    //  NSLog([NSString stringWithFormat:@"%f",diff]);
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
    
    self.lbUptime.text =  outtime;
     }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog([data description]);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"playgame"]) {
        prepareViewController *view = [segue destinationViewController];
        view.data = self.data;
    }else if ([segue.identifier isEqualToString:@"profiledetail"]) {
        otherProfileViewController *view = [segue destinationViewController];
        view.uid = self.data.ownerid;
        //view.uid = [[groups objectAtIndex:selectIndex.row] ownerid];
    }
}
- (IBAction)likefeed:(id)sender {
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/addios.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"type=like&uid=%@&imgno=%@",user.id,data.imgno];
    //NSLog(s);
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
                                                               int ii = [data.likecount integerValue];
                                                               if ([charlieSendString isEqualToString:@"LIKE"]) {
                                                                   
                                                                   data.likecount = [NSString stringWithFormat:@"%i",ii+1];
                                                                   self.lbhlike.text =[NSString stringWithFormat:@"%@ Likes",data.likecount];
                                                                   [self.lbLike setTitle:@" Like" forState:UIControlStateNormal];
                                                                   [self.lbLike setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];                                                               }else if ([charlieSendString isEqualToString:@"UNLIKE"]) {
                                                                   data.likecount = [NSString stringWithFormat:@"%i",ii-1];
                                                                   self.lbhlike.text =[NSString stringWithFormat:@"%@ Likes",data.likecount];
                                                                   [self.lbLike setTitle:@" Like" forState:UIControlStateNormal];
                                                                   [self.lbLike setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                                                               }
                                                               NSLog(@"Load uid sucesses !!!");
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
}

- (IBAction)commentgo:(id)sender {
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
    
    [self.view setFrame:CGRectMake(0,0,320,460)];
    [self.commenttext resignFirstResponder];
    if ([self.commenttext.text isEqualToString:@""]) {
        [self.view.window  makeToast:@"No comment found!!!" duration:2.0 position:@"buttom"];
    }else{
    [self.commenttext resignFirstResponder];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://www.s2td.com/addios.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *s = [NSString stringWithFormat:@"type=comment&uid=%@&imgno=%@&comment=%@",user.id,data.imgno,self.commenttext.text];
    //NSLog(s);
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
                                                               if ([charlieSendString isEqualToString:@"Comment"]) {
                                                                  [self.view.window  makeToast:@"Comment Successful" duration:2.0 position:@"bottom"];
                                                                   self.commenttext.text = @"";
                                                                   [self loadcomment];
                                                               }else {
                                                                   
                                                              [self.view.window  makeToast:@"Comment Failed" duration:2.0 position:@"bottom"];
                                                               }
                                                           }
                                                               NSLog(@"Load uid sucesses !!!");
                                                           NSLog(@"Load data sucesses !!!");
                                                           
                                                           /////////// Default DATA type
                                                           /*NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            foo = [[text componentsSeparatedByString:@","]mutableCopy];
                                                            [self.tableView reloadData];*/
                                                           ////////////
                                                       }];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [dataTask resume];
    }
    
     }];
    [self.tbView reloadData];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view setFrame:CGRectMake(0,-170,320,460)];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view setFrame:CGRectMake(0,0,320,460)];
    [textField resignFirstResponder];
    return YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Set Sec: %i Row: %i",indexPath.section,indexPath.row);
    NSString *cellIden = @"CellComment";
    UITableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIden];
    }
    if (indexPath.section == 0) {
        NSLog(@"topscore count : %i",[topscore count]);
        if ([topscore count]==0) {
            cell.textLabel.text = @"No one played";
    
            cell.detailTextLabel.text = @"";
            return cell;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        //NSLog([NSString stringWithFormat:@"FFFFFSSS%@",data.timeupload]);
        dateFromString = [dateFormatter dateFromString:[topscore objectAtIndex:indexPath.row*4+2]];
        NSLog(@"%d",[[topscore objectAtIndex:indexPath.row*4+2] length]);
        NSLog([topscore objectAtIndex:indexPath.row*4+2] );

        NSDate* currentDate = [NSDate date];
        NSTimeInterval diff = [currentDate timeIntervalSinceDate:dateFromString];
        NSString *outtime;
        //  NSLog([NSString stringWithFormat:@"%f",diff]);
        NSLog(@"%d",(int)diff);
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
        cell.textLabel.text = @"                                        \n                                      ";
        NSLog(outtime);
        
        NSString *query =[NSString stringWithFormat:@"SELECT name FROM user WHERE uid = %@",[topscore objectAtIndex:indexPath.row*4+1]];
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
                                      //[self setName:t AtFacebookUid:uid];
                                      ////NSLog(t);
                                      cell.textLabel.text = [NSString stringWithFormat:@"%@\nScore : %@ ",t,[topscore objectAtIndex:indexPath.row*4+3]];
                                      //NSLog(group.name);
                                  }
                                  
                              }];
    



    
        cell.detailTextLabel.text = outtime;
    }

    else if (indexPath.section == 1) {
        if ([groups count]==0) {
            cell.textLabel.text = @"No comments";
            cell.detailTextLabel.text = @"";
            return cell;
        }
   // NSLog([[groups objectAtIndex:indexPath.row] comment]);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    //NSLog([NSString stringWithFormat:@"FFFFFSSS%@",data.timeupload]);
    dateFromString = [dateFormatter dateFromString:[[groups objectAtIndex:indexPath.row] datepost]];
    NSDate* currentDate = [NSDate date];
    NSTimeInterval diff = [currentDate timeIntervalSinceDate:dateFromString];
    NSString *outtime;
    //  NSLog([NSString stringWithFormat:@"%f",diff]);
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
    

    NSString *cellText = [[groups objectAtIndex:indexPath.row] comment];
    CGSize size = [cellText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",[[groups objectAtIndex:indexPath.row] name],cellText];
    cell.detailTextLabel.text = outtime;
    //cell.frame.size = size;
    }
    cell.userInteractionEnabled = NO;
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        //NSLog(@"Return number sector : %i",[topscore count]);
        
        if ([topscore count]==0) {
            //NSLog(@"Return number sector : %i count : %i",section,1);
            return 1;
        }
        //NSLog(@"Return number sector : %i count : %i",section,[topscore count]);
        return [topscore count]/4;
    }else if(section == 1){
        NSLog(@"Return number sector : %i count : %i",section,[topscore count]);
        if (groups.count == 0) {
            return 1;
        }
        return groups.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section ==1) {
        if ([groups count]==0) {
            return 53;
        }
    NSString *cellText = [[groups objectAtIndex:indexPath.row] comment];
    
    CGSize maximumLabelSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, FLT_MAX);
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey: NSFontAttributeName];
    
    CGSize expectedLabelSize2 = [cellText boundingRectWithSize:maximumLabelSize
                                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:stringAttributes context:nil].size;
    
    
    CGSize size = [cellText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    NSLog(@"%f : %@",expectedLabelSize2.height,cellText);
    return expectedLabelSize2.height+30;
    }else if(indexPath.section == 0){
        return 53;
    }
    return 53;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Top 3 scores";
    }else if (section==1) {
        return @"Comments";
    }
    return nil;
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
            NSLog(@"%i : %@",i,[[groups objectAtIndex:i] name]);
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor orangeColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}
@end
