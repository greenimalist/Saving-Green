//
//  EnergyBusterViewController.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EnergyBuster.h"


@interface EnergyBusterViewController : NSViewController {

    IBOutlet NSTextField *titleField;
    IBOutlet NSTextField *descriptionField;
    IBOutlet NSTextField *setupCostField;
    IBOutlet NSTextField *setupTimeField;
    IBOutlet NSTextField *ongoingTimeField;
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *monthlySavingsField;
    IBOutlet NSTextField *annualSavingsField;
    IBOutlet NSTextField *eventNameField;

    EnergyBuster *energyBuster;
    NSMutableArray *ebArray;
    
@private
    
}

@property (retain) EnergyBuster *energyBuster;
@property (retain) NSMutableArray *ebArray;

- (IBAction)actNow:(id) sender;
- (IBAction)actLater:(id) sender;
- (IBAction)actNever:(id) sender;

- (void)load:(EnergyBuster *)eb;
- (void)loadDailyRate;
- (void)selectNextEnergyBuster;

- (void)archiveEnergyBusters; // Archive the array of energy busters 

@end
