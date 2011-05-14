//
//  CorePlotTestController.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CorePlotTestController.h"


@implementation CorePlotTestController

//- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
//{
- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Initialization code here.
    
    
    
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





-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return 51;
}

//@optional

///// @name Implement one of the following
///// @{
//
///**	@brief Gets a range of plot data for the given plot and field.
// *	@param plot The plot.
// *	@param fieldEnum The field index.
// *	@param indexRange The range of the data indexes of interest.
// *	@return An array of data points.
// **/
//-(NSArray *)numbersForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange;
//
///**	@brief Gets a plot data value for the given plot and field.
// *	@param plot The plot.
// *	@param fieldEnum The field index.
// *	@param index The data index of interest.
// *	@return A data point.
// **/
//-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;
//
///**	@brief Gets a range of plot data for the given plot and field.
// *	@param plot The plot.
// *	@param fieldEnum The field index.
// *	@param indexRange The range of the data indexes of interest.
// *	@return A retained C array of data points.
// **/
//-(double *)doublesForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange;
//
///**	@brief Gets a plot data value for the given plot and field.
// *	@param plot The plot.
// *	@param fieldEnum The field index.
// *	@param index The data index of interest.
// *	@return A data point.
// **/
//-(double)doubleForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;
//
///**	@brief Gets a range of plot data for the given plot and field.
// *	@param plot The plot.
// *	@param fieldEnum The field index.
// *	@param indexRange The range of the data indexes of interest.
// *	@return A one-dimensional array of data points.
// **/
//-(CPNumericData *)dataForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange;
//
/////	@}
//
///// @name Data Range
///// @{
//
///**	@brief Determines the record index range corresponding to a given range of data.
// *	This method is optional. If the method is implemented, it could improve performance
// *  in data sets that are only partially displayed.
// *	@param plot The plot.
// *	@param plotRange The range expressed in data values.
// *	@return The range of record indexes.
// *	@deprecated This method is no longer used and will be removed from a later release.
// **/
//-(NSRange)recordIndexRangeForPlot:(CPPlot *)plot plotRange:(CPPlotRange *)plotRange;
//
/////	@}
//
///// @name Data Labels
///// @{
//
///** @brief Gets a data label for the given plot. This method is optional.
// *	@param plot The plot.
// *	@param index The data index of interest.
// *	@return The data label for the point with the given index.
// *  If you return nil, the default data label will be used. If you return an instance of NSNull,
// *  no label will be shown for the index in question.
// **/
//-(CPLayer *)dataLabelForPlot:(CPPlot *)plot recordIndex:(NSUInteger)index;
//
//





- (void)dealloc
{
    [super dealloc];
}

@end
