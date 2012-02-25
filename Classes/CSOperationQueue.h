//
//  CSOperationQueue.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSTypedefs.h"

@interface CSOperationQueue : NSOperationQueue

@property (nonatomic, copy) void_block_t startedBlock;
@property (nonatomic, copy) void_block_t finishedBlock;

@end
