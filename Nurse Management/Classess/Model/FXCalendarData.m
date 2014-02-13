//
//  FXCalendarData.m
//  DemoFXCalendar
//
//  Created by Le Phuong Tien on 10/21/13.
//  Copyright (c) 2013 Green Global. All rights reserved.
//

#import "FXCalendarData.h"

@implementation FXCalendarData

#pragma mark - CALENDAR

+ (NSCalendar*) getCalendarCurrent
{
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
}

#pragma mark - YEAR

+ (NSInteger) getYearWithDate:(NSDate*)date
{
    NSDateComponents *components = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [components year];
}

+ (NSDate*) getFirstDayOfYearWithDate:(NSDate*)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:[self getYearWithDate:date]];
    
    return [[self getCalendarCurrent] dateFromComponents:comps];
}

+ (NSDate*) getEndDayOfYearWithDate:(NSDate*)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:31];
    [comps setMonth:12];
    [comps setYear:[self getYearWithDate:date]];
    
    return [[self getCalendarCurrent] dateFromComponents:comps];
}

+ (NSDate*) nextYearFormDate:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setYear:[comp year]+1];
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

#pragma mark - MONTH

+ (NSDate*) getFirstDayOfMonthWithDate:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:1];
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSDate*) getEndDayOfMonthWithDate:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:[self numberDayOfMonthWithDate:date]];
    
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSInteger) getMonthWithDate:(NSDate*)date
{
    NSDateComponents *components = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [components month];
}

+ (NSInteger) numberMonthFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    if ([fromDate timeIntervalSinceNow] > [toDate timeIntervalSinceNow]) {
        return 0;
    }
    
    int monthFrom   = [self getMonthWithDate:fromDate];
    int yearFrom    = [self getYearWithDate:fromDate];
    
    int monthTo     = [self getMonthWithDate:toDate];
    int yearTo      = [self getYearWithDate:toDate];
    
    if (yearFrom == yearTo) {
        return (monthTo - monthFrom) + 1;
    } else if (yearFrom + 1 == yearTo) {
        return (12 - monthFrom) + 1 + (monthTo - 1) + 1;
    } else {
        return (12 - monthFrom) + 1 + (monthTo - 1) + 1 + (yearTo - yearFrom -1 )*12;
    }
    
    return 0;
}

+ (NSInteger) numberDayOfMonthWithDate:(NSDate*)date
{
    NSRange days = [[self getCalendarCurrent] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return days.length;
}

#pragma mark - DAY

+ (NSInteger) getDayWithDate:(NSDate*)date
{
    NSDateComponents *components = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [components day];
}

+ (NSInteger) getWeekDayWithDate:(NSDate*)date
{
    NSDateComponents *components = [[self getCalendarCurrent] components:NSWeekdayCalendarUnit fromDate:date];
    return [components weekday];
}

#pragma mark - DATE

+ (NSDate*) dateWithDay:(NSInteger) day month:(NSInteger) month year:(NSInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    
    return [[self getCalendarCurrent] dateFromComponents:comps];
}

+ (NSDate*) dateNextMonthFormDate:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setMonth:[comp month] + 1];
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSDate*) datePrevMonthFormDate:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setMonth:[comp month] - 1];
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSDate*) dateWithAddDay:(NSInteger) day month:(NSInteger) month year:(NSInteger)year fromDate:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:[comp day] + day];
    [comp setMonth:[comp month] + month];
    [comp setYear:[comp year] + year];
    
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSDate*) nextDateFrom:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:[comp day]+1];
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSDate*) prevDateFrom:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:[comp day]-1];
    return  [[self getCalendarCurrent] dateFromComponents:comp];
}

+ (NSDate*) saturdayOfWeek:(NSDate*)date
{
    NSDateComponents *comp = [[self getCalendarCurrent] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    NSLog(@"week day: %d",[comp weekday]);
    
    for (int i = [comp weekday]; i < 7; i++) {
        date = [self nextDateFrom:date];
    }
    
    return  date;
}

@end
