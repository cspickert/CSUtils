//
//  CSObject+UIKit.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSObject.h"
#import "CSObjectCell.h"

extern NSString *const CSObjectCellClassOptionsKey;

@interface CSObject (CSObject_UIKit)

- (UIViewController *)detailViewController;

+ (Class)tableViewCellClass;
- (UITableViewCell *)cellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath options:(NSDictionary *)options;

@end
