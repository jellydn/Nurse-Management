//
//  CDScheduleCategory.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDSchedule;

@interface CDScheduleCategory : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isDefault;
@property (nonatomic) BOOL isEnable;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CDSchedule *pk_schedulecategory;

@end
