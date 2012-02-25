//
//  CSTypedefs.h
//  CSUtils
//
//  Created by Cameron Spickert on 2/25/12.
//  Copyright (c) 2012 Cameron Spickert. All rights reserved.
//

#ifndef CSUtils_CSTypedefs_h
#define CSUtils_CSTypedefs_h

// Block typedefs

typedef void (^void_block_t)(void);
typedef void (^response_block_t)(NSURLResponse *response);
typedef void (^data_block_t)(NSData *data);
typedef void (^error_block_t)(NSError *error);

#endif
