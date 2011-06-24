//
//  CSFetchedResultsController.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@class CSFetchRequest;

@interface CSFetchedResultsController : NSFetchedResultsController <UITableViewDataSource>

- (id)initWithFetchRequest:(CSFetchRequest *)fetchRequest;
- (id)initWithFetchRequest:(CSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName;
- (void)fetch;

@end
