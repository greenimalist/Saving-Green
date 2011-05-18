//
//  EditVC.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EditVC : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
    
    IBOutlet NSTableView *tableView;
    NSMutableArray *ebArray;
    
@private
    
}

@property (retain) NSMutableArray *ebArray;

-(IBAction)toggleEdit:(id)sender;

@end
