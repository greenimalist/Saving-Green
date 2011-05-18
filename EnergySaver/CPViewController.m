//
//  CPViewController.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CPViewController.h"
#import "Calendar.h"


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
    return numberOfDays;
}

- (NSNumber *)numberForPlot:(CPPlot *)plot
                field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index {
    
    NSDictionary *entry = [dataArray objectAtIndex:index];
    NSNumber *mySavings = [entry objectForKey:@"My Savings"];
    NSNumber *averageSavings = [entry objectForKey:@"Average Savings"];
    
    if (fieldEnum == CPScatterPlotFieldX) {
        return [NSNumber numberWithDouble:index];
    }
    else {
        if (plot.identifier == @"My Savings Plot")
            return mySavings;
        else if (plot.identifier == @"Average Savings Plot")
            return averageSavings;
    else
        return [NSNumber numberWithDouble:0.0];
    }
}

- (void)viewDidLoad {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DailyRatePList" ofType:@"plist"];
    
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    dataArray = [[NSArray alloc] initWithArray:[plist objectForKey:@"Data"]];
    
    NSDictionary *firstEntry = [dataArray objectAtIndex:0];
    NSDate *firstDate = [firstEntry objectForKey:@"Date Implemented"];
    NSDictionary *lastEntry = [dataArray lastObject];
    NSDate *lastDate = [lastEntry objectForKey:@"Date Implemented"];
    
    numberOfDays = [NSDate daysBetweenDate:firstDate andDate:lastDate];
    
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
    
//    CPTheme *theme = [CPTheme themeNamed:kCPStocksTheme];
//    [graph applyTheme: theme];
}
- (void)loadView {
    [super loadView];
    [self viewDidLoad];
}

@end
