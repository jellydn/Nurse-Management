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
#import "HomeToolBarView.h"

@interface HomeVC ()<HomeNaviBarViewDelegate, HomeToolBarViewDelegate>
{
    HomeNaviBarView *_naviView ;
    HomeToolBarView *_toolBarView;
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
    [self loadHomeToolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Others

- (void)loadHomeNaivBar
{
    int detalIOS = [Common isIOS7] ? 0 : - 20;
    
    _naviView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeNaviBar]
                                                                 owner:self
                                                               options:nil][0];
    _naviView.delegate           = self;
    _naviView.frame              = CGRectMake(0, detalIOS, 320, 64);
    _naviView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    [self.view addSubview:_naviView];
    
    NSDate *date = [NSDate date];
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
}

- (void)loadHomeToolBar
{
    _toolBarView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeToolBar]
                                                                    owner:self
                                                                  options:nil][0];
    _toolBarView.delegate           = self;
    _toolBarView.frame              = CGRectMake(0, self.view.frame.size.height - 49, 320, 49);
    _toolBarView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    [self.view addSubview:_toolBarView];
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

#pragma mark - HomeToolBarViewDelegate 
- (void) homeToolBarView:(HomeToolBarView*) homeToolBarView didSelectWithIndex:(int)index
{
    NSLog(@"Toolbar select item: %d", index);
}



@end
