//
//  TextWindow.h
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/8/11.
//  Copyright 2011 Simon Brown, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TextWindow : NSWindow {
	IBOutlet NSButton				*okButton;
	IBOutlet NSTextField			*labelField;
	IBOutlet NSTextView				*textField;
}

- (IBAction)okButton:(id)sender;
- (void)setButtonTitle:(NSString*) buttonStr;
- (void)setLabel:(NSString *)labelStr;
- (void)setText:(NSString *)textStr;

@end
