//
//  ListOfPlacesViewController.h
//  RLandApp
//
//  Created by Vikhyath on 1/30/16.
//  Copyright © 2016 Self. All rights reserved.


#import <UIKit/UIKit.h>


@class ListOfPlacesViewController;


@protocol ListOfPlacesViewControllerDelegate <NSObject>
@required
- (void)addItemViewController:(ListOfPlacesViewController *)controller didFinishEnteringItem:(NSInteger)item;
@end




@interface ListOfPlacesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <ListOfPlacesViewControllerDelegate> delegate;
- (IBAction)backAction:(id)sender;


@end
