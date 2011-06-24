//
//  CSTableViewController.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@class CSFetchedResultsController;

@interface CSTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

- (id)initWithStyle:(UITableViewStyle)style andFetchController:(CSFetchedResultsController *)fetchController;
- (void)didSelectObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath;

@end
