//
//  AppDelegate.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AppDelegate.h"

#import "FXThemeManager.h"

#import "HomeVC.h"

#import "CDShift.h"
#import "CDShiftCategory.h"

static __weak AppDelegate *shared = nil;

@implementation AppDelegate

+ (AppDelegate *)shared
{
    return shared;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    shared = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // load theme
    [[FXThemeManager shared] loadTheme];
    
    //init VC
    HomeVC *homeVC                  = [[HomeVC alloc] init];
    _navigationController           = [[FXNavigationController alloc] initWithRootViewController:homeVC];
    
    
    self.window.rootViewController  = _navigationController;
    
    //load core data
    [self fetchedResultsControllerShiftCategory];
    [self fetchedResultsControllerShift];
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Nurse_Management" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Nurse_Management.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Fetch data delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
}

#pragma mark - Fetch data

- (NSFetchedResultsController*) fetchedResultsControllerShiftCategory
{
    if (!_fetchedResultsControllerShiftCategory) {
        NSString *entityName = @"CDShiftCategory";
        
        NSString *cacheName = [NSString stringWithFormat:@"%@",entityName];
        [NSFetchedResultsController deleteCacheWithName:cacheName];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
        
        
        NSSortDescriptor *sort0 = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        NSArray *sortList = [NSArray arrayWithObjects:sort0, nil];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != nil"];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = sortList;
        fetchRequest.predicate = predicate;
        _fetchedResultsControllerShiftCategory = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:self.managedObjectContext
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:cacheName];
        _fetchedResultsControllerShiftCategory.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerShiftCategory performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        }else {
            NSLog(@"total shift category : %lu", (unsigned long)[_fetchedResultsControllerShiftCategory.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerShiftCategory;
}

- (NSFetchedResultsController*) fetchedResultsControllerShift
{
    if (!_fetchedResultsControllerShift) {
        
        NSString *entityName = @"CDShift";
        
        NSString *cacheName = [NSString stringWithFormat:@"%@",entityName];
        [NSFetchedResultsController deleteCacheWithName:cacheName];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
        
        
        NSSortDescriptor *sort0 = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        NSArray *sortList = [NSArray arrayWithObjects:sort0, nil];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != nil"];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = sortList;
        fetchRequest.predicate = predicate;
        _fetchedResultsControllerShift = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:self.managedObjectContext
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:cacheName];
        _fetchedResultsControllerShift.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerShift performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        } else {
            NSLog(@"total shift : %lu", (unsigned long)[_fetchedResultsControllerShift.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerShift;
}

#pragma mark - CoreDate Common method
- (CDShiftCategory*) getshiftCategoryWithID:(int)categoryID
{
    for (CDShiftCategory *item in self.fetchedResultsControllerShiftCategory.fetchedObjects)
    {
        if (item.id == categoryID) {
            return item;
        }
    }
    
    return nil;
}

- (int) lastShiftID
{
    if ([self.fetchedResultsControllerShift.fetchedObjects count] == 0) {
        return 0;
    } else {
        CDShift *cdShift = [self.fetchedResultsControllerShift.fetchedObjects lastObject];
        return cdShift.id;
    }
}

- (void) addQuickShiftWithShiftCategoryID:(int)categoryID date:(NSDate*)date
{
    CDShiftCategory *shiftCategory = [self getshiftCategoryWithID:categoryID];
    
    if (!shiftCategory) {
        return;
    }
    
    CDShift *cdShift = (CDShift *)[NSEntityDescription insertNewObjectForEntityForName:@"CDShift"
                                                                                        inManagedObjectContext:self.managedObjectContext];
    
    cdShift.id                  = [self lastShiftID] + 1;
    cdShift.name                = shiftCategory.name;
    cdShift.shiftCategoryId     = shiftCategory.id;
    cdShift.isAllDay            = YES;
    cdShift.onDate              = [date timeIntervalSince1970];
    cdShift.fk_shift_category   = shiftCategory;
    
    [self saveContext];
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
