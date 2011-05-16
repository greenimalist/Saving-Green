//
//  EnergySaverAppDelegate.h
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface EnergySaverAppDelegate : NSObject <NSApplicationDelegate, CPPlotDataSource> {
@private
    NSWindow *window;
    
    IBOutlet CPLayerHostingView *graphView;
    CPXYGraph *graph;
}

@property (assign) IBOutlet NSWindow *window;

@end
