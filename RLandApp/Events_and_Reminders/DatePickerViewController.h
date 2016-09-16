//
//  DatePickerViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/20/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerDelegate

-(void)dateWasSelected:(NSDate *)selectedDate;

@end


@interface DatePickerViewController : UIViewController

@property (nonatomic, strong) id<DatePickerViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *dtDatePicker;


- (IBAction)acceptDate:(id)sender;

@end
