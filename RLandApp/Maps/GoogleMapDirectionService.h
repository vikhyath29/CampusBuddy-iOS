//
//  GoogleMapDirectionService.h
//  RLandApp
//
//  Created by Vikhyath on 12/16/15.
//  Copyright © 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleMapDirectionService : NSObject

- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;

- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;

- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;

@end
