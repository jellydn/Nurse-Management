//
//  FXDay.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXDay.h"

@implementation FXDay

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    
}

- (void) setDate:(NSDate *)date
{
    _date           = date;
    
    _dayIndex       = (int)[FXCalendarData getDayWithDate:date];
    _monthIndex     = (int)[FXCalendarData getMonthWithDate:date];
    _yearIndex      = (int)[FXCalendarData getYearWithDate:date];
    _weekDayIndex   = (int)[FXCalendarData getWeekDayWithDate:date];
    
    _isCurrent  = (([FXCalendarData getDayWithDate:[NSDate date]] == _dayIndex) &&
                   ([FXCalendarData getMonthWithDate:[NSDate date]] == _monthIndex) &&
                   ([FXCalendarData getYearWithDate:[NSDate date]] == _yearIndex)) ? YES : NO;
}

@end
