//
//  AppDelegate.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXNavigationController.h"
#import "CDShiftCategory.h"
#import "CDShift.h"
#import "CDSchedule.h"
#import "CDScheduleCategory.h"
#import "CDScheduleAlert.h"
#import "ScheduleItem.h"

#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) id<GAITracker> tracker;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShift;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShiftCategory;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShiftAlert;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerSchedule;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerScheduleCategory;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerScheduleAlert;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//common method
- (CDShiftCategory*) getshiftCategoryWithID:(int)categoryID;
- (CDShift*) getShiftWithDate:(NSDate*)date;
- (CDShift*) getShiftWithShiftID:(int32_t)shiftID;
- (void) addQuickShiftWithShiftCategoryID:(int)categoryID date:(NSDate*)date;
- (int) lastShiftID;

- (CDScheduleCategory*) getScheduleCategoryWithID:(int)categoryID;
- (CDSchedule*) getScheduleByID:(int)scheduleID;
- (void) addQuickScheduleWithInfo:(NSDictionary*)info;
- (void) editScheduleWithInfo:(NSDictionary*)info scheduleID:(int)scheduleID;
- (int) lastScheduleID;
- (int) lastScheduleAlertID;
- (int) lastShiftAlertID;
- (NSMutableArray*) getSchedulesOnDate:(NSDate*)date;
- (NSMutableArray*) getColorsSchedulesOnDate:(NSDate*)date;

// share
+ (AppDelegate *)shared;

// ------ Controller ----- //
@property (nonatomic, strong) FXNavigationController *navigationController;


@end
