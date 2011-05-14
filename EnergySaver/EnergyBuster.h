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
    NSString *description;
    NSString *choice;
    
    
    int savedPerInstance;
    int instancesPerMonth;
    int savedPerMonth;
    int setupCost;
    int ongoingCost;
    NSTimeInterval setupTime;
    NSTimeInterval ongoingTime;
    
    NSDate *startDate;
    

@private
    
}

@end
