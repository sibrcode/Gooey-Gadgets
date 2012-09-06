//
//  ProgressWindow.h
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/26/10.
//  Copyright 2010 Simon Brown, Inc. All rights reserved.
//
//	Create progress window/dialog from scratch.

#import <Cocoa/Cocoa.h>


@interface ProgressWindow : NSWindow {
	IBOutlet NSButton				*cancelButton;
	IBOutlet NSTextField			*labelField;
	IBOutlet NSProgressIndicator	*progressIndicator;
}

- (IBAction)cancelProgress:(id)sender;
- (void)setButtonTitle:(NSString*) buttonStr;
- (void)setLabel:(NSString *)labelStr;
- (void)setMaxValue:(double)maxValue;
- (void)setProgress:(double)value;

@end
