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

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShift;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShiftCategory;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerSchedule;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerScheduleCategory;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//common method
- (CDShiftCategory*) getshiftCategoryWithID:(int)categoryID;
- (CDShift*) getShiftWithDate:(NSDate*)date;
- (void) addQuickShiftWithShiftCategoryID:(int)categoryID date:(NSDate*)date;
- (int) lastShiftID;

- (CDScheduleCategory*) getScheduleCategoryWithID:(int)categoryID;
- (void) addQuickScheduleWithInfo:(NSDictionary*)info;


- (int) lastSchedule;

// share
+ (AppDelegate *)shared;

// ------ Controller ----- //
@property (nonatomic, strong) FXNavigationController *navigationController;

//
- (void) getInfoDayWithDate:(NSDate*)date;

@end
