/*
     File: CustomView.m
 Abstract: Subclass of NSView which handles the drawing of the window content. Circle and pentagon graphics are used, switching between the two depending upon the window's level of transparency.
  Version: 1.2
 
 
 */

#import "TransparentBackgroundView.h"

@implementation TransparentBackgroundView

@synthesize backgroundAlpha;
@synthesize msgFont;
@synthesize msgFontAttribs;
@synthesize msgText;

const float		widthPad = 18;
const float		heightPad = 32;


- (void)dealloc {
	// Don't release the msgText or the msgFont -- controller will do that.
//    [circleImage release];
	///[msgFont release];
	///[msgText release];
    [super dealloc];
}

- (void) setFont:(NSFont *)aFont {
	if (aFont) {
		///[aFont release];
	}
	///[aFont retain];
	msgFont = aFont;
	
	// Force redraw?
}


- (void) setStringValue:(NSString *)aString {
	///msgText = [aString retain];
	msgText = aString;
	//[bigLabel setStringValue:aString];
}


- (void) drawRoundedRect:(NSRect)rect x:(CGFloat)x y:(CGFloat)y {

	NSColor *transBlack;

	transBlack = [NSColor colorWithCalibratedRed: 0.0
										   green: 0.0
											blue: 0.0
										   alpha: self.backgroundAlpha];

    NSBezierPath* thePath = [NSBezierPath bezierPath];
	
	[transBlack setFill];
		
    [thePath appendBezierPathWithRoundedRect:rect xRadius:x yRadius:y];
    [thePath fill];
}

//- [self.window setAlphaValue:[sender floatValue]];
/*
 When it's time to draw, this routine is called. This view is inside the window, the window's opaqueness has been turned off, and the window's styleMask has been set to NSBorderlessWindowMask on creation, so this view draws the all the visible content. The first two lines below fill the view with "clear" color, so that any images drawn also define the custom shape of the window.  Furthermore, if the window's alphaValue is less than 1.0, drawing will use transparency.
 */
- (void)drawRect:(NSRect)rect {
	
	// Draw the background (since the Window itself is clear, and can't draw rounded corners).
	float cornerRadius = 12.0;
	[self drawRoundedRect:rect x:cornerRadius y:cornerRadius];

	NSSize msgSize = [msgText sizeWithAttributes:msgFontAttribs];
	float xMid = NSMidX(rect) - msgSize.width/2;
	//float yMid = NSMidY(rect) + widthPad + [msgFont descender]; // ((msgSize.height - [msgFont descender]) / 2);
	
	// We could just use the padding value, but for all numbers this can look a bit odd, and this is the primary purpose of this function
	// So we'll factor out a piece of the descender's height;
	float yMid = heightPad + ([msgFont descender]/4);
	
	rect.origin.y = yMid;
	rect.origin.x = xMid;
	
	//NSLog(@"x=%f, y=%f, w=%f, h=%f, msg=%@",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height, msgText);
	

//	Was previously using drawInRect, but it was giving unpredictable results.
///	[msgText drawInRect:rect withAttributes:msgFontAttribs];

///	[msgText drawAtPoint:rect.origin rect.size.width:200 withFont:msgFont minFontSize:6 actualFontSize:nil lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	[msgText drawAtPoint:rect.origin withAttributes:msgFontAttribs];
}

@end
