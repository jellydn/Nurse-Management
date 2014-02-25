//
//  FXViewController.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXThemeManager.h"
#import "Define.h"
#import "GAITrackedViewController.h"

typedef void (^FXReloadThemeOfView)(NSString *themeName);

@interface FXViewController : GAITrackedViewController

@property (nonatomic) BOOL isHideNaviBarWhenBack;
@property (nonatomic, strong) FXReloadThemeOfView blockReloadThemeOfView;

@property (nonatomic, weak) IBOutlet UIButton        *btBack;
@property (nonatomic, weak) IBOutlet UILabel         *lbTile;
@property (nonatomic, weak) IBOutlet UIView          *viewNavi;

- (void) setBlockReloadThemeOfView:(FXReloadThemeOfView)blockReloadThemeOfView;

- (void) loadHomeNaivBar;
- (void) enableNaviBarDefault;

- (void) enableBackButtonWithHideNaviBar:(BOOL)isHideNaviBarWhenBack;

- (void)eventListenerDidReceiveNotification:(NSNotification *)notif;

@end
