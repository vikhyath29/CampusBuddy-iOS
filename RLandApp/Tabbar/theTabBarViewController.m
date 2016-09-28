//
//  theTabBarViewController.m
//  RLandApp
//
//  Created by Vikhyath on 12/17/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "theTabBarViewController.h"
#import "AppDelegate.h"


@interface theTabBarViewController ()

@end

@implementation theTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    
 //   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];

}


//Without this tab, if you re-select the current selected tabbar, it pops to rootview
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //Here viewController=The view controller belonging to the tab that was tapped by the user.
    if(viewController == self.selectedViewController) return NO;
    else return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}




@end
