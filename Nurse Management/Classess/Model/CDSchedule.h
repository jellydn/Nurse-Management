//
//  CDSchedule.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDScheduleCategory;

@interface CDSchedule : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic) NSTimeInterval onDate;
@property (nonatomic) int32_t scheduleCategoryId;
@property (nonatomic) NSTimeInterval timeEnd;
@property (nonatomic) NSTimeInterval timeStart;
@property (nonatomic, retain) CDScheduleCategory *fk_schedule_category;

@end