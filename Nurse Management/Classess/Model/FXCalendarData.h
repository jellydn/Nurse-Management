//
//  FXCalendarData.h
//  DemoFXCalendar
//
//  Created by Le Phuong Tien on 10/21/13.
//  Copyright (c) 2013 Green Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXCalendarData : NSObject

//Calendar Current
+ (NSCalendar*) getCalendarCurrent;

//Year

+ (NSDate*) getFirstDayOfYearWithDate:(NSDate*)date;
+ (NSDate*) getEndDayOfYearWithDate:(NSDate*)date;
+ (NSDate*) nextYearFormDate:(NSDate*)date;

+ (NSInteger) getYearWithDate:(NSDate*)date;

//Month

+ (NSDate*) getFirstDayOfMonthWithDate:(NSDate*)date;
+ (NSDate*) getEndDayOfMonthWithDate:(NSDate*)date;

+ (NSInteger) getMonthWithDate:(NSDate*)date;
+ (NSInteger) numberMonthFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;
+ (NSInteger) numberDayOfMonthWithDate:(NSDate*)date;

+ (NSArray *) daysInMonthWihtDate: (NSDate *)date;

//Day

+ (NSInteger) getDayWithDate:(NSDate*)date;
+ (NSInteger) getWeekDayWithDate:(NSDate*)date;

//Date
+ (NSDate*) dateWithDay:(NSInteger) day month:(NSInteger) month year:(NSInteger)year;
+ (NSDate*) dateNextMonthFormDate:(NSDate*)date;
+ (NSDate*) datePrevMonthFormDate:(NSDate*)date;
+ (NSDate*) dateWithAddDay:(NSInteger) day month:(NSInteger) month year:(NSInteger)year fromDate:(NSDate*)date;
+ (NSDate*) nextDateFrom:(NSDate*)date;
+ (NSDate*) prevDateFrom:(NSDate*)date;
+ (NSDate*) saturdayOfWeek:(NSDate*)date;
+ (NSDate*) dateNexHourFormDate:(NSDate*)date;
+ (NSDate*) dateNexHourFormDateNoTrimMin:(NSDate*)date;
+ (NSDate*) dateWithSetHourWithHour:(NSInteger)hour date:(NSDate*)date;
+ (NSDate*) trimSecOfDateWithDate:(NSDate*)date;
+ (NSDate*) trimDate:(NSDate*)date;

// Hour
+ (NSInteger) getHourWithDate:(NSDate*)date;

@end
