//
//  MapsViewController.h
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;


@interface MapsViewController : UIViewController<GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *searchFeatureSwitch;
@property (weak, nonatomic) IBOutlet UITableView *placesTableView;
@end
