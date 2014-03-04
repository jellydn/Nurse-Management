//
//  HomeNaviBarView.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "HomeNaviBarView.h"
#import "FXThemeManager.h"

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

- (void) initNavi
{
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
    
    NSDictionary *fonts = [[FXThemeManager shared].themeData objectForKey:@"fonts"];
    NSString *fontName = [fonts objectForKey:@"navi"];
    
    if (fontName && ![fontName isEqualToString:@""]) {
        int size = [[fonts objectForKey:@"naviSize"] integerValue];
        
         NSLog(@"font name: %@ --- size: %d", fontName, size);
        
        //_lbDay.font     = [UIFont fontWithName:fontName size:15];
        _lbMonth.font   = [UIFont fontWithName:fontName size:size];
        //_lbYear.font    = [UIFont fontWithName:fontName size:15];
        
    } else {
        NSLog(@"User fonts default");
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
