//
//  EnergySaverAppDelegate.h
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "EnergyBusterViewController.h"


@interface EnergySaverAppDelegate : NSObject <NSApplicationDelegate, CPPlotDataSource, NSTabViewDelegate> {
@private
    NSWindow *window;
    
    IBOutlet CPLayerHostingView *graphView;
    CPXYGraph *graph;
    EnergyBusterViewController *ebvc;
    IBOutlet NSTabView *tabView;
}

@property (assign) IBOutlet NSWindow *window;

    
@end
