//
//  TableWindow.m
//  Gooey Gadgets
//
//  Created by Simon Brown on 1/15/11.
//  Copyright 2011 Simon Brown, Inc. All rights reserved.
//

#import "TableWindow.h"

@implementation TableWindow

- (void)awakeFromNib {

	[super awakeFromNib];
}

- (void)close {
	
	dataArray = NULL;
	[labelField setStringValue:@""];
	[super close];
}

-(IBAction)okButton:(id)sender
{
	[self close];
}

- (void)setLabel:(NSString*) labelStr {
	if (labelStr) {		
		[labelField setStringValue:labelStr];
	} else {
		[labelField setStringValue:@""];
	}
}

- (void)setButtonTitle:(NSString*) buttonStr {
	if (buttonStr) {		
		[okButton setTitle:buttonStr];
	} else {
		[okButton setTitle:@"OK"];
	}
}

//
//	s e t D a t a
//

- (void)setData:(id)dataList {
	int				i;
	NSTableColumn	*col;
	id				firstRow;
	CGFloat			firstColWidth;

	// Set (or clear) data object.
	dataArray = dataList;

	if (dataList) {
		
		if ([dataList isKindOfClass:[NSString class]]) {
			// Currently, we'll never get a data object that is anything other than NSArray.
			//NSLog (@"data string: %@", dataList);
			
			// CONVERT STRING INTO ARRAY
			dataArray = [dataList componentsSeparatedByString:@"\r"];
		}
		
		firstRow = [dataArray objectAtIndex:0];
		
		if ([firstRow isKindOfClass: [NSArray class]]) {
			//NSLog (@"data array: %@", [dataList description]);
			
			// NSARRAY
			// Create columns based on first row.
			// The first row is always in NIB, plus any others we previously created.
			NSInteger tc = [tableView numberOfColumns];
			NSInteger dc = [firstRow count];
			firstColWidth = [[tableView tableColumnWithIdentifier: @"0"] width];
			i = 1;
				
			while ((i < tc) || (i < dc)) {
				if ((i >= tc) && (i < dc)) {
					// Have more data columns, but there's no column for it in table.
					//NSLog (@"create col #%i", i);
					col = [[NSTableColumn alloc] initWithIdentifier: [NSString stringWithFormat:@"%i", i]];
					
					// In order for sizeToFit to work well, we make sure that the column width is consistent.
					[col setMaxWidth:1000.0];
					[col setWidth:firstColWidth];
					[tableView addTableColumn: col];
				} else if (i >= tc) {
					//NSLog (@"remove col #%i", i);
					// There are more columns in view than data object.
					[tableView removeTableColumn: [tableView tableColumnWithIdentifier: [NSString stringWithFormat:@"%i", i]]];
				} else {
					//NSLog (@"existing col #%i", i);

					// We have data for this column and there is a pre-existing column.
				}
					
				i++;
			}
		} else if ([firstRow isKindOfClass: [NSDictionary class]]) {
			// A dictionary can supply its own identifiers.
			//NSLog (@"data dict: %@", [dataList description]);
		}

	}

	// Adjust view for new data.
	[tableView reloadData];
	[tableView sizeToFit];

}

// IMPLMENTS DATA SOURCE

- (id)tableView:(NSTableView *)aTableView  objectValueForTableColumn:(NSTableColumn *)aTableCol  row:(NSInteger)rowIndex

{
    id theRow;
	id theValue = NULL;

    NSParameterAssert(rowIndex >= 0 && rowIndex < [dataArray count]);
    theRow = [dataArray objectAtIndex:rowIndex];

	if ([theRow isKindOfClass: [NSDictionary class]]) {
		//NSLog (@"tableView get dict: %i", rowIndex);

		theValue = [theRow objectForKey:[aTableCol identifier]];
		
	} else if ([theRow isKindOfClass: [NSArray class]]) {
		//NSLog (@"tableView get array: %i, %i", rowIndex, [[aTableCol identifier] integerValue]);

		// The columns are contained in an array, so we just use a numeric index.
		theValue = [(NSArray *)theRow objectAtIndex:[[aTableCol identifier] integerValue]];
	} else if ([theRow isKindOfClass: [NSString class]]) {
		if ([[aTableCol identifier] isEqualToString:@"0"]) {
			theValue = theRow;
		}
	} else {
		NSLog (@"Unknown class for TableView");
	}


    return theValue;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [dataArray count];
}


- (void)tableView:(NSTableView *)aTableView  setObjectValue:anObject  forTableColumn:(NSTableColumn *)aTableColumn  row:(NSInteger)rowIndex
{
    id theRow;
	
    NSParameterAssert(rowIndex >= 0 && rowIndex < [dataArray count]);
    theRow = [dataArray objectAtIndex:rowIndex];

	if ([theRow isKindOfClass: [NSDictionary class]]) {
		[theRow setObject:anObject forKey:[aTableColumn identifier]];
	}
		
    return;
}


@end
