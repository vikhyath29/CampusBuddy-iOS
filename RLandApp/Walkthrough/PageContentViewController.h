//
//  PageContentViewController.h
//  RLandApp
//
//  Created by Vikhyath on 2/13/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;


@end
