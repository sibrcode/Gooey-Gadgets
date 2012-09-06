/*

 The Controller class implements the -changeTransparency: action, called when the slider on the window is moved.

 */

#import <Cocoa/Cocoa.h>
#import "ProgressWindow.h"
#import "TableWindow.h"
#import "TextWindow.h"

@interface TableWinController : NSWindowController {
	IBOutlet TableWindow		*tableWin;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification;

//- (IBAction)changeTransparency:(id)sender;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApp;
- (BOOL)closeWindow:(NSInteger)windowNum;
- (NSInteger)displayTableWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr label:(NSString*)labelStr dataList:(NSArray *)dataList;
- (NSInteger)updateWindow:(NSInteger)windowNum;
- (NSInteger)updateWindow:(NSInteger)windowNum label:(NSString *)labelStr;
- (NSInteger)updateWindow:(NSInteger)windowNum message:(NSString *)messageStr;
- (NSInteger)updateWindow:(NSInteger)windowNum progressValue:(float)progressValue;
	
@end
