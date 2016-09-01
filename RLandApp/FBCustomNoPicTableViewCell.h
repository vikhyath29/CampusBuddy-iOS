//
//  FBCustomNoPicTableViewCell.h
//  facebookRestartPractise
//
//  Created by Vikhyath on 8/27/16.
//  Copyright © 2016 Vikhyath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCustomNoPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postMessage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pageProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;


@end
