//
//  NSString+URLEncoding.h
//  CoreDataImportTest
//
//  Created by Cameron Spickert on 3/26/11.
//  Copyright 2011 LampPost Mobile LLC. All rights reserved.
//

// Based on Google Toolbox for Mac code
// http://bitly.com/e0qi9h

@interface NSString (URLEncoding)

- (NSString *)stringByEscapingForURLArgument;
- (NSString *)stringByUnescapingFromURLArgument;

@end
