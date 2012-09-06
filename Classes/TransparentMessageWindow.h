//
//  TransparentMessageWindow.h
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/12/10.
//  Copyright 2010 Beezwax Datatools, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TransparentBackgroundView.h"


@interface TransparentMessageWindow : NSWindow {
    TransparentBackgroundView *transMsgView;
	NSPoint initialLocation;
	NSTimer *closeTimer;
}

//- (void)applicationDidFinishLaunching:(NSNotification *)notification;
- (id)initWithMessage:(NSString *)msgText screenPoint:(NSPoint)thePoint transparency:(float)transparency;
- (void) setFont:(NSFont *)aFont;
//- (void) setStringValue:(NSString *)aString;

//@property (assign) TransparentBackgroundView *transView;
@property (assign) NSPoint initialLocation;
@property (assign) NSTimer *closeTimer;


@end
