//
//  ChooseFbPageViewController.h
//  RLandApp
//
//  Created by Vikhyath on 2/7/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMosaicLayout/FMMosaicLayout.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "ListOfFbPostsViewController.h"

@interface ChooseFbPageViewController : UICollectionViewController<UICollectionViewDelegate, UICollectionViewDataSource, FMMosaicLayoutDelegate >





- (IBAction)showFeedAction:(id)sender;

@end
