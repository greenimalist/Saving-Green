//
//  EnergyBuster.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnergyBuster.h"


@implementation EnergyBuster

//@synthesize;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)load:(NSDictionary *)eb {
    NSLog(@"%@", [eb objectForKey:@"Title"]);
    [titleField setStringValue:[eb objectForKey:@"Title"]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
