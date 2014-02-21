//
//  OtherAppCell.m
//  MovingHouse
//
//  Created by Nick Lee on 4/4/13.
//  Copyright (c) 2013 tienlp. All rights reserved.
//

#import "OtherAppCell.h"
#import <QuartzCore/QuartzCore.h>

@interface OtherAppCell ()

@end

@implementation OtherAppCell

- (void)setBorderImage
{
    _imgApp.layer.cornerRadius = 6.0f;
    _imgApp.layer.masksToBounds = TRUE;
}


@end
