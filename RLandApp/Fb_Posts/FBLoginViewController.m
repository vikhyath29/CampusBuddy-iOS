//
//  FBLoginViewController.m
//  RLandApp
//
//  Created by Vikhyath on 9/22/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import "FBLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBLoginViewController ()

@end

@implementation FBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    FBSDKAccessToken *accessToken = [[FBSDKAccessToken alloc]initWithTokenString:@"772744622840259|63e7300f4f21c5f430ecb740b428a10e" permissions:nil declinedPermissions:nil appID:@"772744622840259"  userID:@"772744622840259" expirationDate:nil refreshDate:nil];
    [FBSDKAccessToken setCurrentAccessToken:accessToken];
    

    
}

@end