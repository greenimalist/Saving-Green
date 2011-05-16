//
//  EnergySaverAppDelegate.m
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnergySaverAppDelegate.h"
#import <CorePlot/CorePlot.h>
#import "CorePlotTestController.h"
//#import "EnergyBusterController.h"
#import "EnergyBusterViewController.h"

@interface EnergySaverAppDelegate ()
- (void)createGraph;
@end

@implementation EnergySaverAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
//    CorePlotTestController *controller = [[CorePlotTestController alloc] initWithNibName:@"CorePlotTestController" bundle:nil];
//    [window setContentView: [controller view]];
    
//    CorePlotTestController *controller = [[CorePlotTestController alloc] initWithWindowNibName:@"CorePlotTestController"];
//    [controller showWindow:self];
    
//    EnergyBusterController *controller = [[EnergyBusterController alloc] initWithWindowNibName:@"EnergyBusterView"];
//    [controller showWindow:self];
    
//    EnergyBusterController *controller = [EnergyBusterController shared];
//    [EnergyBusterController shared];
    
    
    NSString *plistPath =
    [[NSBundle mainBundle] pathForResource:@"EnergyBusterList"
                                    ofType:@"plist"];
    NSDictionary *plistContents =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSArray *array = [plistContents objectForKey:@"EnergyBusterArray"];
    
    NSDictionary *ebd = [array objectAtIndex:(arc4random() % [array count])];
    EnergyBuster *eb = [[EnergyBuster alloc] init];
    [eb loadDictionary:ebd];
    
    EnergyBusterViewController *ebvc = [[EnergyBusterViewController alloc] initWithNibName:@"EnergyBusterViewController" bundle:nil];
    
    // force view to load so that we can show the first EnergyBuster
    [ebvc loadView];
    
    [ebvc load:(EnergyBuster *) eb];
    
    NSTabView *tabView = (NSTabView *)[[[window contentView] subviews] lastObject];
    
    [[[tabView tabViewItemAtIndex:0] view] addSubview:ebvc.view];
    [tabView selectFirstTabViewItem:self];
    
    [self createGraph];
}

- (void)createGraph {
    // Create graph from theme
    graph = [(CPXYGraph *)[CPXYGraph alloc] initWithFrame:CGRectZero];
    //CPTheme *theme = [CPTheme themeNamed:kCPPlainWhiteTheme];
    //[graph applyTheme:theme]; 
    graphView.hostedLayer = graph;
    
    graph.paddingTop = 40.0;
    graph.paddingRight = 40.0;
    graph.paddingBottom = 40.0;
    
    float minimumValueForXAxis = -10;
    float minimumValueForYAxis = -10;
    float majorIntervalLengthForX = 2;
    float majorIntervalLengthForY = 2;
    float maximumValueForXAxis = 10;
    float maximumValueForYAxis = 10;
    
    // Setup plot space
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(minimumValueForXAxis) length:CPDecimalFromFloat(maximumValueForXAxis - minimumValueForXAxis)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(minimumValueForYAxis) length:CPDecimalFromFloat(maximumValueForYAxis - minimumValueForYAxis)];
    
    CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromDouble(majorIntervalLengthForX);
    x.orthogonalCoordinateDecimal = CPDecimalFromDouble(minimumValueForYAxis);
    x.minorTicksPerInterval = 5;
    
    CPXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPDecimalFromDouble(majorIntervalLengthForY);
    y.minorTicksPerInterval = 5;
    y.orthogonalCoordinateDecimal = CPDecimalFromDouble(minimumValueForXAxis);
    
    CPMutableLineStyle *borderLineStyle = [CPMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPColor colorWithGenericGray:0.2];
    borderLineStyle.lineWidth = 0.0f;
    
    //	CPBorderedLayer *borderedLayer = (CPBorderedLayer *)axisSet.overlayLayer;
    //	borderedLayer.borderLineStyle = borderLineStyle;
    //	borderedLayer.cornerRadius = 0.0f;
    
    // Create the main plot for the delimited data
    CPScatterPlot *dataSourceLinePlot = [[(CPScatterPlot *)[CPScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
    dataSourceLinePlot.identifier = @"Data Source Plot";
    
    CPMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPColor blackColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Add plot symbols
    //	CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
    //	symbolLineStyle.lineColor = [CPColor whiteColor];
    //	CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
    //	plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
    //	plotSymbol.lineStyle = symbolLineStyle;
    //    plotSymbol.size = CGSizeMake(10.0, 10.0);
    //    dataSourceLinePlot.plotSymbol = plotSymbol;
    
    [graph reloadData];
}

- (NSNumber *)numberForPlot:(CPPlot *)plot
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

- (NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return 51;
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    NSLog(@"Will select Tab#%d", [tabView indexOfTabViewItem:tabViewItem]);
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    NSLog(@"Did select Tab#%d", [tabView indexOfTabViewItem:tabViewItem]);
}



@end
