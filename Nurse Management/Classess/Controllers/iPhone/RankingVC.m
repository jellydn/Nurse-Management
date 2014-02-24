//
//  RankingVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "RankingVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "Define.h"

@interface RankingVC ()
{
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
}
- (IBAction)backVC:(id)sender;

@end

@implementation RankingVC

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
    //load webview
    NSString* url = URL_WS_RANKING;
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl];
    [_webViewContent loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"転職ランキング";
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webViewContent.hidden = YES;
    _indicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    _webViewContent.hidden = NO;
    _indicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _webViewContent.hidden = NO;
    _indicator.hidden = YES;
}



@end
