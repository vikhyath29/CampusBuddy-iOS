//
//  ChooseFbPageViewController.h
//  RLandApp
//
//  Created by Vikhyath on 2/7/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMosaicLayout/FMMosaicLayout.h"


@interface ChooseFbPageViewController : UICollectionViewController<UICollectionViewDelegate, UICollectionViewDataSource, FMMosaicLayoutDelegate >

{
    NSMutableDictionary *selectedProfilesDictionary;
}


- (IBAction)showFeedAction:(id)sender;

@end