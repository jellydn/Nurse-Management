//
//  HomeNaviBarView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "HomeNaviBarView.h"

@interface HomeNaviBarView ()

@end

@implementation HomeNaviBarView



#pragma mark - Action
- (IBAction)toDay:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeNaviBarViewDidSelectToDay:)]) {
        [_delegate homeNaviBarViewDidSelectToDay:self];
    }
}

- (IBAction)sendMail:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(homeNaviBarViewDidSelectMail:)]) {
        [_delegate homeNaviBarViewDidSelectMail:self];
    }
}

#pragma mark - Public method

- (void) setTitleWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    _lbDay.text = [NSString stringWithFormat:@"%ld",(long)month];
    _lbYear.text = [NSString stringWithFormat:@"%ld",(long)year];
    
    NSArray *months = @[@"January",
                        @"February",
                        @"March",
                        @"April",
                        @"May",
                        @"June",
                        @"July",
                        @"August",
                        @"September",
                        @"October",
                        @"November",
                        @"December",];
    
    _lbMonth.text = months[month-1];
}



@end
