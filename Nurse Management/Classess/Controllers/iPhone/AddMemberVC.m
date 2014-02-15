//
//  AddMemberVC.m
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddMemberVC.h"
#import "Member.h"

@interface AddMemberVC () <UIActionSheetDelegate, UITextFieldDelegate> {
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UITextField *_txfName;
    __weak IBOutlet UIButton *_btnDelete;
    __weak IBOutlet UIButton *_btnSave;
    
    Member *_member;
    
    
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)delete:(id)sender;

@end

@implementation AddMemberVC
@synthesize isAddMember;

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
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:     // delete
            [_delegate deleteMember:_member.memberID];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            
        case 1:     // cancel
            [_txfName becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger len = [str length];
    
    if (len > 0)
        _btnSave.enabled = YES;
    else
        _btnSave.enabled = NO;
    
    return YES;
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    if (!isAddMember)
        _member.name = _txfName.text;
    [_delegate saveMemberName:_txfName.text andIsAddMember:isAddMember];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)delete:(id)sender {
    [_txfName resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    if (isAddMember) {
        
        _lbTile.text = @"メンバー名の追加";
        _txfName.text = @"";
        _txfName.placeholder = @"A看護師長";
        _btnDelete.hidden = YES;
        _btnSave.enabled = NO;
        
    } else {
        
        _lbTile.text = @"メンバー名編集";
        _txfName.text = _member.name;
        _btnDelete.hidden = NO;
        
    }
    
    [_txfName becomeFirstResponder];
    
}

- (void) loadSelectedMember: (Member *) selectedMember {
    _member = selectedMember;
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
