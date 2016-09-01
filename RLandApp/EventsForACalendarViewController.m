//
//  EventsForACalendarViewController.m
//  RLandApp
//
//  Created by Vikhyath on 12/19/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import "EventsForACalendarViewController.h"
#import "AppDelegate.h"

@interface EventsForACalendarViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;



//method to ask User for permission to access Calendar DB
-(void)requestAccessToEvents;

@end

@implementation EventsForACalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Instantiate the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    // Requesting access to events.
    [self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - IBAction method implementation

- (IBAction)showCalendars:(id)sender {
    if (self.appDelegate.eventManager.eventsAccessGranted) {
        [self performSegueWithIdentifier:@"idSegueCalendars" sender:self];
    }
}


- (IBAction)createEvent:(id)sender {
    if (self.appDelegate.eventManager.eventsAccessGranted) {
        [self performSegueWithIdentifier:@"idSegueEvent" sender:self];
    }
}


#pragma mark - Private method implementation

-(void)requestAccessToEvents{
    //We use this method in viewDidLoad to request access to events
    
    //Calling the requestAccessToEntityType:completion: method.
    [self.appDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        //this entire thing is one block
        if (error == nil) {
            // Store the returned granted value.
            self.appDelegate.eventManager.eventsAccessGranted = granted;
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


@end
