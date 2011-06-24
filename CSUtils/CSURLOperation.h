//
//  CSURLOperation.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@interface CSURLOperation : NSOperation {
@private
  NSMutableData *responseData;
}

@property (nonatomic, copy) void_block_t startedBlock;
@property (nonatomic, copy) response_block_t responseReceivedBlock;
@property (nonatomic, copy) data_block_t dataReceivedBlock;
@property (nonatomic, copy) void_block_t finishedBlock;
@property (nonatomic, copy) error_block_t failedBlock;

@property (nonatomic, readonly) NSURLResponse *response;
@property (nonatomic, readonly) NSData *responseData;

- (id)initWithURLRequest:(NSURLRequest *)request;

@end
