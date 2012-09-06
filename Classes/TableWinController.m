/*
     File: TableWinController.m
 Abstract: The Controller class implements the -changeTransparency: action, called when the slider on the window is moved.
  Version: 1.2

 TODO:
	Save timer object reference
	Allow more than one line?
	Implement the transparency parameter
	Implement Close Window
	Implement Window Info
 */

#import "TableWinController.h"
#import "TransparentWindow.h"
#import "TransparentBackgroundView.h"
#import "TransparentMessageWindow.h"

@implementation TableWinController

//
//	G L O B A L S
//


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


- (void)closeWindowAfter: (float)seconds {
	NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: seconds
												  target: self
												selector:@selector(closeFirstWindow:)
												userInfo: nil repeats:NO];
}


- (NSInteger)displayTableWindow:(NSString *)windowTitle buttonTitle:(NSString*)buttonTitleStr label:(NSString*)labelStr dataList:(NSArray *)dataList {
	
	NSLog (@"displayTableWindow: %@", windowTitle);
	
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

/*- (IBAction)newDocumentWindow:(id)sender {
	
    // Do the same thing that a typical override of -[NSDocument makeWindowControllers] would do, but then also show the window. This is here instead of in SKTDocument, though it would work there too, with one small alteration, because it's really view-layer code.
    SKTWindowController *windowController = [[SKTWindowController alloc] init];
    [[self document] addWindowController:windowController];
    [windowController showWindow:self];
    [windowController release];	
} */

- (NSInteger)updateWindow:(NSInteger)windowNum {
	//NSLog (@"updateWindow");
	return [NSApp windowWithWindowNumber:windowNum] != NULL;	
}

- (NSInteger)updateWindow:(NSInteger)windowNum label:(NSString *)labelStr {
	NSWindow	*theWin;
	
	//NSLog (@"updateWindow: %@", message);
	
	theWin = [NSApp windowWithWindowNumber:windowNum];
	
	if (theWin) {
		if ([theWin class] == [ProgressWindow class] || [theWin class] == [TextWindow class] || [theWin class] == [TableWindow class]) {
			[theWin setLabel:labelStr];
		}
		return TRUE;
	}
	
	return FALSE;
}

- (NSInteger)updateWindow:(NSInteger)windowNum message:(NSString *)messageStr {
	NSWindow	*theWin;
	
	//NSLog (@"updateWindow: %@", message);
	
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
