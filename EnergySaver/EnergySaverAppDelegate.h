//
//  EnergySaverAppDelegate.h
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EnergyBusterViewController.h"
#import "CPViewController.h"
#import "PieVC.h"
#import "BarVC.h"

@interface EnergySaverAppDelegate : NSObject <NSApplicationDelegate, NSTabViewDelegate> {
@private
    NSWindow *window;

    IBOutlet NSTabView *tabView;
    EnergyBusterViewController *ebvc;
    CPViewController *cpvc;
    PieVC *pvc;
    BarVC *bvc;
}

@property (assign) IBOutlet NSWindow *window;

    
@end
