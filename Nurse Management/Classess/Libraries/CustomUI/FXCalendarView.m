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

@interface FXCalendarView ()<UIScrollViewDelegate, FXMonthViewDelegate>
{
    FXMonthView *_monthView1;
    FXMonthView *_monthView2;
    FXMonthView *_monthView3;

}

@end

@implementation FXCalendarView


- (void) initCalendar
{
    [_scrollView setContentSize:CGSizeMake(320 * 3, 301)];
    
    NSDate *date = [NSDate date];
    _selectDate = date;
    
    _monthView1 = [[FXMonthView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    _monthView1.isLoadDataForCell   = YES;
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date] isSetFirstDay:NO];
    [_scrollView addSubview:_monthView1];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    
    _monthView2                     = [[FXMonthView alloc] initWithFrame:CGRectMake(320, 0, 320, 0)];
    _monthView2.delegate            = self;
    _monthView2.isLoadDataForCell   = YES;
    [_monthView2 loadDataForDate:date setSelectDay:date];
    [_scrollView addSubview:_monthView2];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    _monthView3 = [[FXMonthView alloc] initWithFrame:CGRectMake(640, 0, 320, 0)];
    _monthView3.isLoadDataForCell   = YES;
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date] isSetFirstDay:NO];
    [_scrollView addSubview:_monthView3];
    [_monthView3 reloadHeighForWeekWithAnimate:NO];
    
    [_scrollView setContentOffset:CGPointMake(320, 0)];
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

#pragma mark - FXMonthViewDelegate
- (void) fxMonthView:(FXMonthView*) fxMonthView didSelectDayWith:(FXDay*)day
{
    if (!day.isOutOfDay &&
        _delegate &&
        [_delegate respondsToSelector:@selector(fXCalendarView:didSelectDay:)]) {
        _selectDate = day.date;
        [_delegate fXCalendarView:self didSelectDay:day.date];
    }
}







@end
