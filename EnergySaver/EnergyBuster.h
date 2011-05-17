//
//  EnergyBuster.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnergyBuster : NSObject <NSCoding> {
    
    
    NSString *title;
    NSString *description; // how-to implement EnergyBuster
    NSString *choice; // Interested in trying? Yes, No, Later
    NSString *graphicURL;
    
    NSString *eventName;
    int eventsPerMonth;

    
    int savingsPerEvent; // in cents
    int savingsPerMonth; // in cents
    
    int setupCost; // in cents
    int setupTime; // in seconds

    int ongoingTime; // in seconds, per event
    
    NSDate *startDate; // when first implemented
    

//@private
    
}

//- (int) savedToday; // The amount of money saved today, in cents
//- (int) totalSaved; // The amount of money saved in total, in cents

- (void)loadDictionary:(NSDictionary *)ebd;
- (int)priority; // The higher the priority, the earlier it will be shown

@property (copy) NSString *title;
@property (copy) NSString *description;
@property (copy) NSString *choice;
@property (copy) NSString *graphicURL;
@property (copy) NSString *eventName;
@property int eventsPerMonth;
@property int savingsPerEvent;
@property int savingsPerMonth;
@property int setupCost;
@property int setupTime;
@property int ongoingTime;
@property (copy) NSDate *startDate;
@property (readonly) int savingsPerYear;


@end
