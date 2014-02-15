//
//  ListMembersVC.m
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "ListMembersVC.h"
#import "Member.h"
#import "AddMemberVC.h"
#import "FXNavigationController.h"

@interface ListMembersVC () <UITableViewDataSource, UITableViewDelegate, AddMemberDelegate> {
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UITableView *_tbvMemberList;
    
    NSMutableArray *arrMembers;
}

- (IBAction)backVC:(id)sender;
- (IBAction)addMember:(id)sender;

@end

@implementation ListMembersVC

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
    member1.name = @"A看護師長";
    member1.isOfficial = YES;
    member1.isEnable = YES;
    
    Member *member2 = [[Member alloc] init];
    member2.memberID = @"2";
    member2.name = @"B主任";
    member2.isOfficial = YES;
    member2.isEnable = YES;
    
    Member *member3 = [[Member alloc] init];
    member3.memberID = @"2";
    member3.name = @"C主任";
    member3.isOfficial = YES;
    member3.isEnable = YES;
    
    Member *member4 = [[Member alloc] init];
    member4.memberID = @"2";
    member4.name = @"D主任";
    member4.isOfficial = YES;
    member4.isEnable = YES;
    
    Member *member5 = [[Member alloc] init];
    member5.memberID = @"2";
    member5.name = @"E先輩";
    member5.isOfficial = YES;
    member5.isEnable = YES;
    
    Member *member6 = [[Member alloc] init];
    member6.memberID = @"2";
    member6.name = @"F先輩";
    member6.isOfficial = YES;
    member6.isEnable = YES;
    
    Member *member7 = [[Member alloc] init];
    member7.memberID = @"2";
    member7.name = @"G先輩";
    member7.isOfficial = YES;
    member7.isEnable = YES;
    
    Member *member8 = [[Member alloc] init];
    member8.memberID = @"2";
    member8.name = @"Hさん";
    member8.isOfficial = YES;
    member8.isEnable = YES;
    
    Member *member9 = [[Member alloc] init];
    member9.memberID = @"2";
    member9.name = @"Iさん";
    member9.isOfficial = YES;
    member9.isEnable = YES;
    
    Member *member10 = [[Member alloc] init];
    member10.memberID = @"2";
    member10.name = @"Jさん";
    member10.isOfficial = YES;
    member10.isEnable = YES;
    
    Member *member11 = [[Member alloc] init];
    member11.memberID = @"2";
    member11.name = @"Kさん";
    member11.isOfficial = YES;
    member11.isEnable = YES;
    
    Member *member12 = [[Member alloc] init];
    member12.memberID = @"2";
    member12.name = @"Lさん";
    member12.isOfficial = YES;
    member12.isEnable = YES;
    
    arrMembers = [[NSMutableArray alloc] initWithObjects:member1, member2, member3, member4, member5, member6, member7, member8, member9, member10, member11, member12, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrMembers count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
            NSString *cellIdentifier = @"SwitchCell";
            UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if( aCell == nil ) {
                aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
    
    Member *member = [arrMembers objectAtIndex:indexPath.row];
    
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
    
    Member *member = [arrMembers objectAtIndex:indexPath.row];
    if (!member.isOfficial) {
        AddMemberVC *vc   = [[AddMemberVC alloc] init];
        vc.isAddMember = NO;
        [vc loadSelectedMember:member];
        vc.delegate = self;
        FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:navi animated:YES completion:^{
            
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AddMemberDelegate

- (void) saveMemberName:(NSString *)name andIsAddMember:(BOOL)isAddMember {
    if (isAddMember) {
        Member *lastMember = [arrMembers objectAtIndex:(arrMembers.count - 1)];
        Member *member = [[Member alloc] init];
        member.memberID = [NSString stringWithFormat:@"%d", lastMember.memberID.intValue + 1];
        member.name = name;
        member.isEnable = YES;
        member.isOfficial = NO;
        
        [arrMembers addObject:member];
    }
    
    [_tbvMemberList reloadData];
}

- (void) deleteMember:(NSString *)memberID {

    for (int index = [arrMembers count] - 1; index >= 0; index--) {
        Member *member = [arrMembers objectAtIndex:index];
        if([member.memberID isEqualToString:memberID] && !member.isOfficial) {
            [arrMembers removeObject:member];
            [_tbvMemberList reloadData];
            break;
        }
    }
}

#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addMember:(id)sender {
    AddMemberVC *vc   = [[AddMemberVC alloc] init];
    vc.isAddMember = YES;
    vc.delegate = self;
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    
    if ([arrMembers objectAtIndex:switchControl.tag]) {
        Member *member = [arrMembers objectAtIndex:switchControl.tag];
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
    _lbTile.text = @"メンバー編集";
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
