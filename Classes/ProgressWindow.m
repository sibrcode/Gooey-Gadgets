//
//  ProgressWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/26/10.
//  Copyright 2010 Beezwax Datatools, Inc. All rights reserved.
//

#import "ProgressWindow.h"


@implementation ProgressWindow


-(IBAction)cancelProgress:(id)sender
{
	[self close];
}

- (void)makeKeyAndOrderFront:(id)sender {
	
	/*
	 If we were making from scratch.
	 winRect = NSMakeRect(0.0f, 0.0f, 370.0f, 128.0f);
		
	 theWin = [[NSWindow alloc] initWithContentRect:winRect 
										  styleMask:(NSTitledWindowMask) 
										    backing:NSBackingStoreBuffered defer:NO];
	*/
	 
	[super makeKeyAndOrderFront:sender];
	[progressIndicator startAnimation:self];
	//[progressIndicator setMinValue:1.0];
}

- (void)setLabel:(NSString*) labelStr {
	if (labelStr) {		
		[labelField setStringValue:labelStr];
	} else {
		[labelField setStringValue:@""];
	}
}

- (void)setButtonTitle:(NSString*) buttonStr {
	if (buttonStr) {		
		[cancelButton setTitle:buttonStr];
	} else {
		[cancelButton setTitle:@"Cancel"];
	}
}

- (void)setProgress:(double)value {	
	[progressIndicator setDoubleValue:value];
}

- (void)setMaxValue:(double)maxValue {
	if (maxValue > 0) {
		[progressIndicator setIndeterminate:NO];
		[progressIndicator setMaxValue:maxValue];
	} else {
		[progressIndicator setIndeterminate:YES];
	}
}
	 
@end
