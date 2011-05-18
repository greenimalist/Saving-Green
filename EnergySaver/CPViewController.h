//
//  CPViewController.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface CPViewController : NSViewController <CPPlotDataSource> {

    IBOutlet CPLayerHostingView *cplhv;
    CPXYGraph *graph;
    
    NSMutableArray *ebArray;
    NSArray *dataArray;
    NSInteger numberOfDays;
@private
    
}

@property (retain) NSMutableArray *ebArray;

@end
