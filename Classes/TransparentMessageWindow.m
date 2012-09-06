//
//  TransparentMessageWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/12/10.
//  Copyright 2010 Simon Brown, Inc. All rights reserved.
//

//#import <AppKit/AppKit.h>
#import "TransparentMessageWindow.h"
#import "TransparentBackgroundView.h"
#import "scriptLog.h"

@implementation TransparentMessageWindow

@synthesize initialLocation;
@synthesize closeTimer;


//
//	c e n t e r
//

// We override the center method to truly center the window, which is different from
// the HI guidelines and what the default method does.

- (void)center {
	NSRect windowFrame = [self frame];
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	screenFrame.origin.x += NSMidX(screenFrame) - NSMidX(windowFrame);
	screenFrame.origin.y += NSMidY(screenFrame) - NSMidY(windowFrame);
	[self setFrameOrigin:screenFrame.origin];
} // - (void)center 

//
//	s c r e e n A t P o i n t
//

// Given a point, determine which screen the point falls on.
// If none, returns the main screen.

- (NSScreen *)screenAtPoint:(NSPoint)thePoint {

	NSEnumerator	*screenEnum = [[NSScreen screens] objectEnumerator];
	NSScreen		*screen = NULL;
	
	// Given a point specify the screen to use?
	if (thePoint.x && thePoint.y) {
		// Search for a screen containing the point.
		while ((screen = [screenEnum nextObject]) && !NSMouseInRect(thePoint,[screen frame], NO));
	}
	
	if (!screen) {
		// No point, or no matching screen, so we'll use default.
		screen = [NSScreen mainScreen];
	}

	return screen;
}

//
//	i n i t W i t h M e s s a g e
//

- (id)initWithMessage:(NSString *)msgText screenPoint:(NSPoint)thePoint transparency:(float)transparency {
	
//	NSSize						measureSize;
	NSFont						*msgFont;
	NSDictionary				*msgAttribs;
	const float					padding = 32;		// Set width to screen max – ~1/2 inch on each size.
	float						rectRatio;
	NSRect						screenRect;
	const float					shadowFactor = 30;
	float						sizeRatio;
	NSScreen					*theScreen = NULL;
	NSRect						winRect;
	
	NSLog(@"initWithMessage");
	
	// This is the controller's copy of the string. We set the view's copy later,
	// since the view hasn't been created yet.
	//msgText = [[NSUserDefaults standardUserDefaults] stringForKey:@"msg"];
	
	if (msgText == Nil) {
		msgText = @"510 835-4483";
		//msgText = @"This is a really long message with lots of text that will be difficult to render on one line!";
	}
	
	if (transparency < 0) {
		transparency = 0.7;
	}
	
	//NSLog(@"initWithMessage: %@\n", msgText);
	
	// Start out with the visible area of screen.
	theScreen = [self screenAtPoint:thePoint];
	NSAssert (theScreen != nil, @"Nil screen");
	
	winRect = [theScreen visibleFrame];
	screenRect = winRect;	// Need later to center window.
	//NSLog(@"visibleFrame: x=%f, y=%f, w=%f h=%f\n", winRect.origin.x, winRect.origin.y, winRect.size.width, winRect.size.height);
	
	// Make space for margins on 4 sides.
	winRect.size.width -= padding * 2;
	winRect.size.height -= padding * 2;;
	//NSLog(@"winRect: w=%f h=%f\n", winRect.size.width, winRect.size.height);
	
	// CALC MESSAGE SIZE
	
	// How to layout text message.
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setLineBreakMode:NSLineBreakByTruncatingMiddle];
	[style setAlignment:NSCenterTextAlignment];
	///[style retain];
	
	NSFontManager *fontMgr = [NSFontManager sharedFontManager];
	
	// We don't know what the actual size will be until we know how it fits in window.
	// Using a 1pt font doesn't work (always returns 0), so using 2pt instead.
	msgFont = [fontMgr fontWithFamily:@"Lucida Grande"
							   traits:NSBoldFontMask
							   weight:0
								 size:2];
	
	// These attributes are strictly for measuring, so don't worry about color, etc.
	msgAttribs = [NSDictionary dictionaryWithObjectsAndKeys:
				  msgFont, NSFontAttributeName,
				  style, NSParagraphStyleAttributeName,
				  nil];
	
	// Give it at least enough space to use (roughly) an 8pt font + 1/4" margin on 4 sides.
	// NEED TO GET FONT M-SPACE * 8
	//measureSize.width = (winRect.size.width - padding * 2) / 4.8 ;
	//measureSize.height = (winRect.size.height - padding) / 8.0;
	//NSLog(@"measureSize: w=%f h=%f\n", measureSize.width, measureSize.height);
	
	// Two techniques for using a loop to get best font size.
	// http://stackoverflow.com/questions/2410401/how-do-i-set-the-font-size-in-a-text-cell-so-that-the-string-fills-the-cells-rec
	
	// See http://teilweise.tumblr.com/post/293948288/boundingrectwithsize-options-attributes for some useful info. on the function below.
	//msgRect = [msgText boundingRectWithSize:measureSize options:NSStringDrawingUsesLineFragmentOrigin attributes:msgAttribs];
	//NSLog(@"boundingRectWithSize: w=%f h=%f\n", msgRect.size.width, msgRect.size.height);
	//sizeRatio = winRect.size.width / msgRect.size.width;
	
	// First pass using a 2pt font.
	NSSize msgSize = [msgText sizeWithAttributes:msgAttribs];
	//NSLog(@"msgSize: w=%f h=%f\n", msgSize.width, msgSize.height);
	
	// How many times wider than a 2pt font?
	// Because of the intricacies of font measurement, this won't be exact.
	sizeRatio = (winRect.size.width / msgSize.width) * 1.9;
	
	// Width relative to height? Only needed for animation to get start size.
	rectRatio = winRect.size.width / winRect.size.height;
	
	//NSLog(@"sizeRatio=%f, rectRatio=%f",sizeRatio, rectRatio);
	
	
	// Must rebuild from scratch.
	///[msgFont release];
	///[msgAttribs release];
	
	// CREATE MSG FONT & ATTRIBUTES
	
	// For font's shadow attribute.
	NSShadow* shadw = [[NSShadow alloc] init];
	[shadw setShadowColor:[NSColor controlDarkShadowColor]];
	[shadw setShadowOffset:NSMakeSize (1+sizeRatio/shadowFactor, -(1+sizeRatio/shadowFactor))];
	[shadw setShadowBlurRadius:1+(sizeRatio/shadowFactor)];
	
	// The font we will actually draw with.
	msgFont = [fontMgr fontWithFamily:@"Lucida Grande"
							   traits:NSBoldFontMask
							   weight:0
								 size:sizeRatio];
	
	msgAttribs = [NSDictionary dictionaryWithObjectsAndKeys:
				  msgFont, NSFontAttributeName,
				  style, NSParagraphStyleAttributeName,
				  [NSColor whiteColor], NSForegroundColorAttributeName,
				  shadw, NSShadowAttributeName,
				  nil];
	
	///[msgAttribs retain];

	transMsgView = nil;
	
	// CREATE WINDOW
	
	// Adjust size to what's needed for text at final point size.
	//NSLog(@"capHeight=%f, descender=%f",[msgFont capHeight], [msgFont descender]);
	
	winRect.size.height = [msgFont capHeight] + -[msgFont descender] + padding * 2.0;

	// Somewhat arbitrarily, start ourselves out with a window that's twice the size we got back when measuring at 2pts.
    [self initWithContentRect:NSMakeRect (screenRect.origin.x, screenRect.origin.y, msgSize.width * 2, msgSize.height * 2)
					styleMask:NSTitledWindowMask
					  backing:NSBackingStoreBuffered
						defer:NO
					   screen:theScreen];
	
	
	// Display initial version if using animation.
	//	[bigWin setFrame:NSMakeRect (0, 0, 10 * rectRatio, 10) display:YES animate:YES];
	[self center];

	// Being a type of background app, we need to "steal" the focus back.
	[NSApp activateIgnoringOtherApps: YES];

	[self makeKeyAndOrderFront:nil];
	///	[mainWindow setTitle:@"test window"];

	// Need to up level for window, as this is a background app, and we want the window on top of any window
	// belonging to the current application.
	[self setLevel:NSStatusWindowLevel];

	
//	winRect.size.width += screenRect.origin.x;
	
	
	NSLog(@"winRect P: x=%f, y=%f, w=%f h=%f\n", winRect.origin.x, winRect.origin.y, winRect.size.width, winRect.size.height);

	// Set actual window size.
	[self setFrame:winRect display:YES animate:NO];
	[self center];
	
	// CREATE WINDOW'S VIEW
	
	transMsgView = [TransparentBackgroundView alloc];
	[transMsgView setFont: msgFont];
	transMsgView.msgFontAttribs = msgAttribs;
	[transMsgView setBackgroundAlpha:transparency];
	[transMsgView setStringValue:msgText];
	
	[transMsgView initWithFrame:[[self contentView] frame]];
	[[self contentView] addSubview:transMsgView];
	
	return self;
}

/*
 In Interface Builder, the class for the window is set to this subclass. Overriding the initializer provides a mechanism for controlling how objects of this class are created.
 */
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	//NSLog(@"initWithContentRect: start");

	if (contentRect.size.height < 32.0) {
		contentRect.size.height = 96.0;
		contentRect.size.width = 96.0;
	}
	
	//NSLog(@"x=%f, y=%f",contentRect.origin.x, contentRect.origin.y);
	//NSLog(@"width=%f, height=%f",contentRect.size.width, contentRect.size.height);
	
	// Using NSBorderlessWindowMask results in a window without a title bar.
	[super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];

    if (self != nil) {
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
		[self setBackgroundColor: [NSColor clearColor]]; //added to make non-clipped areas invisible.
    }
	
	//NSLog(@"initWithContentRect: exit");
    return self;
}

 
// Custom windows that use the NSBorderlessWindowMask can't become key by default.
// Override this method so that controls in this window will be enabled.

- (BOOL)canBecomeKeyWindow {
    return YES;
}

/*
 Start tracking a potential drag operation here when the user first clicks the mouse, to establish the initial location.
 */
- (void)mouseDown:(NSEvent *)theEvent {    
    // Get the mouse location in window coordinates.
    self.initialLocation = [theEvent locationInWindow];
	
	[self close]; // Close as soon as clicked
}

//
//	s e t F o n t
//

- (void) setFont:(NSFont *)aFont {
	if (transMsgView) {
		[transMsgView setFont:aFont];
	}
	// Force redraw?
}


- (void)mouseDraggedDISABLED:(NSEvent *)theEvent {
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
