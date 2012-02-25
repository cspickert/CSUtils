//
//  CSAPIServer.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@class CSAPIRequest;

@interface CSAPIServer : NSObject

@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, strong, readonly) NSMutableDictionary *defaultParameters;

+ (id)sharedServer;
+ (void)setSharedServer:(CSAPIServer *)server;

- (id)initWithBaseURL:(NSURL *)baseURL;
- (NSMutableDictionary *)defaultParameters;

- (NSURL *)URLForPath:(NSString *)path;

- (NSURLRequest *)URLRequestForPath:(NSString *)path;
- (NSURLRequest *)URLRequestForPath:(NSString *)path andParameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)mutableURLRequestForPath:(NSString *)path andParameters:(NSDictionary *)parameters;

- (CSAPIRequest *)requestForPath:(NSString *)path;
- (CSAPIRequest *)requestForPath:(NSString *)path model:(Class)model;

@end
