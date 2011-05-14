//
//  CorePlotTestController.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CorePlotTestController.h"


@implementation CorePlotTestController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSUInteger)numberOfRecords {
    return 51;
}

- (NSNumber *) numberForPlot:(CPPlot *)plot
                       field:(NSUInteger)fieldEnum
                 recordIndex:(NSUInteger)index
{
    double val = (index/5.0) - 5;
    
    if (fieldEnum == CPScatterPlotFieldX)
    {
        return [NSNumber numberWithDouble: val];
    }
    else
    {
        if (plot.identifier == @"X Squared Plot")
            return [NSNumber numberWithDouble:val*val];
        else
            return [NSNumber numberWithDouble: 1/val];
    }
}



- (void)dealloc
{
    [super dealloc];
}

@end
