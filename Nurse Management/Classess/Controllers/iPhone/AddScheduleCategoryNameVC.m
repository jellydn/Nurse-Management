//
//  AddScheduleCategoryNameVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddScheduleCategoryNameVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "CDScheduleCategory.h"
#import "FXViewController.h"
@interface AddScheduleCategoryNameVC ()<UIActionSheetDelegate>
{
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    CDScheduleCategory *_scheduleCategory;
    NSString  *_typeColor;
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation AddScheduleCategoryNameVC

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
    _typeColor = @"0";
    [self configView];
}

-(void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        if (!_insertId){
                self.screenName = @"Edit Schedule Category";
        }else{
                    self.screenName = @"Add Schedule Category";
                }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (IBAction)selectButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    _reviewCategory.textColor = [UIColor colorWithRed:93.0/255.0 green:80.0/255.0 blue:76.0/255.0 alpha:1.0];
    _typeColor = [NSString stringWithFormat:@"%d", button.tag];
    switch (button.tag) {
        case 0:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c1.png"];
            break;
        case 1:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c3.png"];
            break;
        case 2:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c5.png"];
            break;
        case 3:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c7.png"];
            break;
        case 4:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c9.png"];
            break;
        case 5:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c1.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 6:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c3.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 7:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c5.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 8:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c7.png"];
            break;
        case 9:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c9.png"];
            break;
        default:
            _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c1.png"];
            break;
    }
}

- (IBAction)delete:(id)sender {
    [_txtName resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
    [actionSheet showInView:self.view];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] > 6) {
        return NO;
    }
    _reviewCategory.text = newString;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // _reviewCategory.text = textField.text;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:     // delete
            [_delegate deleteScheduleCategoryName:_insertId];
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];

            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            
        case 1:     // cancel
            [_txtName becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"カテゴリー名編集";
    if (!_scheduleCategory.isDefault && _insertId != 0) {
        _btDelete.hidden = NO;
    }else{
        _btDelete.hidden = YES;
    }
    
    if (!_insertId) {
        _txtName.text = @"";
        _reviewCategory.text = @"";
    } else {
       _txtName.text = _scheduleCategory.name;
        _reviewCategory.text = _scheduleCategory.name;
        _typeColor = _scheduleCategory.color;
        switch ([ _scheduleCategory.color intValue]) {
            case 0:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c1.png"];
                break;
            case 1:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c3.png"];
                break;
            case 2:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c5.png"];
                break;
            case 3:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c7.png"];
                break;
            case 4:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r1_c9.png"];
                break;
            case 5:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c1.png"];
                _reviewCategory.textColor = [UIColor whiteColor];
                break;
            case 6:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c3.png"];
                _reviewCategory.textColor = [UIColor whiteColor];
                break;
            case 7:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c5.png"];
                _reviewCategory.textColor = [UIColor whiteColor];
                break;
            case 8:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c7.png"];
                break;
            case 9:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c9.png"];
                break;
            default:
                _backgrounReview.image = [UIImage imageNamed:@"sicon_r3_c1.png"];
                break;
        }

    }
    
//    [_txtName becomeFirstResponder];
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    if (!_insertId)
        _scheduleCategory.name = _txtName.text;
    [_delegate saveScheduleCategoryName:_txtName.text andColor:_typeColor andInsertId:_insertId];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)loadSelecteScheduleCategory:(CDScheduleCategory *)selectedScheduleCategory
{
    _scheduleCategory = selectedScheduleCategory;
}
@end
