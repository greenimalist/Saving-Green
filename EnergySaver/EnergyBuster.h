//
//  EnergyBuster.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnergyBuster : NSObject {

    NSString *title;
    NSString *description; // how-to implement EnergyBuster
    NSString *choice; // Interested in trying? Yes, No, Later
    NSString *eventName;
    
    NSURL *graphicURL; // link to picture for each EnergyBuster
    
    int savingsPerEvent; // in cents
    int eventsPerMonth;
    int savedPerMonth; // in cents
    int setupCost;
    
    NSTimeInterval setupTime;
    NSTimeInterval ongoingTime; // time per use
    
    NSDate *startDate; // when first implemented
    

//@private
    
}

//- (int) savedToday; // The amount of money saved today, in cents
//- (int) totalSaved; // The amount of money saved in total, in cents
    
//}

@end
