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
    NSDictionary *ebd;
    
@private
    
}

@property (retain) EnergyBuster *energyBuster;
@property (retain) NSDictionary *ebd;

- (void)load:(EnergyBuster *)eb;
- (IBAction)actNow:(id) sender;
- (IBAction)actLater:(id) sender;
- (IBAction)actNever:(id) sender;
- (void)loadDailyRate;
- (void)selectNextEnergyBuster;

@end
