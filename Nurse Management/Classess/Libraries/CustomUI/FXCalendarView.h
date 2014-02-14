//
//  FXCalendarView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXCalendarViewDelegate;

@interface FXCalendarView : UIView

@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id <FXCalendarViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIView *headerView;

@property (nonatomic, strong) NSDate *selectDate;

- (void) initCalendar;
- (void) reloadToday;
- (int) numberWeekOfCurrentMonth;
- (float) heightCalendarWithCurrentMonth;

@end

@protocol FXCalendarViewDelegate <NSObject>

- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didChangeMonthWithFirstDay:(NSDate*)date;
- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didSelectDay:(NSDate*)date;

@end
