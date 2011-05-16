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
#import "EnergyBusterViewController.h"

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
    
    NSDictionary *ebd = [array objectAtIndex:(arc4random() % [array count])];
    EnergyBuster *eb = [[EnergyBuster alloc] init];
    eb.title = [ebd objectForKey:@"Title"];
    eb.description = [ebd objectForKey:@"Description"];
    eb.choice = [ebd objectForKey:@"Choice"];
    eb.graphicURL = [ebd objectForKey:@"Graphic URL"];
    eb.eventName = [ebd objectForKey:@"Event Name"];
    eb.savingsPerEvent = [[ebd objectForKey:@"Savings Per Event"] intValue];
    eb.savingsPerMonth = [[ebd objectForKey:@"Savings Per Month"] intValue];
    eb.setupCost = [[ebd objectForKey:@"Setup Cost"] intValue];
    eb.setupTime = [[ebd objectForKey:@"Setup Time"] intValue];
    eb.ongoingTime = [[ebd objectForKey:@"Ongoing Time"] intValue];
    
    EnergyBusterViewController *ebvc = [[EnergyBusterViewController alloc] initWithNibName:@"EnergyBusterViewController" bundle:nil];
    
    // force view to load so that we can show the first EnergyBuster
    [ebvc loadView];
    
    [ebvc load:(EnergyBuster *) eb];
    
    NSTabView *tabView = (NSTabView *)[[[window contentView] subviews] lastObject];
    
    [[[tabView tabViewItemAtIndex:0] view] addSubview:ebvc.view];
    [tabView selectFirstTabViewItem:self];
}

@end
