//
//  ChooseFbPageViewController.m
//  RLandApp
//
//  Created by Vikhyath on 2/7/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import "ChooseFbPageViewController.h"

@interface ChooseFbPageViewController ()
{
    NSArray *pageProfilePicsArr;
    NSArray *pageIds ;
}

@end

@implementation ChooseFbPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedProfilesDictionary= [[NSMutableDictionary alloc]init];
    
    pageProfilePicsArr = @[@"Anushruti",
                           @"Ashrae",
                           @"Audio Section",
                           @"bookshelf",
                           @"Cinema Club",
                           @"CineSec",
                           @"Cognizance",
                           @"Electronics Section",
                           @"Fine Arts",
                           @"General Notice Board",
                           @"Group For Interactive Learning",
                           @"IITR Page",
                           @"IMG",
                           @"Mobile Development Group",
                           @"NCC IITR",
                           @"PAG",
                           @"photography section",
                           @"Rhapsody",
                           @"Sanskriti",
                           @"SDS Labs",
                           @"Share iITR",
                           @"Team Robocon",
                           @"Thomso"];
    
    
    
    pageIds = @[@"272394492879208", @"754869404569818", @"418543801611643", @"240482462650426", @"231275190406200", @"100641016663545",@"217963184943488", @"666376426759997", @"567441813288417", @"671125706342859", @"146825225353259", @"415004402015833", @"353701311987", @"198343570325312",
    @"242919515859218", @"537723156291580", @"317158211638196", @"1410660759172170",  @"206783812798277", @"182484805131346",  @"292035034247", @"257702554250168", @"171774543014513"];
    
    NSDictionary *myDict = [NSDictionary dictionaryWithObjects:pageProfilePicsArr forKeys:pageIds];
    

    // Don't use the following shit if you are creating cells using storyboard
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    FMMosaicLayout *mosaicLayout = [[FMMosaicLayout alloc] init];
    self.collectionView.collectionViewLayout = mosaicLayout;
    mosaicLayout.delegate=self;
    
    self.collectionView.allowsMultipleSelection = YES;
    
}

#pragma mark - CollectionView delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [pageProfilePicsArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.alpha=0;
    UIImageView *myImage = (UIImageView *)[cell viewWithTag:143];
    myImage.image = [UIImage imageNamed:[pageProfilePicsArr objectAtIndex:indexPath.row]];
    
    UILabel *myLabel = (UILabel *)[cell viewWithTag:144];
    myLabel.text = [pageProfilePicsArr objectAtIndex:indexPath.row];
    
    if (cell.selected){
        ((UIImageView *)[cell viewWithTag:142]).hidden = NO;
        myImage.alpha=0.3; //Without this, tableview will do some reuse shit.once check out
    }
    else {
        ((UIImageView *)[cell viewWithTag:142]).hidden = YES;
        myImage.alpha=1.0;
    }
    
    // NSLog(@"this is %@", myImage.image);
    
    
    //    CGFloat randomBlue = drand48();
    //    CGFloat randomGreen = drand48();
    //    CGFloat randomRed = drand48();
    //    cell.backgroundColor = [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
    
    UInt64 millidelay = (arc4random()%600)/1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(millidelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.55 animations:^{
            cell.alpha=1.0;
        }];
    });
    
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    //spacing between outercells and the boundary
    return UIEdgeInsetsMake(2, 2, 2, 2);
    
}

//
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
interitemSpacingForSectionAtIndex:(NSInteger)section
{
    //spacing between every two cells
    return 2.0;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
  mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return indexPath.item%7 ==0?FMMosaicCellSizeBig:FMMosaicCellSizeSmall;
    return FMMosaicCellSizeBig;
}

#pragma mark -selectItem delegate methods for collection view
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    
    ((UIImageView *)[cell viewWithTag:142]).hidden=NO;
    
    ((UIImageView *)[cell viewWithTag:143]).alpha=0.3;
    //can use highlightItemAtIndexPath..didn't try it. Maybe checkmark also gets highlighted and de-highlighted if we use this method
    
    [selectedProfilesDictionary setValue:pageIds[indexPath.item] forKey:pageProfilePicsArr[indexPath.item]];
    //make the prof pic array a dictionary with keys as ids
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    
    ((UIImageView *)[cell viewWithTag:142]).hidden=YES;
    ((UIImageView *)[cell viewWithTag:143]).alpha=1;
    
    [selectedProfilesDictionary removeObjectForKey:pageProfilePicsArr[indexPath.item]];
    
}




- (IBAction)showFeedAction:(id)sender {
    
    
    [self performSegueWithIdentifier:@"goToPosts" sender:nil];
//    [selectedProfilesDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
//     {
//         NSLog(@"key: %@, value: %@", key, obj);
//     }];
//    
//    if([selectedProfilesDictionary count])
//    {
//        [self performSegueWithIdentifier:@"goToPosts" sender:nil];
//    }
//    else {
//            UIAlertController* alertpopup = [UIAlertController alertControllerWithTitle:@"Yo!" message:@"You got to select atleast one page!" preferredStyle:UIAlertControllerStyleAlert ];
//        
//        [self presentViewController:alertpopup animated:YES completion:nil];
//                [self performSelector:@selector(myDismissViewController) withObject:self afterDelay:1];
//                
//            
//        
//    }
    
}

-(void) myDismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToPosts"])
    {
        
        
    }
    
}


@end
