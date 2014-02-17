//
//  MoreVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "MoreVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "MoreCell.h"
#import "ChangeThemeVC.h"
#import "MoreCellItem.h"
#import "MoreCellTitle.h"

@interface MoreVC ()
{
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    NSMutableArray *_items;
}
- (IBAction)backVC:(id)sender;
- (IBAction)goChangeThemeVC:(id)sender;

@end

@implementation MoreVC

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
    [self initData];
}
-(void)initData
{
    _items = [[NSMutableArray alloc] init];
    [_items removeAllObjects];
    
    MoreCellItem *item1 = [[MoreCellItem alloc] init];
    item1.typeCell = 0;
    item1.title = @"画面設定";
    [_items addObject:item1];
    
    MoreCellItem *item2 = [[MoreCellItem alloc] init];
    item2.typeCell = 1;
    item2.title = @"シフトパターン設定";
    [_items addObject:item2];
    
    MoreCellItem *item3 = [[MoreCellItem alloc] init];
    item3.typeCell = 1;
    item3.title = @"スケジュールカテゴリ設定";
    [_items addObject:item3];
    
    MoreCellItem *item4 = [[MoreCellItem alloc] init];
    item4.typeCell = 1;
    item4.title = @"メンバーの設定";
    [_items addObject:item4];
    
    MoreCellItem *item5 = [[MoreCellItem alloc] init];
    item5.typeCell = 1;
    item5.title = @"カレンダーテーマ設定";
    [_items addObject:item5];
    
    MoreCellItem *item6 = [[MoreCellItem alloc] init];
    item6.typeCell = 1;
    item6.title = @"週の開始曜日を設定";
    [_items addObject:item6];
    
    MoreCellItem *item7 = [[MoreCellItem alloc] init];
    item7.typeCell = 1;
    item7.title = @"メンバーを非表示にする";
    [_items addObject:item7];
    
    MoreCellItem *item8 = [[MoreCellItem alloc] init];
    item8.typeCell = 0;
    item8.title = @"このアプリについて";
    [_items addObject:item8];
    
    MoreCellItem *item9 = [[MoreCellItem alloc] init];
    item9.typeCell = 1;
    item9.title = @"利用規約";
    [_items addObject:item9];
    
    MoreCellItem *item10 = [[MoreCellItem alloc] init];
    item10.typeCell = 1;
    item10.title = @"プライバシーポリシー";
    [_items addObject:item10];
    
    MoreCellItem *item11 = [[MoreCellItem alloc] init];
    item11.typeCell = 1;
    item11.title = @"お問い合わせ";
    [_items addObject:item11];
    
    MoreCellItem *item12 = [[MoreCellItem alloc] init];
    item12.typeCell = 0;
    item12.title = @"おすすめ無料アプリ";
    [_items addObject:item12];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goChangeThemeVC:(id)sender {
    ChangeThemeVC *vc = [[ChangeThemeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"More";
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCellItem *item = [_items objectAtIndex:indexPath.row];
    
    if (item.typeCell == 1) {
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil] lastObject];
        }
        if (indexPath.row == 6) {
            cell.btStatus.hidden = NO;
            cell.iconRight.hidden = YES;
        }
        cell.lbName.text = item.title;
        return cell;
        
    } else if (item.typeCell == 0) {
        MoreCellTitle *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCellTitle"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCellTitle" owner:self options:nil] lastObject];
        }
        cell.lbName.text = item.title;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        ChangeThemeVC *vc = [[ChangeThemeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
