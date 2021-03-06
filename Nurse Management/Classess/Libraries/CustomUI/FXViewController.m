//
//  FXViewController.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXViewController.h"
#import "Common.h"

#import "HomeNaviBarView.h"

@interface FXViewController ()
{
    
}

@end

@implementation FXViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:_fxThemeNotificationChangeTheme
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:DID_ADD_SCHEDULE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:FIRST_OF_CALENDAR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventListenerDidReceiveNotification:)
                                                 name:OPEN_AD_VIEW
                                               object:nil];
    
    //set background
    if ([[FXThemeManager shared] getImageWithKey:_fxThemeImageBackground]) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[[FXThemeManager shared] getImageWithKey:_fxThemeImageBackground]];
    } else {
        self.view.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorBackground];
    }
    
    //set navi view
    if ([Common isIOS7]) {
        [self.navigationController.navigationBar setBarTintColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar]];
        
        if ([[FXThemeManager shared].themeName isEqualToString:_fxThemeNameGirlie] ||
            [[FXThemeManager shared].themeName isEqualToString:_fxThemeNameSweet]) {
            [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        } else {
            [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        }
        
    } else {
        [self.navigationController.navigationBar setTintColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar]];
    }
    
    // back button
    [_btBack setImage:[[FXThemeManager shared] getImageWithKey:_fxThemeImageBackButton]
             forState:UIControlStateNormal];
    
    // label title
    _lbTile.textColor           = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviTitle];
    
    _viewNavi.backgroundColor   = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    // barButton
    NSDictionary *tempDic = [[FXThemeManager shared].themeData objectForKey:_fxThemeBarButtons];
    
    [_btAdd setImage:[UIImage imageNamed:[tempDic objectForKey:@"add"]] forState:UIControlStateNormal];
    
    [_btCancel setBackgroundImage:[UIImage imageNamed:[tempDic objectForKey:@"background"]] forState:UIControlStateNormal];
    [_btCancel setTitleColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviTitle]
                    forState:UIControlStateNormal];
    
    [_btSave setBackgroundImage:[UIImage imageNamed:[tempDic objectForKey:@"background"]] forState:UIControlStateNormal];
    [_btSave setTitleColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviTitle]
                  forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_fxThemeNotificationChangeTheme object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_ADD_SCHEDULE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FIRST_OF_CALENDAR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPEN_AD_VIEW object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    
}

#pragma mark - Private method

- (void)backVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - Public mehtod

- (void)loadHomeNaivBar
{
    if ([[FXThemeManager shared].themeName isEqualToString:_fxThemeNameDefault]) {
        
        int detalIOS = [Common isIOS7] ? 0 : - 20;
        
        HomeNaviBarView *naviView   = [[NSBundle mainBundle] loadNibNamed:@"HomeNaviBarView" owner:self options:nil][0];
        naviView.frame              = CGRectMake(0, detalIOS, 320, 64);
        naviView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
        
        [self.view addSubview:naviView];
        
    }
}

- (void) enableNaviBarDefault
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void) enableBackButtonWithHideNaviBar:(BOOL)isHideNaviBarWhenBack
{
    
    _isHideNaviBarWhenBack = isHideNaviBarWhenBack;
    
    UIButton *btBack =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btBack setImage:[UIImage imageNamed:@"ic_bt_back.png"] forState:UIControlStateNormal];
    [btBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btBack addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [btBack setFrame:CGRectMake(0, 0, 38, 18)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btBack];
}

- (void) setBlockReloadThemeOfView:(FXReloadThemeOfView)blockReloadThemeOfView
{
    _blockReloadThemeOfView = blockReloadThemeOfView;
}

- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme]) {
        //set background
        if ([[FXThemeManager shared] getImageWithKey:_fxThemeImageBackground]) {
            self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[[FXThemeManager shared] getImageWithKey:_fxThemeImageBackground]];
        } else {
            self.view.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorBackground];
        }
        
        if ([Common isIOS7]) {
            [self.navigationController.navigationBar setBarTintColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar]];
            
            if ([[FXThemeManager shared].themeName isEqualToString:_fxThemeNameGirlie] ||
                [[FXThemeManager shared].themeName isEqualToString:_fxThemeNameSweet]) {
                [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
            } else {
                [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
            }
            
        } else {
            [self.navigationController.navigationBar setTintColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar]];
        }
        
        
        // back button
        [_btBack setImage:[[FXThemeManager shared] getImageWithKey:_fxThemeImageBackButton]
                 forState:UIControlStateNormal];
        
        // label title
        _lbTile.textColor           = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviTitle];
        
        _viewNavi.backgroundColor   = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
        
        // barButton
        NSDictionary *tempDic = [[FXThemeManager shared].themeData objectForKey:_fxThemeBarButtons];
        
        [_btAdd setImage:[UIImage imageNamed:[tempDic objectForKey:@"add"]] forState:UIControlStateNormal];
        
        [_btCancel setBackgroundImage:[UIImage imageNamed:[tempDic objectForKey:@"background"]] forState:UIControlStateNormal];
        [_btCancel setTitleColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviTitle]
                        forState:UIControlStateNormal];
        
        [_btSave setBackgroundImage:[UIImage imageNamed:[tempDic objectForKey:@"background"]] forState:UIControlStateNormal];
        [_btSave setTitleColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviTitle]
                      forState:UIControlStateNormal];
    }
}














@end
