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

#import "AddShiftVC.h"
#import "FXNavigationController.h"

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
    [self switchChanged:switcher];
    cell.swichShift.transform = CGAffineTransformMakeScale(0.8, 0.65);
    return cell;
}
-(void) switchChanged:(id)sender {
    UISwitch* switcher = (UISwitch*)sender;
    BOOL value = switcher.on;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"edit shift");
}
@end
