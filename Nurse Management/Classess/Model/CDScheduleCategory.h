//
//  CDScheduleCategory.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/20/14.
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
@property (nonatomic, retain) NSSet *pk_schedulecategory;
@end

@interface CDScheduleCategory (CoreDataGeneratedAccessors)

- (void)addPk_schedulecategoryObject:(CDSchedule *)value;
- (void)removePk_schedulecategoryObject:(CDSchedule *)value;
- (void)addPk_schedulecategory:(NSSet *)values;
- (void)removePk_schedulecategory:(NSSet *)values;

@end
