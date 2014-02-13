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
#import "AddShiftView.h"
#import "AddScheduleView.h"

#import "RankingVC.h"
#import "MoreVC.h"
#import "ListShiftPatternVC.h"
#import "ScheduleCategoryVC.h"

@interface HomeVC ()<HomeNaviBarViewDelegate, HomeToolBarViewDelegate, AddShiftViewDelegate, AddScheduleViewDelegate>
{
    HomeNaviBarView *_naviView ;
    HomeToolBarView *_toolBarView;
    
    AddShiftView    *_addShiftView;
    AddScheduleView *_addScheduleView;
    
    BOOL _isShowAddShiftView, _isShowAddScheduleView;
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
    [self loadHomeAddShiftView];
    [self loadHomeAddScheduleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        [self loadHomeNaivBar];
        [self loadHomeToolBar];
        [self loadHomeAddShiftView];
        [self loadHomeAddScheduleView];
    }
}


#pragma mark - Others

- (void)loadHomeNaivBar
{
    if (_naviView) {
        [_naviView removeFromSuperview];
        _naviView = nil;
    }
    
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
    if (_toolBarView) {
        [_toolBarView removeFromSuperview];
        _toolBarView = nil;
    }
    
    _toolBarView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeToolBar]
                                                                    owner:self
                                                                  options:nil][0];
    _toolBarView.delegate           = self;
    _toolBarView.frame              = CGRectMake(0, self.view.frame.size.height - 49, 320, 49);
    _toolBarView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    [self.view addSubview:_toolBarView];
}

- (void)loadHomeAddShiftView
{
    if (_addShiftView) {
        [_addShiftView removeFromSuperview];
        _addShiftView = nil;
    }
    
    _addShiftView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddShift]
                                                                    owner:self
                                                                  options:nil][0];
    _addShiftView.delegate           = self;
    _addShiftView.frame = CGRectMake(0, self.view.frame.size.height, 320, 200);
    
    [self.view addSubview:_addShiftView];
}

- (void)loadHomeAddScheduleView
{
    if (_addScheduleView) {
        [_addScheduleView removeFromSuperview];
        _addScheduleView = nil;
    }
    
    _addScheduleView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddSchedule]
                                                                     owner:self
                                                                   options:nil][0];
    _addScheduleView.delegate           = self;
    _addScheduleView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_addScheduleView initLayoutView];
    
    [self.view addSubview:_addScheduleView];
    
}

#pragma mark - HomeNaviBarViewDelegate
- (void) homeNaviBarViewDidSelectToDay:(HomeNaviBarView*)homeNaviBarView
{
    NSLog(@"select today");
}

- (void) homeNaviBarViewDidSelectMail:(HomeNaviBarView*)homeNaviBarView
{
    NSLog(@"send mail");
    
    ListMembersVC *listMembers = [[ListMembersVC alloc] init];
    [self.navigationController pushViewController:listMembers animated:YES];
}

#pragma mark - HomeToolBarViewDelegate 
- (void) homeToolBarView:(HomeToolBarView*) homeToolBarView didSelectWithIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [self showAddShift];
            break;
        }
        case 1:
        {
            [_addScheduleView show];
            break;
        }
        case 2:
        {
            RankingVC *rankingVC = [[RankingVC alloc] init];
            [self.navigationController pushViewController:rankingVC animated:YES];
            
            break;
        }
        case 3:
        {
            MoreVC *moreVC = [[MoreVC alloc] init];
            [self.navigationController pushViewController:moreVC animated:YES];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Add Shift
- (void) showAddShift
{
    if (_isShowAddShiftView) {
        return;
    }
    
    CGRect rect = _addShiftView.frame;
    rect.origin.y -= _addShiftView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _addShiftView.frame = rect;
    } completion:^(BOOL finished) {
        _isShowAddShiftView = YES;
    }];
}

- (void) hideAddShift
{
    if (!_isShowAddShiftView) {
        return;
    }
    
    CGRect rect     = _addShiftView.frame;
    rect.origin.y   += _addShiftView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _addShiftView.frame = rect;
    } completion:^(BOOL finished) {
        _isShowAddShiftView = NO;
    }];
}

#pragma mark - AddShiftViewDelegate
- (void) addShiftView:(AddShiftView*)addShiftView didSelectWithIndex:(int)index
{
    NSLog(@"Add Shift select item with index: %d", index);
}

- (void) addShiftViewDidSelectShowListShiftPattern:(AddShiftView*)addShiftView
{
    ListShiftPatternVC *vc = [[ListShiftPatternVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) addShiftViewDidSelectCloseView:(AddShiftView*)addShiftView
{
    [self hideAddShift];
}

#pragma mark - AddScheduleViewDelegate 
- (void) didShowCategoryName:(AddScheduleView*)addScheduleView
{
    ScheduleCategoryVC *vc = [[ScheduleCategoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) didShowView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = YES;
}

- (void) didHideView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = NO;
}


























@end
