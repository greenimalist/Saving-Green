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

@implementation EnergySaverAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    CorePlotTestController *controller = [[CorePlotTestController alloc] initWithNibName:@"CorePlotTestController" bundle:nil];
    [window setContentView: [controller view]];
}

@end
