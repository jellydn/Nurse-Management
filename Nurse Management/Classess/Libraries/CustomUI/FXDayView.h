//
//  FXDayView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXDay.h"

@interface FXDayView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *colorDay;
@property (nonatomic, strong) UIColor *colorSelect;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *saturdayColor;
@property (nonatomic, strong) UIColor *sundayColor;
@property (nonatomic, strong) UIColor *outOfMonthDayColor;

@property (nonatomic, strong) UILabel *lbDay;

- (void) reloadInfo:(FXDay*)day;


@end
