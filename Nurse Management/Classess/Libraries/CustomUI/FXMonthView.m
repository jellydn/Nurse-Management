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
        _indexSelect        = -1;
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

- (UIColor*) backgoundSelectDay
{
    if (!_backgoundSelectDay) {
        _backgoundSelectDay = [UIColor colorWithRed:254.0/255.0 green:236.0/255.0 blue:170.0/255.0 alpha:1.0];
    }
    
    return _backgoundSelectDay;
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
    
    if (_isFirstOfSunday) {
        UIView *viewSaturday            = [[UIView alloc] initWithFrame:CGRectMake(_widthCell*6, 0, _widthCell, _heightCell*6)];
        viewSaturday.autoresizingMask   = UIViewAutoresizingFlexibleHeight;
        viewSaturday.backgroundColor    = self.backgoundSaturdayColor;
        viewSaturday.tag                = 999;
        [self addSubview:viewSaturday];
        
        UIView *viewSunday              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthCell, _heightCell*6)];
        viewSunday.autoresizingMask     = UIViewAutoresizingFlexibleHeight;
        viewSunday.backgroundColor      = self.backgoundSundayColor;
        viewSunday.tag                  = 998;
        [self addSubview:viewSunday];
    } else {
        UIView *viewSaturday            = [[UIView alloc] initWithFrame:CGRectMake(_widthCell*5, 0, _widthCell, _heightCell*6)];
        viewSaturday.autoresizingMask   = UIViewAutoresizingFlexibleHeight;
        viewSaturday.backgroundColor    = self.backgoundSaturdayColor;
        viewSaturday.tag                = 999;
        [self addSubview:viewSaturday];
        
        UIView *viewSunday              = [[UIView alloc] initWithFrame:CGRectMake(_widthCell*6, 0, _widthCell, _heightCell*6)];
        viewSunday.autoresizingMask     = UIViewAutoresizingFlexibleHeight;
        viewSunday.backgroundColor      = self.backgoundSundayColor;
        viewSunday.tag                  = 998;
        [self addSubview:viewSunday];
    }
    
    //add lines
    _viewLines                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthCell * 7, _heightCell*6 + 1)];
    _viewLines.backgroundColor  = [UIColor clearColor];
    
    
    //loop
    CGRect rectLine = CGRectMake(0, 0, 1, _heightCell*6);
    for (int i = 0; i<8; i++) {
        
        rectLine.origin.x           = i * _widthCell;
        
        UIView *viewLine            = [[UIView alloc] initWithFrame:rectLine];
        viewLine.autoresizingMask   = UIViewAutoresizingFlexibleHeight;
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
    
    //view container select
    _viewContainerSelect                    = [[UIView alloc] initWithFrame:_viewLines.frame];
    _viewContainerSelect.backgroundColor    = [UIColor clearColor];
    
    _viewSelect                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthCell, _heightCell)];
    _viewSelect.backgroundColor     = [[FXThemeManager shared] getColorWithKey:_fxThemeColorMain];
    _viewSelect.hidden              = YES;
    
    UIView *viewBGSelect            = [[UIView alloc] initWithFrame:CGRectMake(2, 2, _viewSelect.frame.size.width - 2, _viewSelect.frame.size.height - 2)];
    viewBGSelect.backgroundColor    = self.backgoundSelectDay;
    viewBGSelect.clipsToBounds      = YES;
    
    [_viewSelect addSubview:viewBGSelect];
    [_viewContainerSelect addSubview:_viewSelect];
    [self addSubview:_viewContainerSelect];
    
    //view container days
    _viewContainerDays                  = [[UIView alloc] initWithFrame:_viewLines.frame];
    _viewContainerDays.backgroundColor  = [UIColor clearColor];
    
    //add day view
    CGRect rect = CGRectMake(1, 1, _widthCell  - 1.5, _heightCell - 1.5);
    
    for (int i = 0; i < 42; i++) {
        
        
        FXDayView *dayView              = [[NSBundle mainBundle] loadNibNamed:@"FXDayView" owner:self options:nil][0];
        [dayView initLayout];
        dayView.clipsToBounds           = YES;
        dayView.frame                   = rect;
        dayView.tag                     = i;
        dayView.btButtonMaks.tag        = i;
        
        
        [_viewContainerDays addSubview:dayView];
        
        rect.origin.x += _widthCell;
        
        if (rect.origin.x > _widthCell * 7 ) {
            rect.origin.x = 1;
            rect.origin.y += _heightCell;
        }
    }
    
    [self addSubview:_viewContainerDays];
}

- (void) reloadLayout:(float)oldHeight newHeight:(float)newHeight
{
    [UIView animateWithDuration:0.3 animations:^{
       
        //view lines
        _viewLines.frame = CGRectMake(0, 0, _widthCell * 7, _heightCell*6 + 1);
        
        for (UIView *view in _viewLines.subviews) {
            if (view.tag > 0) {
                CGRect rect = view.frame;
                rect.origin.y += (newHeight - oldHeight) * view.tag;
                
                view.frame = rect;
            }
        }
        
        //view select
        _viewContainerSelect.frame = _viewLines.frame;
        
        [_viewSelect removeFromSuperview];
        
        _viewSelect                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _widthCell, _heightCell)];
        _viewSelect.backgroundColor     = [[FXThemeManager shared] getColorWithKey:_fxThemeColorMain];
        _viewSelect.hidden              = YES;
        
        UIView *viewBGSelect            = [[UIView alloc] initWithFrame:CGRectMake(2, 2, _viewSelect.frame.size.width - 2, _viewSelect.frame.size.height - 2)];
        viewBGSelect.backgroundColor    = self.backgoundSelectDay;
        viewBGSelect.clipsToBounds      = YES;
        
        [_viewSelect addSubview:viewBGSelect];
        [_viewContainerSelect addSubview:_viewSelect];
        
        //view container days
        _viewContainerDays.frame = _viewLines.frame;
        
        //add day view
        for (FXDayView *dayView in _viewContainerDays.subviews) {
            dayView.frame = CGRectMake(_widthCell * (dayView.tag%7) + 1,
                                       _heightCell * (dayView.tag/7) + 1,
                                       _widthCell  - 1.5,
                                       _heightCell - 1.5);
        }
        
    }];
}

#pragma mark - Action

- (IBAction)selectDay:(id)sender
{
    
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == _indexSelect && !_isViewFull) {
        return;
    }
    
    FXDay *day = _days[button.tag];
    
    if (!day.isOutOfDay) {
        
        if (_indexSelect != -1) {
            FXDay *oldday = _days[_indexSelect];
            oldday.isSelect = NO;
        }
        
        day.isSelect = YES;
        if (_isViewFull) {
            if (_delegate && [_delegate respondsToSelector:@selector(fxMonthViewExitViewFull:)]) {
                [_delegate fxMonthViewExitViewFull:self];
            }
        }
        
        [self reloadSelectViewWith:_indexSelect newSelect:(int)button.tag];
        
        _indexSelect = (int)button.tag;
        
        if (_daySelect) {
            _daySelect = nil;
        }
        
        _daySelect          = day;
        
        _viewSelect.hidden  = NO;
        _viewSelect.frame   = CGRectMake(_widthCell * (button.tag%7) - 1, _heightCell * (button.tag/7) - 1, _widthCell + 2, _heightCell + 2);
        
        
    } else {
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(fxMonthView:didSelectDayWith:)]) {
        [_delegate fxMonthView:self didSelectDayWith:day];
    }
}

- (void) reloadSelectViewWith:(int)oldSelect newSelect:(int)newSelect
{
    for (FXDayView *dayView in _viewContainerDays.subviews) {
        if (dayView.tag == oldSelect) {
            [dayView reloadInfo:_days[oldSelect]];
            continue;
        }
        
        if (dayView.tag == newSelect) {
            [dayView reloadInfo:_days[newSelect]];
            [_viewContainerDays bringSubviewToFront:dayView];
            continue;
        }
    }
}


#pragma mark - Data

- (void) loadDataForDate:(NSDate*)date isSetFirstDay:(BOOL)isSet
{
    self.date = date;
    
    _firstDay = [FXCalendarData getFirstDayOfMonthWithDate:date];
    _firstdayIndex = (int)[FXCalendarData getWeekDayWithDate:_firstDay];
    
    _endDay   = [FXCalendarData getEndDayOfMonthWithDate:date];
    _enddayIndex = (int)[FXCalendarData getWeekDayWithDate:_endDay];
    
    _totalDay = (int)[FXCalendarData numberDayOfMonthWithDate:date];
    
    if (isSet) {
        _daySelect = nil;
        _daySelect = [[FXDay alloc] init];
        _daySelect.date = _firstDay;
        
        if (_delegate && [_delegate respondsToSelector:@selector(fxMonthView:didSelectDayWith:)]) {
            [_delegate fxMonthView:self didSelectDayWith:_daySelect];
        }
    }
    
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    } else {
        [_days removeAllObjects];
    }
    
    if (!_isFirstOfSunday) {
        if (_firstdayIndex == 1 ) {
            _firstdayIndex = 7;
        } else {
            _firstdayIndex--;
        }
        
        if (_enddayIndex == 1) {
            _enddayIndex = 7;
        } else {
            _enddayIndex--;
        }
    }
    
    //get out of day with first week
    for (int i = _firstdayIndex - 1; i > 0; i--) {
        
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        
        [_days addObject:day];
    }
    
    // add day in out of days
    NSDate *tempDate = _firstDay;
    for (int i = (int)[_days count] - 1; i >= 0; i--) {
        
        tempDate = [FXCalendarData prevDateFrom:tempDate];
        FXDay *day = _days[i];
        day.date   = tempDate;
        
    }
    
    //add day in month
    tempDate = _firstDay;
    for (int i = 1; i <= _totalDay; i++) {
        
        FXDay *day          = [[FXDay alloc] init];
        day.isOutOfDay      = NO;
        day.isFirstOfSunday = _isFirstOfSunday;
        day.date            = tempDate;
        day.color1          = @"";
        day.color2          = @"";
        day.color3          = @"";
        
        if (_isLoadDataForCell) {
            
            day.shiftCategory = [[AppDelegate shared] getShiftCategoryWithDate:tempDate];
            
//            CDShift *shift  = [[AppDelegate shared] getShiftWithDate:tempDate];
//            if (shift) {
//                day.shiftCategory = [ShiftCategoryItem convertForCDObject:shift.fk_shift_category];
//            } else {
//                day.shiftCategory = nil;
//            }
            
            NSArray *arrayColor = [[AppDelegate shared] getColorsSchedulesOnDate:tempDate];
            if ([arrayColor count] >= 1) {
                day.color1      = arrayColor[0];
            }
            
            if ([arrayColor count] >= 2) {
                day.color2      = arrayColor[1];
            }
            
            if ([arrayColor count] >= 3) {
                day.color3      = arrayColor[2];
            }
            
        } else {
            day.shiftCategory = nil;
        }
        
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
    
    for (int i = (int)[_days count]; i < allDay ; i++) {
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        day.date = tempDate;
        
        [_days addObject:day];
        
        tempDate = [FXCalendarData nextDateFrom:tempDate];
    }
    
    [self reloadInfoDay];
}

- (void) loadDataForDate:(NSDate *)date setSelectDay:(NSDate*)selectDate
{
    self.date = date;
    
    _firstDay = [FXCalendarData getFirstDayOfMonthWithDate:date];
    _firstdayIndex = (int)[FXCalendarData getWeekDayWithDate:_firstDay];
    
    _endDay   = [FXCalendarData getEndDayOfMonthWithDate:date];
    _enddayIndex = (int)[FXCalendarData getWeekDayWithDate:_endDay];
    
    _totalDay = (int)[FXCalendarData numberDayOfMonthWithDate:date];
    
    _daySelect = nil;
    _daySelect = [[FXDay alloc] init];
    _daySelect.date = selectDate;
    
    if (_delegate && [_delegate respondsToSelector:@selector(fxMonthView:didSelectDayWith:)]) {
        [_delegate fxMonthView:self didSelectDayWith:_daySelect];
    }
    
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    } else {
        [_days removeAllObjects];
    }
    
    
    if (!_isFirstOfSunday) {
        if (_firstdayIndex == 1 ) {
            _firstdayIndex = 7;
        } else {
            _firstdayIndex--;
        }
        
        if (_enddayIndex == 1) {
            _enddayIndex = 7;
        } else {
            _enddayIndex--;
        }
    }
    
    
    //get out of day with first week
    for (int i = _firstdayIndex - 1; i > 0; i--) {
        
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        
        [_days addObject:day];
    }
    
    // add day in out of days
    NSDate *tempDate = _firstDay;
    for (int i = (int)[_days count] - 1; i >= 0; i--) {
        
        tempDate = [FXCalendarData prevDateFrom:tempDate];
        FXDay *day = _days[i];
        day.date   = tempDate;
        
    }
    
    //add day in month
    tempDate = _firstDay;
    for (int i = 1; i <= _totalDay; i++) {
        
        FXDay *day          = [[FXDay alloc] init];
        day.isOutOfDay      = NO;
        day.isFirstOfSunday = _isFirstOfSunday;
        day.date            = tempDate;
        day.color1          = @"";
        day.color2          = @"";
        day.color3          = @"";
        
        if (_isLoadDataForCell) {
            
            day.shiftCategory = [[AppDelegate shared] getShiftCategoryWithDate:tempDate];
            
//            CDShift *shift  = [[AppDelegate shared] getShiftWithDate:tempDate];
//            if (shift) {
//                day.shiftCategory = [ShiftCategoryItem convertForCDObject:shift.fk_shift_category];
//            } else {
//                day.shiftCategory = nil;
//            }
            
            NSArray *arrayColor = [[AppDelegate shared] getColorsSchedulesOnDate:tempDate];
            if ([arrayColor count] >= 1) {
                day.color1      = arrayColor[0];
            }
            
            if ([arrayColor count] >= 2) {
                day.color2      = arrayColor[1];
            }
            
            if ([arrayColor count] >= 3) {
                day.color3      = arrayColor[2];
            }
            
        } else {
            day.shiftCategory = nil;
        }
        
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
    
    for (int i = (int)[_days count]; i < allDay ; i++) {
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        day.date = tempDate;
        
        [_days addObject:day];
        
        tempDate = [FXCalendarData nextDateFrom:tempDate];
    }
    
    [self reloadInfoDay];
}

- (void) reloadDays
{
    
    NSMutableArray *tempDays = [[NSMutableArray alloc] init];
    for (FXDay *day in _days) {
        if (!day.isOutOfDay) {
            [tempDays addObject:day];
        }
    }
    
    _firstdayIndex  = (int)[FXCalendarData getWeekDayWithDate:_firstDay];
    _enddayIndex    = (int)[FXCalendarData getWeekDayWithDate:_endDay];
    _totalDay       = (int)[FXCalendarData numberDayOfMonthWithDate:_date];
    
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    } else {
        [_days removeAllObjects];
    }
    
    
    if (!_isFirstOfSunday) {
        if (_firstdayIndex == 1 ) {
            _firstdayIndex = 7;
        } else {
            _firstdayIndex--;
        }
        
        if (_enddayIndex == 1) {
            _enddayIndex = 7;
        } else {
            _enddayIndex--;
        }
    }
    
    
    //get out of day with first week
    for (int i = _firstdayIndex - 1; i > 0; i--) {
        
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        
        [_days addObject:day];
    }
    
    // add day in out of days
    NSDate *tempDate = _firstDay;
    for (int i = (int)[_days count] - 1; i >= 0; i--) {
        
        tempDate = [FXCalendarData prevDateFrom:tempDate];
        FXDay *day = _days[i];
        day.date   = tempDate;
        
    }
    
    //add day in month
    tempDate = _firstDay;
    
    for (FXDay *day in tempDays) {
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
    
    for (int i = (int)[_days count]; i < allDay ; i++) {
        FXDay *day = [[FXDay alloc] init];
        day.isOutOfDay = YES;
        day.date = tempDate;
        
        [_days addObject:day];
        
        tempDate = [FXCalendarData nextDateFrom:tempDate];
    }
    
    [self reloadInfoDay];
}

- (void) reloadInfoDay
{
    _viewSelect.hidden = YES;
    
    for (FXDayView *dayView in _viewContainerDays.subviews) {
        if (dayView.tag < [_days count]) {
            
            FXDay *day = _days[dayView.tag];
            day.isSelect = NO;
            
            if (_daySelect &&
                
                _daySelect.dayIndex == day.dayIndex &&
                _daySelect.monthIndex == day.monthIndex &&
                _daySelect.yearIndex == day.yearIndex) {
                
                _viewSelect.hidden  = NO;
                _viewSelect.frame   = CGRectMake(_widthCell * (dayView.tag%7) - 1, _heightCell * (dayView.tag/7) - 1, _widthCell + 2, _heightCell + 2);
                
                day.isSelect = YES;
                
                _indexSelect = (int)dayView.tag;
            }
            
            [dayView reloadInfo:day];
            
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

#pragma mark - View Full
- (void) reloadViewToViewFullWithAnimate:(BOOL)isAnimate
{
    if (_isViewFull) {
        return;
    } else {
        _isViewFull = YES;
    }
    
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//    }
    
    _indexSelect        = -1;
    _widthCell          = self.frame.size.width / 7;
    _heightCell         = 60;
    
    CGRect frame        = self.frame;
    frame.size.height   = _heightCell*6 + 1;
    self.frame          = frame;
    
    
    //[self initLayout];
    [self reloadLayout:50 newHeight:60];
}

- (void) reloadViewForExitViewFullWithAnimate:(BOOL)isAnimate
{
    if (!_isViewFull) {
        return;
    } else {
        _isViewFull = NO;
    }
    
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//    }
    
    _indexSelect        = -1;
    _widthCell          = self.frame.size.width / 7;
    _heightCell         = 50;
    
    CGRect frame        = self.frame;
    frame.size.height   = _heightCell*6 + 1;
    self.frame          = frame;
    
    
    //[self initLayout];
    [self reloadLayout:60 newHeight:50];
}

- (void) reloadTheme
{
    _viewSelect.backgroundColor     = [[FXThemeManager shared] getColorWithKey:_fxThemeColorMain];
}

- (void) reloadChangeFirstOfCalendar:(BOOL)isFirstOfSunday
{
    self.isFirstOfSunday = isFirstOfSunday;
    
    for (UIView *view in self.subviews) {
        if (view.tag == 999) {
            int temp = _isFirstOfSunday ? 6 : 5;
            view.frame = CGRectMake(_widthCell*temp, 0, _widthCell, _heightCell*6);
        } else if (view.tag == 998) {
            int temp = _isFirstOfSunday ? 0 : 6;
            view.frame = CGRectMake(_widthCell*temp, 0, _widthCell, _heightCell*6);
        }
    }
    
    [self reloadDays];
    
    
}



#pragma mark - Cell
- (void) reloadCellWithTag:(int)tag
{
    for (FXDayView *dayView in _viewContainerDays.subviews) {
        if (dayView.tag < [_days count] &&
            dayView.tag == tag) {
            
            FXDay *day = _days[dayView.tag];
            day.isSelect = NO;
            
            day.shiftCategory = [[AppDelegate shared] getShiftCategoryWithDate:day.date];
            NSArray *arrayColor = [[AppDelegate shared] getColorsSchedulesOnDate:day.date];
            if ([arrayColor count] >= 1) {
                day.color1      = arrayColor[0];
            }
            
            if ([arrayColor count] >= 2) {
                day.color2      = arrayColor[1];
            }
            
            if ([arrayColor count] >= 3) {
                day.color3      = arrayColor[2];
            }
            
            [dayView reloadInfo:day];
            
            _indexSelect++;
            _viewSelect.hidden  = NO;
            _viewSelect.frame   = CGRectMake(_widthCell * (tag%7) - 1, _heightCell * (tag/7) - 1, _widthCell + 2, _heightCell + 2);
            
        }
    }
}
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

@end
