//
//  HomePageViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "theTabBarViewController.h"


@interface HomePageViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *password;



- (IBAction)testAction:(UIButton *)sender;


@end
