//
//  PieVC.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PieVC.h"


@implementation PieVC

@synthesize graph, pieData;

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
    [super dealloc];
}

- (void)viewDidLoad {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MonthlySavingsByCategory" ofType:@"plist"];
    
    categories = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (NSString *key in categories)
    {
        NSLog(@"%@", [categories objectForKey:key]);
    }
    
    // Sample Code
    
    graph = [[CPXYGraph alloc] initWithFrame: self.view.bounds];
    cplhv.hostedLayer = graph;
    
    CPPieChart *pieChart = [[CPPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.pieRadius = 100.0;
    pieChart.identifier = @"PieChart1";
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPPieDirectionCounterClockwise;
    
    self.pieData = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:90.0], 
                    [NSNumber numberWithDouble:20.0],
                    [NSNumber numberWithDouble:30.0],
                    [NSNumber numberWithDouble:40.0],
                    [NSNumber numberWithDouble:50.0], [NSNumber numberWithDouble:60.0], nil];
    [graph addPlot:pieChart];
    [pieChart release];
    
    
    /*
    NSLog(@"Number of Days: %d", numberOfDays);
    
    double minY = 0.0;
    double maxY = 0.0;
    
    for (NSDictionary *d in dataArray)
    {
        double mySavings = [[d objectForKey:@"My Savings"] doubleValue];
        double averageSavings = [[d objectForKey:@"Average Savings"] doubleValue];
        maxY = MAX(MAX(maxY, mySavings), averageSavings);
    }
    
    graph = [[CPXYGraph alloc] initWithFrame:self.view.bounds];
    
    cplhv.hostedLayer = graph;
    
    graph.paddingLeft = 30.0;
    graph.paddingTop = 30.0;
    graph.paddingRight = 30.0;
    graph.paddingBottom = 30.0;
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1) length:CPDecimalFromFloat(numberOfDays)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(minY-1) length:CPDecimalFromFloat(maxY-minY+1)];
    
    CPMutableLineStyle *lineStyle = [CPMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = CPDecimalFromDouble(7.0);
    axisSet.xAxis.minorTicksPerInterval = 6;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 8.0f;
    //    axisSet.xAxis.axisLabelOffset = 3.0f;
    
    axisSet.yAxis.majorIntervalLength = CPDecimalFromDouble(5.0);
    axisSet.yAxis.minorTicksPerInterval = 4;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 8.0f;
    //    axisSet.yAxis.axisLabelOffset = 3.0f;
    
    CPScatterPlot *mySavingsPlot = [[[CPScatterPlot alloc] initWithFrame:cplhv.frame] autorelease];
    mySavingsPlot.identifier = @"My Savings Plot";
    mySavingsPlot.dataSource = self;
    [graph addPlot:mySavingsPlot];
    
    CPPlotSymbol *blueCirclePlotSymbol = [CPPlotSymbol ellipsePlotSymbol];
    blueCirclePlotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
    blueCirclePlotSymbol.size = CGSizeMake(4.0, 4.0);
    mySavingsPlot.plotSymbol = blueCirclePlotSymbol;
    
    CPScatterPlot *averageSavingsPlot = [[[CPScatterPlot alloc] initWithFrame:cplhv.frame] autorelease];
    averageSavingsPlot.identifier = @"Average Savings Plot";
    averageSavingsPlot.dataSource = self;
    [graph addPlot:averageSavingsPlot];
    
    CPPlotSymbol *greenCirclePlotSymbol = [CPPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPFill fillWithColor:[CPColor greenColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    averageSavingsPlot.plotSymbol = greenCirclePlotSymbol;
     */
         
}
- (void)loadView {
    [super loadView];
    [self viewDidLoad];
}


// Data Source Methods

- (NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return [self.pieData count];
}

- (NSNumber *)numberForPlot:(CPPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index {
    return [self.pieData objectAtIndex:index];
}

@end
