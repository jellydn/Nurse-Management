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

- (void) initCalendar;
- (void) reloadToday;

@end

@protocol FXCalendarViewDelegate <NSObject>

- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didChangeMonthWithFirstDay:(NSDate*)date;

@end
