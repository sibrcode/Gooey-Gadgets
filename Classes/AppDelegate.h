//
//  AppDelegate.h
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/29/11.

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import <Cocoa/Cocoa.h>
#import "ProgressWindow.h"
#import "ProgressWindowController.h"
#import "TableWindow.h"
#import "TextWindow.h"
#import "TransparentWindow.h"
#import "TransparentMessageWindow.h"


@interface AppDelegate : NSObject {
//	IBOutlet ProgressWindow		*progressWin;
//	IBOutlet TableWindow		*tableWin;
//	IBOutlet TextWindow			*textWin;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApp;
- (NSInteger)displayMessageWindow:(NSString *)msgText giveUpAfter:(float)waitSeconds screenPoint:(NSPoint)screenPt transparency:(float)transparency;
- (NSInteger)displayProgressWindow:(NSString *)windowTitle buttonTitle:(NSString *)buttonTitle maxValue:(float)maxValue label:(NSString *)labelStr;
- (NSInteger)displayTableWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr label:(NSString*)labelStr dataList:(NSArray *)dataList;
- (NSInteger)displayTextWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr label:(NSString*)labelStr text:(NSString*)textStr;
- (NSInteger)updateWindow:(NSInteger)windowNum;
- (NSInteger)updateWindow:(NSInteger)windowNum label:(NSString *)labelStr;
- (NSInteger)updateWindow:(NSInteger)windowNum message:(NSString *)messageStr;
- (NSInteger)updateWindow:(NSInteger)windowNum progressValue:(float)progressValue;

@end
