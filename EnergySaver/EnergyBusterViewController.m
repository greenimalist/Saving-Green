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

@synthesize energyBuster;

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
    
    NSLog(@"%@", [energyBuster title]);
    [titleField setStringValue:[energyBuster title]];
    NSLog(@"%@", [energyBuster description]);
    [descriptionField setStringValue:[energyBuster description]];
    NSLog(@"%d", [energyBuster ongoingTime]);
    [ongoingTimeField setStringValue:[NSString stringWithFormat:@"%d", [energyBuster ongoingTime]]];
    NSLog(@"%d", [energyBuster setupTime]);
    [setupTimeField setStringValue:[NSString stringWithFormat:@"%d", [energyBuster setupTime]]];
    NSLog(@"%d", [energyBuster setupCost]);
    [setupCostField setStringValue:[NSString stringWithFormat:@"%d", [energyBuster setupCost]]];
    NSLog(@"%@", [energyBuster graphicURL]);
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[energyBuster graphicURL]]];
    
    [imageView setImage:image];
    
    [image release];
    
    int monthlySavings = [energyBuster savingsPerMonth];
    NSLog(@"$%d.%d", monthlySavings/100, monthlySavings%100);
    [monthlySavingsField setStringValue:[NSString stringWithFormat:@"$%d.%d", monthlySavings/100, monthlySavings%100]];
    
    int annualSavings = [energyBuster savingsPerYear];
    NSLog(@"$%2d.%2d", annualSavings/100, annualSavings%100);
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
    
    [self loadDailyRate];
}

- (IBAction)actNever:(id) sender {
    NSLog(@"Act Never!");
    energyBuster.choice = @"No";
    
    [self loadDailyRate];
}

- (void)loadDailyRate {
    [self selectNextEnergyBuster];
    
    NSWindow *window = [(EnergySaverAppDelegate *)[[NSApplication sharedApplication] delegate] window];
    NSTabView *tabView = (NSTabView *)[[[window contentView] subviews] lastObject];
    [tabView selectTabViewItemAtIndex:1];
}

- (void)selectNextEnergyBuster {
    // There's probably a better way to do this than repeat what the App Delegate did
    
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
    
    [self load:eb];
}


@end
