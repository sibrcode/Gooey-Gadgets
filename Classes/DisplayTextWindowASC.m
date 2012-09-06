//
//  DisplayTextWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/8/11.

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "DisplayTextWindowASC.h"
#import "AppDelegate.h"
#import "scriptLog.h"


@implementation DisplayTextWindowASC

- (id) performDefaultImplementation {
	
	NSString				*buttonTitleStr;
	NSString				*labelStr;
	NSData					*screenObj = NULL;
	Point					screenPt;
	NSPoint					screenAt = NSMakePoint(0.0,0.0);	// Use window's default.
	NSDictionary			*theArguments = [self evaluatedArguments];
	NSString				*textStr;
	NSString				*titleStr;
	NSInteger				windowNum;
	
	//SLOG(@"DisplayTextWindow performDefaultImplementation");
	//	NSLog(@"performDefaultImplementation");
	
	/* report the parameters */
	//SLOG(@"The direct parameter is: '%@'", [self directParameter]);
	//SLOG(@"The other parameters are: '%@'", theArguments);
	
	/* return the quoted direct parameter to show how to return a string from a command
	 Here, if the optional ProseText parameter has been provided, we return that value in
	 quotes, otherwise we return the direct parameter in quotes. */
	buttonTitleStr = [theArguments objectForKey:@"ButtonTitle"];
	labelStr = [theArguments objectForKey:@"Label"];
	screenObj = (NSData *) [theArguments objectForKey:@"ScreenPt"];
	textStr = [theArguments objectForKey:@"Message"];
	
	titleStr = [self directParameter];
	
	if (screenObj) {
		// This will actually be an NSConcreteData class object.
		[screenObj getBytes:&screenPt length:4];
		//NSLog (@"point: %i,%i", screenPt.h, screenPt.v);
		screenAt = NSMakePoint (screenPt.h, screenPt.v);
	}
	
	//	return theResult;
	// - (void)makeTransparentMsgWindow:(NSString *)msgText screenPoint:(NSPoint)winPoint
	
	windowNum = [(AppDelegate *)[[NSApplication sharedApplication] delegate] displayTextWindow:titleStr buttonTitle:buttonTitleStr label:labelStr text:textStr];
	
	return [NSNumber numberWithInteger:windowNum];
}

@end
