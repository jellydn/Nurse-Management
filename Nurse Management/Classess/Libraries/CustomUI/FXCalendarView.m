//
//  FXCalendarView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXCalendarView.h"
#import "FXCalendarData.h"
#import "FXDay.h"

#import "FXMonthView.h"
#import "FXDayView.h"
#import "Define.h"

@interface FXCalendarView ()<UIScrollViewDelegate, FXMonthViewDelegate>
{
    FXMonthView *_monthView1;
    FXMonthView *_monthView2;
    FXMonthView *_monthView3;

    BOOL _isFirstOfSunday;
}

@end

@implementation FXCalendarView


- (void) initCalendar
{
    //set theme for header
    if ([[FXThemeManager shared] getImageWithKey:_fxThemeImageCalendarHeader]) {
        _headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[[FXThemeManager shared] getImageWithKey:_fxThemeImageCalendarHeader]];
    } else {
        _headerView.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorCalendarHeader];
    }
    
    //set first of calendar
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FIRST_OF_CALENDAR]) {
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:FIRST_OF_CALENDAR] == 0) {
            _isFirstOfSunday            = YES;
            _headerViewMonday.hidden    = YES;
            _headerViewSunday.hidden    = NO;
        } else {
            _isFirstOfSunday            = NO;
            _headerViewMonday.hidden    = NO;
            _headerViewSunday.hidden    = YES;
        }
        
    } else {
  
        _isFirstOfSunday = YES;
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:FIRST_OF_CALENDAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [_scrollView setContentSize:CGSizeMake(320 * 3, 301)];
    
    NSDate *date = [NSDate date];
    _selectDate = date;
    
    _monthView1 = [[FXMonthView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    _monthView1.isLoadDataForCell   = NO;
    _monthView1.isFirstOfSunday     = _isFirstOfSunday;
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
    [_scrollView addSubview:_monthView1];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    
    _monthView2                     = [[FXMonthView alloc] initWithFrame:CGRectMake(320, 0, 320, 0)];
    _monthView2.delegate            = self;
    _monthView2.isLoadDataForCell   = YES;
    _monthView2.isFirstOfSunday     = _isFirstOfSunday;
    [_monthView2 loadDataForDate:date setSelectDay:date];
    [_scrollView addSubview:_monthView2];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    _monthView3 = [[FXMonthView alloc] initWithFrame:CGRectMake(640, 0, 320, 0)];
    _monthView3.isLoadDataForCell   = NO;
    _monthView3.isFirstOfSunday     = _isFirstOfSunday;
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
    [_scrollView addSubview:_monthView3];
    [_monthView3 reloadHeighForWeekWithAnimate:NO];
    
    [_scrollView setContentOffset:CGPointMake(320, 0)];
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handleSwipeDownFrom:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeUpGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (!decelerate) {
        if (scrollView.contentOffset.x == 0) {

            NSDate *date = _monthView1.date;
            
            [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
            [_monthView1 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView2 loadDataForDate:date isSetFirstDay:YES];
            [_monthView2 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
            [_monthView3 reloadHeighForWeekWithAnimate:NO];
            
            [_scrollView setContentOffset:CGPointMake(320, 0)];
            
        } else if (scrollView.contentOffset.x == 640){
            
            NSDate *date = _monthView3.date;
            
            [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
            [_monthView1 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView2 loadDataForDate:date isSetFirstDay:YES];
            [_monthView2 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
            [_monthView3 reloadHeighForWeekWithAnimate:NO];
            
            [_scrollView setContentOffset:CGPointMake(320, 0)];
            
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(fXCalendarView:didChangeMonthWithFirstDay:)]) {
            [_delegate fXCalendarView:self didChangeMonthWithFirstDay:_monthView2.date];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        
        NSDate *date = _monthView1.date;
        
        [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
        [_monthView1 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView2 loadDataForDate:date isSetFirstDay:YES];
        [_monthView2 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
        [_monthView3 reloadHeighForWeekWithAnimate:NO];
        
        [_scrollView setContentOffset:CGPointMake(320, 0)];
        
    } else if (scrollView.contentOffset.x == 640){
        
        NSDate *date = _monthView3.date;
        
        [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
        [_monthView1 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView2 loadDataForDate:date isSetFirstDay:YES];
        [_monthView2 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
        [_monthView3 reloadHeighForWeekWithAnimate:NO];
        
        [_scrollView setContentOffset:CGPointMake(320, 0)];
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(fXCalendarView:didChangeMonthWithFirstDay:)]) {
        [_delegate fXCalendarView:self didChangeMonthWithFirstDay:[FXCalendarData getFirstDayOfMonthWithDate:_monthView2.date]];
    }
}

#pragma mark - Public method
- (void) reloadToday
{
    NSDate *date = [FXCalendarData getFirstDayOfMonthWithDate:[NSDate date]];
    _selectDate = date;
    
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    [_monthView2 loadDataForDate:date setSelectDay:[NSDate date]];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
    [_monthView3 reloadHeighForWeekWithAnimate:NO];
    
    if (_delegate && [_delegate respondsToSelector:@selector(fXCalendarView:didChangeMonthWithFirstDay:)]) {
        [_delegate fXCalendarView:self didChangeMonthWithFirstDay:[NSDate date]];
    }
}

- (int) numberWeekOfCurrentMonth
{
    return _monthView2.numberWeekOfMonth;
}

- (float) heightCalendarWithCurrentMonth
{
    return _headerView.frame.size.height + _monthView2.numberWeekOfMonth * _monthView2.heightCell + 1;
}

- (void) setNextSelectDate
{
    _selectDate = [FXCalendarData nextDateFrom:_selectDate];
    
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:_selectDate] isSetFirstDay:NO];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    [_monthView2 loadDataForDate:_selectDate setSelectDay:_selectDate];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:_selectDate] isSetFirstDay:NO];
    [_monthView3 reloadHeighForWeekWithAnimate:NO];
    
    if (_delegate && [_delegate respondsToSelector:@selector(fXCalendarView:didSelectNextDay:)]) {
        [_delegate fXCalendarView:self didSelectNextDay:_selectDate];
    }
}

- (void) reloadData
{
    [_monthView2 loadDataForDate:_selectDate setSelectDay:_selectDate];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
}

- (void) reloadChangeFirstDayOfCalendar
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:FIRST_OF_CALENDAR] == 0) {
        _isFirstOfSunday            = YES;
        _headerViewMonday.hidden    = YES;
        _headerViewSunday.hidden    = NO;
    } else {
        _isFirstOfSunday            = NO;
        _headerViewMonday.hidden    = NO;
        _headerViewSunday.hidden    = YES;
    }
    
    [_monthView1 reloadChangeFirstOfCalendar:_isFirstOfSunday];
    [_monthView2 reloadChangeFirstOfCalendar:_isFirstOfSunday];
    [_monthView3 reloadChangeFirstOfCalendar:_isFirstOfSunday];
}

#pragma mark - FXMonthViewDelegate
- (void) fxMonthView:(FXMonthView*) fxMonthView didSelectDayWith:(FXDay*)day
{
    if (!day.isOutOfDay &&
        _delegate &&
        [_delegate respondsToSelector:@selector(fXCalendarView:didSelectDay:)]) {
        _selectDate = day.date;
        [_delegate fXCalendarView:self didSelectDay:day.date];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(fxcalendarView:didFull:)]) {
        [_delegate fxcalendarView:self didFull:_monthView2.isViewFull];
    }
}

- (void) fxMonthViewExitViewFull:(FXMonthView *)fxMonthView
{
    [self reloadViewisFull:NO];
}

#pragma mark - Swipe
- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [self reloadViewisFull:YES];
}

- (void) reloadViewisFull:(BOOL)isFull
{
    if (isFull) {
        [_monthView1 reloadViewToViewFullWithAnimate:NO];
        [_monthView2 reloadViewToViewFullWithAnimate:YES];
        [_monthView3 reloadViewToViewFullWithAnimate:NO];
        
        CGRect rect = self.frame;
        rect.size.height = 381;
        self.frame = rect;
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(fxcalendarView:didFull:)]) {
            [_delegate fxcalendarView:self didFull:YES];
        }
    } else {
        [_monthView1 reloadViewForExitViewFullWithAnimate:NO];
        [_monthView2 reloadViewForExitViewFullWithAnimate:YES];
        [_monthView3 reloadViewForExitViewFullWithAnimate:NO];
        
        CGRect rect = self.frame;
        rect.size.height = 321;
        self.frame = rect;
        [_scrollView setContentSize:CGSizeMake(320 * 3, 301)];
    }
    
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:_selectDate] isSetFirstDay:NO];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    [_monthView2 loadDataForDate:_selectDate setSelectDay:_selectDate];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:_selectDate] isSetFirstDay:NO];
    [_monthView3 reloadHeighForWeekWithAnimate:NO];
}

- (void) reloadTheme
{
    //set theme for header
    if ([[FXThemeManager shared] getImageWithKey:_fxThemeImageCalendarHeader]) {
        _headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[[FXThemeManager shared] getImageWithKey:_fxThemeImageCalendarHeader]];
    } else {
        _headerView.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorCalendarHeader];
    }
    
    [_monthView2 reloadTheme];
}






@end
