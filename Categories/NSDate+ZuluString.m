//
//  NSDate+ZuluString.m
//  LampPost
//
//  Created by Cameron Spickert on 12/7/10.
//  Copyright 2010 LampPost Mobile LLC. All rights reserved.
//

#import "NSDate+ZuluString.h"

static NSString *kZuluDateFormat = @"yyyy-MM-dd'T'HH:mm:ss Z";

@implementation NSDate (ZuluString)

+ (NSDateFormatter *)dateFormatter {
  static NSDateFormatter *dateFormatter_ = nil;
  if (dateFormatter_ == nil) {
    dateFormatter_ = [NSDateFormatter new];
    [dateFormatter_ setDateFormat:kZuluDateFormat];
  }
  return dateFormatter_;
}

+ (NSDate *)dateFromZuluString:(NSString *)zulu {
  NSString *modifiedZulu = [zulu stringByReplacingOccurrencesOfString:@"Z" 
                            withString:@" +0000"];
  return [[self dateFormatter] dateFromString:modifiedZulu];
}

- (NSString *)zuluString {
  NSString *formattedString = [[[self class] dateFormatter] stringFromDate:self];
  NSArray *components = [formattedString componentsSeparatedByString:@" "];
  return [[components objectAtIndex:0] stringByAppendingString:@"Z"];
}

@end
