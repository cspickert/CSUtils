//
//  CSAPIRequest.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSAPIRequest.h"
#import "CSAPIServer.h"
#import "CSAPIParser.h"

@implementation CSAPIRequest

@synthesize model;

static Class _parserClass = nil;

+ (void)setParserClass:(Class)parserClass
{
    ZAssert([parserClass isSubclassOfClass:[CSAPIParser class]], @"");
    _parserClass = parserClass;
}

+ (Class)parserClass
{
    return _parserClass;
}

- (id)initWithPath:(NSString *)path andParameters:(NSDictionary *)parameters {
  NSMutableURLRequest *request = [[CSAPIServer sharedServer] mutableURLRequestForPath:path andParameters:parameters];
  return [self initWithURLRequest:request];
}

- (id)initWithPath:(NSString *)path andParameters:(NSDictionary *)parameters andModel:(Class)aModel {
  if ((self = [self initWithPath:path andParameters:parameters])) {
    [self setModel:aModel];
  }
  return self;
}

#pragma mark -
#pragma mark NSURLConnection methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  // Load incoming data into the persistent store if necessary
  if ([self model]) {
      Class parserClass = [[self class] parserClass];
    CSAPIParser *parser = [[parserClass alloc] initWithModel:[self model]];
    [parser parseDataInBackground:[self responseData]];
  }
  [super connectionDidFinishLoading:connection];
}

@end
