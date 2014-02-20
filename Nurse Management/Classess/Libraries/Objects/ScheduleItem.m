//
//  ScheduleItem.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/20/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ScheduleItem.h"
#import "AppDelegate.h"

@implementation ScheduleItem

+ (ScheduleItem*) convertForCDObjet:(CDSchedule*)cdSchedule
{
    ScheduleItem *item      = [[ScheduleItem alloc] init];
    
    item.scheduleID         = cdSchedule.id;
    item.memo               = cdSchedule.memo;
    item.onDate             = [NSDate dateWithTimeIntervalSince1970:cdSchedule.onDate];
    item.scheduleCategoryId = cdSchedule.scheduleCategoryId;
    item.timeEnd            = [NSDate dateWithTimeIntervalSince1970:cdSchedule.timeEnd];
    item.timeStart          = [NSDate dateWithTimeIntervalSince1970:cdSchedule.timeStart];
    item.isAllDay           = cdSchedule.isAllDay;
    
    item.category           = [ScheduleCategoryItem convertForCDObject:cdSchedule.fk_schedule_category];
    
    return item;
}

- (NSString*) getStringTimeStart:(BOOL)isStart
{
    if (_isAllDay) {
        
        if (isStart) {
            return @"00:00";
        } else {
            return @"24:00";
        }
        
    } else {
        if (isStart) {
            return [Common convertTimeToStringWithFormat:@"HH:mm" date:_timeStart];
        } else {
            return [Common convertTimeToStringWithFormat:@"HH:mm" date:_timeEnd];
        }
    }
    
    return @"00:00";
}

@end
