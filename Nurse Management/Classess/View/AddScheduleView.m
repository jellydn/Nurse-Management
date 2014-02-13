//
//  AddScheduleView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddScheduleView.h"

@interface AddScheduleView ()

@end

@implementation AddScheduleView

- (void) initLayoutView
{
    _viewMask.alpha = 0;
    
    CGRect rect             = _viewContainer.frame;
    rect.origin.y          += rect.size.height;
    _viewContainer.frame    = rect;
    
    self.hidden = YES;
}

- (void) show
{
    self.hidden = NO;
    
    CGRect rect = _viewContainer.frame;
    rect.origin.y -= rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewMask.alpha = 0.5;
        _viewContainer.frame = rect;
        
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(didShowView:)]) {
            [_delegate didShowView:self];
        }
    }];
}

- (void) hide
{
    
    CGRect rect     = _viewContainer.frame;
    rect.origin.y   += rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewMask.alpha = 0;
        _viewContainer.frame = rect;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(didHideView:)]) {
            [_delegate didHideView:self];
        }
    }];
}

#pragma mark - Touch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch= [touches anyObject];
    if ([touch view] == _viewMask)
    {
        [self hide];
    }
}

#pragma mark - Action

- (IBAction)selectCategory:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didShowCategoryName:)]) {
        [_delegate didShowCategoryName:self];
    }
}

- (IBAction)choiceTime:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didChoiceTime:)]) {
        [_delegate didChoiceTime:self];
    }
}



















@end
