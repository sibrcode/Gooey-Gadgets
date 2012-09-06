//
//  DisplayMessageWindowASC.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 12/12/10.
//  Copyright 2010 Simon Brown, Inc. All rights reserved.
//

#import "DisplayMessageWindowASC.h"
#import "AppDelegate.h"
#import "scriptLog.h"


@implementation DisplayMessageWindowASC

// Based on Apple's ApplyFirmwarePassword example.

- (NSMutableArray *)arrayFromAEDescriptor:(NSAppleEventDescriptor *)descriptor { 
    unsigned int count = [descriptor numberOfItems]; 
    unsigned int i = 1; 
    NSMutableArray *myList = [NSMutableArray arrayWithCapacity:count]; 
	
    for (i = 1; i <= count; i++ ) { 
        id value = [self objectFromAEDescriptor:[descriptor descriptorAtIndex:i]]; 
        if (value) [myList addObject:value]; 
    } 
    
    return myList; 
} 

- (NSMutableDictionary *)dictionaryFromAEDescriptor:(NSAppleEventDescriptor *)descriptor { 
    if (![descriptor numberOfItems]) return nil; 
    descriptor = [descriptor descriptorAtIndex:1]; 
    unsigned int count = [descriptor numberOfItems]; 
    unsigned int i = 1; 
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count]; 
	
    for (i = 1; i <= count; i += 2 ) { 
        NSString *key = [[descriptor descriptorAtIndex:i] stringValue]; 
        id value = [self objectFromAEDescriptor:[descriptor descriptorAtIndex:(i + 1)]]; 
        if (key && value) [dict setObject:value forKey:key]; 
    } 
	
    return dict; 
} 

// From Apple's ApplyFirmwarePassword example.

- (id)objectFromAEDescriptor:(NSAppleEventDescriptor *)descriptor {
    switch ([descriptor descriptorType]) {
        case typeChar:
        case typeUnicodeText:
            return [descriptor stringValue];
        case typeAEList:
            return [self arrayFromAEDescriptor:descriptor];
        case typeAERecord:
            return [self dictionaryFromAEDescriptor:descriptor];
			
        case typeBoolean:
            return [NSNumber numberWithBool:(BOOL)[descriptor booleanValue]];
        case typeTrue:
            return [NSNumber numberWithBool:YES];
        case typeFalse:
            return [NSNumber numberWithBool:NO];
        case typeType:
            return [NSNumber numberWithUnsignedLong:(unsigned long)[descriptor typeCodeValue]];
        case typeEnumerated:
            return [NSNumber numberWithUnsignedLong:(unsigned long)[descriptor enumCodeValue]];
        case typeNull:
            return [NSNull null];
			
        case typeSInt16:
            return [NSNumber numberWithInt:(short)[descriptor int32Value]];
        case typeSInt32:
            return [NSNumber numberWithInt:(int)[descriptor int32Value]];
        case typeUInt32:
            return [NSNumber numberWithLong:(unsigned int)[descriptor int32Value]];
        case typeSInt64:
            return [NSNumber numberWithLong:(long)[descriptor int32Value]];
			//      case typeIEEE32BitFloatingPoint:
			//          return [NSNumber numberWithBytes:[[descriptor data] bytes] objCType:@encode(float)];
			//      case typeIEEE64BitFloatingPoint:
			//          return [NSNumber numberWithBytes:[[descriptor data] bytes] objCType:@encode(double)];
			//      case type128BitFloatingPoint:
			//      case typeDecimalStruct:
    }
    
    return [descriptor data];
}

//typedef UInt8        char4[4];


- (id) performDefaultImplementation {
	
	float					giveUpAfter = 0.0;
	NSData					*screenObj = NULL;
	float					transparency = -1.0;				// Use window's default.
	NSNumber				*transparencyNum = NULL;
	Point					screenPt;
	NSPoint					screenAt = NSMakePoint(0.0,0.0);	// Use window's default.
	NSNumber				*giveUpAfterNum = NULL;
	NSDictionary			*theArguments = [self evaluatedArguments];
	NSInteger				windowNum;
	NSString				*msgText;
	
	//SLOG(@"DisplayMessageWindow performDefaultImplementation");
	
	/* report the parameters */
	//SLOG(@"The direct parameter is: '%@'", [self directParameter]);
	//SLOG(@"The other parameters are: '%@'", theArguments);
	
	/* return the quoted direct parameter to show how to return a string from a command
	 Here, if the optional ProseText parameter has been provided, we return that value in
	 quotes, otherwise we return the direct parameter in quotes. */
	giveUpAfterNum = [theArguments objectForKey:@"GiveUpAfter"];
	screenObj = (NSData *) [theArguments objectForKey:@"ScreenPt"];
	transparencyNum = [theArguments objectForKey:@"Transparency"];

	msgText = [self directParameter];
		   
	if (screenObj) {
		// This will actually be an NSConcreteData class object.
		[screenObj getBytes:&screenPt length:4];
		//NSLog (@"point: %i,%i", screenPt.h, screenPt.v);
		screenAt = NSMakePoint (screenPt.h, screenPt.v);
	}
	
	if (giveUpAfterNum) {
		giveUpAfter = [giveUpAfterNum floatValue];
	}

	if (transparencyNum) {
		transparency = [transparencyNum floatValue];
	}

	windowNum = [(AppDelegate *)[[NSApplication sharedApplication] delegate] displayMessageWindow:msgText giveUpAfter:giveUpAfter screenPoint:screenAt transparency:transparency];

	return [NSNumber numberWithInteger:windowNum];
}

@end



// High-level parsing of NSAppleEventDescriptor
// http://www.cocoabuilder.com/archive/cocoa/186420-fetching-result-from-nsapplescript.html

// Extracting from a record:
// http://stackoverflow.com/questions/1247013/how-to-extract-applescript-data-from-a-nsappleeventdescriptor-in-cocoa-and-parse
				  
// - (NSPoint) extractPoint
// Direct parameter is NSAppleEventDescriptor with descriptor type "list"; direct object is '<list of UI action'>.	 
// Convert list descriptor to array of UI actions; based on Apple's Apply Firmware Password sample code.
/*
				 NSUInteger count = [directParameter numberOfItems];
id value;	 
for (NSUInteger idx = 1; idx <= count; idx++) {
	specifier = [NSScriptObjectSpecifier objectSpecifierWithDescriptor:[directParameter descriptorAtIndex:idx]];
	value = [specifier objectsByEvaluatingSpecifier];
	if ([value isKindOfClass:[UIActionClass class]]) {
					uiActionsArray = [uiActionsArray arrayByAddingObject:value];
				  }
				}
*/

/*
float delta = ... how much to make the window bigger or smaller ...;
NSRect frame = [window frame];

frame.origin.y -= delta;
frame.size.height += delta;

[window setFrame: frame
		 display: YES
		 animate: YES];
*/