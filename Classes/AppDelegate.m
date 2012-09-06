//
//  AppDelegate.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/29/11.

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "AppDelegate.h"


@implementation AppDelegate

//
//	G L O B A L S
//

BOOL						gTerminateAfterLastWindowClosed = NO;
//ProgressWindowController	*progressWinController;


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApp {
	
	// when called with command line options this will be set to YES,
	// but will remain no if called otherwise.
	
	return gTerminateAfterLastWindowClosed;
}


- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	float		giveUp = 0.0;		// Wait forever
	//NSInteger	maxValue = 0;
	float		screenX = 0.0;		// Default screen (main)
	float		screenY = 0.0;
	
	// Pull out values from command line.
	NSString *cmdStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"cmd"];
	
	// Only do this if called via command line. Presumably we won't be getting an AppleEvent later.
	if (cmdStr) {
		// NOTE: IT IS POSSIBLE TO GET INVOKED FROM CMD LINE W/ NO PARAMS
		// We don't stay open when invoked from command line.
		gTerminateAfterLastWindowClosed = YES;
		
		
		//std::string buff;
		//std::cin >> buff;
		//NSString* s = [[NSString stringWithCString:buff.c_str()] retain];
		
		// Parse out the command line parameters
		NSString *buttonTitleStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"buttontitle"];
		NSString *giveUpStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"giveup"];
		//NSString *maxValueStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"maxvalue"];
		NSString *msgStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"msg"];
		NSString *screenXStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"screenx"];
		NSString *screenYStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"screeny"];
		NSString *titleStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"title"];		
		
		if (giveUpStr) {
			giveUp = [giveUpStr floatValue];
		}
		/* if (maxValueStr) {
		 maxValue = [maxValueStr integerValue];
		 } */
		if (screenXStr) {
			screenX = [screenXStr floatValue];
		}
		if (screenYStr) {
			screenY = [screenYStr floatValue];
		}
		
		if (cmdStr) {
			// Which command is it?
			if ([cmdStr isEqualToString:@"messagewindow"] && msgStr)
				[self displayMessageWindow:msgStr giveUpAfter:giveUp screenPoint:NSMakePoint(screenX,screenY) transparency:-1.0];
			
			else if ([cmdStr isEqualToString:@"progresswindow"])
				[self displayProgressWindow:titleStr buttonTitle:buttonTitleStr maxValue:0 label:msgStr];
			
			else if ([cmdStr isEqualToString:@"textwindow"]) {
				// Get anything sent to us via stdin
				NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
				NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
				NSString *inputStr = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
				
				//NSString *inputStr = @"line1\nline2";
				//NSLog (@"tablewindow: %@", inputStr);
				
				[self displayTextWindow:titleStr buttonTitle:buttonTitleStr label:msgStr text:inputStr];
			}
			// When run from command line we must make ourselves frontmost.
			[NSApp activateIgnoringOtherApps:YES];
		}
	}
}


- (BOOL)closeWindow:(NSInteger)windowNum {
	// Close given window, if any.
	NSWindow	*theWin;
	
	theWin = [NSApp windowWithWindowNumber:windowNum];
	if (theWin) {
		[theWin close];
		return TRUE;
	}
	
	return FALSE;
}


- (NSInteger)displayMessageWindow:(NSString *)msgText giveUpAfter:(float)waitSeconds screenPoint:(NSPoint)screenPt transparency:(float)transparency {

	NSInteger windowNum = 0;
	
	NSWindowController			*messageWinController;
	TransparentMessageWindow	*messageWin;
	
	//NSLog (@"displayMessageWindow: %@", msgText);

	messageWinController = [[NSWindowController alloc] initWithWindowNibName: @"MessageWindow"];
	assert (messageWinController != nil);
	
	// force loading of nib
	messageWin = (TransparentMessageWindow*) [messageWinController window];

//	Should've been allocated by loading NIB.
	messageWin = [TransparentMessageWindow alloc];
	
	if (messageWin) {
		[messageWin initWithMessage:msgText screenPoint:screenPt transparency:transparency];
		//- (id)initWithMessage:(NSString *)msgText screenPoint:(NSPoint)thePoint
		if (waitSeconds > 0.0) {
			// Create a timer that will close the window after given period.
			NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: waitSeconds
														  target: messageWin
														selector: @selector(close)
														userInfo: nil repeats:NO];
			[messageWin setCloseTimer:t];
			
		}
		// In case external apps want to refer to this window.
		windowNum = [messageWin windowNumber];
	}			
	return windowNum;
}

- (NSInteger)displayProgressWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr maxValue:(float)maxValue label:(NSString*)labelStr {
	
	//NSLog (@"displayProgressWindow: %@", windowTitle);
	
	//progressWin = [[ProgressWindow alloc] init];
	
	NSWindowController		*progressWinController;
	ProgressWindow			*progressWin;

	progressWinController = [[NSWindowController alloc]
							 initWithWindowNibName: @"ProgressWindow"];
	assert (progressWinController != nil);
	
	// force loading of nib
	progressWin = (ProgressWindow*) [progressWinController window];
	
	// The title in NIB is used if the button title is null.
	if (buttonTitleStr) {
		[progressWin setButtonTitle:buttonTitleStr];
	}
	
	[progressWin setProgress:0.0];
	[progressWin setLabel:labelStr];
	[progressWin setMaxValue:(double) maxValue];
	[progressWin setTitle:windowTitle];
	
	// Now it's ready for us to make it visible.
	[progressWin makeKeyAndOrderFront:nil];
	
	// In case external apps want to refer to this window.
	return [progressWin windowNumber];
}


- (NSInteger)displayTableWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr label:(NSString*)labelStr dataList:(NSArray *)dataList {
	
	TableWindow			*tableWin;
	NSWindowController	*tableWinController;

	//NSLog (@"displayTableWindow: %@", windowTitle);
	
	tableWinController = [[NSWindowController alloc] initWithWindowNibName:@"TableWindow"];
	assert (tableWinController != nil);

	// force loading of nib
	tableWin = (TableWindow*) [tableWinController window];
	
	// Make the panel appear in a good default location.
	[tableWin center];
	[tableWin makeKeyAndOrderFront:nil];
	
	// The title in NIB is used if the button title is null.
	[tableWin setButtonTitle:buttonTitleStr];
	
	[tableWin setLabel:labelStr];
	[tableWin setData:dataList];
	[tableWin setTitle:windowTitle];
	
	// Now it's ready for us to make it visible.
	[tableWin makeKeyAndOrderFront:nil];
	
	// In case external apps want to refer to this window.
	return [tableWin windowNumber];
}


- (NSInteger)displayTextWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitle label:(NSString*)labelStr text:(NSString*)textStr {
	TextWindow			*textWin;
	NSWindowController	*textWinController;
	
	//NSLog (@"displayTextWindow: %@", windowTitle);
	
	textWinController = [[NSWindowController alloc] initWithWindowNibName: @"TextWindow"];
	assert (textWinController != nil);
	
	// force loading of nib
	textWin = (TextWindow*) [textWinController window];
	
	// The title in NIB is used if the button title is null.
	if (buttonTitle) {
		[textWin setButtonTitle:buttonTitle];
	}

	[textWin setLabel:labelStr];
	[textWin setText:textStr];
	[textWin setTitle:windowTitle];
	
	// Now it's ready for us to make it visible.
	[textWin makeKeyAndOrderFront:nil];
	
	// In case external apps want to refer to this window.
	return [textWin windowNumber];
}


- (NSInteger)updateWindow:(NSInteger)windowNum {
	//NSLog (@"updateWindow");
	return [NSApp windowWithWindowNumber:windowNum] != NULL;	
}

- (NSInteger)updateWindow:(NSInteger)windowNum label:(NSString *)labelStr {
	NSWindow	*theWin;
	
	//NSLog (@"updateWindow: %@", labelStr);
	
	theWin = [NSApp windowWithWindowNumber:windowNum];
	
	if (theWin) {
		if ([theWin class] == [ProgressWindow class] || [theWin class] == [TextWindow class]) {
			[theWin setLabel:labelStr];
		}
		if ([theWin class] == [TextWindow class]) {
			[theWin setLabel:labelStr];
		}
		return TRUE;
	}
	
	return FALSE;
}

- (NSInteger)updateWindow:(NSInteger)windowNum message:(NSString *)messageStr {
	NSWindow	*theWin;
	
	//NSLog (@"updateWindow: %@", messageStr);
	
	theWin = [NSApp windowWithWindowNumber:windowNum];
	
	if (theWin) {
		if ([theWin class] == [TextWindow class]) {
			[theWin setText:messageStr];
		}
		return TRUE;
	}
	
	return FALSE;
}

- (NSInteger)updateWindow:(NSInteger)windowNum progressValue:(float)progressValue {
	ProgressWindow	*theWin;
	
	//NSLog (@"updateWindow: %n", progressValue);
	
	theWin = (ProgressWindow *)[NSApp windowWithWindowNumber:windowNum];
	
	// Only a ProgressWindow has this method.
	if (theWin && [theWin class] == [ProgressWindow class]) {
		[theWin setProgress:progressValue];
		return TRUE;
	}
	
	return FALSE;
}



@end
