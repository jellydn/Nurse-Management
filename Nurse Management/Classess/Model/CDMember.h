//
//  CDMember.h
//  Nurse Management
//
//  Created by PhuNQ on 2/19/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDShift;

@interface CDMember : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isDisplay;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *pk_shift;
@end

@interface CDMember (CoreDataGeneratedAccessors)

- (void)addPk_shiftObject:(CDShift *)value;
- (void)removePk_shiftObject:(CDShift *)value;
- (void)addPk_shift:(NSSet *)values;
- (void)removePk_shift:(NSSet *)values;

@end
