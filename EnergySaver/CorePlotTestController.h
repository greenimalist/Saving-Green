//
//  CorePlotTestController.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface CorePlotTestController : NSWindowController <CPPlotDataSource> {
   	IBOutlet CPLayerHostingView *graphView;
    CPXYGraph *graph;
    
@private
    
}

@end
