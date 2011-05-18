//
//  BarVC.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarVC.h"


@implementation BarVC

@synthesize graph;

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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MonthlySavingsTotal" ofType:@"plist"];
    dataArray = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] objectForKey:@"Data"];
    
//    for (NSDictionary *monthDict in dataArray)
//    {
//        NSString *month = [[monthDict allKeys] lastObject];
//        NSLog(@"%@ = %@", month, [monthDict objectForKey:month]);
//    }
    
    
    graph = [[CPXYGraph alloc] initWithFrame:self.view.bounds];
    cplhv.hostedLayer = graph;
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    
    double minY = 0;
    double maxY = 0;
    
    for (NSDictionary *monthDict in dataArray)
    {
        NSString *month = [[monthDict allKeys] lastObject];
        maxY = MAX([[monthDict objectForKey:month] doubleValue], maxY);
    }
    
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(0) length:CPDecimalFromDouble(13)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation: CPDecimalFromDouble(minY) length:CPDecimalFromDouble(maxY)];
    
    CPBarPlot *plot = [[CPBarPlot alloc] initWithFrame:self.view.frame];
    plot.plotRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(0.0) length:CPDecimalFromDouble(12)];
    
    plot.barOffset = CPDecimalFromDouble(0.5);
    plot.dataSource = self;
    [graph addPlot:plot];
    
    [plot release];
}

- (void)loadView {
    [super loadView];
    [self viewDidLoad];
}

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return [dataArray count];
}

- (NSNumber *)numberForPlot:(CPPlot *)plot 
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index
{
    if (fieldEnum == CPScatterPlotFieldX) {
        return [NSNumber numberWithInt:index+1];
    }
    else {
        return [[[dataArray objectAtIndex:index] allValues] lastObject];
    }

}


@end
