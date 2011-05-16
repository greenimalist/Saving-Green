//
//  EnergySaverAppDelegate.m
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnergySaverAppDelegate.h"
#import <CorePlot/CorePlot.h>
#import "CorePlotTestController.h"
//#import "EnergyBusterController.h"
#import "EnergyBuster.h"

@implementation EnergySaverAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
//    CorePlotTestController *controller = [[CorePlotTestController alloc] initWithNibName:@"CorePlotTestController" bundle:nil];
//    [window setContentView: [controller view]];
    
//    CorePlotTestController *controller = [[CorePlotTestController alloc] initWithWindowNibName:@"CorePlotTestController"];
//    [controller showWindow:self];
    
//    EnergyBusterController *controller = [[EnergyBusterController alloc] initWithWindowNibName:@"EnergyBusterView"];
//    [controller showWindow:self];
    
//    EnergyBusterController *controller = [EnergyBusterController shared];
//    [EnergyBusterController shared];
    
    
    NSString *plistPath =
    [[NSBundle mainBundle] pathForResource:@"EnergyBusterList"
                                    ofType:@"plist"];
    NSDictionary *plistContents =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSArray *array = [plistContents objectForKey:@"EnergyBusterArray"];
    
    NSTabView *tabView = (NSTabView *)[[[window contentView] subviews] lastObject];

    EnergyBuster *eb = (EnergyBuster *)[[[[tabView tabViewItemAtIndex:0] view] subviews] lastObject];
    
    [eb load:[array objectAtIndex:(arc4random() % [array count])]];
}

@end
