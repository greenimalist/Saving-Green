//
//  EnergyBuster.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnergyBuster.h"


@implementation EnergyBuster

@synthesize title, description, choice, graphicURL, eventName, eventsPerMonth, savingsPerEvent, savingsPerMonth, setupCost, setupTime, ongoingTime, startDate;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

-(int)savingsPerYear {
    return savingsPerMonth * 12;
}


@end
