//
//  AddScheduleView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddScheduleView.h"
#import "ScheduleCategoryItem.h"
#import "FXThemeManager.h"
#import "Common.h"
#import "FXCalendarData.h"

@interface AddScheduleView ()

@end

@implementation AddScheduleView

- (void) initLayoutView
{
    _viewMask.alpha = 0;
    
    CGRect rect             = _viewContainer.frame;
    CGRect rect2            = _viewTime.frame;
    CGRect rect3            = _viewTimePicker.frame;
    
    rect.origin.y           += rect.size.height;
    rect2.origin.y          += rect.size.height;
    rect3.origin.y          += rect.size.height;
    
    _viewContainer.frame    = rect;
    _viewTime.frame         = rect2;
    _viewTimePicker.frame   = rect3;
    
    self.hidden = YES;
    
    _datePicker.calendar        = [NSCalendar autoupdatingCurrentCalendar];
    _datePicker.datePickerMode  = UIDatePickerModeTime;
    
    NSDictionary *tempDic = [[FXThemeManager shared].themeData objectForKey:_fxThemeOthersAddSchedule];
    
    [_btNextSchedule setImage:[UIImage imageNamed:[tempDic objectForKey:@"button1"]] forState:UIControlStateNormal];
    [_btBackChoiceCategory setImage:[UIImage imageNamed:[tempDic objectForKey:@"button2"]] forState:UIControlStateNormal];
    [_btSaveSchedule setImage:[UIImage imageNamed:[tempDic objectForKey:@"button3"]] forState:UIControlStateNormal];
    
}

- (void) show
{
    self.hidden = NO;
    
    CGRect rect = _viewContainer.frame;
    CGRect rect2    = _viewTime.frame;
    
    rect.origin.y -= rect.size.height;
    rect2.origin.y  -= rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewMask.alpha = 0.5;
        _viewContainer.frame = rect;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        
        _isShowPicker       = NO;
        _isAllDay           = NO;
        _isSetTimeStart     = NO;
        
        [_btAllDay setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]];
        
        _dateTimeStart      = [FXCalendarData dateNexHourFormDate:_selectDate];
        _dateTimeEnd        = [FXCalendarData dateNexHourFormDate:_dateTimeStart];
        _arrayTimeAlerts    = nil;
        
        _lbTimeStart.text   = [Common convertTimeToStringWithFormat:@"HH:mm" date:_dateTimeStart];
        _lbTimeEnd.text     = [Common convertTimeToStringWithFormat:@"HH:mm" date:_dateTimeEnd];
        
        _btStartTime.enabled    = YES;
        _btEndTime.enabled      = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didShowView:)]) {
            [_delegate didShowView:self];
        }
    }];
}

- (void) hide
{
    
    CGRect rect     = _viewContainer.frame;
    CGRect rect2    = _viewTime.frame;
    
    rect.origin.y   += rect.size.height;
    rect2.origin.y  += rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewMask.alpha = 0;
        _viewContainer.frame = rect;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _isShowPicker = NO;
        
        CGRect rect             = _viewContainer.frame;
        CGRect rect2            = _viewTime.frame;
        CGRect rect3            = _viewTimePicker.frame;
        
        rect.origin.x           = 0;
        rect2.origin.x          = 320;
        rect3.origin.y          = self.frame.size.height;
        
        _viewContainer.frame    = rect;
        _viewTime.frame         = rect2;
        _viewTimePicker.frame   = rect3;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didHideView:)]) {
            [_delegate didHideView:self];
        }
    }];
}

- (void) loadScheduleCategoryInfo:(NSMutableArray*)schedules selectDate:(NSDate*)selectDate
{
    NSLog(@"total %d", [schedules count]);
    
    for (UIView *view in _scrollScheduleView.subviews) {
        if (view.tag > 99) {
            [view removeFromSuperview];
        }
    }
    
    if ([schedules count] <= 0) {
        return;
    }
    
    _selectDate = [FXCalendarData dateWithSetHourWithHour:[FXCalendarData getHourWithDate:[NSDate date]] date:selectDate];
    
    _pageControl.currentPageIndicatorTintColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorMain];
    
    int page                    = ([schedules count] % 10 == 0) ? [schedules count] / 10 : [schedules count] / 10 + 1;
    _pageControl.numberOfPages  = page;
    _pageControl.currentPage    = 0;
    
    [_scrollScheduleView setContentSize:CGSizeMake(320 * page, 140)];
    [_scrollScheduleView setContentOffset:CGPointMake(0, 0)];
    
    CGRect rect = CGRectMake(15, 27, 50, 44);
    int temp = 0;
    
    if (!_viewSelect) {
        _viewSelect = [[UIView alloc] initWithFrame:CGRectMake(13, 25, 54, 48)];
        _viewSelect.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorMain];
        _viewSelect.tag = 0;
        [_scrollScheduleView addSubview:_viewSelect];
    }
    
    _viewSelect.frame = CGRectMake(13, 25, 54, 48);
    
    for (ScheduleCategoryItem *item in schedules) {
        
        if (temp == 0) {
            _scheduleCategoryID = item.scheduleCategoryID;
        }
        
        UIButton *button            = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font      = [UIFont systemFontOfSize:15.0];
        button.tag                  = item.scheduleCategoryID + 100;
        [button setBackgroundImage:[UIImage imageNamed:item.image] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollScheduleView addSubview:button];
        
        UILabel *lb         = [[UILabel alloc] initWithFrame:CGRectMake((temp / 10) * 320 + (temp % 5) * 60 + 15,
                                                                        (temp % 10) >= 5 ? 95 : 30,
                                                                        50,
                                                                        44)];
        lb.text             = item.name;
        lb.backgroundColor  = [UIColor clearColor];
        lb.textColor        = item.textColor;
        lb.font             = [UIFont systemFontOfSize:14.0];
        lb.textAlignment    = NSTextAlignmentCenter;
        lb.numberOfLines    = 2;
        lb.tag              = item.scheduleCategoryID + 100;
        [_scrollScheduleView addSubview:lb];
        
        
        rect.origin.x = (temp / 10) * 320 + (temp % 5) * 60 + 15;
        rect.origin.y = (temp % 10) >= 5 ? 89 : 27;
        
        button.frame = rect;
        
        temp++;
        
        
    }
}

#pragma mark - Touch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch= [touches anyObject];
    if ([touch view] == _viewMask)
    {
        if (_isShowPicker) {
            
            CGRect rect                 = _viewTimePicker.frame;
            rect.origin.y               += rect.size.height;
            
            [UIView animateWithDuration:0.3 animations:^{
                _viewTimePicker.frame   = rect;
            } completion:^(BOOL finished) {
                _isShowPicker = NO;
            }];
            
        } else {
            [self hide];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) {
        _pageControl.currentPage = scrollView.contentOffset.x / 320;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / 320;
}

#pragma mark - Action

- (IBAction)selectItem:(id)sender
{
    UIButton *button = (UIButton*)sender;
    CGRect rect = button.frame;
    
    rect.origin.x       -= 2;
    rect.origin.y       -= 2;
    rect.size.width     += 4;
    rect.size.height    += 4;
    
    _viewSelect.frame   = rect;
    
    _scheduleCategoryID = button.tag - 100;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCategory:categoryID:)]) {
        [_delegate didSelectCategory:self categoryID:_scheduleCategoryID];
    }
}

- (IBAction)selectCategory:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didShowCategoryName:)]) {
        [_delegate didShowCategoryName:self];
    }
    
}

- (IBAction)choiceTime:(id)sender
{
    
    if (!_chooseTimeView) {
        [_chooseTimeView removeFromSuperview];
        _chooseTimeView = nil;
    }
    
    _chooseTimeView             = [[ChooseTimeView alloc] initWithFrame:CGRectMake(15, 140, 320 - 15*2, 44)];
    _chooseTimeView.delegate    = self;
    [_chooseTimeView setStartDate:_dateTimeStart];
    [_chooseTimeView setColorForActiontionChoose:[[FXThemeManager shared] getColorWithKey:_fxThemeColorMain]];
    [_viewTime addSubview:_chooseTimeView];
    
    CGRect rect1 = _viewContainer.frame;
    CGRect rect2 = _viewTime.frame;
    
    rect1.origin.x -= 320;
    rect2.origin.x -= 320;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewContainer.frame = rect1;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(didChoiceTime:)]) {
            [_delegate didChoiceTime:self];
        }
    }];
    
}

- (IBAction)backChoiceCategory:(id)sender
{
    CGRect rect1 = _viewContainer.frame;
    CGRect rect2 = _viewTime.frame;
    
    rect1.origin.x += 320;
    rect2.origin.x += 320;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewContainer.frame = rect1;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)saveSchedule:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSaveSchedule:info:)]) {
        
        NSArray *keys = @[@"schedule_category_id",
                         @"start_time",
                         @"end_time",
                         @"is_all_day",
                         @"array_alert",
                         @"select_date",
                         @"memo"];
        
        NSArray *values = @[[NSString stringWithFormat:@"%d",_scheduleCategoryID],
                           (_dateTimeStart != nil) ? _dateTimeStart : @"",
                           (_dateTimeEnd != nil) ? _dateTimeEnd : @"",
                           [NSString stringWithFormat:@"%d",_isAllDay],
                           (_arrayTimeAlerts == nil) ? @"" : _arrayTimeAlerts,
                            _selectDate,
                            @""];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        
        [_delegate didSaveSchedule:self info:info];
    }
    
    [self hide];
}

- (IBAction)selectTimeForSchedule:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 3) {
        
        if (_isAllDay) {
            _isAllDay = NO;
            [_btAllDay setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]];
            _lbTimeStart.text   = (_dateTimeStart == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_dateTimeStart];
            _lbTimeEnd.text     = (_dateTimeEnd == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_dateTimeEnd];
            
            _btStartTime.enabled    = YES;
            _btEndTime.enabled      = YES;
            
        } else {
            _isAllDay = YES;
            [_btAllDay setBackgroundColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorMain]];
            _lbTimeStart.text   = @"00:00";
            _lbTimeEnd.text     = @"00:00";
            
            _btStartTime.enabled    = NO;
            _btEndTime.enabled      = NO;
        }
        
        return;
        
    } else if (button.tag == 1) {
        _isSetTimeStart = YES;
        
        if (_dateTimeEnd) {
            _datePicker.minimumDate = nil;
            _datePicker.maximumDate = _dateTimeEnd;
        }
        
    } else if (button.tag == 2) {
        _isSetTimeStart = NO;
        
        if (_dateTimeStart) {
            _datePicker.minimumDate = _dateTimeStart;
            _datePicker.maximumDate = nil;
        }
    } else {
        return;
    }
    
    CGRect rect                 = _viewTimePicker.frame;
    rect.origin.y               -= rect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewTimePicker.frame   = rect;
    } completion:^(BOOL finished) {
        _isShowPicker = YES;
    }];
}

- (IBAction)cancelPickerTime:(id)sender
{
    if (!_isShowPicker) {
        return;
    }
    
    CGRect rect                 = _viewTimePicker.frame;
    rect.origin.y               += rect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewTimePicker.frame   = rect;
    } completion:^(BOOL finished) {
        _isShowPicker = NO;
    }];
}

- (IBAction)donePickerTime:(id)sender
{
    if (!_isShowPicker) {
        return;
    }
    
    CGRect rect                 = _viewTimePicker.frame;
    rect.origin.y               += rect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewTimePicker.frame   = rect;
    } completion:^(BOOL finished) {
        _isShowPicker = NO;
        
        if (_isSetTimeStart) {
            _lbTimeStart.text   = [Common convertTimeToStringWithFormat:@"HH:mm" date:_datePicker.date];
            _dateTimeStart      = _datePicker.date;
            [_chooseTimeView setStartDate:_datePicker.date];
        } else {
            _lbTimeEnd.text     = [Common convertTimeToStringWithFormat:@"HH:mm" date:_datePicker.date];
            _dateTimeEnd        = _datePicker.date;
        }
        
    }];
}

#pragma mark - Time


#pragma mark - ChooseTimeViewDelegate

- (void)didChooseTimeWithIndex:(NSInteger)index arrayChooseTime:(NSMutableArray *)arrayChooseTime
{
    _arrayTimeAlerts = arrayChooseTime;
}

















@end
