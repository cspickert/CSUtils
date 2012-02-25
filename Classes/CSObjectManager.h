//
//  CSObjectManager.h
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

@interface CSObjectManager : NSObject

@property (nonatomic) NSMutableDictionary *entityDescriptions;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedManager;

- (id)initWithStoreName:(NSString *)storeName;
- (NSEntityDescription *)entityForModel:(Class)model;
- (NSManagedObjectContext *)newContext;
- (void)mergeContext:(NSNotification *)notification;

@end
