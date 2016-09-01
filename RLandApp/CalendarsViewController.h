//
//  CalendarsViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/19/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblCalendars;

- (IBAction)Edit:(UIBarButtonItem *)sender;


@end
