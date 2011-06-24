//
//  CSObject+UIKit.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSObject+UIKit.h"

NSString *const CSObjectCellClassOptionsKey = @"cellClass";

@implementation CSObject (CSObject_UIKit)

- (UIViewController *)detailViewController {
	return nil;
}

+ (Class)tableViewCellClass {
	NSString *className = [NSString stringWithFormat:@"%@Cell", NSStringFromClass([self class])];
	return NSClassFromString(className);
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	return [self cellInTableView:tableView atIndexPath:indexPath options:nil];
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath options:(NSDictionary *)options {
	Class cellClass;
	if (!(cellClass = [options objectForKey:CSObjectCellClassOptionsKey])) {
		if (!(cellClass = [[self class] tableViewCellClass])) {
			cellClass = [CSObjectCell class];
		}
	}
	return [cellClass cellForObject:self inTableView:tableView atIndexPath:indexPath];
}

@end
