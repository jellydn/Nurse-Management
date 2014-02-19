//
//  CDShiftCategory.h
//  Nurse Management
//
//  Created by PhuNQ on 2/19/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDShift;

@interface CDShiftCategory : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * timeEnd;
@property (nonatomic, retain) NSString * timeStart;
@property (nonatomic, retain) NSSet *pk_shiftcategory;
@end

@interface CDShiftCategory (CoreDataGeneratedAccessors)

- (void)addPk_shiftcategoryObject:(CDShift *)value;
- (void)removePk_shiftcategoryObject:(CDShift *)value;
- (void)addPk_shiftcategory:(NSSet *)values;
- (void)removePk_shiftcategory:(NSSet *)values;

@end
