//
//  HomePageViewController.m
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "HomePageViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface HomePageViewController ()

//@property(nonatomic, weak) id< UITabBarControllerDelegate > myTabBardelegate;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSNumber numberWithBool:0]; //wtf is this for?
    // Do any additional setup after loading the view.
    
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField //what for? don't remember
{
    [textField resignFirstResponder];
    return YES;
}
- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController
{
    return UIInterfaceOrientationPortrait;
}

@end
