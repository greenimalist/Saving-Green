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
    NSLog(@"%@", [eb objectForKey:@"Description"]);
    [descriptionField setStringValue:[eb objectForKey:@"Description"]];
    NSLog(@"%@", [eb objectForKey:@"Ongoing Time"]);
    [ongoingTimeField setStringValue:[eb objectForKey:@"Ongoing Time"]];
    NSLog(@"%@", [eb objectForKey:@"Setup Time"]);
    [setupTimeField setStringValue:[eb objectForKey:@"Setup Time"]];
    NSLog(@"%@", [eb objectForKey:@"Setup Cost"]);
    [setupCostField setStringValue:[eb objectForKey:@"Setup Cost"]];
/*    NSLog(@"%@", [eb objectForKey:@"Graphic URL"]);
    
    NSImage *image = [[]];
    
    [imageView setStringValue:[eb objectForKey:@"Graphic URL"]];
 */
}

- (IBAction)actNow:(id) sender {
    NSLog(@"Act Now!");
    
}

- (IBAction)actLater:(id) sender {
    NSLog(@"Act Later!");
}

- (IBAction)actNever:(id) sender {
    NSLog(@"Act Never!");
}

- (void)dealloc
{
    [super dealloc];
}

@end
