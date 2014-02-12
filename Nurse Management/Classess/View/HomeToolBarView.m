//
//  HomeToolBarView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "HomeToolBarView.h"

@interface HomeToolBarView ()

@end

@implementation HomeToolBarView

- (IBAction)selectItem:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeToolBarView:didSelectWithIndex:)]) {
        UIButton *button = (UIButton*)sender;
        [_delegate homeToolBarView:self didSelectWithIndex:button.tag];
    }
}

@end
