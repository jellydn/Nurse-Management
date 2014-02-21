//
//  FXDay.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXDay.h"
#import "Common.h"
#import "Define.h"
#import "AppDelegate.h"

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

#pragma mark - Setter
- (void) setColor1:(NSString *)color1
{
    if ([color1 isEqualToString:@""]) {
        _color1 = @"";
    } else {
        _color1 = [NSString stringWithFormat:@"schedule_bg_%@.png",color1];
    }
}

- (void) setColor2:(NSString *)color2
{
    if ([color2 isEqualToString:@""]) {
        _color2 = @"";
    } else {
        _color2 = [NSString stringWithFormat:@"schedule_bg_%@.png",color2];
    }
}

- (void) setColor3:(NSString *)color3
{
    if ([color3 isEqualToString:@""]) {
        _color3 = @"";
    } else {
        _color3 = [NSString stringWithFormat:@"schedule_bg_%@.png",color3];
    }
}

















@end
