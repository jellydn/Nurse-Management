//
//  ScheduleCategoryItem.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDScheduleCategory.h"

@interface ScheduleCategoryItem : NSObject

@property (nonatomic, strong) NSString * color;
@property (nonatomic) int  scheduleCategoryID;
@property (nonatomic) BOOL isDefault;
@property (nonatomic) BOOL isEnable;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong)   NSString *image;
@property (nonatomic, strong)   UIColor *textColor;

+ (ScheduleCategoryItem*) convertForCDObject:(CDScheduleCategory*)cdCategory;


@end
