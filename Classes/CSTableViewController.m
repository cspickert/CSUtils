//
//  CSTableViewController.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSTableViewController.h"
#import "CSObject+UIKit.h"
#import "CSFetchRequest.h"
#import "CSFetchedResultsController.h"

@interface CSTableViewController ()

@property (nonatomic, retain) CSFetchedResultsController *fetchController;

@end

@implementation CSTableViewController

@synthesize fetchController;

- (id)initWithStyle:(UITableViewStyle)aStyle andFetchController:(CSFetchedResultsController *)aFetchController {
  if ((self = [super initWithStyle:aStyle])) {
    [self setFetchController:aFetchController];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[self tableView] setDataSource:[self fetchController]];
  [[self tableView] setDelegate:self];
  [[self fetchController] fetch];
}

#pragma mark -
#pragma mark Table view methods

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	[self didSelectObject:[[self fetchController] objectAtIndexPath:indexPath] atIndexPath:indexPath];
}

- (void)didSelectObject:(CSObject *)anObject atIndexPath:(NSIndexPath *)indexPath {
  UIViewController *detailController = [anObject detailViewController];
  if (detailController) {
    [[self navigationController] pushViewController:detailController animated:YES];
  }
}

@end
