//
//  EnergyBuster.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnergyBuster : NSView {
    
    IBOutlet NSTextField *titleField;
    
    NSString *title;
    NSString *description; // how-to implement EnergyBuster
    NSString *choice; // Interested in trying? Yes, No, Later
    NSString *eventName;
    
    NSURL *graphicURL; // link to picture for each EnergyBuster
    
    int savingsPerEvent; // in cents
    int eventsPerMonth;
    int savingsPerMonth; // in cents
    int setupCost; // in cents
    
    int setupTime; // in seconds
    int ongoingTime; // in seconds, per event
    
    NSDate *startDate; // when first implemented
    

//@private
    
}

//- (int) savedToday; // The amount of money saved today, in cents
//- (int) totalSaved; // The amount of money saved in total, in cents

- (void)load:(NSDictionary *)eb;

@end
