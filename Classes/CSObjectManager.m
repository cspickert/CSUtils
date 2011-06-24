//
//  CSObjectManager.m
//  CSUtils
//
//  Created by Cameron Spickert on 6/24/11.
//  Copyright 2011 Cameron Spickert. All rights reserved.
//

#import "CSObjectManager.h"
#import "CSObject.h"

static NSString *const CSObjectManagerDefaultStoreName = @"store.db";

@implementation CSObjectManager

@synthesize entityDescriptions;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (void)dealloc {
	[entityDescriptions release];
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	[super dealloc];
}

+ (id)sharedManager {
  static CSObjectManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  return sharedManager;
}

- (id)initWithStoreName:(NSString *)storeName {
  if ((self = [super init])) {
    [self setManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    [self setEntityDescriptions:[NSMutableDictionary dictionary]];
    
    for (NSEntityDescription *entity in self.managedObjectModel) {
      Class model = NSClassFromString([entity managedObjectClassName]);
      [[self entityDescriptions] setObject:entity forKey:model];
      [model setupEntity];
		}
    
    [self setPersistentStoreCoordinator:[[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]] autorelease]];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSURL *storeURL = [NSURL fileURLWithPath:[documentsPath stringByAppendingPathComponent:storeName]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, NSMigratePersistentStoresAutomaticallyOption, (id)kCFBooleanTrue, NSInferMappingModelAutomaticallyOption, nil];
    
    NSPersistentStore *(^addPersistentStore)(NSError **) = ^(NSError **anError){
      return [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:anError];
    };
    
    NSError *error = nil;
    ZAssert(!!addPersistentStore(&error), @"Couldn't create persistent store at %@, %@", storeURL, [error localizedDescription]);
    
    [self setManagedObjectContext:[[NSManagedObjectContext new] autorelease]];
    [[self managedObjectContext] setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
  }
  return self;
}

- (id)init {
  return [self initWithStoreName:CSObjectManagerDefaultStoreName];
}

- (NSEntityDescription *)entityForModel:(Class)model {
  NSEntityDescription *entity = [[self entityDescriptions] objectForKey:model];
  if (!entity) {
    entity = [NSEntityDescription entityForName:[model entityName] inManagedObjectContext:[self managedObjectContext]];
    [[self entityDescriptions] setObject:entity forKey:model];
  }
  return entity;
}

- (NSManagedObjectContext *)newContext {
  NSManagedObjectContext *context = [[NSManagedObjectContext new] autorelease];
  [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
  return context;
}

- (void)mergeContext:(NSNotification *)notification {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(mergeContext:) withObject:notification waitUntilDone:NO];
  }
  [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
  NSError *error;
  ZAssert([[self managedObjectContext] save:&error], @"Error saving main context: %@", error);
}

@end
