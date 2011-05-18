//
//  EditVC.h
//  EnergySaver
//
//  Created by Aaron Lin on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EditVC : NSViewController {
    
    IBOutlet NSTableView *tableView;
    
@private
    
}

-(IBAction)toggleEdit:(id)sender;

@end
