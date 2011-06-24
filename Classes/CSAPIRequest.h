//
//  CSAPIRequest.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSURLOperation.h"

@interface CSAPIRequest : CSURLOperation

@property (nonatomic, assign) Class model;

- (id)initWithPath:(NSString *)path andParameters:(NSDictionary *)parameters;
- (id)initWithPath:(NSString *)path andParameters:(NSDictionary *)parameters andModel:(Class)aModel;

@end
