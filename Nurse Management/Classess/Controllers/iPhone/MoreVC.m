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
#import "OtherAppCell.h"
#import "ListShiftPatternVC.h"
#import "ListMembersVC.h"
#import "ScheduleCategoryVC.h"
#import "OtherAppWS.h"
#import "AppItem.h"

#import "Downloader.h"
#import "TermVC.h"
@interface MoreVC ()<UIScrollViewDelegate, OtherAppWSDelegate, DownloaderDelegate>
{
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    NSMutableArray *_items;
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIActivityIndicatorView *_indicator;
    IBOutlet OtherAppCell *_otherAppCell;
    NSMutableArray *_otherApps;
    int _offset,_limit;
    
    
}
- (IBAction)backVC:(id)sender;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = GA_MOREVC;
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
    
    
    //Others app
    _otherApps = [[NSMutableArray alloc] init];
    _offset = 0;
    _limit = 50;
    [self getOtherAppWS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"その他";
    
    
}

#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    [super eventListenerDidReceiveNotification:notif];
    
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_items count];
    } else if (section == 1) {
        return [_otherApps count];
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        return 70;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
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
        
    } else if (indexPath.section == 1) {
        
        OtherAppCell *cellR = [tableView dequeueReusableCellWithIdentifier:@"OtherAppCell"];
        if (cellR == nil) {
           cellR = [[NSBundle mainBundle] loadNibNamed:@"OtherAppCell" owner:self options:nil][0];
            
        }
        
        AppItem *item = [_otherApps objectAtIndex:indexPath.row];
        NSString *getPrice;
        if([item.yen isEqualToString:@"0"]){
            getPrice = @"無 料";
        }else{
            getPrice = item.yen;
        }
        cellR.lbAppName.text = item.appliName;
        cellR.lbAppBy.text   = item.publisher;
        cellR.lbAppTest.text = getPrice;
        
        if (item.imgIcon) {
            cellR.imgApp.image = item.imgIcon;
        } else {
            cellR.imgApp.image = [UIImage imageNamed:@"no_icon.png"];
        }
        
        [cellR setBorderImage];
        
        return cellR;
        
    }
    
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NSLog(@"ListShiftPatternVC");
            ListShiftPatternVC *vc = [[ListShiftPatternVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2) {
            ScheduleCategoryVC *vc = [[ScheduleCategoryVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3) {
            ListMembersVC *vc = [[ListMembersVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 4) {
            ChangeThemeVC *vc = [[ChangeThemeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 5) {
            //TODO: switch to begin date : Sunday or Monday
        }
        else if (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10){
            TermVC *term = [[TermVC alloc] init];
            term.selectTerm = indexPath.row;
            [self.navigationController pushViewController:term animated:YES];
        }
    } else if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AppItem *item = [_otherApps objectAtIndex:indexPath.row];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:item.url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.url]];
        }
    }    
}

#pragma mark - OtherAppWSDelegate

- (void)getOtherAppWS
{
    NSLog(@"get ws with offset = %d -- limit = %d",_offset,_limit);
    OtherAppWS *otherAppWS = [[OtherAppWS alloc] init];
    otherAppWS.delegate = self;
    [otherAppWS getAppsWithOffset:_offset limit:_limit];
}

- (void)didFailWithError:(Error*)error
{
    [Common showAlert:error.error_msg title:APP_NAME];
    _indicator.hidden = YES;
}

- (void)didSuccessWithApps:(NSMutableArray*)apps hasnext:(BOOL)hasnext
{
    _indicator.hidden = YES;
    
    for (AppItem *item in apps) {
        [_otherApps addObject:item];
    }
    
    if (hasnext) {
        _offset += _limit;
        
        // load ws
        [self getOtherAppWS];
    } else {
        
        
    }
    
    // table reload
    [_tableView reloadData];
    
    
    [self downloadImageIcon];
}

#pragma mark - Downloader

- (void) downloadImageIcon
{
    for (UITableViewCell *cellR in [_tableView visibleCells]) {
        
        NSIndexPath *indexPath = [_tableView indexPathForCell:cellR];
        
        if (indexPath.section == 0) {
            continue;
        }
        
        AppItem *item = [_otherApps objectAtIndex:indexPath.row];
        
        if (!item.imgIcon) {
            if (![item.iconUrl isEqualToString:@""]) {
                Downloader *down = [[Downloader alloc] init];
                down.delegate = self;
                down.identifier = indexPath;
                [down get:[NSURL URLWithString:item.iconUrl]];
            } else {
                item.imgIcon = [UIImage imageNamed:@"no_icon.png"];
                
                OtherAppCell *cell = (OtherAppCell*)cellR;
                cell.imgApp.image = [UIImage imageNamed:@"no_icon.png"];
            }
        } else {
            
        }
    }
}

-(void)downloader:(NSURLConnection *)conn didLoad:(NSMutableData *)data identifier:(id)identifier
{
    NSIndexPath *indexPath = (NSIndexPath*)identifier;
    if (indexPath.row < [_otherApps count]) {
        OtherAppCell *cell = (OtherAppCell*) [_tableView cellForRowAtIndexPath:indexPath];
        AppItem *item = [_otherApps objectAtIndex:indexPath.row];
        
        if (data.length > 0) {
            cell.imgApp.image = [UIImage imageWithData:data];
            item.imgIcon = [UIImage imageWithData:data];
        }
    }
}

-(void)downloaderFailedIndentifier:(id)indentifier
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView) {
        if (!decelerate) {
            [self downloadImageIcon];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [self downloadImageIcon];
    }
}












@end
