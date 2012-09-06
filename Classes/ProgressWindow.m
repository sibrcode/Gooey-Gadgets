//
//  ProgressWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/26/10.

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


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
