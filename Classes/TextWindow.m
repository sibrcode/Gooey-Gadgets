//
//  TextWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/8/11.

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "TextWindow.h"

@implementation TextWindow

- (void)awakeFromNib {

	[textField setEditable:NO];
}

- (void)close {
	
	[textField setString:@""];
	[labelField setStringValue:@""];
	[super close];
}

-(IBAction)okButton:(id)sender
{
	[self close];
}

- (void)setLabel:(NSString*) labelStr {
	if (labelStr) {		
		[labelField setStringValue:labelStr];
	}
}

- (void)setButtonTitle:(NSString*) buttonStr {
	if (buttonStr) {		
		[okButton setTitle:buttonStr];
	}
}

- (void)setText:(NSString*)textStr {
	if (textStr) {
		[textField setString:textStr];
	}
}


@end
