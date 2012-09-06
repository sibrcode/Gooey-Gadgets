//
//  CloseWindowASC.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/25/10.
//  Copyright 2010 Simon Brown, Inc. All rights reserved.
//

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "CloseWindowASC.h"
#import "Controller.h"


@implementation CloseWindowASC

- (id) performDefaultImplementation {
	NSNumber	*windowNum;
	BOOL		windowPresent;
	
	windowNum = [self directParameter];
	windowPresent = [(Controller *)[[NSApplication sharedApplication] delegate] closeWindow:[windowNum intValue]];
	return [NSNumber numberWithBool:windowPresent];
}

@end
