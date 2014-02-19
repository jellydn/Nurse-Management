//
//  CDShiftMember.h
//  Nurse Management
//
//  Created by PhuNQ on 2/19/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDShiftMember : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) int32_t memberId;
@property (nonatomic) int32_t shiftId;

@end
