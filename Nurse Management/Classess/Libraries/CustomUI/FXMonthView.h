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
#import "AppDelegate.h"
#import "CDShift.h"
#import "CDShiftCategory.h"
#import "ShiftCategoryItem.h"
#import "FXThemeManager.h"

@protocol FXMonthViewDelegate;

@interface FXMonthView : UIView

//property
@property (nonatomic, weak) id<FXMonthViewDelegate> delegate;

@property (nonatomic) BOOL isHighlight;
@property (nonatomic) BOOL isMouthCurrent;
@property (nonatomic) BOOL is6Week;
@property (nonatomic) BOOL isShowSelectDay;
@property (nonatomic) BOOL isLoadDataForCell;
@property (nonatomic) BOOL isViewFull;
@property (nonatomic) BOOL isFirstOfSunday;

@property (nonatomic) int totalDay;
@property (nonatomic) int monthIndex;
@property (nonatomic) int dayIndex;
@property (nonatomic) int firstdayIndex;
@property (nonatomic) int enddayIndex;
@property (nonatomic) int numberWeekOfMonth;
@property (nonatomic) int indexSelect;

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
@property (nonatomic, strong) UIColor *backgoundSelectDay;

@property (nonatomic, strong) UIView  *viewLines;
@property (nonatomic, strong) UIView  *viewContainerSelect;
@property (nonatomic, strong) UIView  *viewSelect;
@property (nonatomic, strong) UIView  *viewContainerDays;

@property (nonatomic, strong) NSDate            *date;
@property (nonatomic, strong) NSDate            *firstDay;
@property (nonatomic, strong) NSDate            *endDay;
@property (nonatomic, strong) NSMutableArray    *days;

@property (nonatomic, strong) FXDay             *daySelect;


//method
- (void) loadDataForDate:(NSDate*)date isSetFirstDay:(BOOL)isSet;
- (void) loadDataForDate:(NSDate *)date setSelectDay:(NSDate*)selectDate;
- (void) reloadHeighForWeekWithAnimate:(BOOL)isAnimate;
- (void) reloadViewToViewFullWithAnimate:(BOOL)isAnimate;
- (void) reloadViewForExitViewFullWithAnimate:(BOOL)isAnimate;
- (void) reloadTheme;
- (void) reloadChangeFirstOfCalendar:(BOOL)isFirstOfSunday;
- (void) reloadDays;
- (void) reloadCellWithTag:(int)tag;

//instance method
- (id)initWithWidth:(float)width;

//Action
- (IBAction)selectDay:(id)sender;

@end

@protocol FXMonthViewDelegate <NSObject>

- (void) fxMonthView:(FXMonthView*) fxMonthView didSelectDayWith:(FXDay*)day;
- (void) fxMonthViewExitViewFull:(FXMonthView *)fxMonthView;

@end



















