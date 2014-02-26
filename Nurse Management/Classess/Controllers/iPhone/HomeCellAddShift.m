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
#import "Define.h"

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
    
    _lbMember.hidden = [[NSUserDefaults standardUserDefaults] boolForKey:HIDE_MEMBER];
    
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
    
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:shift.timeStart];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:shift.timeEnd];
        NSInteger endHour = [FXCalendarData getHourWithDate:endDate];
        NSString *strStartTime = [Common convertTimeToStringWithFormat:@"HH:mm" date:startDate];
        NSString *strEndTime = (endHour == 0) ? @"24:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:endDate] ;
        
        if (shift.isAllDay)
            _lbTime.text = TEXT_ALL_DAY;
        else
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
            int count = 0;
            for (CDMember *item in shift.pk_shift) {
                
                if (count == [shift.pk_shift count] - 1) {
                    _lbMember.text = [_lbMember.text stringByAppendingFormat:@"%@",item.name];
                } else {
                    _lbMember.text = [_lbMember.text stringByAppendingFormat:@"%@, ",item.name];
                }
        
                count++;
            }
        }
        
        //load alert
//        _lbAlert.text = [NSString stringWithFormat:@"%d alerts",(int)[shift.pk_shiftalert count]];
        if ([shift.pk_shiftalert count] == 0)
            _lbAlert.text = @"0 alerts";
        else {
            int count = 0;
            _lbAlert.text = @"";
            for (CDShiftAlert *alarm in [shift.pk_shiftalert allObjects]) {
                // get the interval of the alarm time
                double duration = shift.timeStart - alarm.onTime;
                NSString *strAlert = [Common durationFromUnixTime:duration];
                if ([strAlert isEqualToString:@""]) {
                    strAlert = [Common stringFromDate:[NSDate dateWithTimeIntervalSince1970:alarm.onTime] withFormat:@"HH:mm"];
                }
                if (count == [shift.pk_shiftalert count] - 1) {
                    _lbAlert.text = [_lbAlert.text stringByAppendingString:strAlert];
                } else {
                    _lbAlert.text = [_lbAlert.text stringByAppendingString:[NSString stringWithFormat:@"%@, ", strAlert]];
                }
                count++;
            }
        }
        
    } else {
        
        _viewAdd.hidden     = NO;
        _viewInfo.hidden    = YES;
        
    }
}

@end
