//
//  CDShift.m
//  Nurse Management
//
//  Created by PhuNQ on 2/19/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "CDShift.h"
#import "CDMember.h"
#import "CDShiftAlert.h"
#import "CDShiftCategory.h"


@implementation CDShift

@dynamic id;
@dynamic isAllDay;
@dynamic memo;
@dynamic name;
@dynamic onDate;
@dynamic shiftCategoryId;
@dynamic timeEnd;
@dynamic timeStart;
@dynamic fk_shift_category;
@dynamic pk_shift;
@dynamic pk_shiftalert;

@end
