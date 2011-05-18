//
//  EditVC.m
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditVC.h"
#import "EnergyBuster.h"


@implementation EditVC

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
    [super dealloc];
}

-(IBAction)toggleEdit:(id)sender {
    
}

// Data Source Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [ebArray count];
}

- (id)tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
            row:(NSInteger)rowIndex {
    EnergyBuster *eb = [ebArray objectAtIndex:rowIndex];
    NSString *result;
    
    int columnIndex = [aTableColumn.identifier intValue];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    switch (columnIndex) {
        case 0:
            result = eb.title;
            break;
        case 1:
            result = eb.choice;
            break;
        case 2:
            result = [NSString stringWithFormat:@"%d", eb.savingsPerMonth];
            break;
        case 3:
            [formatter setDateFormat:@"MM-dd"];
                        
            result = [formatter stringFromDate:eb.startDate];
            break;
        default:
            result = @"ERROR";
    }
    
    return result;
    
}


@end
