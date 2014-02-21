//
//  HomeCellAddShift.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "HomeCellAddShift.h"
#import "FXCalendarData.h"
#import "Common.h"
#import "ShiftCategoryItem.h"

@interface HomeCellAddShift ()

@end

@implementation HomeCellAddShift

- (void) loadInfoWithNSDate:(NSDate*)date isAddShift:(BOOL)isAddShift
{
    _lbDay.text = [NSString stringWithFormat:@"%d",(int) [FXCalendarData getDayWithDate:date]];
    _lbMonth.text = [NSString stringWithFormat:@"%d", (int) [FXCalendarData getMonthWithDate:date]];
    
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

- (void) loadInfoWithNSDate:(NSDate*)date shift:(CDShift*)shift
{
    _lbDay.text = [NSString stringWithFormat:@"%d",(int) [FXCalendarData getDayWithDate:date]];
    _lbMonth.text = [NSString stringWithFormat:@"%d", (int) [FXCalendarData getMonthWithDate:date]];
    
    NSArray *arrayWeekDays = @[@"-",
                               @"sun",
                               @"mon",
                               @"tue",
                               @"wed",
                               @"thu",
                               @"fri",
                               @"sat",];
    _lbWeekDay.text = arrayWeekDays[[FXCalendarData getWeekDayWithDate:date]];
    
    if (shift) {
        
        _viewAdd.hidden     = YES;
        _viewInfo.hidden    = NO;
        
        _btEdit.tag = shift.id;
        
//        ShiftCategoryItem *shiftCategory = [ShiftCategoryItem convertForCDObject:shift.fk_shift_category];
//        if (shiftCategory.isAllDay) {
//            _lbTime.text = [NSString stringWithFormat:@"00:00～24:00"];
//        } else {
//            _lbTime.text = [NSString stringWithFormat:@"%@～%@",shiftCategory.strTimeStart, shiftCategory.strTimeEnd];
//        }
        
//        if (shift.isAllDay) {
//            _lbTime.text = [NSString stringWithFormat:@"00:00～24:00"];
//        } else {
//            _lbTime.text = [NSString stringWithFormat:@"%f～%f",shift.timeStart, shift.timeEnd];
//        }
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:shift.timeStart];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:shift.timeEnd];
        
//        NSInteger startDay = [FXCalendarData getDayWithDate:startDate];
        NSInteger endHour = [FXCalendarData getHourWithDate:endDate];
        
        NSString *strStartTime = [Common convertTimeToStringWithFormat:@"HH:mm" date:startDate];
        NSString *strEndTime = (endHour == 0) ? @"24:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:endDate] ;
        
//        if (startDay != endDay)
//            strStartTime = @"00:00";
        
//        NSString *strStartTime   = [Common convertTimeToStringWithFormat:@"HH:mm" date:startDate];
        
        _lbTime.text = [NSString stringWithFormat:@"%@～%@", strStartTime, strEndTime];
        
        ShiftCategoryItem *shiftCategory = [ShiftCategoryItem convertForCDObject:shift.fk_shift_category];
        _imgCategory.image          = [UIImage imageNamed:shiftCategory.image];
        _lbCategoryName.text        = shiftCategory.name;
        _lbCategoryName.textColor   = shiftCategory.textColor;
        
        //load member
        if ([shift.pk_shift count] == 0) {
            _lbMember.text = @"0 members";
        } else {
            _lbMember.text = @"";
            for (CDMember *item in shift.pk_shift) {
                _lbMember.text = [_lbMember.text stringByAppendingFormat:@"%@,",item.name];
            }
        }
        
        //load alert
        _lbAlert.text = [NSString stringWithFormat:@"%d alerts",(int)[shift.pk_shiftalert count]];
        
    } else {
        
        _viewAdd.hidden     = NO;
        _viewInfo.hidden    = YES;
        
    }
}

@end
