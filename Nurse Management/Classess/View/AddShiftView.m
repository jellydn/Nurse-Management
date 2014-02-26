//
//  AddShiftView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddShiftView.h"
#import "ShiftCategoryItem.h"
#import "FXThemeManager.h"
#import <QuartzCore/QuartzCore.h>

@interface AddShiftView ()

@end

@implementation AddShiftView

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMaskView) name:@"hide_mask_view_addShiftView" object:nil];
    
    _viewMask.alpha = 0;
}

- (void)hideMaskView
{
        
    _viewMask.alpha = 0;
    NSLog(@"fdav _viewMask.hidden = YES;");
    
}

- (IBAction)selectItem:(id)sender
{
    NSLog(@"fdaf _viewMask.hidden = no;");
    
    _viewMask.alpha = 0.5;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_delegate && [_delegate respondsToSelector:@selector(addShiftView:didSelectWithIndex:)]) {
                UIButton *button = (UIButton*)sender;
                
                [_delegate addShiftView:self didSelectWithIndex:(int)button.tag - 100];
                
            }else {
                _viewMask.alpha = 0;
            }

        });
    });
    
}

- (IBAction)showListShiftPattern:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(addShiftViewDidSelectShowListShiftPattern:)]) {
        [_delegate addShiftViewDidSelectShowListShiftPattern:self];
    }
}

- (IBAction)closeAddShiftView:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(addShiftViewDidSelectCloseView:)]) {
        [_delegate addShiftViewDidSelectCloseView:self];
    }
}

#pragma mark - Public method
- (void) loadInfoWithShiftCategories:(NSMutableArray*)shifts
{
    NSLog(@"total %d", (int)[shifts count]);
    
    for (UIView *view in _scrollView.subviews) {
        if (view.tag > 99) {
            [view removeFromSuperview];
        }
    }
    
    [_btClose setTitleColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorAddShiftButton] forState:UIControlStateNormal];
    _btClose.layer.borderWidth = 1.0;
    _btClose.layer.borderColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorAddShiftButton].CGColor;
    [_btClose.layer setCornerRadius:6.0];
    _btClose.layer.masksToBounds = YES;
    
    //_pageControl.currentPageIndicatorTintColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorMain];
    
    int page                    = ([shifts count] % 10 == 0) ? (int)[shifts count] / 10  : (int)[shifts count] / 10 + 1;
    _pageControl.numberOfPages  = page;
    _pageControl.currentPage    = 0;
    
    [_scrollView setContentSize:CGSizeMake(320 * page, 140)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    CGRect rect = CGRectMake(15, 27, 50, 44);
    int temp = 0;
    
    for (ShiftCategoryItem *item in shifts) {

        UIButton *button            = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font      = [UIFont systemFontOfSize:15.0];
        button.tag                  = item.shiftCategoryID + 100;
        [button setTitle:item.name forState:UIControlStateNormal];
        [button setTitleColor:item.textColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:item.image] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        
        rect.origin.x = (temp / 10) * 320 + (temp % 5) * 60 + 15;
        rect.origin.y = (temp % 10) >= 5 ? 89 : 27;
        
        button.frame = rect;
        
        temp++;
        
        [_scrollView addSubview:button];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) {
        _pageControl.currentPage = scrollView.contentOffset.x / 320;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / 320;
}


@end
