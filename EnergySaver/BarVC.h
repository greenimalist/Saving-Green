//
//  BarVC.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>


@interface BarVC : NSViewController <CPPlotDataSource> {

    IBOutlet CPLayerHostingView *cplhv;
    NSArray *dataArray;
    CPXYGraph *graph;
    NSArray *allKeys;

@private
    
}

@property (retain) CPXYGraph *graph;

@end
