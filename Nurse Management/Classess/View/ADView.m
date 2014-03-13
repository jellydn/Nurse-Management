//
//  ADView.m
//  Nurse Management
//
//  Created by Tien Le Phuong on 3/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ADView.h"
#import "Define.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"

@interface ADView ()

@end

@implementation ADView


#pragma mark - public mehtod
- (void) initADView
{
    NSURLRequest *request       = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL_WEB_AD_BANER]];
    [_webView loadRequest:request];
    
    _btOpen.layer.cornerRadius              = 10;
    _btOpen.layer.masksToBounds             = YES;
    
    _viewContainerWeb.layer.cornerRadius    = 10;
    _viewContainerWeb.layer.masksToBounds   = YES;
    
    self.alpha = 0;
    
    if (![Common checkScreenIPhone5]) {
        for (UIView *view in self.subviews) {
            CGRect rect     = view.frame;
            rect.origin.y   -= 40;
            view.frame      = rect;
        }
    }
}

- (void) show
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hide
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Action
- (IBAction)closeAdView:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(adViewDidClose:)]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [_delegate adViewDidClose:self];
        }];
    }
}

- (IBAction)openUrlAD:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_WEB_AD_OPENT_SAFARI]];
    }];
}


@end
