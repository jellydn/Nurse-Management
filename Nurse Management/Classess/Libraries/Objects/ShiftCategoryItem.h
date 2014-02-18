//
//  ShiftCategoryItem.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShiftCategoryItem : NSObject

@property (nonatomic, strong)   NSString * color;
@property (nonatomic) int       shiftCategoryID;
@property (nonatomic) BOOL      isAllDay;
@property (nonatomic, strong)   NSString * name;
@property (nonatomic)           NSTimeInterval timeEnd;
@property (nonatomic)           NSTimeInterval timeStart;

@property (nonatomic, strong)   NSString *image;
@property (nonatomic, strong)   UIColor *textColor;

@end
