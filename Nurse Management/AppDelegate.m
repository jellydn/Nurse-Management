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
#import "CDShiftAlert.h"

#import "Common.h"
#import "Define.h"
#import "FXCalendarData.h"

static __weak AppDelegate *shared = nil;
/******* Set your tracking ID here *******/
static NSString *const kTrackingId      = @"UA-48355055-1";
static NSString *const kAllowTracking   = @"allowTracking";


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
    
    //Google Analytics
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval           = 120;
    [GAI sharedInstance].trackUncaughtExceptions    = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:APP_NAME trackingId:kTrackingId];
    
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
    [self fetchedResultsControllerShiftAlert];
    [self fetchedResultsControllerSchedule];
    [self fetchedResultsControllerScheduleCategory];
    [self fetchedResultsControllerScheduleAlert];
    
    //init dictionary
    [self initDictionaryShift];
    [self initDictionarySchedule];
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TableShiftCategoryUpdate"
                                                        object:self];

    if (controller == _fetchedResultsControllerShift) {
        [self initDictionaryShift];
    } else if (controller == _fetchedResultsControllerSchedule) {
        [self initDictionarySchedule];
    }
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
        }
        
    }
    
    return _fetchedResultsControllerShift;
}

- (NSFetchedResultsController*) fetchedResultsControllerShiftAlert
{
    if (!_fetchedResultsControllerShiftAlert)
    {
        
        NSString *entityName = ENTITY_SHIFT_ALERT;
        
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
        _fetchedResultsControllerShiftAlert = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:self.managedObjectContext
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:cacheName];
        _fetchedResultsControllerShiftAlert.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerShiftAlert performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        } else {
            NSLog(@"appdelegate total schedule alert : %lu", (unsigned long)[_fetchedResultsControllerShiftAlert.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerShiftAlert;
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
    for (CDShift *item in self.fetchedResultsControllerShift.fetchedObjects) {
        
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:item.onDate];
        //if ([[Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:tempDate] isEqualToString:strDay]) {
            //return item;
        //}
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date interval:NULL forDate:date];
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&tempDate interval:NULL forDate:tempDate];
        
        NSComparisonResult result = [date compare:tempDate];
        if (result == NSOrderedSame) {
            //NSLog(@"The same:");
            return item;
        }
    }
    
    return nil;
}

- (CDShift*) getShiftWithShiftID:(int32_t)shiftID
{
    
    for (CDShift *item in self.fetchedResultsControllerShift.fetchedObjects) {
        
        if (item.id == shiftID) {
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

- (int) lastShiftAlertID {
    if ([self.fetchedResultsControllerShiftAlert.fetchedObjects count] == 0) {
        return 0;
    } else {
        CDShiftAlert *cdShiftAlert = [self.fetchedResultsControllerShiftAlert.fetchedObjects lastObject];
        return cdShiftAlert.id;
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
//        cdShift.isAllDay            = YES;
        cdShift.isAllDay            = shiftCategory.isAllDay;
        cdShift.onDate              = [date timeIntervalSince1970];
        cdShift.timeStart           = [[Common dateAppenedFromDate:date andTime:shiftCategory.timeStart] timeIntervalSince1970];
        cdShift.timeEnd             =[[Common dateAppenedFromDate:date andTime:shiftCategory.timeEnd] timeIntervalSince1970];
        cdShift.fk_shift_category   = shiftCategory;
        
    } else {
        NSLog(@"Add new Shift");
        
        CDShift *cdShift2 = (CDShift *)[NSEntityDescription insertNewObjectForEntityForName:@"CDShift"
                                                                     inManagedObjectContext:self.managedObjectContext];
        
        cdShift2.id                  = [self lastShiftID] + 1;
        cdShift2.name                = shiftCategory.name;
        cdShift2.shiftCategoryId     = shiftCategory.id;
//        cdShift2.isAllDay            = YES;
        cdShift2.isAllDay            = shiftCategory.isAllDay;
        cdShift2.onDate              = [date timeIntervalSince1970];
        cdShift2.timeStart           = [[Common dateAppenedFromDate:date andTime:shiftCategory.timeStart] timeIntervalSince1970];
        cdShift2.timeEnd             =[[Common dateAppenedFromDate:date andTime:shiftCategory.timeEnd] timeIntervalSince1970];
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

- (CDSchedule*) getScheduleByID:(int)scheduleID
{
    for (CDSchedule *item in self.fetchedResultsControllerSchedule.fetchedObjects) {
        if (item.id == scheduleID) {
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
    schedule.memo                   = [info objectForKey:@"memo"];
    
    NSDate *onDate                  = [info objectForKey:@"select_date"];
    schedule.onDate                 = [onDate timeIntervalSince1970];
    
    NSDate *timeEndDate             = [info objectForKey:@"end_time"];
    schedule.timeEnd                = [timeEndDate timeIntervalSince1970];
    
    NSDate *timeStartDate           = [info objectForKey:@"start_time"];
    schedule.timeStart              = [timeStartDate timeIntervalSince1970];
    
    schedule.fk_schedule_category   = [self getScheduleCategoryWithID:[[info objectForKey:@"schedule_category_id"] integerValue]];
    
    
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
            
            if ([date timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
                //add Push notification local
                UILocalNotification* localNotification          = [[UILocalNotification alloc] init];
                
                localNotification.fireDate                      = date;
                localNotification.alertBody                     = [NSString stringWithFormat:@"Schedule on %@",
                                                                   [Common convertTimeToStringWithFormat:@"MMM dd, yyyy" date:date]];
                localNotification.applicationIconBadgeNumber    = 0;
                localNotification.soundName                     = UILocalNotificationDefaultSoundName;
                localNotification.userInfo                      = info;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                
                NSLog(@"Add push notification local");
                
            } else {
                NSLog(@"No add push");
            }
            
            
            alertID++;
            
        }
    }
    
    [self saveContext];
    
    
    
    
    //post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];
    
}

- (void) editScheduleWithInfo:(NSDictionary*)info scheduleID:(int)scheduleID
{
    CDSchedule *schedule = [self getScheduleByID:scheduleID];
    
    if (schedule) {
        
        schedule.scheduleCategoryId     = [[info objectForKey:@"schedule_category_id"] integerValue];
        schedule.isAllDay               = [[info objectForKey:@"is_all_day"] isEqualToString:@"1"] ? YES : NO;
        schedule.memo                   = [info objectForKey:@"memo"];
        
        NSDate *onDate                  = [info objectForKey:@"select_date"];
        schedule.onDate                 = [onDate timeIntervalSince1970];
        
        NSDate *timeEndDate             = [info objectForKey:@"end_time"];
        schedule.timeEnd                = [timeEndDate timeIntervalSince1970];
        
        NSDate *timeStartDate           = [info objectForKey:@"start_time"];
        schedule.timeStart              = [timeStartDate timeIntervalSince1970];
        
        schedule.fk_schedule_category   = [self getScheduleCategoryWithID:[[info objectForKey:@"schedule_category_id"] integerValue]];
        
        //remove old alert for schedule
        for (CDScheduleAlert *alert in schedule.pk_schedule) {
            [self.managedObjectContext deleteObject:alert];
        }
        
        // add new alert
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
                
                alertID++;
                
            }
        }
        
        [self saveContext];
        
        //post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];
        
    }
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

- (NSMutableArray*) getSchedulesOnDate:(NSDate*)date
{
    //NSString *strDate = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date];
    NSMutableArray *schedules = [[NSMutableArray alloc] init];
    
    for (CDSchedule *itemCD in self.fetchedResultsControllerSchedule.fetchedObjects) {
        
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:itemCD.onDate];
        //NSString *strTemp = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:tempDate];
     
        //if ([strTemp isEqualToString:strDate]) {
            //[schedules addObject:[ScheduleItem convertForCDObjet:itemCD]];
        //}
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date interval:NULL forDate:date];
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&tempDate interval:NULL forDate:tempDate];
        
        NSComparisonResult result = [date compare:tempDate];
        if (result == NSOrderedSame) {
            //NSLog(@"The same:");
            //return item;
            [schedules addObject:[ScheduleItem convertForCDObjet:itemCD]];
        }
    }
    
    return schedules;
}

- (NSMutableArray*) getColorsSchedulesOnDate:(NSDate*)date
{

//    //NSString *strDate = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date];
//    NSMutableArray *schedules = [[NSMutableArray alloc] init];
//    
//    int count = 0;
//    for (CDSchedule *itemCD in self.fetchedResultsControllerSchedule.fetchedObjects) {
//        
//        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:itemCD.onDate];
//        //NSString *strTemp = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:tempDate];
//        
//        //if ([strTemp isEqualToString:strDate]) {
//            //[schedules addObject:itemCD.fk_schedule_category.color];
//            //count++;
//        //}
//        
//        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&date interval:NULL forDate:date];
//        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&tempDate interval:NULL forDate:tempDate];
//        
//        NSComparisonResult result = [date compare:tempDate];
//        if (result == NSOrderedSame) {
//            [schedules addObject:itemCD.fk_schedule_category.color];
//            count++;
//        }
//        
//        if (count == 3) {
//            break;
//        }
//    }

    NSString *strDate = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date];
//    NSMutableArray *schedules = [[NSMutableArray alloc] init];
//    
//    int count = 0;
//    for (CDSchedule *itemCD in self.fetchedResultsControllerSchedule.fetchedObjects) {
//        
//        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:itemCD.onDate];
//        NSString *strTemp = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:tempDate];
//        
//        if ([strTemp isEqualToString:strDate]) {
//            [schedules addObject:itemCD.fk_schedule_category.color];
//            count++;
//        }
//        
//        if (count == 3) {
//            break;
//        }
//    }
    
    return [_dictionarySchedule objectForKey:strDate];
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Others

#pragma mark - Push Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Recieved Notification %@",notification);
    //NSDictionary *info = notification.userInfo;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];

    application.applicationIconBadgeNumber = 0;
}


#pragma mark - Dictionary
- (void) initDictionaryShift
{
    NSLog(@"initDictionaryShift");
    if (_dictionaryShift) {
        [_dictionaryShift removeAllObjects];
    } else {
        _dictionaryShift = [[NSMutableDictionary alloc] init];
    }
    
    for (CDShift *shift in self.fetchedResultsControllerShift.fetchedObjects) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:shift.onDate];
        NSString *strDate = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date];
        [_dictionaryShift setObject:[ShiftCategoryItem convertForCDObject:shift.fk_shift_category] forKey:strDate];
        
    }
     NSLog(@"initDictionaryShift ---- end");
    
}

- (void) initDictionarySchedule
{
    NSLog(@"initDictionarySchedule");
    if (_dictionarySchedule) {
        [_dictionarySchedule removeAllObjects];
    } else {
        _dictionarySchedule = [[NSMutableDictionary alloc] init];
    }
    
    
    for (CDSchedule *item in self.fetchedResultsControllerSchedule.fetchedObjects) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:item.onDate];
        NSString *strDate = [Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date];
        
        if ([_dictionarySchedule objectForKey:strDate]) {
            NSMutableArray *arrayColor = [_dictionarySchedule objectForKey:strDate];
            [arrayColor addObject:item.fk_schedule_category.color];
            
            [_dictionarySchedule setObject:arrayColor forKey:strDate];
        } else {
            NSMutableArray *arrayColor = [[NSMutableArray alloc] init];
            [arrayColor addObject:item.fk_schedule_category.color];
            
            [_dictionarySchedule setObject:arrayColor forKey:strDate];
        }
        
    }
    
    
    NSLog(@"initDictionarySchedule ---- end");
}

- (ShiftCategoryItem*) getShiftCategoryWithDate:(NSDate*)date
{
    return [_dictionaryShift objectForKey:[Common convertTimeToStringWithFormat:@"dd-MM-yyyy" date:date]];
}




























@end
