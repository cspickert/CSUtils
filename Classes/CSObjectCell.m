//
//  CSObjectCell.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSObjectCell.h"
#import "CSObject.h"

NSInteger const CSObjectCellDefaultHeight = 44.0f;

@implementation CSObjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
	}
	return self;
}

#pragma mark -
#pragma mark Instance methods

- (void)configureForObject:(CSObject *)anObject {
  [[self textLabel] setText:[anObject localID]];
}

#pragma mark -
#pragma mark Class methods

+ (UITableViewCellStyle)cellStyle {
	return UITableViewCellStyleDefault;
}

+ (UITableViewCell *)cellForObject:(CSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = NSStringFromClass(self);
	
	CSObjectCell *cell = (CSObjectCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[self alloc] initWithStyle:[self cellStyle] reuseIdentifier:cellIdentifier];
	}
	
	[cell configureForObject:object];
	return cell;
}

+ (CGFloat)cellHeightForObject:(CSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  return CSObjectCellDefaultHeight;
}

@end
