//
//  ScheduleItem.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/20/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleCategoryItem.h"
#import "CDSchedule.h"
#import "CDScheduleCategory.h"
#import "Common.h"

@interface ScheduleItem : NSObject

@property (nonatomic)           int                 scheduleID;
@property (nonatomic, strong)   NSString            *memo;
@property (nonatomic, strong)   NSDate              *onDate;
@property (nonatomic)           int                 scheduleCategoryId;
@property (nonatomic, strong)   NSDate              *timeEnd;
@property (nonatomic, strong)   NSDate              *timeStart;
@property (nonatomic)           BOOL                isAllDay;

@property (nonatomic, strong) ScheduleCategoryItem  *category;

- (NSString*) getStringTimeStart:(BOOL)isStart;

+ (ScheduleItem*) convertForCDObjet:(CDSchedule*)cdSchedule;

@end
