//
//  FXDayView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXDayView.h"
#import <QuartzCore/QuartzCore.h>
#import "FXThemeManager.h"

@implementation FXDayView

- (void)dealloc
{
    self.day = nil;
}

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
 
    [_imgSchedule1.layer setCornerRadius:4.0];
    _imgSchedule1.layer.masksToBounds = YES;
    
    [_imgSchedule2.layer setCornerRadius:4.0];
    _imgSchedule2.layer.masksToBounds = YES;
    
    [_imgSchedule3.layer setCornerRadius:4.0];
    _imgSchedule3.layer.masksToBounds = YES;
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

    _day = day;
    
    _lbDay.text = [NSString stringWithFormat:@"%d",day.dayIndex];
    
    if (day.shiftCategory) {
        _lbCategoryName.hidden  = NO;
        _imgCategory.hidden     = NO;
        
        _imgCategory.image          = [UIImage imageNamed:day.shiftCategory.image];
        _lbCategoryName.text        = day.shiftCategory.name;
        _lbCategoryName.textColor   = day.shiftCategory.textColor;
        
    } else {
        _lbCategoryName.hidden  = YES;
        _imgCategory.hidden     = YES;
        
        
        
    }
    
    if (day.isOutOfDay) {
        _lbDay.textColor = self.outOfMonthDayColor;
        
        _imgSchedule1.hidden = YES;
        _imgSchedule2.hidden = YES;
        _imgSchedule3.hidden = YES;
        
    } else {
        
        _imgSchedule1.hidden = NO;
        _imgSchedule2.hidden = NO;
        _imgSchedule3.hidden = NO;
        
        _imgSchedule1.image = [UIImage imageNamed:day.color1];
        _imgSchedule2.image = [UIImage imageNamed:day.color2];
        _imgSchedule3.image = [UIImage imageNamed:day.color3];
        
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
        if (day.isSelect) {
            self.backgroundColor = [UIColor clearColor];
            
        } else {
            
            NSDictionary *dicCalendar = [[FXThemeManager shared].themeData objectForKey:@"calendar"];
            self.backgroundColor = [[FXThemeManager shared] colorFromHexString:[dicCalendar objectForKey:@"color_current_day"]];
            
            
            //self.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:228.0/255.0 blue:254.0/255.0 alpha:1.0];
            
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
    
}

#pragma mark - Others

- (IBAction)selectDay:(id)sender
{
    
}





















@end
