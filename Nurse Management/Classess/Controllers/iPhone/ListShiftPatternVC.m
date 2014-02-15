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
#import "ShiftCell.h"
#import "EditShiftVC.h"
#import "AddShiftVC.h"
//#import "AddShiftCategoryVC.h"
#import "FXNavigationController.h"
#import "AddScheduleVC.h"
@interface ListShiftPatternVC ()<UITableViewDelegate, UITableViewDataSource>
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
    EditShiftVC *vc                  = [[EditShiftVC alloc] init];
    vc.date                         = [NSDate date];
    vc.typeShift                    = YES;
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
#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShiftCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShiftCell" owner:self options:nil] lastObject];
    }
    UISwitch* switcher = (UISwitch*)[cell.contentView viewWithTag:100];
    [switcher setOn:!switcher.on animated:YES];

    cell.swichShift.transform = CGAffineTransformMakeScale(0.8, 0.65);
    cell.swichShift.onTintColor = [UIColor colorWithRed:0.0/255.0 green:131.0/255.0 blue:234.0/255.0 alpha:1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddScheduleVC *vc                 = [[AddScheduleVC alloc] init];
  //  vc.typeShift                    = NO;
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];

}
@end
