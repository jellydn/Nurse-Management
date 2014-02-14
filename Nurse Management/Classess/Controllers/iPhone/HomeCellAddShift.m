//
//  HomeCellAddShift.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "HomeCellAddShift.h"
#import "FXCalendarData.h"

@interface HomeCellAddShift ()

@end

@implementation HomeCellAddShift

- (void) loadInfoWithNSDate:(NSDate*)date isAddShift:(BOOL)isAddShift
{
    _lbDay.text = [NSString stringWithFormat:@"%d", [FXCalendarData getDayWithDate:date]];
    _lbMonth.text = [NSString stringWithFormat:@"%d", [FXCalendarData getMonthWithDate:date]];
    
    NSArray *arrayWeekDays = @[@"-",
                               @"sun",
                               @"mon",
                               @"tue",
                               @"wed",
                               @"thu",
                               @"fri",
                               @"sat",];
    _lbWeekDay.text = arrayWeekDays[[FXCalendarData getWeekDayWithDate:date]];
    
    //
    _viewAdd.hidden     = !isAddShift;
    _viewInfo.hidden    = isAddShift;
}

@end
