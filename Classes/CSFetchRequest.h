//
//  CSFetchRequest.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@interface CSFetchRequest : NSFetchRequest

@property (nonatomic, assign) Class model;
@property (nonatomic, retain) NSURLRequest *remoteRequest;

- (id)initWithModel:(Class)model;

@end
