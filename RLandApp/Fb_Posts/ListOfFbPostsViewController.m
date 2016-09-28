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
{
    int numberOfPosts;
    
    UIRefreshControl *refreshControl;
    
}
@property (nonatomic) NSMutableArray *sortedPosts, *feedOfEachPage;
@property (nonatomic) NSMutableDictionary *unsortedPosts;
@property (weak, nonatomic) IBOutlet UITableView *fbtable;

@property (strong, nonatomic) UIImageView *tappedImageView;
@property (strong, nonatomic) UIView *expandedFbPostView;


@end


/*To-Do:
 1. Remove extra spacing at top of tableview
 2. Placeholder image
 */


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
    
    
    numberOfPosts = 0;
    
    _sortedPosts =[[NSMutableArray alloc]init];
    _unsortedPosts =[[NSMutableDictionary alloc]init];
    _feedOfEachPage = [[NSMutableArray alloc]init];
    
   
    self.fbtable.tableHeaderView = nil;
    [self.fbtable setHidden:YES];
    
    //for adjustable row height in tableview
    _fbtable.rowHeight = UITableViewAutomaticDimension;
    _fbtable.estimatedRowHeight = 300;
    
    [self sendRequestToFb];
    [self performSelector:@selector(showPosts) withObject:nil afterDelay:1.2];
    
    //refreshControl
    refreshControl = [[UIRefreshControl alloc]init];
    [self.fbtable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    
    //expanded Facebook Post View
    _expandedFbPostView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _expandedFbPostView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _expandedFbPostView.userInteractionEnabled = YES;
    UITapGestureRecognizer *removeExpandedViewGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(removeExpandedFbPost:)];
    removeExpandedViewGestureRecognizer.numberOfTapsRequired = 1;
    [_expandedFbPostView addGestureRecognizer:removeExpandedViewGestureRecognizer];
    [self.view addSubview:_expandedFbPostView];

    _tappedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    [_expandedFbPostView addSubview:_tappedImageView];
    _tappedImageView.frame = CGRectMake(0, _tappedImageView.superview.frame.size.height*1/16, _tappedImageView.superview.frame.size.width, _tappedImageView.superview.frame.size.height*3/4);
    
    _expandedFbPostView.hidden = YES;
}


#pragma mark FbPosts Fetching Actions
-(void) sendRequestToFb {
    
    for(NSString *fbid in _selectedProfileIds ) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:[NSString stringWithFormat:@"/%@", fbid] parameters:@{ @"fields": @"posts{message,created_time,id,full_picture, link},name,picture",} HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            numberOfPosts++;
            
            if (!error)
                [_feedOfEachPage addObject:@{@"posts"          :result[@"posts"][@"data"],
                                             kPageProfPicURL   :result[@"picture"][@"data"][@"url"],
                                             kPageProfName     :result[@"name"]
                                             }];
            else {
                UIAlertController* alertPopup = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Please try again later!" preferredStyle:UIAlertControllerStyleAlert ];
                [self presentViewController:alertPopup animated:YES completion:nil];

                double delayInSeconds = 1.6;
                dispatch_time_t popoutTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popoutTime, dispatch_get_main_queue(), ^{
                    // code executed on main queues after delay
                    [alertPopup dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
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
    return 30;
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
    // _tappedImageView = cellWithPic.imageVie;
    
    //Handling Tap
    cellWithPic.imageVie.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showExpandedFbPost:)];
    tapped.numberOfTapsRequired = 1;
    [cellWithPic.imageVie addGestureRecognizer:tapped];
    
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


#pragma mark - Refresh TableView
- (void)refreshTable {
    //refresh data
    [self sendRequestToFb];
    [self performSelector:@selector(showPosts) withObject:nil afterDelay:1.5];
    
    [refreshControl endRefreshing];
    [self.fbtable reloadData];
}

#pragma mark - Gesture Recognizer methods

-(void) showExpandedFbPost:(UITapGestureRecognizer *)sender {
    self.navigationController.navigationBarHidden = YES;
    //    _tappedImageView = (UIImageView *)sender.view;
    _tappedImageView.image =  [(UIImageView *)sender.view image];
    _expandedFbPostView.hidden = NO;
}

-(void) removeExpandedFbPost:(UITapGestureRecognizer *)sender {
    self.navigationController.navigationBarHidden = NO;
    _expandedFbPostView.hidden = YES;
}



@end
