//
//  CSTableViewController.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@class CSFetchRequest;

@interface CSTableViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style andFetchRequest:(CSFetchRequest *)fetchRequest;

@end
