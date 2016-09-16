//
//  CreateAlertViewController.m
//  RLandApp
//
//  Created by Vikhyath on 12/17/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "CreateAlertViewController.h"


@interface CreateAlertViewController ()

@end

@implementation CreateAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0) return 1;
    else if(section == 1) return 2;
    else return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{return section ? @"":@"Create a Reminder:";}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Name of Label";
            cell.userInteractionEnabled = NO;
            // using cell.selectionStyle = UITableViewCellSelectionStyleNone; doesn't prevent the cell from calling didSelectRowAtindexPath when row is selected
            break;
            
        case 1:
            if(indexPath.row ==0) cell.textLabel.text = @"Add Alarm Time";
            if(indexPath.row ==1) cell.textLabel.text = @"Repeat";
            break;
            
    }
            return cell;
}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
