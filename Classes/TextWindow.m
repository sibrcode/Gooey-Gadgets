//
//  TextWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/8/11.
//  Copyright 2011 Simon Brown, Inc. All rights reserved.
//

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
