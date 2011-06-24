//
//  CSObjectCell.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@class CSObject;

@interface CSObjectCell : UITableViewCell

- (void)configureForObject:(CSObject *)anObject;

+ (UITableViewCell *)cellForObject:(CSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)cellHeightForObject:(CSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
