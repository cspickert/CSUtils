//
//  NSString+URLEncoding.m
//  CoreDataImportTest
//
//  Created by Cameron Spickert on 3/26/11.
//  Copyright 2011 LampPost Mobile LLC. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)stringByEscapingForURLArgument {
	// Encode all the reserved characters, per RFC 3986
  // (<http://www.ietf.org/rfc/rfc3986.txt>)
  CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	return [(NSString *)escaped autorelease];
}

- (NSString *)stringByUnescapingFromURLArgument {
	NSMutableString *resultString = [NSMutableString stringWithString:self];
  [resultString replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [resultString length])];
  return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
