//
//  ShowPageViewController.h
//  RLandApp
//
//  Created by Vikhyath on 2/13/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface ShowPageViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
//didn't implement the delegate though

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;


@end
