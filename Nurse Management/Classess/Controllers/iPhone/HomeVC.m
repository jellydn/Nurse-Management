//
//  HomeVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "HomeVC.h"
#import "FXThemeManager.h"
#import "Common.h"
#import "Define.h"
#import "FXCalendarData.h"

#import "HomeNaviBarView.h"

@interface HomeVC ()<HomeNaviBarViewDelegate>
{
    HomeNaviBarView *_naviView ;
}

@end

@implementation HomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadHomeNaivBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Others

- (void)loadHomeNaivBar
{
    if ([[FXThemeManager shared].themeName isEqualToString:_fxThemeNameDefault]) {
        
        int detalIOS = [Common isIOS7] ? 0 : - 20;
        
        _naviView                    = [[NSBundle mainBundle] loadNibNamed:@"HomeNaviBarView" owner:self options:nil][0];
        _naviView.delegate           = self;
        _naviView.frame              = CGRectMake(0, detalIOS, 320, 64);
        _naviView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
        
        [self.view addSubview:_naviView];
        
    }
    
    
    NSDate *date = [NSDate date];
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
}

#pragma mark - HomeNaviBarViewDelegate
- (void) homeNaviBarViewDidSelectToDay:(HomeNaviBarView*)homeNaviBarView
{
    NSLog(@"select today");
}

- (void) homeNaviBarViewDidSelectMail:(HomeNaviBarView*)homeNaviBarView
{
    NSLog(@"send mail");
}



@end
