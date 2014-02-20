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

#import "Common.h"

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
    [self fetchedResultsControllerSchedule];
    [self fetchedResultsControllerScheduleCategory];
    [self fetchedResultsControllerScheduleAlert];
    
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
            NSLog(@"appdelegate total shift category : %lu", (unsigned long)[_fetchedResultsControllerShiftCategory.fetchedObjects count]);
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
            NSLog(@"appdelegate total shift : %lu", (unsigned long)[_fetchedResultsControllerShift.fetchedObjects count]);
            for (CDShift *item in _fetchedResultsControllerShift.fetchedObjects) {
                NSLog(@"Shift id: %d  -- name: %@ -- onDate: %@",
                      item.id,
                      item.name,
                      [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:[NSDate dateWithTimeIntervalSince1970:item.onDate]]);
            }
        }
        
    }
    
    return _fetchedResultsControllerShift;
}

- (NSFetchedResultsController*) fetchedResultsControllerSchedule
{
    if (!_fetchedResultsControllerSchedule) {
        
        NSString *entityName = @"CDSchedule";
        
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
        _fetchedResultsControllerSchedule = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                             managedObjectContext:self.managedObjectContext
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:cacheName];
        _fetchedResultsControllerSchedule.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerSchedule performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        } else {
            NSLog(@"appdelegate total schedule : %lu", (unsigned long)[_fetchedResultsControllerSchedule.fetchedObjects count]);
            for (CDSchedule *item in _fetchedResultsControllerSchedule.fetchedObjects) {
                NSLog(@"schedule id: %d  -- onDate: %@ -- alerts: %d",
                      item.id,
                      [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:[NSDate dateWithTimeIntervalSince1970:item.onDate]],
                      [item.pk_schedule count]);
            }
        }
        
    }
    
    return _fetchedResultsControllerSchedule;
}

- (NSFetchedResultsController*) fetchedResultsControllerScheduleCategory
{
    if (!_fetchedResultsControllerScheduleCategory) {
        
        NSString *entityName = @"CDScheduleCategory";
        
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
        _fetchedResultsControllerScheduleCategory = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                managedObjectContext:self.managedObjectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:cacheName];
        _fetchedResultsControllerScheduleCategory.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerScheduleCategory performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        } else {
            NSLog(@"appdelegate total schedule category : %lu", (unsigned long)[_fetchedResultsControllerScheduleCategory.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerScheduleCategory;
}

- (NSFetchedResultsController*) fetchedResultsControllerScheduleAlert
{
    if (!_fetchedResultsControllerScheduleAlert)
    {
        
        NSString *entityName = @"CDScheduleAlert";
        
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
        _fetchedResultsControllerScheduleAlert = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                        managedObjectContext:self.managedObjectContext
                                                                                          sectionNameKeyPath:nil
                                                                                                   cacheName:cacheName];
        _fetchedResultsControllerScheduleAlert.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerScheduleAlert performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        } else {
            NSLog(@"appdelegate total schedule alert : %lu", (unsigned long)[_fetchedResultsControllerScheduleAlert.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerScheduleAlert;
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

- (CDShift*) getShiftWithDate:(NSDate*)date
{
    NSString *strDay = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date];
    
    for (CDShift *item in self.fetchedResultsControllerShift.fetchedObjects) {
        
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:item.onDate];
        if ([[Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:tempDate] isEqualToString:strDay]) {
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
    
    CDShift *cdShift = [self getShiftWithDate:date];
    
    if (cdShift) {
        NSLog(@"Update Shift");
        
        cdShift.name                = shiftCategory.name;
        cdShift.shiftCategoryId     = shiftCategory.id;
        cdShift.isAllDay            = YES;
        cdShift.fk_shift_category   = shiftCategory;
        
    } else {
        NSLog(@"Add new Shift");
        
        CDShift *cdShift2 = (CDShift *)[NSEntityDescription insertNewObjectForEntityForName:@"CDShift"
                                                                     inManagedObjectContext:self.managedObjectContext];
        
        cdShift2.id                  = [self lastShiftID] + 1;
        cdShift2.name                = shiftCategory.name;
        cdShift2.shiftCategoryId     = shiftCategory.id;
        cdShift2.isAllDay            = YES;
        cdShift2.onDate              = [date timeIntervalSince1970];
        cdShift2.fk_shift_category   = shiftCategory;
    }
    
    [self saveContext];
    
}

- (CDScheduleCategory*) getScheduleCategoryWithID:(int)categoryID
{
    for (CDScheduleCategory *item in self.fetchedResultsControllerScheduleCategory.fetchedObjects) {
        if (item.id == categoryID) {
            return item;
        }
    }
    
    return nil;
}

- (void) addQuickScheduleWithInfo:(NSDictionary*)info
{
    CDSchedule *schedule = (CDSchedule*) [NSEntityDescription insertNewObjectForEntityForName:@"CDSchedule"
                                                                       inManagedObjectContext:self.managedObjectContext];
    
    schedule.id                     = [self lastScheduleID] + 1;
    schedule.scheduleCategoryId     = [[info objectForKey:@"schedule_category_id"] integerValue];
    schedule.isAllDay               = [[info objectForKey:@"is_all_day"] isEqualToString:@"1"] ? YES : NO;
    schedule.memo                   = @"";
    
    NSDate *onDate                  = [info objectForKey:@"select_date"];
    schedule.onDate                 = [onDate timeIntervalSince1970];
    
    NSDate *timeEndDate             = [info objectForKey:@"end_time"];
    schedule.timeEnd                = [timeEndDate timeIntervalSince1970];
    
    NSDate *timeStartDate           = [info objectForKey:@"start_time"];
    schedule.timeStart              = [timeStartDate timeIntervalSince1970];
    
    schedule.fk_schedule_category   = [self getScheduleCategoryWithID:schedule.scheduleCategoryId];
    
    
    if ([[info objectForKey:@"array_alert"] isKindOfClass:[NSArray class]]) {
        int alertID = [self lastScheduleAlertID];
        alertID++;
        for (NSDate *date in [info objectForKey:@"array_alert"]) {
            
            CDScheduleAlert *alert  = (CDScheduleAlert*) [NSEntityDescription insertNewObjectForEntityForName:@"CDScheduleAlert"
                                                                                       inManagedObjectContext:self.managedObjectContext];
            alert.id                = alertID;
            alert.onTime            = [date timeIntervalSince1970];
            alert.scheduleId        = schedule.id;
            
            alert.fk_alert_schedule = schedule;
            
        }
    }
    
    [self saveContext];
    
}

- (int) lastScheduleID
{
    if ([self.fetchedResultsControllerSchedule.fetchedObjects count] == 0) {
        return 0;
    } else {
        CDSchedule *cdSchedule = [self.fetchedResultsControllerSchedule.fetchedObjects lastObject];
        return cdSchedule.id;
    }
}

- (int) lastScheduleAlertID
{
    if ([self.fetchedResultsControllerScheduleAlert.fetchedObjects count] == 0) {
        return 0;
    } else {
        CDScheduleAlert *cdScheduleAlert = [self.fetchedResultsControllerScheduleAlert.fetchedObjects lastObject];
        return cdScheduleAlert.id;
    }
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Others
- (void) getInfoDayWithDate:(NSDate*)date
{
    // query coredata : Shift --> get info shift for date;
    
    // query coredata : schedule --> get list schedule for date;
}



@end
