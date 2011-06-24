//
//  CSFetchRequest.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSFetchRequest.h"
#import "CSObject.h"

@implementation CSFetchRequest

@synthesize model;
@synthesize remoteRequest;

- (void)dealloc {
  [remoteRequest release];
  [super dealloc];
}

- (id)initWithModel:(Class)aModel {
  if ((self = [super init])) {
    [self setModel:aModel];
    [self setEntity:[aModel entity]];
    [self setSortDescriptors:[aModel defaultSortDescriptors]];
  }
  return self;
}

@end
