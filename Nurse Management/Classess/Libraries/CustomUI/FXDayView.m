//
//  FXDayView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXDayView.h"

@implementation FXDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initLayout];
    }
    return self;
}

- (void) initLayout
{
    _lbDay                  = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width - 5, 20)];
    _lbDay.textColor        = self.outOfMonthDayColor;
    _lbDay.font             = [UIFont systemFontOfSize:14.0];
    _lbDay.text             = @"1";
    _lbDay.backgroundColor  = [UIColor clearColor];
    
    [self addSubview:_lbDay];
}

#pragma mark - Geter
- (UIColor*) borderColor
{
    if (!_borderColor) {
        _borderColor = [UIColor colorWithRed:117.0/255.0 green:95.0/255.0 blue:50.0/255.0 alpha:1.0];
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




#pragma mark - Public mehtod
- (void) reloadInfo:(FXDay*)day
{
    _lbDay.text = [NSString stringWithFormat:@"%d",day.dayIndex];
    
    if (day.isOutOfDay) {
        _lbDay.textColor = self.outOfMonthDayColor;
    } else {
        switch (day.weekDayIndex) {
            case 1:
                _lbDay.textColor = self.sundayColor;
                break;
            case 7:
                _lbDay.textColor = self.saturdayColor;
                break;
                
            default:
                _lbDay.textColor = self.borderColor;
                break;
        }
    }
    
    if (day.isCurrent) {
        self.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:228.0/255.0 blue:254.0/255.0 alpha:1.0];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
    
}








@end
