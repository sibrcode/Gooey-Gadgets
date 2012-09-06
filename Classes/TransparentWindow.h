/*
     File: CustomWindow.h
 Abstract: Subclass of NSWindow with a custom shape and transparency. Since the window will not have a title bar, -mouseDown: and -mouseDragged: are overriden so the window can be moved by dragging its content area.
  Version: 1.2
 
 

 
 Copyright (C) 2010 Simon Brown. All Rights Reserved.
 
 */

#import <Cocoa/Cocoa.h>

@interface TransparentWindow : NSWindow {
    // This point is used in dragging to mark the initial click location
    NSPoint initialLocation;

}
- (void)applicationDidFinishLaunching:(NSNotification *)notification;

@property (assign) NSPoint initialLocation;

@end
