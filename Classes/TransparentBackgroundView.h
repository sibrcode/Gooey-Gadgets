/*
     File: CustomView.h
 Abstract: Subclass of NSView which handles the drawing of the window content. Circle and pentagon graphics are used, switching between the two depending upon the window's level of transparency.
  Version: 1.2

 
 Copyright (C) 2010 Simon Brown. All Rights Reserved.
 
 */

#import <Cocoa/Cocoa.h>

@interface TransparentBackgroundView : NSView {
	float					backgroundAlpha;	// Controls transparency of black background, which is drawn by view.
	NSFont					*msgFont;
	NSDictionary			*msgFontAttribs;
	NSString				*msgText;
}

- (void) setFont:(NSFont *)aFont;
- (void) setStringValue:(NSString *)aString;

@property (assign) float backgroundAlpha;
@property (retain) NSFont *msgFont;
@property (retain) NSDictionary *msgFontAttribs;
@property (retain) NSString *msgText;

@end
