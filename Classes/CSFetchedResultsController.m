//
//  CSFetchedResultsController.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSFetchedResultsController.h"
#import "CSObjectManager.h"
#import "CSFetchRequest.h"
#import "CSObject+UIKit.h"

@implementation CSFetchedResultsController

- (id)initWithFetchRequest:(CSFetchRequest *)aFetchRequest {
  return [self initWithFetchRequest:aFetchRequest sectionNameKeyPath:nil cacheName:nil];
}

- (id)initWithFetchRequest:(CSFetchRequest *)aFetchRequest sectionNameKeyPath:(NSString *)aSectionNameKeyPath cacheName:(NSString *)aCacheName {
  NSManagedObjectContext *context = [[CSObjectManager sharedManager] managedObjectContext];
  return [super initWithFetchRequest:aFetchRequest managedObjectContext:context sectionNameKeyPath:aSectionNameKeyPath cacheName:aCacheName];
}

- (void)fetch {
	NSError *fetchError;
	ZAssert([self performFetch:&fetchError], @"Error fetching objects: %@", fetchError);
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[[self sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self objectAtIndexPath:indexPath] cellInTableView:aTableView atIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self sections] objectAtIndex:section];
  return sectionInfo.name;
}


@end
