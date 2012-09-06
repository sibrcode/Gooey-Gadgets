//
//  DisplayProgressWindowASC.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/31/10.
//  Copyright 2010 Beezwax Datatools, Inc. All rights reserved.
//

#import "DisplayProgressWindowASC.h"
#import "AppDelegate.h"
#import "scriptLog.h"


@implementation DisplayProgressWindowASC

- (id) performDefaultImplementation {
	
	NSString				*buttonTitleStr;
	NSString				*labelStr;
	NSInteger				maxValue = 0;
	NSNumber				*maxValueObj = NULL;
	NSData					*screenObj = NULL;
	Point					screenPt;
	NSPoint					screenAt = NSMakePoint(0.0,0.0);	// Use window's default.
	NSDictionary			*theArguments = [self evaluatedArguments];
	NSString				*titleStr;
	NSInteger				windowNum;
	
	//SLOG(@"DisplayMessageWindow performDefaultImplementation");
//	NSLog(@"performDefaultImplementation");

	/* report the parameters */
	//SLOG(@"The direct parameter is: '%@'", [self directParameter]);
	//SLOG(@"The other parameters are: '%@'", theArguments);
	
	/* return the quoted direct parameter to show how to return a string from a command
	 Here, if the optional ProseText parameter has been provided, we return that value in
	 quotes, otherwise we return the direct parameter in quotes. */
	buttonTitleStr = [theArguments objectForKey:@"ButtonTitle"];
	maxValueObj = [theArguments objectForKey:@"MaxValue"];
	labelStr = [theArguments objectForKey:@"Label"];
	screenObj = (NSData *) [theArguments objectForKey:@"ScreenPt"];
	
	titleStr = [self directParameter];
	
	if (maxValueObj) {
		maxValue = [maxValueObj intValue];
	}
	
	if (screenObj) {
		// This will actually be an NSConcreteData class object.
		[screenObj getBytes:&screenPt length:4];
		//NSLog (@"point: %i,%i", screenPt.h, screenPt.v);
		screenAt = NSMakePoint (screenPt.h, screenPt.v);
	}
	
	//	return theResult;
	// - (NSInteger)displayProgressWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr maxValue:(float)maxValue label:(NSString*)labelStr
	
	windowNum = [(AppDelegate *)[[NSApplication sharedApplication] delegate] displayProgressWindow:titleStr buttonTitle:buttonTitleStr maxValue:maxValue label:labelStr];
	
	return [NSNumber numberWithInteger:windowNum];
}

@end
