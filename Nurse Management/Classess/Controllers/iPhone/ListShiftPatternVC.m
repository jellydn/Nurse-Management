//
//  ListShiftPatternVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ListShiftPatternVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"

#import "AddShiftVC.h"
#import "FXNavigationController.h"

@interface ListShiftPatternVC ()
{
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
}
- (IBAction)backVC:(id)sender;
- (IBAction)addShift:(id)sender;

@end

@implementation ListShiftPatternVC

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
    [self configView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addShift:(id)sender {
    AddShiftVC *vc                  = [[AddShiftVC alloc] init];
    vc.date                         = [NSDate date];
    
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"シフトパターン一覧";
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}


@end
