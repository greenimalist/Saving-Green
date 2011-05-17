//
//  CPViewController.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
/*
 #import <CorePlot/CorePlot.h>
#import "CorePlotTestController.h"
 IBOutlet CPLayerHostingView *graphView;
 CPXYGraph *graph;
 @interface EnergySaverAppDelegate ()
 - (void)createGraph;


*/

@interface CPViewController : NSViewController {

    IBOutlet CPLayerHostingView *cplhv;
@private
    
}

@end
