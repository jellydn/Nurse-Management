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

@interface FXCalendarView ()<UIScrollViewDelegate>
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
    
    _monthView1 = [[FXMonthView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date]];
    [_scrollView addSubview:_monthView1];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    
    _monthView2 = [[FXMonthView alloc] initWithFrame:CGRectMake(320, 0, 320, 0)];
    [_monthView2 loadDataForDate:date];
    [_scrollView addSubview:_monthView2];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    _monthView3 = [[FXMonthView alloc] initWithFrame:CGRectMake(640, 0, 320, 0)];
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date]];
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
            
            [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date]];
            [_monthView1 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView2 loadDataForDate:date];
            [_monthView2 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date]];
            [_monthView3 reloadHeighForWeekWithAnimate:NO];
            
            [_scrollView setContentOffset:CGPointMake(320, 0)];
            
        } else if (scrollView.contentOffset.x == 640){
            
            NSDate *date = _monthView3.date;
            
            [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date]];
            [_monthView1 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView2 loadDataForDate:date];
            [_monthView2 reloadHeighForWeekWithAnimate:NO];
            
            [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date]];
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
        
        [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date]];
        [_monthView1 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView2 loadDataForDate:date];
        [_monthView2 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date]];
        [_monthView3 reloadHeighForWeekWithAnimate:NO];
        
        [_scrollView setContentOffset:CGPointMake(320, 0)];
        
    } else if (scrollView.contentOffset.x == 640){
        
        NSDate *date = _monthView3.date;
        
        [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date]];
        [_monthView1 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView2 loadDataForDate:date];
        [_monthView2 reloadHeighForWeekWithAnimate:NO];
        
        [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date]];
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
    
    [_monthView1 loadDataForDate:[FXCalendarData datePrevMonthFormDate:date]];
    [_monthView1 reloadHeighForWeekWithAnimate:NO];
    
    [_monthView2 loadDataForDate:date];
    [_monthView2 reloadHeighForWeekWithAnimate:YES];
    
    [_monthView3 loadDataForDate:[FXCalendarData dateNextMonthFormDate:date]];
    [_monthView3 reloadHeighForWeekWithAnimate:NO];
    
    if (_delegate && [_delegate respondsToSelector:@selector(fXCalendarView:didChangeMonthWithFirstDay:)]) {
        [_delegate fXCalendarView:self didChangeMonthWithFirstDay:_monthView2.date];
    }
}







@end
