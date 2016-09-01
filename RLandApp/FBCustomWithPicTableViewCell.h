//
//  FBCustomWithPicTableViewCell.h
//  facebookRestartPractise
//
//  Created by Vikhyath on 8/19/16.
//  Copyright © 2016 Vikhyath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCustomWithPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabe;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pageProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *groupName;

@property (weak, nonatomic) IBOutlet UIImageView *imageVie;

@end
