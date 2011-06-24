//
//  NSDate+ZuluString.h
//  LampPost
//
//  Created by Cameron Spickert on 12/7/10.
//  Copyright 2010 LampPost Mobile LLC. All rights reserved.
//

@interface NSDate (ZuluString)

+ (NSDate *)dateFromZuluString:(NSString *)zulu;
- (NSString *)zuluString;

@end
