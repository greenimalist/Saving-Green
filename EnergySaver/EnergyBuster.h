//
//  EnergyBuster.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnergyBuster : NSView {
    
    IBOutlet NSTextField *titleField;
    IBOutlet NSTextField *descriptionField;
    IBOutlet NSTextField *setupCostField;
    IBOutlet NSTextField *setupTimeField;
    IBOutlet NSTextField *ongoingTimeField;
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *monthlySavingsField;
    IBOutlet NSTextField *annualSavingsField;
    
    NSString *title;
    NSString *description; // how-to implement EnergyBuster
    NSString *choice; // Interested in trying? Yes, No, Later
    NSString *eventName;
    
    int savingsPerEvent; // in cents
    int eventsPerMonth;
    int savingsPerMonth; // in cents
    int setupCost; // in cents
    
    int setupTime; // in seconds
    int ongoingTime; // in seconds, per event
    
    NSDate *startDate; // when first implemented
    

//@private
    
}

//- (int) savedToday; // The amount of money saved today, in cents
//- (int) totalSaved; // The amount of money saved in total, in cents

- (void)load:(NSDictionary *)eb;
- (IBAction)actNow:(id) sender;
- (IBAction)actLater:(id) sender;
- (IBAction)actNever:(id) sender;
- (void)loadDailyRate;

@end
