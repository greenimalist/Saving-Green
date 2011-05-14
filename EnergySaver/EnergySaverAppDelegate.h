//
//  EnergySaverAppDelegate.h
//  EnergySaver
//
//  Created by Elliot Michael Lee on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EnergySaverAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
