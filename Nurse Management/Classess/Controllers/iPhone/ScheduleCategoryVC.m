//
//  ScheduleCategoryVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ScheduleCategoryVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "Member.h"
#import "FXNavigationController.h"
#import "AddScheduleCategoryNameVC.h"

@interface ScheduleCategoryVC ()
{
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UITableView *_tableView;
    
    NSMutableArray *arrItems;

}

- (IBAction)backVC:(id)sender;
- (IBAction)addScheduleName:(id)sender;

@end

@implementation ScheduleCategoryVC

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
    
    // temporarely initialize data
    Member *member1 = [[Member alloc] init];
    member1.memberID = @"1";
    member1.name = @"￼美容院";
    member1.isOfficial = YES;
    member1.isEnable = YES;
    
    Member *member2 = [[Member alloc] init];
    member2.memberID = @"2";
    member2.name = @"マツエク";
    member2.isOfficial = NO;
    member2.isEnable = NO;
    
    arrItems = [[NSMutableArray alloc] initWithObjects:member1, member2, nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrItems count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"SwitchCell";
    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( aCell == nil ) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Member *member = [arrItems objectAtIndex:indexPath.row];
    
    aCell.textLabel.text = member.name;
    
    if (member.isOfficial)  // can't not press for official items
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    else                    // be able to press for non-official items
        aCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    aCell.accessoryView = switchView;
    switchView.tag = indexPath.row;
    
    if (member.isEnable)
        [switchView setOn:YES animated:NO];
    else
        [switchView setOn:NO animated:NO];
    
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    return aCell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Member *member = [arrItems objectAtIndex:indexPath.row];
    if (!member.isOfficial) {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AddMemberDelegate

- (void) saveMemberName:(NSString *)name andIsAddMember:(BOOL)isAddMember {
    if (isAddMember) {
        Member *lastMember = [arrItems objectAtIndex:(arrItems.count - 1)];
        Member *member = [[Member alloc] init];
        member.memberID = [NSString stringWithFormat:@"%d", lastMember.memberID.intValue + 1];
        member.name = name;
        member.isEnable = YES;
        member.isOfficial = NO;
        
        [arrItems addObject:member];
    }
    
//    [_tbvMemberList reloadData];
}

- (void) deleteMember:(NSString *)memberID {
    
    for (int index = [arrItems count] - 1; index >= 0; index--) {
        Member *member = [arrItems objectAtIndex:index];
        if([member.memberID isEqualToString:memberID] && !member.isOfficial) {
            [arrItems removeObject:member];
//            [_tbvMemberList reloadData];
            break;
        }
    }
}



#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addScheduleName:(id)sender {
    AddScheduleCategoryNameVC *vc   = [[AddScheduleCategoryNameVC alloc] init];
    
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    
    if ([arrItems objectAtIndex:switchControl.tag]) {
        Member *member = [arrItems objectAtIndex:switchControl.tag];
        if (switchControl.on)
            member.isEnable = YES;
        else
            member.isEnable = NO;
    }
    
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}


#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"スケジュール名一覧";
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
