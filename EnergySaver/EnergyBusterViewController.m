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

@synthesize energyBuster, plistArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)load:(EnergyBuster *)eb {
    
    self.energyBuster = eb;
    
//    NSLog(@"%@", [energyBuster title]);
//    NSLog(@"%@", [energyBuster description]);
//    NSLog(@"%d", [energyBuster ongoingTime]);
//    NSLog(@"%d", [energyBuster setupTime]);
//    NSLog(@"%d", [energyBuster setupCost]);
//    NSLog(@"%@", [energyBuster graphicURL]);
//    NSLog(@"$%d.%d", monthlySavings/100, monthlySavings%100);
//    NSLog(@"$%2d.%2d", annualSavings/100, annualSavings%100);

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
    NSLog(@"Act Now!");
    energyBuster.choice = @"Yes";
    
    [self loadDailyRate];
}

- (IBAction)actLater:(id) sender {
    NSLog(@"Act Later!");
    energyBuster.choice = @"Later";
    
    [self selectNextEnergyBuster];
}

- (IBAction)actNever:(id) sender {
    NSLog(@"Act Never!");
    energyBuster.choice = @"No";
    
    [self selectNextEnergyBuster];
}

- (void)loadDailyRate {
    [self selectNextEnergyBuster];
    
    NSWindow *window = [(EnergySaverAppDelegate *)[[NSApplication sharedApplication] delegate] window];
    NSTabView *tabView = (NSTabView *)[[[window contentView] subviews] lastObject];
    [tabView selectTabViewItemAtIndex:1];
}

- (void)selectNextEnergyBuster {
    // There's probably a better way to do this than repeat what the App Delegate did
    
    NSDictionary *ebd = [plistArray objectAtIndex:(arc4random() % [plistArray count])];
    
    EnergyBuster *eb = [[EnergyBuster alloc] init];
    [eb loadDictionary:ebd];
    
    [self load:eb];
}



@end
