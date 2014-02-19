//
//  CDScheduleAlert.h
//  Nurse Management
//
//  Created by PhuNQ on 2/19/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDSchedule;

@interface CDScheduleAlert : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) NSTimeInterval onTime;
@property (nonatomic) int32_t scheduleId;
@property (nonatomic, retain) CDSchedule *fk_alert_schedule;

@end
