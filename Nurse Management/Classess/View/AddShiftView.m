//
//  AddShiftView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddShiftView.h"

@interface AddShiftView ()

@end

@implementation AddShiftView

- (IBAction)selectItem:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(addShiftView:didSelectWithIndex:)]) {
        UIButton *button = (UIButton*)sender;
        [_delegate addShiftView:self didSelectWithIndex:button.tag];
    }
}


@end
