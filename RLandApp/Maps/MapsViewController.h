//
//  MapsViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
#import "ListOfPlacesTableViewController.h"

@interface MapsViewController : UIViewController<GMSMapViewDelegate, ListOfPlacesTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>




//@property (weak, nonatomic) IBOutlet UISwitch *isTrackEnabled;
@property (weak, nonatomic) IBOutlet UISwitch *searchFeatureSwitch;

@property (weak, nonatomic) IBOutlet UITableView *placesTableView;

- (IBAction)trackEnableAction:(UISwitch *)sender;
- (IBAction)toggleMapViewAction:(UISegmentedControl *)sender;
- (IBAction)featuresAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *listOfPlacesTableView;

@end
