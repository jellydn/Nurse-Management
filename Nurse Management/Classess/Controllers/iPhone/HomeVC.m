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

#import "FXCalendarView.h"
#import "ListMembersVC.h"

#import "HomeCellAddShift.h"
#import "HomeCellAddSchedule.h"
#import "HomeCellSchedule.h"
#import "AddScheduleVC.h"
#import "FXNavigationController.h"
#import "AddShiftVC.h"

@interface HomeVC ()<HomeNaviBarViewDelegate, HomeToolBarViewDelegate, AddShiftViewDelegate, AddScheduleViewDelegate, FXCalendarViewDelegate>
{
    HomeNaviBarView *_naviView ;
    HomeToolBarView *_toolBarView;
    
    AddShiftView    *_addShiftView;
    AddScheduleView *_addScheduleView;
    
    FXCalendarView  *_calendarView;
    
    __weak IBOutlet UITableView *_tableView;
    
    BOOL _isShowAddShiftView, _isShowAddScheduleView;
}

@property (nonatomic, strong) NSDate *selectDate;

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
    
    _selectDate = [NSDate date];
    
    [self loadCalendar];
    [self resetLayoutTableWithAnimate:NO];
    [self.view bringSubviewToFront:_tableView];
    
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

- (void) loadCalendar
{
    int detalIOS = [Common isIOS7] ? 0 : - 20;
    
    _calendarView                   = [[NSBundle mainBundle] loadNibNamed:@"FXCalendarView" owner:self options:nil][0];
    _calendarView.delegate          = self;
    _calendarView.frame             = CGRectMake(0, 64 + detalIOS, 320, 350);
    [_calendarView initCalendar];
    
    [self.view addSubview:_calendarView];
}

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
    
    float detalIOS = [Common isIOS7] ? 0 : 20;
    float height   = [Common checkScreenIPhone5] ? 568 : 480;
    
    _toolBarView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeToolBar]
                                                                    owner:self
                                                                  options:nil][0];
    _toolBarView.delegate           = self;
    _toolBarView.frame              = CGRectMake(0, height - detalIOS - 49, 320, 49);
    _toolBarView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    [self.view addSubview:_toolBarView];
}

- (void)loadHomeAddShiftView
{
    if (_addShiftView) {
        [_addShiftView removeFromSuperview];
        _addShiftView = nil;
    }
    
    float detalIOS = [Common isIOS7] ? 0 : 20;
    float height   = [Common checkScreenIPhone5] ? 568 : 480;
    
    _addShiftView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddShift]
                                                                    owner:self
                                                                  options:nil][0];
    _addShiftView.delegate           = self;
    _addShiftView.frame = CGRectMake(0, height - detalIOS, 320, 200);
    
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
    NSDate *date = [NSDate date];
    _selectDate = date;
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    
    [_calendarView reloadToday];
}

- (void) homeNaviBarViewDidSelectMail:(HomeNaviBarView*)homeNaviBarView
{
    NSLog(@"send mail");

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

- (void) didSaveSchedule:(AddScheduleView*)addScheduleView
{
    NSLog(@"save schedule");
}

- (void) didShowView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = YES;
}

- (void) didHideView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = NO;
}


#pragma mark - FXCalendarViewDelegate
- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didChangeMonthWithFirstDay:(NSDate*)date
{
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    _selectDate = date;
    [self resetLayoutTableWithAnimate:YES];
}

- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didSelectDay:(NSDate*)date
{
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    _selectDate = date;
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_tableView reloadData];
}

#pragma mark - Table view
- (void) resetLayoutTableWithAnimate:(BOOL)isAnimate
{
    float detalIOS      = [Common isIOS7] ? 0 : 20;
    float height        = [Common checkScreenIPhone5] ? 568 : 480;
    
    CGRect rect = CGRectMake(0,
                             [_calendarView heightCalendarWithCurrentMonth] + 64 - detalIOS ,
                             320,
                             height - 49 - [_calendarView heightCalendarWithCurrentMonth]);
    
    if (isAnimate) {
        [UIView animateWithDuration:0.3 animations:^{
            
            _tableView.frame = rect;
            
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _tableView.frame = rect;
    }
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2) {
        return 44;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    } else if (section == 2) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        HomeCellAddShift *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellAddShift"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCellAddShift" owner:self options:nil] lastObject];
        }
        
        
        [cell loadInfoWithNSDate:_selectDate isAddShift:(arc4random() % (1-0+1)) + 0];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        HomeCellAddSchedule *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellAddSchedule"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCellAddSchedule" owner:self options:nil] lastObject];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        HomeCellSchedule *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellSchedule"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCellSchedule" owner:self options:nil] lastObject];
        }
        
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action
- (IBAction)addShift:(id)sender
{
    NSLog(@"show view Add shift");
    
    AddShiftVC *addShiftVC = [[AddShiftVC alloc] init];
    FXNavigationController *nc = [[FXNavigationController alloc] initWithRootViewController:addShiftVC];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)editShif:(id)sender
{
    NSLog(@"show view Edit shift");
    
    AddShiftVC *addShiftVC = [[AddShiftVC alloc] init];
    FXNavigationController *nc = [[FXNavigationController alloc] initWithRootViewController:addShiftVC];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)addSchedule:(id)sender {
    AddScheduleVC *vc                  = [[AddScheduleVC alloc] init];
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];

}


















@end
