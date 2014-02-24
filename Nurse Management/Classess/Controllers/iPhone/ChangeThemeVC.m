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
    
    __weak IBOutlet UIView          *_viewNavi;
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIPageControl *_pageControll;
    __weak IBOutlet UILabel *_lbThemeTitleName;
    
    NSArray *_themeTitleName, *_themeName;
    int _pageCurrent;
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
    int index = button.tag;
    
    int page = (_scrollView.contentOffset.x - 50) / 200;
    if (page != button.tag) {
        [self setThemeWith:button.tag];
        
        [_scrollView setContentOffset:CGPointMake(button.tag* 200 + 50, 0) animated:YES];
        index = -1;
    }
    
    switch (index) {
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
            [[FXThemeManager shared] changeThemeWithName:_fxThemeNameGirlie];
            break;
        }
        case 5:
        {
            [[FXThemeManager shared] changeThemeWithName:_fxThemeNameSweet];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor   = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    self.lbTile.text = @"カレンダーテーマ設定";
    
    [_scrollView setContentSize:CGSizeMake(1400, 0)];
    
    
    _themeTitleName = @[@"SimpleBlue",
                        @"SimpleGreen",
                        @"SimpleOrange",
                        @"SimplePink",
                        @"Girlie",
                        @"Sweet"];
    
    _themeName = @[@"_fxThemeNameDefault",
                   @"_fxThemeNameDefaultGreen",
                   @"_fxThemeNameDefaultOrange",
                   @"_fxThemeNameDefaultPink",
                   @"_fxThemeNameGirlie",
                   @"_fxThemeNameSweet"];
    
    [self setThemeWith:[_themeName indexOfObject:[FXThemeManager shared].themeName]];
    [_scrollView setContentOffset:CGPointMake([_themeName indexOfObject:[FXThemeManager shared].themeName]*200 + 50, 0)];
}

#pragma mark - Others

- (void) setThemeWith:(int)page
{
    _pageControll.currentPage   = page;
    _lbThemeTitleName.text      = _themeTitleName[page];
    _pageCurrent = page;
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    [super eventListenerDidReceiveNotification:notif];
    
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor   = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
        int page = (scrollView.contentOffset.x - 50) / 200;
        [_scrollView setContentOffset:CGPointMake(page* 200 + 50, 0) animated:YES];
        [self setThemeWith:page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x - 50) / 200;
    [_scrollView setContentOffset:CGPointMake(page* 200 + 50, 0) animated:YES];
    
    [self setThemeWith:page];
}








@end
