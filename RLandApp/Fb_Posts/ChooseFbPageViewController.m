//
//  ChooseFbPageViewController.m
//  RLandApp
//
//  Created by Vikhyath on 2/7/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import "ChooseFbPageViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface ChooseFbPageViewController ()
{
    UIRefreshControl *refreshControl;
    NSMutableArray *navigationBarButtons;
    
    int checkIfAllPagesLoaded;
}



/*
    pageProfileDetails = @{@{pageId, url} : name}
    sortedNames is used to sort pageProfileDetails by name
*/
@property (strong, nonatomic)  NSMutableDictionary *pageProfileDetails;
@property (strong, nonatomic) NSArray *sortedNames;


@property (strong, nonatomic) NSMutableDictionary *selectedMickey;

@end

/*To-Do:
 
 */

@implementation ChooseFbPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKAccessToken *accessToken = [[FBSDKAccessToken alloc]initWithTokenString:@"772744622840259|63e7300f4f21c5f430ecb740b428a10e" permissions:nil declinedPermissions:nil appID:@"772744622840259"  userID:@"772744622840259" expirationDate:nil refreshDate:nil];
    [FBSDKAccessToken setCurrentAccessToken:accessToken];
    

    
    self.pageProfileDetails = [[NSMutableDictionary alloc]init];
    
    

    
    
    _selectedMickey = [[NSMutableDictionary alloc]init];
    NSArray *selectedpageIdsPersisted = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedFbProfileIds"];
    for(NSString *selectedFbProfileId in selectedpageIdsPersisted)
        [_selectedMickey setObject:selectedFbProfileId forKey:selectedFbProfileId];
    
    NSLog(@"%@", [_selectedMickey allValues]);
    
    
    

    
    

    // Don't use the following shit if you are creating cells using storyboard
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    

    FMMosaicLayout *mosaicLayout = [[FMMosaicLayout alloc] init];
    self.collectionView.collectionViewLayout = mosaicLayout;
    mosaicLayout.delegate=self;
    
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self getPageProfilePictures];
    [self performSelector:@selector(sortByName) withObject:nil afterDelay:1.5];

    navigationBarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    [navigationBarButtons removeObject:self.getFeedButton];
    [self.navigationItem setRightBarButtonItems:navigationBarButtons];

    //Refresh Control
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshCollection) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
 
    for(NSInteger i; i<_sortedNames.count; ++i)
    if([[_selectedMickey allKeys] containsObject:_sortedNames[i]])
    {

//        [self.collectionView ]
//        [[self.collectionView delegate] collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

    }

    

}


#pragma mark - CollectionView delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_pageProfileDetails count];
}


//http://stackoverflow.com/questions/18977527/how-do-i-display-the-standard-checkmark-on-a-uicollectionviewcell

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.alpha=0;
    
    if(_sortedNames.count>indexPath.item) {
        
        UILabel *myLabel = (UILabel *)[cell viewWithTag:144];
        myLabel.text = _sortedNames[indexPath.item];
        
    UIImageView *myImage = (UIImageView *)[cell viewWithTag:143];
    myImage.image = [UIImage imageNamed:@"checkmark.png"];
    [myImage sd_setImageWithURL:[NSURL URLWithString:_pageProfileDetails[_sortedNames[indexPath.item]][@"profPicURL"]] placeholderImage:[UIImage imageNamed:@"checkmark.png"]];

//        if(indexPath.item==0) {
//            cell.selected = TRUE;
//            [self collectionView:collectionView myCustomSelectDeselectItemAtIndexPath:indexPath];
//            
////            [collectionView selectItemAtIndexPath:indexPath animated:TRUE scrollPosition:UICollectionViewScrollPositionNone];
////            [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
//            
//        }

        
       // NSLog(@"Cell at %ld is %i", (long)indexPath.item, cell.isSelected);
//        if([[_selectedMickey allKeys] containsObject:_sortedNames[indexPath.item]])
//        {
//            [collectionView selectItemAtIndexPath:indexPath animated:TRUE scrollPosition:UICollectionViewScrollPositionNone];
//            [[collectionView delegate] collectionView:collectionView didSelectItemAtIndexPath:indexPath];
//            //  [self collectionView:self.collectionView myCustomSelectDeselectItemAtIndexPath:indexPath];
//            
//            
//        }
        
        
//    
//    if (cell.selected){
//        ((UIImageView *)[cell viewWithTag:142]).hidden = NO;
//        myImage.alpha=0.3;     }
//    else {
//        ((UIImageView *)[cell viewWithTag:142]).hidden = YES;
//        myImage.alpha=1.0;
//    }
    
    
    UInt64 millidelay = (arc4random()%600)/1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(millidelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.55 animations:^{
            cell.alpha=1.0;
        }];
    });
    }
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    //spacing between outercells and the boundary
    return UIEdgeInsetsMake(2, 2, 2, 2);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
interitemSpacingForSectionAtIndex:(NSInteger)section
{
    //spacing between every two cells
    return 2.0;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
  mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return FMMosaicCellSizeBig;
}

#pragma mark -selectItem delegate methods for collection view
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [self collectionView:collectionView myCustomSelectDeselectItemAtIndexPath:indexPath];
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self collectionView:collectionView myCustomSelectDeselectItemAtIndexPath:indexPath];
}

-(void) collectionView:(UICollectionView *)collectionView myCustomSelectDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    
    if(cell.selected) {
        ((UIImageView *)[cell viewWithTag:142]).hidden=NO;
        ((UIImageView *)[cell viewWithTag:143]).alpha=0.3;
        
        
        /* a dictionary is used to keep track of item at the time of de-selection */
        NSString *selectedPagedId = _pageProfileDetails[_sortedNames[indexPath.item]][@"pageId"];
        [_selectedMickey setObject:selectedPagedId forKey:_sortedNames[indexPath.item]];
        
        if([_selectedMickey count] && ![navigationBarButtons containsObject:self.getFeedButton]) {
            [navigationBarButtons addObject:self.getFeedButton];
            [self.navigationItem setRightBarButtonItems:navigationBarButtons];
        }
  
    }
    
    
    else {
        ((UIImageView *)[cell viewWithTag:142]).hidden=YES;
        ((UIImageView *)[cell viewWithTag:143]).alpha=1;
        
        
        [_selectedMickey removeObjectForKey:_sortedNames[indexPath.item]];
        
        if(![_selectedMickey count]) {
            [navigationBarButtons removeObject:self.getFeedButton];
            [self.navigationItem setRightBarButtonItems:navigationBarButtons];
        }
    }
}



#pragma mark - Facebook Fetch
-(void) getPageProfilePictures {
    
    NSArray * pageIds = @[    @"272394492879208",
                              @"754869404569818",
                              @"418543801611643",
                              @"240482462650426",
                              @"231275190406200",
                              @"100641016663545",
                              @"217963184943488",
                              @"666376426759997",
                              @"567441813288417",
                              @"671125706342859",
                              @"146825225353259",
                              @"415004402015833",
                              @"353701311987",
                              @"198343570325312",
                              @"242919515859218",
                              @"537723156291580",
                              @"317158211638196",
                              @"1410660759172170",
                              @"206783812798277",
                              @"182484805131346",
                              @"292035034247",
                              @"257702554250168",
                              @"171774543014513"];
    
    for(NSString *fbid in pageIds ) {
  
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:[NSString stringWithFormat:@"/%@", fbid] parameters:@{ @"fields": @"picture.type(normal), name",} HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (!error) {
                [self.pageProfileDetails setObject:@{
                                                @"pageId"     : fbid,
                                                @"profPicURL" : result[@"picture"][@"data"][@"url"]
                                                }
                                       forKey:result[@"name"]];
                
            }
            else {
                UIAlertController* alertPopup = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"There seems an error! Try again later" preferredStyle:UIAlertControllerStyleAlert ];
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
    }; //end of for loop
}


-(void) sortByName {
    
    _sortedNames = [[self.pageProfileDetails allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.collectionView reloadData];

}


- (IBAction)showFeedAction:(id)sender {
    
//    [_selectedMickey enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
//     {
//         NSLog(@"key: %@, value: %@", key, obj); 
//     }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_selectedMickey allKeys] forKey:@"selectedFbProfileIds"];
    [userDefaults synchronize];
    
    
    [self performSegueWithIdentifier:@"goToPosts" sender:nil];

}




#pragma mark-Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToPosts"])
    {
        ListOfFbPostsViewController *destin = [segue destinationViewController];
        destin.selectedProfileIds = (NSArray *)[_selectedMickey allValues];

    }
    
}


-(void) refreshCollection {
    //refresh data
    [self getPageProfilePictures];
    [self performSelector:@selector(sortByName) withObject:nil afterDelay:1];
    
    [refreshControl endRefreshing];
    [self.collectionView reloadData];
}

@end
