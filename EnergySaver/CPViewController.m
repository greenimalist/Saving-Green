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

@end
