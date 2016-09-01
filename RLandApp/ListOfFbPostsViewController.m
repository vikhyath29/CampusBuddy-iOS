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
    //for adjustable row in tableview
    _fbtable.rowHeight = UITableViewAutomaticDimension;
    _fbtable.estimatedRowHeight = 300;
    
    [self clickMe];
    [self performSelector:@selector(showPosts) withObject:nil afterDelay:1.5];
    
    
}


#pragma mark FbPosts Fetching Actions
-(void) clickMe {
    NSArray *arrids = @[@"272394492879208", @"754869404569818", @"418543801611643", @"240482462650426", @"231275190406200", @"100641016663545",@"217963184943488", @"666376426759997", @"567441813288417", @"671125706342859", @"146825225353259", @"415004402015833", @"353701311987", @"198343570325312", @"242919515859218", @"537723156291580", @"317158211638196", @"1410660759172170",  @"206783812798277", @"182484805131346",  @"292035034247", @"257702554250168", @"171774543014513"];
    
    
    for(NSString *fbid in arrids ) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:[NSString stringWithFormat:@"/%@", fbid] parameters:@{ @"fields": @"posts{message,created_time,id,full_picture, link},name,picture",} HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (!error)
                [_feedOfEachPage addObject:@{@"posts"          :result[@"posts"][@"data"],
                                             kPageProfPicURL   :result[@"picture"][@"data"][@"url"],
                                             kPageProfName     :result[@"name"]
                                             }];
            else {
                //TODO: Make an alertView
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
    
    NSString * const cellIdentifier1 = @"FBCustomWithPicTableViewCell";
    NSString* const cellIdentifier2 = @"FBCustomNoPicTableViewCell";
    
    FBCustomWithPicTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    FBCustomNoPicTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    if(cell1 == nil) {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1
                                                          owner:self
                                                        options:nil];
        cell1 = [nibViews objectAtIndex: 0];
    }
    
    if(cell2 == nil) {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2
                                                          owner:self
                                                        options:nil];
        cell2 = [nibViews objectAtIndex: 0];
    }
    
    
    if(_sortedPosts.count && indexPath.row<_sortedPosts.count) {
        if(self.sortedPosts[indexPath.row][kPostInfo][kFullPicture]) {
            cell1.textLabe.text = _sortedPosts[indexPath.row][kPostInfo][kMessage];
            cell1.dateLabel.text = [self changeTimeFormatOf:_sortedPosts[indexPath.row][kPostInfo][kCreatedTime]];
            cell1.groupName.text = _sortedPosts[indexPath.row][kPageProfName];
            [cell1.pageProfilePic sd_setImageWithURL:[NSURL URLWithString:_sortedPosts[indexPath.row][kPageProfPicURL]] placeholderImage:[UIImage imageNamed:@"sample.png"]];
            [cell1.imageVie sd_setImageWithURL:[NSURL URLWithString:_sortedPosts[indexPath.row][kPostInfo][kFullPicture]]
                              placeholderImage:[UIImage imageNamed:@"sample.png"]];
            
            ////        cell1.imageVie.image = [UIImage imageNamed:@"sample.png"];
            //    NSURL *url = [NSURL URLWithString:_sortedPosts[indexPath.row][kFullPicture]];
            //    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //        if (data) {
            //            UIImage *image = [UIImage imageWithData:data];
            //            if (image) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    CustomCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            //                    if (updateCell)
            //                        updateCell.imageVie.image = image;
            //                });
            //            }
            //        } //end of if(data)
            //    }]; //end of task
            //    [task resume];
            return cell1;
        } //end of if(_sortedPosts[indexPath.row][kFullPicture])
        
        else if(!_sortedPosts[indexPath.row][kFullPicture]) {
            cell2.postMessage.text = _sortedPosts[indexPath.row][kPostInfo][kMessage];
            [cell2.pageProfilePic sd_setImageWithURL:[NSURL URLWithString:_sortedPosts[indexPath.row][kPageProfPicURL]] placeholderImage:[UIImage imageNamed:@"sample.png"]];
            cell2.groupNameLabel.text = _sortedPosts[indexPath.row][kPageProfName];
            cell2.dateLabel.text = [self changeTimeFormatOf:_sortedPosts[indexPath.row][kPostInfo][kCreatedTime]];
            
            
            return cell2;
        }
    }
    
    return cell2;
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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+z"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    
    NSDate *date = [df dateFromString:timestamp];
    
    NSString *todayDateString = [df stringFromDate:[NSDate date]];
    NSDate *todayDate = [df dateFromString:todayDateString];
    
    NSTimeInterval secondsBetween = [todayDate timeIntervalSinceDate:date];
    int numberOfDays = secondsBetween / 86400;
    
    switch(numberOfDays) {
        case 0:
            [df setDateFormat:@"hh:mm a"];
            return [NSString stringWithFormat:@"Today at %@",[df stringFromDate:date]];
            break;
            
        case 1:
            [df setDateFormat:@"hh:mm a"];
            return [NSString stringWithFormat:@"Today at %@",[df stringFromDate:date]];
            break;
            
        default:
            [df setDateFormat:@"eee MMM dd, yyyy hh:mm a"];
            return [df stringFromDate:date];
    }
}






@end
