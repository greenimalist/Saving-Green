//
//  PieVC.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>


@interface PieVC : NSViewController <CPPieChartDataSource> {
    
    IBOutlet CPLayerHostingView *cplhv;
    NSDictionary *categories;
    CPXYGraph *graph;
    NSMutableArray *pieData;
    
@private
    
}

@property (retain) NSMutableArray *pieData;
@property (retain) CPXYGraph *graph;

@end
