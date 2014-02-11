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
    
    //set background
    self.view.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorBackground];
    
    if ([Common isIOS7]) {
        [self.navigationController.navigationBar setBarTintColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar]];
    } else {
        [self.navigationController.navigationBar setTintColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
