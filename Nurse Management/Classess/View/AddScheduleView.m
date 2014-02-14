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
    CGRect rect2            = _viewTime.frame;
    
    rect.origin.y           += rect.size.height;
    rect2.origin.y          += rect.size.height;
    
    _viewContainer.frame    = rect;
    _viewTime.frame         = rect2;
    
    self.hidden = YES;
}

- (void) show
{
    self.hidden = NO;
    
    CGRect rect = _viewContainer.frame;
    CGRect rect2    = _viewTime.frame;
    
    rect.origin.y -= rect.size.height;
    rect2.origin.y  -= rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewMask.alpha = 0.5;
        _viewContainer.frame = rect;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(didShowView:)]) {
            [_delegate didShowView:self];
        }
    }];
}

- (void) hide
{
    
    CGRect rect     = _viewContainer.frame;
    CGRect rect2    = _viewTime.frame;
    
    rect.origin.y   += rect.size.height;
    rect2.origin.y  += rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewMask.alpha = 0;
        _viewContainer.frame = rect;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        
        CGRect rect     = _viewContainer.frame;
        CGRect rect2    = _viewTime.frame;
        
        rect.origin.x = 0;
        rect2.origin.x = 320;
        
        _viewContainer.frame = rect;
        _viewTime.frame = rect2;
        
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
    
    CGRect rect1 = _viewContainer.frame;
    CGRect rect2 = _viewTime.frame;
    
    rect1.origin.x -= 320;
    rect2.origin.x -= 320;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewContainer.frame = rect1;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)backChoiceCategory:(id)sender
{
    CGRect rect1 = _viewContainer.frame;
    CGRect rect2 = _viewTime.frame;
    
    rect1.origin.x += 320;
    rect2.origin.x += 320;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _viewContainer.frame = rect1;
        _viewTime.frame = rect2;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)saveSchedule:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSaveSchedule:)]) {
        [_delegate didSaveSchedule:self];
    }
    
    [self hide];
}



















@end
