//
//  AddMemberVC.m
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddMemberVC.h"
#import "Member.h"

@interface AddMemberVC () {
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UITextField *_txfName;
    __weak IBOutlet UIButton *_btnDelete;
    
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
    
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    if (isAddMember) {
        
        _lbTile.text = @"Add Member";
        _txfName.text = @"";
        _txfName.placeholder = @"Member Name";
        _btnDelete.hidden = YES;
        
    } else {
        
        _lbTile.text = @"Edit Member";
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
