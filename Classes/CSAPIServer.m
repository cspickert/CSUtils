//
//  CSAPIServer.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSAPIServer.h"
#import "NSDictionary+URLEncoding.h"

@interface CSAPIServer ()
@end

static CSAPIServer *sharedServer = nil;

@implementation CSAPIServer

@synthesize baseURL;

+ (id)sharedServer {
  return sharedServer;
}

+ (void)setSharedServer:(CSAPIServer *)aServer {
  [sharedServer release];
  sharedServer = [aServer retain];
}

- (void)dealloc {
  [baseURL release];
  if (sharedServer == self) {
    [[self class] setSharedServer:nil];
  }
  [super dealloc];
}

- (id)initWithBaseURL:(NSURL *)aBaseURL {
  if ((self = [super init])) {
    [self setBaseURL:aBaseURL];
    if (!sharedServer) {
      [[self class] setSharedServer:self];
    }
  }
  return self;
}

- (NSURL *)URLForPath:(NSString *)aPath {
  return [[self baseURL] URLByAppendingPathComponent:aPath];
}

- (NSMutableURLRequest *)mutableURLRequestForPath:(NSString *)path andParameters:(NSDictionary *)parameters {
  NSURL *requestURL = [self URLForPath:path];
  if (parameters && [parameters count]) {
    NSString *newURLString = [[requestURL absoluteString] stringByAppendingFormat:@"?%@", [parameters URLEncodedString]];
    requestURL = [NSURL URLWithString:newURLString];
  }
  return [NSMutableURLRequest requestWithURL:requestURL];
}

@end
