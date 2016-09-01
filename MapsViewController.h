//
//  MapsViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
#import "ListOfPlacesViewController.h"

@interface MapsViewController : UIViewController<GMSMapViewDelegate, ListOfPlacesViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>



@property (weak, nonatomic) IBOutlet UISwitch *isTrackEnabled;






- (IBAction)trackEnableAction:(UISwitch *)sender;
- (IBAction)toggleMapViewAction:(UISegmentedControl *)sender;
- (IBAction)featuresAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *listOfPlacesTableView;

@end
