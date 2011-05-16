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

- (void)loadDictionary:(NSDictionary *)ebd {
    self.title = [ebd objectForKey:@"Title"];
    self.description = [ebd objectForKey:@"Description"];
    self.choice = [ebd objectForKey:@"Choice"];
    self.graphicURL = [ebd objectForKey:@"Graphic URL"];
    self.eventName = [ebd objectForKey:@"Event Name"];
    self.savingsPerEvent = [[ebd objectForKey:@"Savings Per Event"] intValue];
    self.savingsPerMonth = [[ebd objectForKey:@"Savings Per Month"] intValue];
    self.setupCost = [[ebd objectForKey:@"Setup Cost"] intValue];
    self.setupTime = [[ebd objectForKey:@"Setup Time"] intValue];
    self.ongoingTime = [[ebd objectForKey:@"Ongoing Time"] intValue];
}


- (void)dealloc
{
    [super dealloc];
}

-(int)savingsPerYear {
    return savingsPerMonth * 12;
}


@end
