//
//  ListOfFbPostsViewController.m
//  RLandApp
//
//  Created by Vikhyath on 8/31/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import "ListOfFbPostsViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface ListOfFbPostsViewController ()



@property (nonatomic) NSMutableArray *sortedPosts, *feedOfEachPage;
@property (nonatomic) NSMutableDictionary *unsortedPosts;

@property (weak, nonatomic) IBOutlet UITableView *fbtable;

@end


@implementation ListOfFbPostsViewController

NSString *const kPostInfo = @"postInfo";
NSString *const kPageProfPicURL = @"pageProfPicURL";
NSString *const kPageProfName = @"pageProfName";
/* facebook key strings */
NSString *const kFullPicture = @"full_picture";
NSString *const kCreatedTime = @"created_time";
NSString *const kMessage = @"message";
NSString *const kPostURL = @"link";




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sortedPosts =[[NSMutableArray alloc]init];
    _unsortedPosts =[[NSMutableDictionary alloc]init];
    _feedOfEachPage = [[NSMutableArray alloc]init];
    
   
    
    [self.fbtable setHidden:YES];
    //for adjustable row height in tableview
    _fbtable.rowHeight = UITableViewAutomaticDimension;
    _fbtable.estimatedRowHeight = 300;
    
    [self clickMe];
    [self performSelector:@selector(showPosts) withObject:nil afterDelay:1.5];
}




#pragma mark FbPosts Fetching Actions
-(void) clickMe {
     
    for(NSString *fbid in _selectedProfileIds ) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:[NSString stringWithFormat:@"/%@", fbid] parameters:@{ @"fields": @"posts{message,created_time,id,full_picture, link},name,picture",} HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (!error)
                [_feedOfEachPage addObject:@{@"posts"          :result[@"posts"][@"data"],
                                             kPageProfPicURL   :result[@"picture"][@"data"][@"url"],
                                             kPageProfName     :result[@"name"]
                                             }];
            else {
                UIAlertController* alertpopup = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Please try again later!" preferredStyle:UIAlertControllerStyleAlert ];
                
                [self presentViewController:alertpopup animated:YES completion:nil];
                [self performSelector:@selector(dismissAlertController) withObject:self afterDelay:1];

            }
            
        }]; //end of request
    } //end of for loop
    
    

}

-(void) showPosts {
    //add each post together with its pageInfo into an unsortedPosts Dictionary with Timestamps as keys
    for(int i=0; i<[_feedOfEachPage count]; ++i)
        for(id postInfo in _feedOfEachPage[i][@"posts"])
            [_unsortedPosts setObject:@{
                                        kPostInfo      : postInfo,
                                        kPageProfPicURL: _feedOfEachPage[i][kPageProfPicURL],
                                        kPageProfName  : _feedOfEachPage[i][kPageProfName],
                                        }
                               forKey:postInfo[kCreatedTime]];
    
    //sort dates
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *sortedDates = [[_unsortedPosts allKeys] sortedArrayUsingDescriptors:descriptors];
    
    /* Using SortedDates, make a sortedPosts Array.
     (Dictionary not needed(like in unsortedPosts), as the index of the elemnent is itself is its sorting priority) */
    for(int i=0; i<[sortedDates count]; ++i)
        [_sortedPosts addObject:[_unsortedPosts valueForKey:sortedDates[i]]];
    
    //finally reload
    [self.fbtable setHidden:NO];
    [self.fbtable reloadData];
    
}

#pragma mark TableView
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 138;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_sortedPosts.count && indexPath.row<_sortedPosts.count) {
        if(self.sortedPosts[indexPath.row][kPostInfo][kFullPicture])
            return [self cellWithPostPictureFrom:_sortedPosts atIndexPath:indexPath];
            
        else if(!_sortedPosts[indexPath.row][kFullPicture])
            return [self cellWithNoPostPictureFrom:_sortedPosts atIndexPath:indexPath];
    }
        
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BackupCell"];
    if(cell==nil)
        cell = [[UITableViewCell alloc]init];
    return cell;
}


//Next two are auxiliary methods for cellForRowAtIndexPath: method
-(FBCustomWithPicTableViewCell *) cellWithPostPictureFrom:(NSArray *)sortedPosts atIndexPath:(NSIndexPath *)indexPath {
    
    NSString * const cellIdentifier1 = @"FBCustomWithPicTableViewCell";
    FBCustomWithPicTableViewCell *cellWithPic = [_fbtable dequeueReusableCellWithIdentifier:cellIdentifier1];
    
    if(cellWithPic ==nil) {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1
                                                          owner:self
                                                        options:nil];
        cellWithPic = [nibViews objectAtIndex: 0];
    }
    
    //configuring cell
        cellWithPic.textLabe.text = _sortedPosts[indexPath.row][kPostInfo][kMessage];
        cellWithPic.dateLabel.text = [self changeTimeFormatOf:_sortedPosts[indexPath.row][kPostInfo][kCreatedTime]];
        cellWithPic.pageName.text = _sortedPosts[indexPath.row][kPageProfName];
    
    
        [cellWithPic.pageProfilePic sd_setImageWithURL:[NSURL URLWithString:_sortedPosts[indexPath.row][kPageProfPicURL]] placeholderImage:[UIImage imageNamed:@"sample.png"]];
        [cellWithPic.imageVie sd_setImageWithURL:[NSURL URLWithString:_sortedPosts[indexPath.row][kPostInfo][kFullPicture]] placeholderImage:[UIImage imageNamed:@"sample.png"]];
    
    
    return cellWithPic;
}

-(FBCustomNoPicTableViewCell *) cellWithNoPostPictureFrom:(NSArray *)sortedPosts atIndexPath:(NSIndexPath *)indexPath {
    
    NSString * const cellIdentifier2 = @"FBCustomNoPicTableViewCell";
    FBCustomNoPicTableViewCell *cellWithNoPic = [_fbtable dequeueReusableCellWithIdentifier:cellIdentifier2];

    if(cellWithNoPic == nil) {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2
                                                          owner:self
                                                        options:nil];
        cellWithNoPic = [nibViews objectAtIndex: 0];
    }
    
    
        cellWithNoPic.postMessage.text = _sortedPosts[indexPath.row][kPostInfo][kMessage];
        [cellWithNoPic.pageProfilePic sd_setImageWithURL:[NSURL URLWithString:_sortedPosts[indexPath.row][kPageProfPicURL]] placeholderImage:[UIImage imageNamed:@"sample.png"]];
        cellWithNoPic.pageName.text = _sortedPosts[indexPath.row][kPageProfName];
        cellWithNoPic.dateLabel.text = [self changeTimeFormatOf:_sortedPosts[indexPath.row][kPostInfo][kCreatedTime]];

    return cellWithNoPic;
}




/* PROBLEM: Images only loading for visible rows. so I've to scroll the tableview up and down
 See http://stackoverflow.com/questions/15701556/sdwebimage-does-not-load-remote-images-until-scroll
 
 */


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailFbPostViewController *dpvc = [[DetailFbPostViewController alloc]init];
    dpvc.postURLString = _sortedPosts[indexPath.row][kPostInfo][kPostURL];
    [self.navigationController pushViewController:dpvc animated:YES];
}

- (IBAction)scrollToTopAction:(id)sender {
    [self.fbtable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}






#pragma mark Auxiliary Methods

-(NSString *) changeTimeFormatOf:(NSString *)timestamp {
    //configuring a dateformatter
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+z"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    
    NSDate *date = [df dateFromString:timestamp];
    
//    NSDate *todayDate = [NSDate date];

//    switch([todayDate compare:date]) {
//        case NSOrderedAscending:
//            NSLog(@"Ascending");
//            [df setDateFormat:@"hh:mm a"];
//            return [NSString stringWithFormat:@"Today at %@",[df stringFromDate:date]];
//            break;
//            
//        case NSOrderedDescending:
//            NSLog(@"Descending");
//            [df setDateFormat:@"hh:mm a"];
//            return [NSString stringWithFormat:@"Today at %@",[df stringFromDate:date]];
//            break;
//            
//        default:
//            [df setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
//            return [df stringFromDate:date];
//    }

    [df setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
    return [df stringFromDate:date];

}

#pragma mark - dismiss AlertController
-(void) dismissAlertController {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
