//
//  EventManager.m
//  RLandApp
//
//  Created by Vikhyath on 12/19/15.
//  Copyright © 2015 Self. All rights reserved.


#import "EventManager.h"
// Used to manage the various Event Kit related taskslike saving, loading, deleting and more operations.

@interface EventManager()
@property (nonatomic, strong) NSMutableArray *arrCustomCalendarIdentifiers;


@end

@implementation EventManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 1.Alloc-Initing the eventStore property of this class (Note: This step is very time-consuming
        self.eventStore = [[EKEventStore alloc] init];
        
        //Creating a userDefaults dictionary
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Check if the access granted value for the events exists in the user defaults dictionary.
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            // The value exists, so assign it to the property.
            self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
        }
        else{
            // Set the default value.
            self.eventsAccessGranted = NO;
        }
    
    
    
    
    // Load the selected calendar identifier from the user defaults dictionary when an EventManager object is initialized
    if ([userDefaults objectForKey:@"eventkit_selected_calendar"] != nil) {
       self.selectedCalendarIdentifier = [userDefaults objectForKey:@"eventkit_selected_calendar"];
    }
    else
        self.selectedCalendarIdentifier = @"";
        //If the eventkit_selected_calendar key exists in the user defaults dictionary then we load the identifier of the selected calendar, otherwise we set the empty string as the value of the selectedCalendarIdentifier property.
    }
    return self;
}

#pragma mark - Setter method override

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted{
    //Besides setting the property’s value, we’ll store this boolean property to the user dictionary too everytime a new value is assigned to them.
    
    _eventsAccessGranted = eventsAccessGranted;
    //Notice that we use the _eventsAccessGranted member variable that automatically gets synthesized, instead of the self.eventsAccessGranted property, as that’s the proper way to set its value.
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

-(void)setSelectedCalendarIdentifier:(NSString *)selectedCalendarIdentifier{
    //he identifier gets saved to the user defaults dictionary upon value assignment
    //We will call this in the init method
    
    _selectedCalendarIdentifier = selectedCalendarIdentifier;
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedCalendarIdentifier forKey:@"eventkit_selected_calendar"];
}


#pragma mark - Public methods
-(NSArray *)getLocalEventCalendars{
    //In order to list existing (local) calendars, it’s required to have data to show. we’ll get all the local calendars from the event store object
    
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    
    //Note that this array contains calendars of all types, so we must get only the local ones. For that reason, we initialize a mutable array, and using a loop we check the type of each returned calendar. 
    for (int i=0; i<allCalendars.count; i++) {
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        if (currentCalendar.type == EKCalendarTypeLocal) {
            [localCalendars addObject:currentCalendar];
        }
    }
    
    return (NSArray *)localCalendars;
}

-(void)saveCustomCalendarIdentifier:(NSString *)identifier{
    [self.arrCustomCalendarIdentifiers addObject:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
}


-(BOOL)checkIfCalendarIsCustomWithIdentifier:(NSString *)identifier{
    BOOL isCustomCalendar = NO;
    
    for (int i=0; i<self.arrCustomCalendarIdentifiers.count; i++) {
        if ([[self.arrCustomCalendarIdentifiers objectAtIndex:i] isEqualToString:identifier]) {
            isCustomCalendar = YES;
            break;
        }
    }
    
    return isCustomCalendar;
}


-(void)removeCalendarIdentifier:(NSString *)identifier{
    [self.arrCustomCalendarIdentifiers removeObject:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
}


-(NSString *)getStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:@"d MMM yyyy, HH:mm"];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}


-(NSArray *)getEventsOfSelectedCalendar{
    // Specify the calendar that will be used to get the events from.
    EKCalendar *calendar = nil;
    if (self.selectedCalendarIdentifier != nil && self.selectedCalendarIdentifier.length > 0) {
        calendar = [self.eventStore calendarWithIdentifier:self.selectedCalendarIdentifier];
    }
    
    // If no selected calendar identifier exists and the calendar variable has the nil value, then all calendars will be used for retrieving events.
    NSArray *calendarsArray = nil;
    if (calendar != nil) {
        calendarsArray = @[calendar];
    }
    
    // Create a predicate value with start date a year before and end date a year after the current date.
    int yearSeconds = 365 * (60 * 60 * 24);
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-yearSeconds] endDate:[NSDate dateWithTimeIntervalSinceNow:yearSeconds] calendars:calendarsArray];
    
    // Get an array with all events.
    NSArray *eventsArray = [self.eventStore eventsMatchingPredicate:predicate];
    
    // Copy all objects one by one to a new mutable array, and make sure that the same event is not added twice.
    NSMutableArray *uniqueEventsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<eventsArray.count; i++) {
        EKEvent *currentEvent = [eventsArray objectAtIndex:i];
        
        BOOL eventExists = NO;
        
        // Check if the current event has any recurring rules set. If not, no need to run the next loop.
        if (currentEvent.recurrenceRules != nil && currentEvent.recurrenceRules.count > 0) {
            for (int j=0; j<uniqueEventsArray.count; j++) {
                if ([[[uniqueEventsArray objectAtIndex:j] eventIdentifier] isEqualToString:currentEvent.eventIdentifier]) {
                    // The event already exists in the array.
                    eventExists = YES;
                    break;
                }
            }
        }
        
        // If the event does not exist to the new array, then add it now.
        if (!eventExists) {
            [uniqueEventsArray addObject:currentEvent];
        }
    }
    
    // Sort the array based on the start date.
    uniqueEventsArray = (NSMutableArray *)[uniqueEventsArray sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    
    // Return that array.
    return (NSArray *)uniqueEventsArray;
}


-(void)deleteEventWithIdentifier:(NSString *)identifier{
    // Get the event that's about to be deleted.
    EKEvent *event = [self.eventStore eventWithIdentifier:identifier];
    
    // Delete it.
    NSError *error;
    if (![self.eventStore removeEvent:event span:EKSpanFutureEvents error:&error]) {
        // Display the error description.
        NSLog(@"%@", [error localizedDescription]);
    }
}









@end
