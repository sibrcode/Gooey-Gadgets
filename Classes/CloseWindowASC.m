//
//  CloseWindowASC.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/25/10.
//  Copyright 2010 Simon Brown, Inc. All rights reserved.
//

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
