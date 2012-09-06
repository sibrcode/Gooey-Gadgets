//
//  ProgressWinController.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 6/8/11.
//  Copyright 2011 Simon Brown, Inc. All rights reserved.
//

#import "ProgressWindowController.h"


@implementation ProgressWindowController

-(IBAction)cancelProgress:(id)sender
{
	[self close];
}

- (void)setLabel:(NSString*) labelStr {
	if (labelStr) {		
		[[window labelField] setStringValue:labelStr];
	} else {
		[[window labelField ] setStringValue:@""];
	}
}

- (void)setButtonTitle:(NSString*) buttonStr {
	if (buttonStr) {		
		[[window cancelButton] setTitle:buttonStr];
	} else {
		[[window cancelButton ] setTitle:@"Cancel"];
	}
	
}

- (void)setProgress:(float)value {	
	[[window progressIndicator] setDoubleValue:value];
}

- (void)setMaxValue:(float)maxValue {
	if (maxValue > 0) {
		[[window progressIndicator] setIndeterminate:NO];
		[[window progressIndicator] setMaxValue:maxValue];
	} else {
		[progressIndicator setIndeterminate:YES];
	}
}

- (IBAction)showWindow:(id)sender {
	
	[super showWindow:sender];
	[[window progressIndicator] startAnimation:self];
	//[progressIndicator setMinValue:1.0];
}


@end
