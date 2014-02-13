//
//  FXMonthView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXCalendarData.h"
#import "FXDay.h"
#import "FXDayView.h"

@protocol FXMonthViewDelegate;

@interface FXMonthView : UIView

//property
@property (nonatomic, weak) id<FXMonthViewDelegate> delegate;

@property (nonatomic) BOOL isHighlight;
@property (nonatomic) BOOL isMouthCurrent;
@property (nonatomic) BOOL is6Week;

@property (nonatomic) int totalDay;
@property (nonatomic) int monthIndex;
@property (nonatomic) int dayIndex;
@property (nonatomic) int firstdayIndex;
@property (nonatomic) int enddayIndex;
@property (nonatomic) int numberWeekOfMonth;

@property (nonatomic) float widthCell;
@property (nonatomic) float heightCell;
@property (nonatomic) float lineWidth;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *saturdayColor;
@property (nonatomic, strong) UIColor *sundayColor;
@property (nonatomic, strong) UIColor *outOfMonthDayColor;

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *backgoundSaturdayColor;
@property (nonatomic, strong) UIColor *backgoundSundayColor;

@property (nonatomic, strong) UIView  *viewLines;
@property (nonatomic, strong) UIView  *viewContainerDays;

@property (nonatomic, strong) NSDate            *date;
@property (nonatomic, strong) NSDate            *firstDay;
@property (nonatomic, strong) NSDate            *endDay;
@property (nonatomic, strong) NSMutableArray    *days;

//method
- (void) loadDataForDate:(NSDate*)date;

- (void) reloadHeighForWeekWithAnimate:(BOOL)isAnimate;

//instance method
- (id)initWithWidth:(float)width;

@end

@protocol FXMonthViewDelegate <NSObject>



@end
