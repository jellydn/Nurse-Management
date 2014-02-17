//
//  CDShiftMember.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/17/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDMember, CDShift;

@interface CDShiftMember : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) int32_t memberId;
@property (nonatomic) int32_t shiftId;
@property (nonatomic, retain) NSSet *fk_member;
@property (nonatomic, retain) CDShift *fk_shift;
@end

@interface CDShiftMember (CoreDataGeneratedAccessors)

- (void)addFk_memberObject:(CDMember *)value;
- (void)removeFk_memberObject:(CDMember *)value;
- (void)addFk_member:(NSSet *)values;
- (void)removeFk_member:(NSSet *)values;

@end
