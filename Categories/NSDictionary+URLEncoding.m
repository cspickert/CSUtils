//
//  NSDictionary+URLEncoding.m
//  CoreDataImportTest
//
//  Created by Cameron Spickert on 3/26/11.
//  Copyright 2011 LampPost Mobile LLC. All rights reserved.
//

#import "NSDictionary+URLEncoding.h"

@implementation NSDictionary (URLEncoding)

- (NSString *)URLEncodedString {
	NSMutableArray *encodedPairs = [NSMutableArray array];
	for (NSString *key in self) {
		NSString *encodedKey = [key stringByEscapingForURLArgument];
		NSString *encodedValue = [[self valueForKey:key] stringByEscapingForURLArgument];
		if ([encodedValue length] == 0) {
			[encodedPairs addObject:encodedKey];
		} else {
			[encodedPairs addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
		}
	}
	return [encodedPairs componentsJoinedByString:@"&"];
}

@end
