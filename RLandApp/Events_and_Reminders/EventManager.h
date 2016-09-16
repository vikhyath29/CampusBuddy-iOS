//
//  EventManager.h
//  RLandApp
//
//  Created by Vikhyath on 12/19/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

// Used to manage the various Event Kit related taskslike saving, loading, deleting and more operations.

@interface EventManager : NSObject

// 1. This class handles almost everything in the Event Kit:Create, edit, delete events from a user's Calendar DB
@property (nonatomic, strong) EKEventStore *eventStore;

// 2. Requesting access to user's Calendar DB

// 3. To let us know whether the user has granted access or not, we will use a boolean value. That value will be saved to the user defaults (NSUserDefaults) dictionary, and it will be retrieved upon subsequent launches of the app.
@property (nonatomic) BOOL eventsAccessGranted;

//In order to list existing (local) calendars, it’s required to have data to show. we’ll get all the local calendars from the event store object
-(NSArray *)getLocalEventCalendars;

//each calendar has a unique identifier string, so instead of storing a calendar object when users selects one, we’ll just save its identifier. That’s simpler to do, and by using the identifier we can retrieve the respective calendar from the event store object.
@property (nonatomic, strong) NSString *selectedCalendarIdentifier;

@property (nonatomic, strong) NSString *selectedEventIdentifier;

//its purpose is to store the identifiers of the newly created calendars, but how can we handle a bunch of them, not only when saving, but when loading them or later when deleting calendars? The best solution that we have at our disposal it to use an array, in which we’ll add all identifiers, and then we’ll store that array to the user defaults dictionary.
-(void)saveCustomCalendarIdentifier:(NSString *)identifier;

-(BOOL)checkIfCalendarIsCustomWithIdentifier:(NSString *)identifier;

-(void)removeCalendarIdentifier:(NSString *)identifier;

-(NSString *)getStringFromDate:(NSDate *)date;

-(NSArray *)getEventsOfSelectedCalendar;

-(void)deleteEventWithIdentifier:(NSString *)identifier;

@end

