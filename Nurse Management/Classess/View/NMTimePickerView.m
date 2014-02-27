//
//  NMTimePickerView.m
//  NurseManagementDemoControl
//
//  Created by phungduythien on 2/19/14.
//  Copyright (c) 2014 GreenGlobal. All rights reserved.
//

#import "NMTimePickerView.h"

#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithRed:215/255.0 green:224/255.0 blue:221/255.0 alpha:1.0]
#define DEFAULT_COLOR_BAR_BUTTON    [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0]
#define DEFAULT_FONT_BAR_BUTTON     [UIFont boldSystemFontOfSize:15.0]

#define DEFAULT_TINT_NAVI_BAR_COLOR [UIColor colorWithRed:101/255.0 green:135/255.0 blue:199/255.0 alpha:1.0]

@interface NMTimePickerView()

@property (nonatomic, retain) UIActionSheet     *actionSheet;

- (void)tapToCancel;
- (void)tapToDone;

@end

@implementation NMTimePickerView

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = nil;
        
        self.actionSheet = [[UIActionSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        
        self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.actionSheet addSubview:self.navigationBar];
        
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        [self.navigationBar pushNavigationItem:navigationItem animated:NO];        
        [self.navigationBar setTintColor:DEFAULT_BACKGROUND_COLOR];
        
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"肖去" style:UIBarButtonItemStylePlain target:self action:@selector(tapToCancel)];
        NSDictionary *attrTextCancel = [NSDictionary dictionaryWithObjectsAndKeys:
                                    DEFAULT_COLOR_BAR_BUTTON,NSForegroundColorAttributeName,
                                    DEFAULT_FONT_BAR_BUTTON,NSFontAttributeName,
                                    nil];
        [btnCancel setTitleTextAttributes:attrTextCancel
                                                    forState:UIControlStateNormal];
        [btnCancel setTintColor:DEFAULT_TINT_NAVI_BAR_COLOR];
          
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStylePlain target:self action:@selector(tapToDone)];
        NSDictionary *attrTextDone = [NSDictionary dictionaryWithObjectsAndKeys:
                                    DEFAULT_COLOR_BAR_BUTTON,NSForegroundColorAttributeName,
                                    DEFAULT_FONT_BAR_BUTTON,NSFontAttributeName,
                                    nil];
        [btnDone setTitleTextAttributes:attrTextDone
                                 forState:UIControlStateNormal];
        [btnDone setTintColor:DEFAULT_TINT_NAVI_BAR_COLOR];
       
        
        self.navigationBar.topItem.rightBarButtonItems = @[btnDone, btnCancel];
        
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        //self.datePicker.date = [NSDate date];
        [self.actionSheet addSubview:self.datePicker];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    
    self.navigationBar = nil;
    self.datePicker = nil;
    
    self.actionSheet = nil;
    
}

- (void)showWithSupperViewFrame:(UITabBar *)tabbar
{
    [self.actionSheet showFromTabBar:tabbar];
    self.actionSheet.frame = CGRectMake(tabbar.frame.origin.x, tabbar.frame.origin.y - 260, tabbar.frame.size.width, 260);
}

- (void)showActionSheetInView:(UIView *)view
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self.actionSheet showInView:window];
    self.actionSheet.frame = CGRectMake(window.frame.origin.x, window.frame.size.height - 260, window.frame.size.width, 260);
}

- (void)tapToCancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:dismissWithButtonDone:)]) {
        [self.delegate datePicker:self dismissWithButtonDone:NO];
    }
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)tapToDone
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:dismissWithButtonDone:)]) {
        [self.delegate datePicker:self dismissWithButtonDone:YES];
    }
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


@end
