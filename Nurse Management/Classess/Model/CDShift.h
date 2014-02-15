//
//  CDShift.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDShiftCategory;

@interface CDShift : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSTimeInterval onDate;
@property (nonatomic) int32_t shiftCategoryId;
@property (nonatomic) NSTimeInterval timeEnd;
@property (nonatomic) NSTimeInterval timeStart;
@property (nonatomic, retain) CDShiftCategory *fk_shift_category;

@end
