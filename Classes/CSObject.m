//
//  CSObject.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSObject.h"
#import "CSObjectManager.h"
#import "CSFetchRequest.h"

#import "NSDate+ZuluString.h"
#import "NSString+Inflections.h"

NSString *const CSManagedObjectContextOptionsKey = @"managedObjectContext";
NSString *const CSImportBatchSizeOptionsKey = @"importBatchSize";
NSInteger const CSDefaultImportBatchSize = 10;

@implementation CSObject

@dynamic localID;

+ (void)setupEntity {
  NSAttributeDescription *localIDAttribute = [[[[self entity] properties] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", [self localIDField]]] lastObject];
	if (!localIDAttribute) {
    localIDAttribute = [[NSAttributeDescription new] autorelease];
    [localIDAttribute setName:[self localIDField]];
    [localIDAttribute setAttributeType:NSStringAttributeType];
	}
  [[self entity] setProperties:[[[self entity] properties] arrayByAddingObject:localIDAttribute]];
}

+ (id)objectManager {
  return [CSObjectManager sharedManager];
}

+ (NSString *)entityName {
	return NSStringFromClass(self);
}

+ (NSEntityDescription *)entity {
	return [[self objectManager] entityForModel:self];
}

+ (NSArray *)defaultSortDescriptors {
	return [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:[self localIDField] ascending:YES] autorelease]];
}

+ (CSFetchRequest *)fetchRequest {
  return [[[CSFetchRequest alloc] initWithModel:self] autorelease];
}

+ (NSString *)remoteCollectionPath {
	return [[NSStringFromClass([self class]) lowercaseString] pluralize];
}

+ (NSString *)remoteIDField {
	return @"id";
}

+ (NSString *)localIDField {
	return @"resourceID";
}

- (id)localID {
	return [self valueForKey:[[self class] localIDField]];
}

- (void)setLocalID:(id)aLocalId {
	[self setValue:aLocalId forKey:[[self class] localIDField]];
}

#pragma mark -
#pragma mark Create and update

+ (NSString *)localNameForRemoteField:(NSString *)remoteField {
	SEL localNameForField = NSSelectorFromString([NSString stringWithFormat:@"localNameFor%@", [remoteField capitalize]]);
	if ([self respondsToSelector:localNameForField]) {
		return [self performSelector:localNameForField withObject:remoteField];
	}
	if ([remoteField isEqualToString:[self remoteIDField]]) {
		return [self localIDField];
	}
	return [remoteField camelizeWithLowerFirstLetter];
}

+ (NSString *)remoteNameForLocalField:(NSString *)localField {
	SEL remoteNameForField = NSSelectorFromString([NSString stringWithFormat:@"remoteNameFor%@", [localField capitalize]]);
	if ([self respondsToSelector:remoteNameForField]) {
		return [self performSelector:remoteNameForField withObject:localField];
	}
	if ([localField isEqualToString:[self localIDField]]) {
		return [self remoteIDField];
	}
	return [localField underscore];
}

+ (NSPropertyDescription *)propertyForRemoteField:(NSString *)remoteField {
	NSString *localField = [self localNameForRemoteField:remoteField];
	return [[[self entity] propertiesByName] objectForKey:localField];
}

//
// Updating an attribute
//
// 1. If the incoming value is [NSNull null], set the attribute to nil.
// 2. Preprocess values as necessary. Currently, strings are converted to instances of NSDate.
//
- (void)updateAttribute:(NSAttributeDescription *)attribute withValue:(id)value {
	if ([value isEqual:[NSNull null]]) {
		[self setValue:nil forKey:[attribute name]];
		return;
	}
  //
  // Do any attribute preprocessing below.
  //
	switch ([attribute attributeType]) {
    //
    // Convert strings to NSDate instances.
    //
		case NSDateAttributeType:
      if ([value isKindOfClass:[NSString class]]) {
        value = [NSDate dateFromZuluString:value];
      }
			break;
    //
    // Add cases for converting numbers to strings (or vice versa), etc. if needed
    //
    default:
      break;
	}
	[self setValue:value forKey:[attribute name]];
}

//
// Updating a relationship (to-one and to-many)
//
// 1. If the incoming value is [NSNull null], set the relationship to nil.
// 2. Convert incoming value to CSObject instance(s) by recursively invoking +createOrUpdate:options: on the destination class.
// 3. Handle to-many and to-one cases.
//
- (void)updateRelationship:(NSRelationshipDescription *)relationship withValue:(id)value options:(NSDictionary *)options {
	if ([value isEqual:[NSNull null]]) {
		value = nil;
	}
	Class relatedModel = NSClassFromString([[relationship destinationEntity] managedObjectClassName]);
	id oldResources = [self valueForKey:[relationship name]];
	NSArray *newResources = value ? [relatedModel createOrUpdate:value options:options] : nil;
  id newValue;
  if (relationship.isToMany) {
    newValue = [NSSet setWithArray:newResources];
  } else {
    newValue = [newResources lastObject];
  }
	if (![newResources isEqual:oldResources]) {
		[self setValue:newValue forKey:[relationship name]];
	}
}

//
// Updating an object
//
// For each key, value pair in the incoming dictionary:
//
// 1. If the model doesn't contain a local property for key, continue.
// 2. If the key maps to a relationship, call -updateRelationship:withValue:options:.
// 3. If the key maps to an attribute, call -updateAttribute:withValue:.
//
- (void)updateWithParameters:(NSDictionary *)parameters options:(NSDictionary *)options {
	for (NSString *remoteField in parameters) {
		NSPropertyDescription *property = [[self class] propertyForRemoteField:remoteField];
		if (!property) {
			continue;
		}
		id newValue = [parameters valueForKey:remoteField];
		if ([property isKindOfClass:[NSRelationshipDescription class]]) {
			[self updateRelationship:(NSRelationshipDescription *)property withValue:newValue options:options];
		} else {
			ZAssert([property isKindOfClass:[NSAttributeDescription class]], @"Expected attribute, got something else");
			[self updateAttribute:(NSAttributeDescription *)property withValue:newValue];
		}
    //
    // Give subclasses a chance to post-process updated properties
    //
    SEL didUpdateSelector = NSSelectorFromString([NSString stringWithFormat:@"didUpdate%@:", [[property name] capitalize]]);
    if ([self respondsToSelector:didUpdateSelector]) {
      [self performSelector:didUpdateSelector withObject:newValue];
    }
	}
}

//
// Creating an object
//
// 1. Create a new object of this class.
// 2. Call -updateWithParameters:options:.
//
+ (CSObject *)createWithParameters:(NSDictionary *)parameters options:(NSDictionary *)options {
	NSManagedObjectContext *context = [options objectForKey:CSManagedObjectContextOptionsKey];
	if (!context) {
		context = [[CSObjectManager sharedManager] managedObjectContext];
	}
	CSObject *resource = [[[self alloc] initWithEntity:[self entity] insertIntoManagedObjectContext:context] autorelease];
	[resource updateWithParameters:parameters options:options];
	return resource;
}

//
// Create or update one object
//
// 1. Look for an existing object whose localID == the incoming parameters' remoteIDField value.
// 2. If found, call -updateWithParameters:options:.
// 3. Otherwise, call +createWithParameters:options:.
//
+ (CSObject *)createOrUpdateOne:(NSDictionary *)parameters options:(NSDictionary *)options {
  if (![parameters isKindOfClass:[NSDictionary class]]) {
    parameters = [NSDictionary dictionaryWithObject:parameters forKey:[self remoteIDField]];
  }
	id remoteId = [parameters objectForKey:[self remoteIDField]];
	if (!remoteId) {
		return [self createWithParameters:parameters options:options];
	}
	NSManagedObjectContext *context = [options objectForKey:CSManagedObjectContextOptionsKey];
	NSFetchRequest *request = [self fetchRequest];
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", [self localIDField], remoteId]];
	[request setFetchLimit:1];
	NSError *error = nil;
	CSObject *resource = [[context executeFetchRequest:request error:&error] lastObject];
  ZAssert(!!error, @"Error fetching %@: %@", self, error);
	if (resource) {
		[resource updateWithParameters:parameters options:options];
	} else {
		resource = [self createWithParameters:parameters options:options];
	}
	return resource;
}

//
// Create or update multiple objects
//
// For each dict in parametersArray, call +createOrUpdateOne:options:, saving after importing every <batch size> objects.
//
// TODO: This can be made more efficient by doing one fetch instead of n fetches. So far no performance problems, though. Improving this plus +createOrUpdate:options:, we could eliminate +createOrUpdateOne:options:.
//
+ (NSArray *)createOrUpdateAll:(NSArray *)parametersArray options:(NSDictionary *)options {
	NSMutableArray *resources = [NSMutableArray array];
	for (id parameters in parametersArray) {
    [resources addObject:[self createOrUpdateOne:parameters options:options]];
    
		if ([resources count] % [[options objectForKey:CSImportBatchSizeOptionsKey] intValue] == 0) {
      NSError *saveError;
			ZAssert([[options objectForKey:CSManagedObjectContextOptionsKey] save:&saveError], @"Error saving context: %@", saveError);
		}
	}
	return [NSArray arrayWithArray:resources];
}

//
// Create or update one or more objects
//
// Generic wrapper for +createOrUpdateAll:options: and +createOrUpdateOne:options:.
//
+ (NSArray *)createOrUpdate:(id)value options:(NSDictionary *)options {
  if (!options) {
    options = [NSDictionary dictionary];
  }
  if (![options objectForKey:CSImportBatchSizeOptionsKey]) {
    NSMutableDictionary *mutableOptions = [NSMutableDictionary dictionaryWithDictionary:options];
    [mutableOptions setObject:[NSNumber numberWithInt:CSDefaultImportBatchSize] forKey:CSImportBatchSizeOptionsKey];
    options = [NSDictionary dictionaryWithDictionary:mutableOptions];
  }
	if (![value isKindOfClass:[NSArray class]]) {
		if (![value isKindOfClass:[NSDictionary class]]) {
      value = [NSDictionary dictionaryWithObject:value forKey:[[self class] remoteIDField]];
    }
    value = [NSArray arrayWithObject:value];
	}
  return [self createOrUpdateAll:value options:options];
}


@end
