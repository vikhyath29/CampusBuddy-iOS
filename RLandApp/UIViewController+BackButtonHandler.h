//
//  UIViewController+BackButtonHandler.h
//
//  Created by Sergey Nikitenko on 10/1/13.
//  Copyright 2013 Sergey Nikitenko. All rights reserved.


#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
