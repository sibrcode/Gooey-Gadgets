/*
     File: Controller.m
 Abstract: The Controller class implements the -changeTransparency: action, called when the slider on the window is moved.
  Version: 1.2

 TODO:
	Save timer object reference
	Allow more than one line?
	Implement the transparency parameter
	Implement Close Window
	Implement Window Info
 */

#import "Controller.h"
#import "TransparentWindow.h"
#import "TransparentBackgroundView.h"
#import "TransparentMessageWindow.h"

@implementation Controller

//
//	G L O B A L S
//

BOOL	terminateAfterLastWindowClosed = NO;


/*NSRect newSize = NSMakeRect(0.0, -768.0, 1024.0, 1200.0);
[self setFrame:newSize display:YES animate:YES];

//[self performZoom:self];
[self center];
*/

/*
- (NSScriptObjectSpecifier *)objectSpecifier{
	NSArray *windows = [[self document] graphics];// 1
	unsigned index = [graphics indexOfObjectIdenticalTo:self];// 2
	if (index != NSNotFound) {
		NSScriptObjectSpecifier *containerRef = [[self document] objectSpecifier];// 3
		return [[[NSIndexSpecifier allocWithZone:[self zone]]
				 initWithContainerClassDescription:[containerRef keyClassDescription]
				 containerSpecifier:containerRef key:@"graphics" index:index] autorelease];// 4
	} else {
		return nil;// 5
	}
} */

//
//
//


- (void)closeWindowAfter: (float)seconds {
	NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: seconds
												  target: self
												selector:@selector(closeFirstWindow:)
												userInfo: nil repeats:NO];
}


/*- (IBAction)newDocumentWindow:(id)sender {
	
    // Do the same thing that a typical override of -[NSDocument makeWindowControllers] would do, but then also show the window. This is here instead of in SKTDocument, though it would work there too, with one small alteration, because it's really view-layer code.
    SKTWindowController *windowController = [[SKTWindowController alloc] init];
    [[self document] addWindowController:windowController];
    [windowController showWindow:self];
    [windowController release];	
} */



@end
