//
//  CDSchedule.h
//  Nurse Management
//
//  Created by PhuNQ on 2/19/14.
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
@property (nonatomic, retain) CDScheduleCategory *fk_schedule_category;
@property (nonatomic, retain) CDScheduleAlert *pk_schedule;

@end
