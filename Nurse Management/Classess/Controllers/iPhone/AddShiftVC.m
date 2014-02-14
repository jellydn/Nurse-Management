//
//  AddShiftVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddShiftVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "FXCalendarData.h"

#define ALERT_BG_COLOR	 [UIColor colorWithRed:100.0/255.0 green:137.0/255.0 blue:199.0/255.0 alpha:1.0]

@interface AddShiftVC ()
{
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    
    __weak IBOutlet UIImageView *_imvAlertBG1;
    __weak IBOutlet UIImageView *_imvAlertBG2;
    __weak IBOutlet UIImageView *_imvAlertBG3;
    __weak IBOutlet UIImageView *_imvAlertBG4;
    __weak IBOutlet UIImageView *_imvAlertBG5;
    __weak IBOutlet UIImageView *_imvAlertBG6;
    
    __weak IBOutlet UILabel *_lblAlert1;
    __weak IBOutlet UILabel *_lblAlert2;
    __weak IBOutlet UILabel *_lblAlert3;
    __weak IBOutlet UILabel *_lblAlert4;
    __weak IBOutlet UILabel *_lblAlert5;
    __weak IBOutlet UILabel *_lblAlert6;
    
    __weak IBOutlet UIButton *_btnStartTime;
    __weak IBOutlet UIButton *_btnEndTime;
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)chooseAlert:(id)sender;
- (IBAction)chooseShiftCategory:(id)sender;
- (IBAction)chooseTimeMode:(id)sender;
- (IBAction)chooseTime:(id)sender;

@end

@implementation AddShiftVC

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

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)chooseAlert:(id)sender {
    
    switch ([sender tag]) {
        case 1:
            _imvAlertBG1.backgroundColor = ALERT_BG_COLOR;
            _lblAlert1.textColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

- (IBAction)chooseShiftCategory:(id)sender {
    
}

- (IBAction)chooseTimeMode:(id)sender {
    UIButton *btnAllDay = (UIButton *)sender;
    
    if ([btnAllDay tag] == 1) {
        
    }
}

- (IBAction)chooseTime:(id)sender {
    
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = [NSString stringWithFormat:@"%d月%d日",[FXCalendarData getDayWithDate:_date], [FXCalendarData getMonthWithDate:_date]];
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
