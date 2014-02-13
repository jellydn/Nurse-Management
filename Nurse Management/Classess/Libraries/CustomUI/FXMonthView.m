//
//  FXMonthView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXMonthView.h"

@interface FXMonthView()
{
    
}

@end

@implementation FXMonthView

- (void)dealloc
{
    self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _widthCell          = frame.size.width / 7;
        _heightCell         = 50;
        
        frame.size.height   = _heightCell*6 + 1;
        self.frame          = frame;
        [self initLayout];
    }
    return self;
}

- (id)initWithWidth:(float)width
{
    
    _widthCell      = width / 7;
    _heightCell     = 50;
    
    CGRect rect = CGRectMake(0, 0, width, _heightCell * 6 + 1);
    
    self = [super initWithFrame:rect];
    if (self) {
        [self initLayout];
    }
    return self;
}

#pragma mark - Geter

- (UIColor*) borderColor
{
    if (!_borderColor) {
        _borderColor = [UIColor colorWithRed:165.0/255.0 green:157.0/255.0 blue:139.0/255.0 alpha:1.0];
    }
    
    return _borderColor;
}

- (UIColor*) selectColor
{
    if (!_selectColor) {
        _selectColor = [UIColor colorWithRed:109.0/255.0 green:141.0/255.0 blue:197.0/255.0 alpha:1.0];
    }
    
    return _selectColor;
}

- (UIColor*) saturdayColor
{
    if (!_saturdayColor) {
        _saturdayColor = [UIColor colorWithRed:20.0/255.0 green:123.0/255.0 blue:235.0/255.0 alpha:1.0];
    }
    
    return _saturdayColor;
}

- (UIColor*) sundayColor
{
    if (!_sundayColor) {
        _sundayColor = [UIColor colorWithRed:209.0/255.0 green:81.0/255.0 blue:67.0/255.0 alpha:1.0];
    }
    
    return _sundayColor;
}

- (UIColor*) outOfMonthDayColor
{
    if (!_outOfMonthDayColor) {
        _outOfMonthDayColor = [UIColor colorWithRed:193.0/255.0 green:185.0/255.0 blue:184.0/255.0 alpha:1.0];
    }
    
    return _outOfMonthDayColor;
}

- (UIColor*) bgColor
{
    if (!_bgColor) {
        _bgColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    return _bgColor;
}

- (UIColor*) backgoundSaturdayColor
{
    if (!_backgoundSaturdayColor) {
        _backgoundSaturdayColor = [UIColor colorWithRed:231.0/255.0 green:240.0/255.0 blue:253.0/255.0 alpha:1.0];
    }
    return _backgoundSaturdayColor;
}

- (UIColor*) backgoundSundayColor
{
    if (!_backgoundSundayColor) {
        _backgoundSundayColor = [UIColor colorWithRed:252.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    }
    return _backgoundSundayColor;
}

- (UIFont*) font
{
    if (!_font) {
        _font = [UIFont systemFontOfSize:14.0];
    }
    
    return _font;
}

- (NSDate*) date
{
    if (!_date) {
        _date           = [NSDate date];
        _isMouthCurrent = YES;
    }
    
    return _date;
}

#pragma mark - Others

- (void) initLayout
{
    self.clipsToBounds = YES;
    
    // set BG color
    [self setBackgroundColor:self.bgColor];
    
    UIView *viewSaturday            = [[UIView alloc] initWithFrame:CGRectMake(_widthCell*6, 0, _widthCell, _heightCell*6)];
    viewSaturday.backgroundColor    = self.backgoundSaturdayColor;
    [self addSubview:viewSaturday];
    
    UIView *viewSunday              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthCell, _heightCell*6)];
    viewSunday.backgroundColor      = self.backgoundSundayColor;
    [self addSubview:viewSunday];
    
    //add lines
    _viewLines                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthCell * 7, _heightCell*6 + 1)];
    _viewLines.backgroundColor  = [UIColor clearColor];
    
    
    //loop
    CGRect rectLine = CGRectMake(0, 0, 1, _heightCell*6);
    for (int i = 0; i<8; i++) {
        
        rectLine.origin.x           = i * _widthCell;
        
        UIView *viewLine            = [[UIView alloc] initWithFrame:rectLine];
        viewLine.tag                = 0;
        viewLine.backgroundColor    = self.borderColor;
        
        [_viewLines addSubview:viewLine];
    }
    
    //loop
    rectLine = CGRectMake(0, 0, _widthCell*7, 1);
    for (int i = 0; i<8; i++) {
        
        rectLine.origin.y           = i * _heightCell;
        
        UIView *viewLine            = [[UIView alloc] initWithFrame:rectLine];
        viewLine.tag                = i;
        viewLine.backgroundColor    = self.borderColor;
        
        [_viewLines addSubview:viewLine];
    }
    
    [self addSubview:_viewLines];
    
    //view container days
    _viewContainerDays                  = [[UIView alloc] initWithFrame:_viewLines.frame];
    _viewContainerDays.backgroundColor  = [UIColor clearColor];
    
    //add day view
    CGRect rect = CGRectMake(1, 1, _widthCell  - 1, _heightCell - 1);
    
    for (int i = 0; i < 42; i++) {
        
        FXDayView *dayView = [[FXDayView alloc] initWithFrame:rect];
        dayView.tag        = i;
        [_viewContainerDays addSubview:dayView];
        
        rect.origin.x += _widthCell;
        
        if (rect.origin.x > _widthCell * 7 ) {
            rect.origin.x = 1;
            rect.origin.y += _heightCell;
        }
    }
    
    [self addSubview:_viewContainerDays];
}

#pragma mark - Data

- (void) loadDataForDate:(NSDate*)date
{
    self.date = date;
    
    _firstDay = [FXCalendarData getFirstDayOfMonthWithDate:date];
    _firstdayIndex = [FXCalendarData getWeekDayWithDate:_firstDay];
    
    _endDay   = [FXCalendarData getEndDayOfMonthWithDate:date];
    _enddayIndex = [FXCalendarData getWeekDayWithDate:_endDay];
    
    _totalDay = [FXCalendarData numberDayOfMonthWithDate:date];
    
    
    NSLog(@"index First: %d -- end: %d", _firstdayIndex, _enddayIndex);
    
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    } else {
        [_days removeAllObjects];
    }
    
    
    
    //get out of day with first week
    for (int i = _firstdayIndex - 1; i > 0; i--) {
        
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
    
        [_days addObject:day];
    }
    
    // add day in out of days
    NSDate *tempDate = _firstDay;
    for (int i = [_days count] - 1; i >= 0; i--) {
        
        tempDate = [FXCalendarData prevDateFrom:tempDate];
        FXDay *day = _days[i];
        day.date   = tempDate;
        
    }
    
    //add day in month
    tempDate = _firstDay;
    for (int i = 1; i <= _totalDay; i++) {
        
        FXDay *day      = [[FXDay alloc] init];
        day.isOutOfDay  = NO;
        day.date        = tempDate;
        
        [_days addObject:day];
        
        tempDate = [FXCalendarData nextDateFrom:tempDate];
        
    }
    
    float allDay        = 35;
    _is6Week            = NO;
    _numberWeekOfMonth  = 5;
    
    if ([_days count] > 35) {
        
        allDay              = 42;
        _is6Week            = YES;
        _numberWeekOfMonth  = 6;
    }
    
    for (int i = [_days count]; i < allDay ; i++) {
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        day.date = tempDate;
        
        [_days addObject:day];
        
        NSLog(@"%d",day.dayIndex);
        
        tempDate = [FXCalendarData nextDateFrom:tempDate];
    }
    
    NSLog(@"total day: %d", [_days count]);
    [self reloadInfoDay];
}

- (void) reloadInfoDay
{
    for (FXDayView *dayView in _viewContainerDays.subviews) {
        if (dayView.tag < [_days count]) {
            [dayView reloadInfo:_days[dayView.tag]];
        }
    }
}
   
#pragma mark - Animation 
- (void) reloadHeighForWeekWithAnimate:(BOOL)isAnimate
{
    CGRect rect = self.frame;
    
    rect.size.height = _heightCell * _numberWeekOfMonth + 1;
    
    if (isAnimate) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        self.frame = rect;
    }
}
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

@end
