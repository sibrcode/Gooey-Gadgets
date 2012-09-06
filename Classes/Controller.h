/*

 The Controller class implements the -changeTransparency: action, called when the slider on the window is moved.

 */

#import <Cocoa/Cocoa.h>

@interface Controller : NSController {
	NSWindow					*messageWin;		// This window built from scratch.
}


//- (IBAction)changeTransparency:(id)sender;
- (BOOL)closeWindow:(NSInteger)windowNum;
	
@end
