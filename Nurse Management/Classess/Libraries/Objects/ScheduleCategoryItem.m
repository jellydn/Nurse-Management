//
//  ScheduleCategoryItem.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/18/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ScheduleCategoryItem.h"

@implementation ScheduleCategoryItem

- (void)setColor:(NSString *)color
{
    _color      = color;
    _textColor  = [UIColor colorWithRed:91/255.0 green:80/255.0 blue:77/255.0 alpha:1.0];
    _image      = [NSString stringWithFormat:@"schedule_bg_%@.png",color];
}

@end
