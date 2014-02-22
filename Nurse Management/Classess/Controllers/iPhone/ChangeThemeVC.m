//
//  ChangeThemeVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ChangeThemeVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"

@interface ChangeThemeVC ()<UIScrollViewDelegate>
{
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIPageControl *_pageControll;
    __weak IBOutlet UILabel *_lbThemeTitleName;
    
    NSArray *_themeTitleName;
}
- (IBAction)backVC:(id)sender;
- (IBAction)selectTheme:(id)sender;

@end

@implementation ChangeThemeVC

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


- (IBAction)selectTheme:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSLog(@"select theme %d : %@", button.tag, _themeTitleName[button.tag]);
    
    switch (button.tag) {
        case 0:
        {
            [[FXThemeManager shared] changeThemeWithName:_fxThemeNameDefault];
            break;
        }
        case 1:
        {
            [[FXThemeManager shared] changeThemeWithName:_fxThemeNameDefaultGreen];
            break;
        }
        case 2:
        {
            [[FXThemeManager shared] changeThemeWithName:_fxThemeNameDefaultOrange];
            break;
        }
        case 3:
        {
            [[FXThemeManager shared] changeThemeWithName:_fxThemeNameDefaultPink];
            break;
        }
        case 4:
        {
            [Common showAlert:@"No support." title:APP_NAME];
            break;
        }
        case 5:
        {
            [Common showAlert:@"No support." title:APP_NAME];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"カレンダーテーマ設定";
    
    [_scrollView setContentSize:CGSizeMake(320*6, 0)];
    
    _themeTitleName = @[@"SimpleBlue",
                        @"SimpleGreen",
                        @"SimpleOrange",
                        @"SimplePink",
                        @"Girlie",
                        @"Sweet"];
    
    [self setThemeWith:0];
}

#pragma mark - Others

- (void) setThemeWith:(int)page
{
    _pageControll.currentPage   = page;
    _lbThemeTitleName.text      = _themeTitleName[page];
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self setThemeWith:scrollView.contentOffset.x / 320];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     [self setThemeWith:scrollView.contentOffset.x / 320];
}









@end
