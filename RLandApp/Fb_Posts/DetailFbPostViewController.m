//
//  DetailFbPostViewController.m
//  RLandApp
//
//  Created by Vikhyath on 8/31/16.
//  Copyright © 2016 Self. All rights reserved.
//

#import "DetailFbPostViewController.h"

@interface DetailFbPostViewController ()

@end

@implementation DetailFbPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activityIndicator.color = [UIColor blueColor];
    //    activityIndicator.hidden = NO;
    //    [self.view addSubview:activityIndicator];
    //    [activityIndicator startAnimating];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    NSURL *url = [NSURL URLWithString:_postURLString];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}


@end
