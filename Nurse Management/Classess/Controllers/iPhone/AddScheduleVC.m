//
//  AddScheduleVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/15/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddScheduleVC.h"
#import "ChooseTimeView.h"
#import "AddScheduleView.h"
#import "FXThemeManager.h"
@interface AddScheduleVC ()<UITextViewDelegate, ChooseTimeViewDelegate, AddScheduleViewDelegate>{
    AddScheduleView *_addScheduleView;
}

@end

@implementation AddScheduleVC

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
    // view choose time

    ChooseTimeView *chooseTimeView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(15, 210, 320 - 15*2, 44)];
    chooseTimeView.delegate = self;
    [chooseTimeView setStartDate:[NSDate date]];
    
    [self.view addSubview:chooseTimeView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    CGRect rect = _viewContent.frame;
    rect.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _viewContent.frame = rect;
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rect = _viewContent.frame;
    if (textView    == _textViewContent) {
        rect.origin.y = -100;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _viewContent.frame = rect;
    }];
    return YES;
}

- (IBAction)changeName:(id)sender {
    if (_addScheduleView) {
        [_addScheduleView removeFromSuperview];
        _addScheduleView = nil;
    }
    
    _addScheduleView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddSchedule]
                                                                        owner:self
                                                                      options:nil][0];
    _addScheduleView.delegate           = self;
    _addScheduleView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_addScheduleView initLayoutView];
    
    [self.view addSubview:_addScheduleView];

    [_addScheduleView show];
}
- (IBAction)btAllTime:(id)sender {
    _beginTime.text = @"00:00";
    _EndTime.text = @"00:00";
}
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
