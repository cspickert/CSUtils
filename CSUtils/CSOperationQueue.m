//
//  CSOperationQueue.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSOperationQueue.h"

@implementation CSOperationQueue

@synthesize startedBlock;
@synthesize finishedBlock;

- (void)dealloc {
  [self removeObserver:self forKeyPath:PROPERTY(operationCount)];
  [startedBlock release];
  [finishedBlock release];
  [super dealloc];
}

- (id)init {
  if ((self = [super init])) {
    [self addObserver:self forKeyPath:PROPERTY(operationCount) options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
  }
  return self;
}

- (void)didStart {
  DLog(@"%@ started", self);
  if ([self startedBlock]) {
    [self startedBlock]();
  }
}

- (void)didFinish {
  DLog(@"%@ finished", self);
  if ([self finishedBlock]) {
    [self finishedBlock]();
  }
}

- (void)didUpdateOperationsFrom:(NSInteger)from to:(NSInteger)to {
  if (from == 0 && to > 0) {
    [self didStart];
  } else if (from > 0 && to == 0) {
    [self didFinish];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (!(object == self && [keyPath isEqualToString:PROPERTY(operationCount)])) {
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [self didUpdateOperationsFrom:[[change objectForKey:NSKeyValueChangeOldKey] intValue] to:[[change objectForKey:NSKeyValueChangeNewKey] intValue]];
  });
}

@end
