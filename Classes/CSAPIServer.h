//
//  CSAPIServer.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@interface CSAPIServer : NSObject

@property (nonatomic, copy) NSURL *baseURL;

+ (id)sharedServer;
+ (void)setSharedServer:(CSAPIServer *)server;

- (id)initWithBaseURL:(NSURL *)baseURL;
- (NSURL *)URLForPath:(NSString *)path;
- (NSMutableURLRequest *)mutableURLRequestForPath:(NSString *)path andParameters:(NSDictionary *)parameters;

@end
