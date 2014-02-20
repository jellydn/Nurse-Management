//
//  CDSchedule.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/20/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDScheduleAlert, CDScheduleCategory;

@interface CDSchedule : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic) NSTimeInterval onDate;
@property (nonatomic) int32_t scheduleCategoryId;
@property (nonatomic) NSTimeInterval timeEnd;
@property (nonatomic) NSTimeInterval timeStart;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, retain) CDScheduleCategory *fk_schedule_category;
@property (nonatomic, retain) NSSet *pk_schedule;
@end

@interface CDSchedule (CoreDataGeneratedAccessors)

- (void)addPk_scheduleObject:(CDScheduleAlert *)value;
- (void)removePk_scheduleObject:(CDScheduleAlert *)value;
- (void)addPk_schedule:(NSSet *)values;
- (void)removePk_schedule:(NSSet *)values;

@end
