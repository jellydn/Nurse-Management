//
//  FXDay.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXCalendarData.h"
#import "AppDelegate.h"
#import "CDShiftCategory.h"
#import "CDShift.h"
#import "ShiftCategoryItem.h"

@interface FXDay : NSObject

@property (nonatomic) BOOL isCurrent;
@property (nonatomic) BOOL isOutOfDay;
@property (nonatomic) BOOL isSelect;

@property (nonatomic) int dayIndex;
@property (nonatomic) int monthIndex;
@property (nonatomic) int yearIndex;
@property (nonatomic) int weekDayIndex;

@property (nonatomic) NSDate *date;

@property (nonatomic, strong) ShiftCategoryItem *shiftCategory;

@end
