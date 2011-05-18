//
//  EnergySaverAppDelegate.m
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnergySaverAppDelegate.h"
#import "EnergyBuster.h"
#define PLISTURLSTRING @"http://www.greenimalist.com/energySaver/EnergyBusterList.plist"


@implementation EnergySaverAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    
    NSURL *plistURL = [NSURL URLWithString:PLISTURLSTRING];
    NSDictionary *plistContents = [NSDictionary dictionaryWithContentsOfURL:plistURL];

    // Fall back to cache if download fails
    if (plistContents == nil)
    {
        NSString *plistPath =
        [[NSBundle mainBundle] pathForResource:@"EnergyBusterList"
                                        ofType:@"plist"];
        plistContents =
        [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    
    NSArray *array = [plistContents objectForKey:@"EnergyBusterArray"];
    
    NSMutableArray *ebArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *ebd in array)
    {
        EnergyBuster *eb = [[EnergyBuster alloc] init];
        [eb loadDictionary:ebd];
        [ebArray addObject:eb];
        [eb release];
    } 
    
    ebvc = [[EnergyBusterViewController alloc] initWithNibName:@"EnergyBusterViewController" bundle:nil];
    ebvc.delegate = self;
    ebvc.ebArray = ebArray;
    [ebArray release];
    
    // force view to load so that we can show the first EnergyBuster
    [ebvc loadView];
    [ebvc selectNextEnergyBuster];
    
    [[[tabView tabViewItemAtIndex:0] view] addSubview:ebvc.view];
    
    cpvc = [[CPViewController alloc] initWithNibName:@"CPViewController" bundle:nil];
    [[[tabView tabViewItemAtIndex:1] view] addSubview:cpvc.view];
    
    pvc = [[PieVC alloc] initWithNibName:@"PieVC" bundle:nil];
    [[[tabView tabViewItemAtIndex:2] view] addSubview:pvc.view];
    
    [tabView selectFirstTabViewItem:self];
    
}
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
//    NSLog(@"Will select Tab#%d", [tabView indexOfTabViewItem:tabViewItem]);
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
//    NSLog(@"Did select Tab#%d", [tabView indexOfTabViewItem:tabViewItem]);
}

- (void)dealloc {
    [ebvc release];
    [super dealloc];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
    // Making sure that state is saved
    NSMutableArray *ebArray = ebvc.ebArray;
    for (EnergyBuster *eb in ebArray)
    {
        NSLog(@"Title: %@", [eb title]);
        NSLog(@"Choice: %@", [eb choice]);
        NSLog(@"Date Implemented: %@", [eb startDate]);
    }
}

- (void)loadNextTab:(id)sender {
    cpvc.ebArray = ebvc.ebArray;
    [tabView selectNextTabViewItem:self];
}

@end
