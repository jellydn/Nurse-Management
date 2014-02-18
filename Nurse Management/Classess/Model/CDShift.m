//
//  CDShift.m
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/17/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "CDShift.h"
#import "CDShiftAlert.h"
#import "CDShiftCategory.h"
#import "CDShiftMember.h"


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
