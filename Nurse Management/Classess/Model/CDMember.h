//
//  CDMember.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDShiftMember;

@interface CDMember : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isDisplay;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CDShiftMember *pk_member;

@end
