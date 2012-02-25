//
//  CSAPIServer.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSAPIServer.h"
#import "NSDictionary+URLEncoding.h"
#import "CSAPIRequest.h"

@interface CSAPIServer ()

@property (nonatomic, strong) NSMutableDictionary *defaultParameters;

@end

static CSAPIServer *sharedServer = nil;

@implementation CSAPIServer

@synthesize defaultParameters;
@synthesize baseURL;

+ (id)sharedServer {
  return sharedServer;
}

+ (void)setSharedServer:(CSAPIServer *)aServer {
  sharedServer = aServer;
}

- (void)dealloc {
  if (sharedServer == self) {
    [[self class] setSharedServer:nil];
  }
}

- (id)initWithBaseURL:(NSURL *)aBaseURL {
  if ((self = [super init])) {
    [self setBaseURL:aBaseURL];
      [self setDefaultParameters:[NSMutableDictionary dictionary]];
    if (!sharedServer) {
      [[self class] setSharedServer:self];
    }
  }
  return self;
}

- (NSURL *)URLForPath:(NSString *)aPath {
  return [[self baseURL] URLByAppendingPathComponent:aPath];
}

- (NSURLRequest *)URLRequestForPath:(NSString *)path {
    return [[self mutableURLRequestForPath:path andParameters:nil] copy];
}

- (NSURLRequest *)URLRequestForPath:(NSString *)path andParameters:(NSDictionary *)parameters {
    NSURL *requestURL = [self URLForPath:path];
    NSMutableDictionary *mutableParameters = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    [mutableParameters addEntriesFromDictionary:[self defaultParameters]];
    if (mutableParameters && [mutableParameters count]) {
        NSString *newURLString = [[requestURL absoluteString] stringByAppendingFormat:@"?%@", [mutableParameters URLEncodedString]];
        requestURL = [NSURL URLWithString:newURLString];
    }
    return [NSURLRequest requestWithURL:requestURL];
}

- (NSMutableURLRequest *)mutableURLRequestForPath:(NSString *)path andParameters:(NSDictionary *)parameters {
    return [[self URLRequestForPath:path andParameters:parameters] mutableCopy];
}

- (CSAPIRequest *)requestForPath:(NSString *)path {
    return [self requestForPath:path parameters:nil model:nil];
}

- (CSAPIRequest *)requestForPath:(NSString *)path parameters:(NSDictionary *)parameters model:(Class)model {
    return [[CSAPIRequest alloc] initWithPath:path andParameters:nil andModel:model];
}

@end
