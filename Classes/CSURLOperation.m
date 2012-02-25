//
//  CSURLOperation.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSURLOperation.h"

@interface CSURLOperation ()

@property (assign) BOOL isExecuting;
@property (assign) BOOL isFinished;
@property (nonatomic) NSURLConnection *connection;
#ifdef DEBUG
@property (nonatomic) NSDate *startDate;
#endif

- (void)finish;

@end

@implementation CSURLOperation

@synthesize isExecuting;
@synthesize isFinished;
@synthesize connection;
#ifdef DEBUG
@synthesize startDate;
#endif

@synthesize startedBlock;
@synthesize responseReceivedBlock;
@synthesize dataReceivedBlock;
@synthesize finishedBlock;
@synthesize failedBlock;

@synthesize request;
@synthesize response;
@synthesize responseData;


- (id)initWithURLRequest:(NSMutableURLRequest *)aRequest {
  if ((self = [super init])) {
    [self setRequest:aRequest];
    [self setIsExecuting:NO];
    [self setIsFinished:NO];
  }
  return self;
}

- (NSData *)responseData {
  return [NSData dataWithData:responseData];
}

#pragma mark -
#pragma mark NSOperation methods

- (BOOL)isConcurrent {
  return YES;
}

- (void)start {
  if ([self isCancelled]) {
    [self finish];
    return;
  }
  [self setIsExecuting:YES];
  [self setIsFinished:NO];
  
  [self setConnection:[[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:NO]];
  [[self connection] scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
  [[self connection] start];
}

- (void)finish {
  [self setIsFinished:YES];
  [self setIsExecuting:NO];
  [self setConnection:nil];
}

#pragma mark -
#pragma mark NSURLConnection methods

// All NSURLConnection delegate methods will execute on main thread (see run loop scheduling above)

- (NSURLRequest *)connection:(NSURLConnection *)aConnection willSendRequest:(NSURLRequest *)aRequest redirectResponse:(NSURLResponse *)aResponse {
  if (!aResponse) {
#if DEBUG
    DLog(@"%@ started: %@ %@", self, [aRequest HTTPMethod], [aRequest URL]);
    [self setStartDate:[NSDate date]];
#endif
    if ([self startedBlock]) {
      [self startedBlock]();
    }
  } else {
    DLog(@"%@ redirected to: %@", self, [aResponse URL]);
  }
  return aRequest;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse {
  if ([aResponse isKindOfClass:[NSHTTPURLResponse class]]) {
    NSHTTPURLResponse *HTTPResponse = (id)aResponse;
    DLog(@"%@ received response: %i", self, [HTTPResponse statusCode]);
  }
  responseData = [NSMutableData new];
  response = aResponse;
  if ([self responseReceivedBlock]) {
    [self responseReceivedBlock](aResponse);
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [responseData appendData:data];
  if ([self dataReceivedBlock]) {
    [self dataReceivedBlock](data);
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
#ifdef DEBUG
  NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:[self startDate]];
  DLog(@"%@ loaded %lu bytes (%0.2f sec)", self, [[self responseData] length], time);
#endif
  if ([self finishedBlock]) {
    [self finishedBlock]();
  }
  [self finish];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)anError {
  DLog(@"%@ failed with error: %@", self, [anError localizedDescription]);
  if ([self failedBlock]) {
    [self failedBlock](anError);
  }
  [self finish];
}

#pragma mark -
#pragma mark KVO notifications

// http://stackoverflow.com/questions/3573236

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
  return YES;
}

@end
