//
//  DisplayTableWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/15/11.
//  Copyright 2011 Simon Brown, Inc. All rights reserved.
//

#import "DisplayTableWindowASC.h"
#import "AppDelegate.h"
#import "scriptLog.h"


@implementation DisplayTableWindowASC


// The methods below are based on Apple's ApplyFirmwarePassword example,
// but have been modified to return string values

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
            return [[NSNumber numberWithBool:(BOOL)[descriptor booleanValue]] stringValue];
        case typeTrue:
            return [[NSNumber numberWithBool:YES] stringValue];
        case typeFalse:
            return [[NSNumber numberWithBool:NO] stringValue];
        case typeType:
            return [[NSNumber numberWithUnsignedLong:(unsigned long)[descriptor typeCodeValue]] stringValue];
        case typeEnumerated:
            return [[NSNumber numberWithUnsignedLong:(unsigned long)[descriptor enumCodeValue]] stringValue];
        case typeNull:
            return @"";
        case typeSInt16:
            return [[NSNumber numberWithInt:(short)[descriptor int32Value]] stringValue];
        case typeSInt32:
            return [[NSNumber numberWithInt:(int)[descriptor int32Value]] stringValue];
        case typeUInt32:
            return [[NSNumber numberWithLong:(unsigned int)[descriptor int32Value]] stringValue];
        case typeSInt64:
            return [[NSNumber numberWithLong:(long)[descriptor int32Value]] stringValue];
			//      case typeIEEE32BitFloatingPoint:
			//          return [NSNumber numberWithBytes:[[descriptor data] bytes] objCType:@encode(float)];
			//      case typeIEEE64BitFloatingPoint:
			//          return [NSNumber numberWithBytes:[[descriptor data] bytes] objCType:@encode(double)];
			//      case type128BitFloatingPoint:
			//      case typeDecimalStruct:
    }
    
    return [descriptor data];
}


- (NSArray *)arrayFromList: (NSArray*)objList {
	
	NSEnumerator			*objIterator = [objList objectEnumerator];
	NSAppleEventDescriptor	*object = NULL;
	NSMutableArray			*strList = [[NSMutableArray alloc] init];
	
	// Repeat through the top level objects in list,
	// converting each row to an array of strings.
	
	while ((object = (NSAppleEventDescriptor *) [objIterator nextObject])) {
		// Extract NSArray, NSDictionary, or string from NSAppleEventDescriptor record.
		[strList addObject: [self objectFromAEDescriptor: object]];
	}

	return strList;
}

- (id) performDefaultImplementation {
	
	NSString				*buttonTitleStr;
	NSString				*labelStr;
	NSData					*screenObj = NULL;
	Point					screenPt;
	NSPoint					screenAt = NSMakePoint(0.0,0.0);	// Use window's default.
	NSDictionary			*theArguments = [self evaluatedArguments];
	id						dataObj;
	NSArray					*dataList = NULL;
	NSString				*titleStr;
	NSInteger				windowNum;
	
	//SLOG(@"DisplayTableWindow performDefaultImplementation");
	
	/* report the parameters */
	//SLOG(@"The direct parameter is: '%@'", [self directParameter]);
	//SLOG(@"The other parameters are: '%@'", theArguments);
	
	/* return the quoted direct parameter to show how to return a string from a command
	 Here, if the optional ProseText parameter has been provided, we return that value in
	 quotes, otherwise we return the direct parameter in quotes. */
	buttonTitleStr = [theArguments objectForKey:@"ButtonTitle"];
	labelStr = [theArguments objectForKey:@"Label"];
	screenObj = (NSData *) [theArguments objectForKey:@"ScreenPt"];
	dataObj = [theArguments objectForKey:@"Data"];

	if (dataObj) {
		if ([dataObj isKindOfClass: [NSArray class]] || [dataObj isKindOfClass: [NSDictionary class]]) {
			// We have a list of items, and these will given to us as an NSAppleEventDescriptor,
			// so we need to extract these into a NSString, NSArray, or NSDictionary objects.
			dataList = [self arrayFromList: dataObj];
			//NSLog (@"list: %@", [dataList description]);
		} else {
			// Just return the object directly, the DisplayTable class will handle the rest.
			dataList = dataObj;
		}
	}
	
	titleStr = [self directParameter];
	
	if (screenObj) {
		// This will actually be an NSConcreteData class object.
		[screenObj getBytes:&screenPt length:4];
		//NSLog (@"point: %i,%i", screenPt.h, screenPt.v);
		screenAt = NSMakePoint (screenPt.h, screenPt.v);
	}
	
	//	return theResult;
	// - (void)makeTransparentMsgWindow:(NSString *)msgText screenPoint:(NSPoint)winPoint
	
	windowNum = [(AppDelegate *)[[NSApplication sharedApplication] delegate] displayTableWindow:titleStr buttonTitle:buttonTitleStr label:labelStr dataList:dataList];
	
	return [NSNumber numberWithInteger:windowNum];
}

@end
