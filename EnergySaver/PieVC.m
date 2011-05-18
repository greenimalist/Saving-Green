//
//  PieVC.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PieVC.h"


@implementation PieVC

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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MonthlySavingsByCategory" ofType:@"plist"];
    
    categories = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] objectForKey:@"Data"];
    allKeys = [[categories allKeys] retain];
    
    // Sample Code
    
    graph = [[CPXYGraph alloc] initWithFrame: self.view.bounds];
    cplhv.hostedLayer = graph;
    
    CPPieChart *pieChart = [[CPPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.pieRadius = 100.0;
    pieChart.identifier = @"Monthly Savings";
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPPieDirectionCounterClockwise;
    
    [graph addPlot:pieChart];
    [pieChart release];
    
//    CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
//    [graph applyTheme:theme];
    
}
- (void)loadView {
    [super loadView];
    [self viewDidLoad];
}


// Data Source Methods

- (NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return [categories count];
}

- (NSNumber *)numberForPlot:(CPPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index {
    NSLog(@"%d, %@", index, [allKeys objectAtIndex:index]);
    return [categories objectForKey:[allKeys objectAtIndex:index]];
}

//-(CPFill *)sliceFillForPieChart:(CPPieChart *)pieChart recordIndex:(NSUInteger)index {
//    CPFill *fill = [CPFill fillWithGradient:[CPGradient unifiedDarkGradient]];
//    return fill;
//}

@end
