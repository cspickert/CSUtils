//
//  CSFetchRequest.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@interface CSFetchRequest : NSFetchRequest

@property (nonatomic, unsafe_unretained) Class model;
@property (nonatomic) NSURLRequest *remoteRequest;

- (id)initWithModel:(Class)model;

@end
