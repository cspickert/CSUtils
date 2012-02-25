//
//  CSAPIParser.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@interface CSAPIParser : NSObject

- (id)initWithModel:(Class)model;

- (id)deserializedData:(NSData *)data;
- (void)parseDataInBackground:(NSData *)data;
- (void)parseData:(NSData *)data;

@end
