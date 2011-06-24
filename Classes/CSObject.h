//
//  CSObject.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/23/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

extern NSString *const CSManagedObjectContextOptionsKey;
extern NSString *const CSImportBatchSizeOptionsKey;

@class CSFetchRequest;

@interface CSObject : NSManagedObject

@property (nonatomic, retain) NSString *localID;

+ (void)setupEntity;
+ (NSString *)entityName;
+ (NSEntityDescription *)entity;
+ (NSArray *)defaultSortDescriptors;
+ (CSFetchRequest *)fetchRequest;

+ (NSString *)remoteCollectionPath;
+ (NSString *)remoteIDField;
+ (NSString *)localIDField;

+ (NSString *)localNameForRemoteField:(NSString *)remoteField;
+ (NSString *)remoteNameForLocalField:(NSString *)localField;

+ (NSArray *)createOrUpdate:(id)value options:(NSDictionary *)options;
- (void)updateWithParameters:(NSDictionary *)parameters options:(NSDictionary *)options;

@end
