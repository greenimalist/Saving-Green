//
//  CPViewController.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CPViewController.h"


@implementation CPViewController

@synthesize ebArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [ebArray release];
    [super dealloc];
}

// CP Data Source

- (NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return 101;
}

- (NSNumber *)numberForPlot:(CPPlot *)plot
                field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index {
    double val = (index / 10.0) - 5;
    
    if (fieldEnum == CPScatterPlotFieldX) {
        return [NSNumber numberWithDouble:val];
    }
    else {
        if (plot.identifier == @"X Squared Plot")
            return [NSNumber numberWithDouble:val*val];
        else
            return [NSNumber numberWithDouble:1/val];
    }
}

- (void)viewDidLoad {
    graph = [[CPXYGraph alloc] initWithFrame:self.view.bounds];
    
    cplhv.hostedLayer = graph;
    
    graph.paddingLeft = 5.0;
    graph.paddingTop = 5.0;
    graph.paddingRight = 5.0;
    graph.paddingBottom = 5.0;
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-6) length:CPDecimalFromFloat(12)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-5) length:CPDecimalFromFloat(12)];
    
    CPMutableLineStyle *lineStyle = [CPMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = CPDecimalFromDouble(5.0);
    axisSet.xAxis.minorTicksPerInterval = 4;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
//    axisSet.xAxis.axisLabelOffset = 3.0f;
    
    axisSet.yAxis.majorIntervalLength = CPDecimalFromDouble(5.0);
    axisSet.yAxis.minorTicksPerInterval = 4;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
//    axisSet.yAxis.axisLabelOffset = 3.0f;
    
    CPScatterPlot *xSquaredPlot = [[[CPScatterPlot alloc] initWithFrame:cplhv.frame] autorelease];
    xSquaredPlot.identifier = @"X Squared Plot";
//    xSquaredPlot.dataLineStyle.lineWidth = 1.0f;
//    xSquaredPlot.dataLineStyle.lineColor = [CPColor redColor];
    xSquaredPlot.dataSource = self;
    [graph addPlot:xSquaredPlot];
    
    CPPlotSymbol *greenCirclePlotSymbol = [CPPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPFill fillWithColor:[CPColor greenColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    xSquaredPlot.plotSymbol = greenCirclePlotSymbol;
    
    CPScatterPlot *xInversePlot = [[[CPScatterPlot alloc] initWithFrame:cplhv.frame] autorelease];
    xInversePlot.identifier = @"X Inverse Plot";
//    xInversePlot.dataLineStyle.lineWidth = 1.0f;
//    xInversePlot.dataLineStyle.lineColor = [CPColor blueColor];
    xInversePlot.dataSource = self;
    [graph addPlot:xInversePlot];
}
- (void)loadView {
    [super loadView];
    [self viewDidLoad];
}

@end
