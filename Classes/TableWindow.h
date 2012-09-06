//
//  TableWindow.h
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/16/11.
//  Copyright 2011 Simon Brown, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TableWindow : NSWindow {
	IBOutlet NSButton				*okButton;
	IBOutlet NSTextField			*labelField;
	IBOutlet NSTableView			*tableView;
	NSArray							*dataArray;
}

- (void)close;
- (IBAction)okButton:(id)sender;
- (void)setButtonTitle:(NSString*) buttonStr;
- (void)setLabel:(NSString *)labelStr;
- (void)setData:(id)dataList;

@end
