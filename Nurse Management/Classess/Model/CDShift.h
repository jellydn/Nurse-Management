//
//  CDShift.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDShiftAlert, CDShiftCategory, CDShiftMember;

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
@property (nonatomic, retain) NSSet *pk_shift;
@property (nonatomic, retain) NSSet *pk_shiftalert;
@end

@interface CDShift (CoreDataGeneratedAccessors)

- (void)addPk_shiftObject:(CDShiftMember *)value;
- (void)removePk_shiftObject:(CDShiftMember *)value;
- (void)addPk_shift:(NSSet *)values;
- (void)removePk_shift:(NSSet *)values;

- (void)addPk_shiftalertObject:(CDShiftAlert *)value;
- (void)removePk_shiftalertObject:(CDShiftAlert *)value;
- (void)addPk_shiftalert:(NSSet *)values;
- (void)removePk_shiftalert:(NSSet *)values;

@end
