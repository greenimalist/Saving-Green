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

// NSCoding Methods

- (id)initWithCoder:(NSCoder *)decoder {
//  NSObject doesn't conform to NSCoder
// self = [super initWithCoder:decoder];
    
    self = [self init];
    
    self.title = [decoder decodeObjectForKey:@"Title"];
    self.description = [decoder decodeObjectForKey:@"Description"];
    self.choice = [decoder decodeObjectForKey:@"Choice"];
    self.graphicURL = [decoder decodeObjectForKey:@"Graphic URL"];
    self.eventName = [decoder decodeObjectForKey:@"Event Name"];
    self.eventsPerMonth = [decoder decodeIntForKey:@"Events Per Month"];
    self.savingsPerEvent = [decoder decodeIntForKey:@"Savings Per Event"];
    self.savingsPerMonth = [decoder decodeIntForKey:@"Savings Per Month"];
    self.setupCost = [decoder decodeIntForKey:@"Setup Cost"];
    self.setupTime = [decoder decodeIntForKey:@"Setup Time"];
    self.ongoingTime = [decoder decodeIntForKey:@"Ongoing Time"];
    self.startDate = [decoder decodeObjectForKey:@"Start Date"];

    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
//  NSObject doesn't conform to NSCoder
//  [super encodeWithCoder:encoder];

    [encoder encodeObject:title forKey:@"Title"];
    [encoder encodeObject:description forKey:@"Description"];
    [encoder encodeObject:choice forKey:@"Choice"];
    [encoder encodeObject:graphicURL forKey:@"Graphic URL"];
    [encoder encodeObject:eventName forKey:@"Event Name"];
    [encoder encodeInt:eventsPerMonth forKey:@"Events Per Month"];
    [encoder encodeInt:savingsPerEvent forKey:@"Savings Per Event"];
    [encoder encodeInt:savingsPerMonth forKey:@"Savings Per Month"];
    [encoder encodeInt:setupCost forKey:@"Setup Cost"];
    [encoder encodeInt:setupTime forKey:@"Setup Time"];
    [encoder encodeInt:ongoingTime forKey:@"Ongoing Time"];
    [encoder encodeObject:startDate forKey:@"Start Date"];
}

- (int)priority {
    // TODO: Come up with a better algorithm!
    return self.savingsPerYear;
}


@end
