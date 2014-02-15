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
#import "UIPickerActionSheet.h"
#import "Define.h"
#import "ListMembersVC.h"
#import "FXNavigationController.h"
#import "ChooseTimeView.h"

#define ALERT_BG_COLOR	 [UIColor colorWithRed:100.0/255.0 green:137.0/255.0 blue:199.0/255.0 alpha:1.0]
#define BUTTON_BG_COLOR	 [UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]
#define TITLE_COLOR	 [UIColor colorWithRed:126.0/255.0 green:96.0/255.0 blue:39.0/255.0 alpha:1.0]
#define kOFFSET_FOR_KEYBOARD 160.0

@interface AddShiftVC () <UITextViewDelegate, UIActionSheetDelegate, UIPickerActionSheetDelegate, ChooseTimeViewDelegate>
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
    __weak IBOutlet UILabel *_lblStartTime;
    __weak IBOutlet UILabel *_lblEndTime;
    
    __weak IBOutlet UITextView *_txvMemo;
    
    UIPickerActionSheet *_pickerActionSheet;
    NSMutableDictionary *_startTime;
    NSMutableDictionary *_endTime;
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)chooseAlert:(id)sender;
- (IBAction)chooseShiftCategory:(id)sender;
- (IBAction)chooseTimeMode:(id)sender;
- (IBAction)chooseTime:(id)sender;
- (IBAction)chooseMembers:(id)sender;
- (IBAction)tapHideKeyboard:(UITapGestureRecognizer *)sender;
- (IBAction)moveToNextDay:(id)sender;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;


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

- (void) viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    
    _btnStartTime.tag = START_TIME;
    _btnEndTime.tag = END_TIME;
    
    _pickerActionSheet = [[UIPickerActionSheet alloc] initForView:self.view];
    _pickerActionSheet.delegate = self;
    
    ChooseTimeView *chooseTimeView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(15, 362, 320 - 15*2, 44)];
    chooseTimeView.delegate = self;
    [chooseTimeView setStartDate:[NSDate date]];
    
    [self.view addSubview:chooseTimeView];
}

- (void) viewWillDisappear:(BOOL)animated {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:_txvMemo])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//#pragma mark - UIPickerViewDataSource
//
//- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 2;
//}
//
//- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    
//    if (component == 1)
//        return 24;
//    else if (component == 2)
//        return 60;
//    
//    return 0;
//}
//
//- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return @"test";
//}

//#pragma mark - ChooseTimeViewDelegate
//
//- (void) didChooseTimeWithIndex:(NSInteger)index arrayChooseTime:(NSMutableArray *)arrayChooseTime {
//    
//}

#pragma mark - Actions

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
        
        btnAllDay.tag = 2;
        btnAllDay.backgroundColor = ALERT_BG_COLOR;
        _lblStartTime.enabled = NO;
        _lblStartTime.textColor = [UIColor grayColor];
        _lblStartTime.text = @"00:00";
        _lblEndTime.enabled = NO;
        _lblEndTime.textColor = [UIColor grayColor];
        _lblEndTime.text = @"00:00";
        
    } else if ([btnAllDay tag] == 2) {
        
        btnAllDay.tag = 1;
        btnAllDay.backgroundColor = BUTTON_BG_COLOR;
        
        _lblStartTime.enabled = YES;
        _lblStartTime.textColor = TITLE_COLOR;
        if (_startTime)
            _lblStartTime.text = [NSString stringWithFormat:@"%02d:%02d", [[_startTime objectForKey:HOUR_KEY] intValue], [[_startTime objectForKey:MINUTE_KEY] intValue]];
        else
            _lblStartTime.text = @"00:00";
        
        _lblEndTime.enabled = YES;
        _lblEndTime.textColor = TITLE_COLOR;
        if (_endTime)
            _lblEndTime.text = [NSString stringWithFormat:@"%02d:%02d", [[_endTime objectForKey:HOUR_KEY] intValue], [[_endTime objectForKey:MINUTE_KEY] intValue]];
        else
            _lblEndTime.text = @"00:00";
        
    }
}

- (IBAction)chooseTime:(id)sender {
    
    if ([sender tag] == START_TIME) {
        [_pickerActionSheet show:_startTime];
    } else if ([sender tag] == END_TIME) {
        [_pickerActionSheet show:_endTime];
    }
    
    _pickerActionSheet.type = [sender tag];
    
}

- (IBAction)chooseMembers:(id)sender {
    
    ListMembersVC *listMembersVC = [[ListMembersVC alloc] init];
    [self.navigationController pushViewController:listMembersVC animated:YES];
    
}

- (void)pickerActionSheetDidCancel:(UIPickerActionSheet*)aPickerActionSheet
{
    
}

- (void)pickerActionSheet:(UIPickerActionSheet*)aPickerActionSheet didSelectItem:(id)aItem
{
    NSMutableDictionary *selectedValue = (NSMutableDictionary *)aItem;
    int hour = [[selectedValue objectForKey:HOUR_KEY] intValue];
    int minute = [[selectedValue objectForKey:MINUTE_KEY] intValue];
    
    if (aPickerActionSheet.type == START_TIME) {
        
        _lblStartTime.text = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        _startTime = [selectedValue copy];
        
    } else if (aPickerActionSheet.type == END_TIME) {
        
        _lblEndTime.text = [NSString stringWithFormat:@"%02d:%02d", hour, minute];;
        _endTime = [selectedValue copy];
        
    }
}

- (IBAction)tapHideKeyboard:(UITapGestureRecognizer *)sender {
    [_txvMemo resignFirstResponder];
}

- (IBAction)moveToNextDay:(id)sender {
    
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboard show");
    
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = [NSString stringWithFormat:@"%d月%d日",[FXCalendarData getDayWithDate:_date], [FXCalendarData getMonthWithDate:_date]];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
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
