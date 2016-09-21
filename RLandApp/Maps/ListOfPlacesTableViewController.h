//
//  ListOfPlacesViewController.h
//  RLandApp
//
//  Created by Vikhyath on 1/30/16.
//  Copyright © 2016 Self. All rights reserved.


#import <UIKit/UIKit.h>


@class ListOfPlacesTableViewController;


@protocol ListOfPlacesTableViewControllerDelegate <NSObject>
/* Custom Delegate to pass selected Places */
@required
- (void)addItemViewController:(ListOfPlacesTableViewController *)controller didFinishEnteringItem:(NSInteger)item;
@end


/*Interface Section */
@interface ListOfPlacesTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <ListOfPlacesTableViewControllerDelegate> delegate;
- (IBAction)backAction:(id)sender;

@end
