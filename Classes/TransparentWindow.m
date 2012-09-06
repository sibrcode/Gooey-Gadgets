/*
     File: CustomWindow.m
 Abstract: Subclass of NSWindow with a custom shape and transparency. Since the window will not have a title bar, -mouseDown: and -mouseDragged: are overriden so the window can be moved by dragging its content area.
  Version: 1.2
 
  */

#import "TransparentWindow.h"
#import <AppKit/AppKit.h>

@implementation TransparentWindow

@synthesize initialLocation;


- (void)applicationDidFinishLaunching:(NSNotification *)notification {

}

- (void)center {
	NSRect windowFrame = [self frame];
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	screenFrame.origin.x += NSMidX(screenFrame) - NSMidX(windowFrame);
	screenFrame.origin.y += NSMidY(screenFrame) - NSMidY(windowFrame);
	[self setFrameOrigin:screenFrame.origin];
} // - (void)center 


/*
 In Interface Builder, the class for the window is set to this subclass. Overriding the initializer provides a mechanism for controlling how objects of this class are created.
 */
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
		
	// Using NSBorderlessWindowMask results in a window without a title bar.
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
		[self setBackgroundColor: [NSColor clearColor]]; //added to make non-clipped areas invisible.
    }
		
    return self;
}

/*
- (id) initWithContentRect: (NSRect) contentRect
                 styleMask: (unsigned int) aStyle
                   backing: (NSBackingStoreType) bufferingType
                     defer: (BOOL) flag
{
    if (![super initWithContentRect: contentRect 
						  styleMask: NSBorderlessWindowMask 
							backing: bufferingType 
							  defer: flag]) return nil;
    [self setBackgroundColor: [NSColor clearColor]];
    [self setOpaque:NO];
	
    return self;
}
*/

/*
 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.
 */
- (BOOL)canBecomeKeyWindow {
    return YES;
}

/*
 Start tracking a potential drag operation here when the user first clicks the mouse, to establish the initial location.
 */
- (void)mouseDown:(NSEvent *)theEvent {    
    // Get the mouse location in window coordinates.
    //self.initialLocation = [theEvent locationInWindow];
	
	[self close]; // Close as soon as clicked
}

/*
 Once the user starts dragging the mouse, move the window with it. The window has no title bar for the user to drag (so we have to implement dragging ourselves)
 */
- (void)mouseDragged:(NSEvent *)theEvent {
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;

    // Get the mouse location in window coordinates.
    NSPoint currentLocation = [theEvent locationInWindow];
    // Update the origin with the difference between the new mouse location and the old mouse location.
    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);

    // Don't let window get dragged up under the menu bar
    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    // Move the window to the new location
    [self setFrameOrigin:newOrigin];
}

@end
