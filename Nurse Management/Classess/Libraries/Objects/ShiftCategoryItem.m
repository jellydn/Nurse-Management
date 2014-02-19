//
//  ShiftCategoryItem.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ShiftCategoryItem.h"

@implementation ShiftCategoryItem

- (void)setColor:(NSString *)color
{
    _color     = color;
    _textColor = [UIColor colorWithRed:91/255.0 green:80/255.0 blue:77/255.0 alpha:1.0];
    
    if ([color isEqualToString:@"0"]) {
        
        _image = @"icon_r1_c1.png";
        
    } else if ([color isEqualToString:@"1"]) {
        
        _image = @"icon_r1_c3.png";
        
    } else if ([color isEqualToString:@"2"]) {
        
        _image = @"icon_r1_c5.png";
        
    } else if ([color isEqualToString:@"3"]) {
        
        _image = @"icon_r1_c7.png";
        
    } else if ([color isEqualToString:@"4"]) {
        
        _image = @"icon_r1_c9.png";
        
    } else if ([color isEqualToString:@"5"]) {
        
        _image = @"icon_r3_c1.png";
        _textColor = [UIColor whiteColor];
        
    } else if ([color isEqualToString:@"6"]) {
        
        _image = @"icon_r3_c3.png";
        _textColor = [UIColor whiteColor];
        
    } else if ([color isEqualToString:@"7"]) {
        
        _image = @"icon_r3_c5.png";
        _textColor = [UIColor whiteColor];
        
    } else if ([color isEqualToString:@"8"]) {
        
        _image = @"icon_r3_c7.png";
        
    } else if ([color isEqualToString:@"9"]) {
        
        _image = @"icon_r3_c9.png";
        
    }
}

+ (ShiftCategoryItem*) convertForCDObject:(CDShiftCategory*)cdShiftCategory
{
    ShiftCategoryItem *item = [[ShiftCategoryItem alloc] init];
    
    item.shiftCategoryID = cdShiftCategory.id;
    item.name            = cdShiftCategory.name;
    item.color           = cdShiftCategory.color;
    item.strTimeEnd      = cdShiftCategory.timeEnd;
    item.strTimeStart    = cdShiftCategory.timeStart;
    item.isAllDay        = cdShiftCategory.isAllDay;
    
    return item;
}

@end
