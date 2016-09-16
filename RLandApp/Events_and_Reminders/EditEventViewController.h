//
//  EditEventViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/19/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"

@protocol EditEventViewControllerDelegate

-(void)eventWasSuccessfullySaved;

@end


@interface EditEventViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DatePickerViewControllerDelegate>

@property (nonatomic, strong) id<EditEventViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblEvent;



- (IBAction)saveEvent:(id)sender;

@end
