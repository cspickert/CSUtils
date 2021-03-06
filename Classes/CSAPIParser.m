//
//  CSAPIParser.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSAPIParser.h"
#import "CSObjectManager.h"
#import "CSObject.h"

@interface CSAPIParser ()

@property (nonatomic, unsafe_unretained) Class model;
#ifdef DEBUG
@property (nonatomic) NSDate *startDate;
@property (nonatomic, assign) NSInteger importCount;
#endif

@end

@implementation CSAPIParser

@synthesize model;
#ifdef DEBUG
@synthesize startDate;
@synthesize importCount;
#endif

- (id)initWithModel:(Class)aModel {
  if ((self = [super init])) {
    [self setModel:aModel];
  }
  return self;
}

- (void)finish {
#ifdef DEBUG
  if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(finish) withObject:nil waitUntilDone:YES];
    return;
	}
  NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:[self startDate]];
  DLog(@"%@ imported %i objects (%0.2f sec)", self, [self importCount], time);
#endif
}

- (void)failWithError:(NSError *)error {
#ifdef DEBUG
  if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(failWithError:) withObject:error waitUntilDone:YES];
    return;
	}
  DLog(@"%@ failed with error: %@", self, error);
#endif
}

- (void)parseDataInBackground:(NSData *)data {
  [self performSelectorInBackground:@selector(parseData:) withObject:data];
}

- (id)deserializedData:(NSData *)data {
  return nil;
}

- (void)parseData:(NSData *)data {
  //NSAutoreleasePool *pool = [NSAutoreleasePool new];
  
#ifdef DEBUG
  [self setStartDate:[NSDate date]];
#endif
  
  id JSONObject = [self deserializedData:data];
	
	// Check for API errors
  //  NSError *apiError = [NSError errorWithAPIError:JSONObject];
  //	if (apiError) {
  //		[self failWithError:apiError];
  //		goto done;
  //	}
	
	NSManagedObjectContext *importContext = [[CSObjectManager sharedManager] newContext];
	id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:importContext queue:nil usingBlock:^(NSNotification *notification) {
		[[CSObjectManager sharedManager] mergeContext:notification];
	}];
  
  NSDictionary *options = [NSDictionary dictionaryWithObject:importContext forKey:CSManagedObjectContextOptionsKey];
  NSArray *result = [[self model] createOrUpdate:JSONObject options:options];
  
#ifdef DEBUG
  [self setImportCount:[result count]];
#endif
	
	// Save to trigger a context merge on the main thread
	NSError *saveError = nil;
	ZAssert([importContext save:&saveError], @"Error saving context: %@", saveError);
	
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
	[importContext reset];
	
	[self finish];
}

@end
