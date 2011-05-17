//
//  EnergyBusterViewController.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnergyBusterViewController.h"
#import "EnergySaverAppDelegate.h"

@implementation EnergyBusterViewController

@synthesize energyBuster, ebArray, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"initWithNibName:bundle:");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {

    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)updateFields {

    [titleField setStringValue:[energyBuster title]];
    [descriptionField setStringValue:[energyBuster description]];
    int ongoingTime = [energyBuster ongoingTime];
    [ongoingTimeField setStringValue:[NSString stringWithFormat:@"%2dmin:%2dsec", ongoingTime/60, ongoingTime%60]];
    [eventNameField setStringValue:[NSString stringWithFormat:@"per %@", [energyBuster eventName]]];
    int setupTime = [energyBuster setupTime];
    [setupTimeField setStringValue:[NSString stringWithFormat:@"%2dhr:%2dmin", setupTime/3600, (setupTime/60)%60]];
    int setupCost = [energyBuster setupCost]; 
    [setupCostField setStringValue:[NSString stringWithFormat:@"$%2d.%2d", setupCost/100, setupCost%100]];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[energyBuster graphicURL]]];
    [imageView setImage:image];
    [image release];
    int monthlySavings = [energyBuster savingsPerMonth];
    [monthlySavingsField setStringValue:[NSString stringWithFormat:@"$%d.%d", monthlySavings/100, monthlySavings%100]];
    int annualSavings = [energyBuster savingsPerYear];
    [annualSavingsField setStringValue:[NSString stringWithFormat:@"$%2d.%2d", annualSavings/100, annualSavings%100]];
}

- (IBAction)actNow:(id) sender {
    energyBuster.choice = @"Yes";
    energyBuster.startDate = [NSDate date];
    [self archiveEnergyBusters];
    [self loadDailyRate];
}

- (IBAction)actLater:(id) sender {
    energyBuster.choice = @"Later";
    [self archiveEnergyBusters];    
    [self selectNextEnergyBuster];
}

- (IBAction)actNever:(id) sender {
    energyBuster.choice = @"No";
    [self archiveEnergyBusters]; 
    [self selectNextEnergyBuster];
}

- (void)loadDailyRate {
    [self selectNextEnergyBuster];
    [delegate loadNextTab];
    /*
    NSWindow *window = [(EnergySaverAppDelegate *)[[NSApplication sharedApplication] delegate] window];
    NSTabView *tabView = (NSTabView *)[[[window contentView] subviews] lastObject];
    [tabView selectTabViewItemAtIndex:1];
     */
}

- (void)selectNextEnergyBuster {
    
    // Have something to fall back on in case all
    // energy busters have been picked
    EnergyBuster *highestPriority = [ebArray objectAtIndex:(arc4random() % [ebArray count])];
    
    for (EnergyBuster *eb in ebArray)
    {
        if ([eb priority] > [highestPriority priority])
            highestPriority = eb;
    }
    
    self.energyBuster = highestPriority;
    
    [self updateFields];
}

- (void)archiveEnergyBusters {
    
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"EnergySaverArray.archive"];
    NSLog(@"%@", archivePath);
    
    [NSKeyedArchiver archiveRootObject:ebArray toFile:archivePath];
}

- (void)loadView {
    [super loadView];
}


@end
