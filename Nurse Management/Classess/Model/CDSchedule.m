//
//  CDSchedule.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/20/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "CDSchedule.h"
#import "CDScheduleAlert.h"
#import "CDScheduleCategory.h"


@implementation CDSchedule

@dynamic id;
@dynamic memo;
@dynamic onDate;
@dynamic scheduleCategoryId;
@dynamic timeEnd;
@dynamic timeStart;
@dynamic isAllDay;
@dynamic fk_schedule_category;
@dynamic pk_schedule;

@end
