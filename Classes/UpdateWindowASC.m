//
//  UpdateWindowASC.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/3/11.

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "UpdateWindowASC.h"
#import "AppDelegate.h"


@implementation UpdateWindowASC

- (id) performDefaultImplementation {

	BOOL			hasParam = FALSE;
	NSString		*labelStr;
	NSString		*messageStr;
	NSNumber		*progressNum;
	NSDictionary	*theArguments = [self evaluatedArguments];
	NSNumber		*windowNum;
	BOOL			windowPresent;
	
	windowNum = [self directParameter];
	labelStr = [theArguments objectForKey:@"Label"];
	messageStr = [theArguments objectForKey:@"Message"];
	progressNum = [theArguments objectForKey:@"Progress"];
	
	//NSLog (@"UpdateWindowASC");
	if (progressNum) {
		windowPresent = [(AppDelegate *)[[NSApplication sharedApplication] delegate] updateWindow:[windowNum intValue] progressValue:[progressNum floatValue]];
		hasParam = TRUE;
	}
	if (labelStr) {
		windowPresent = [(AppDelegate *)[[NSApplication sharedApplication] delegate] updateWindow:[windowNum intValue] label:labelStr];
		hasParam = TRUE;		
	}
	if (messageStr) {
		windowPresent = [(AppDelegate *)[[NSApplication sharedApplication] delegate] updateWindow:[windowNum intValue] message:messageStr];
		hasParam = TRUE;		
	}
	if (!hasParam) {
		windowPresent = [(AppDelegate *)[[NSApplication sharedApplication] delegate] updateWindow:[windowNum intValue]];
	}
	
	return [NSNumber numberWithBool:windowPresent];	
	
}

@end
