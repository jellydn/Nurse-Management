//
//  ListShiftPatternVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//
#import "AppDelegate.h"
#import "ListShiftPatternVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "ShiftCell.h"
#import "EditShiftVC.h"
#import "AddShiftVC.h"
#import "CDShiftCategory.h"
#import "FXNavigationController.h"

@interface ListShiftPatternVC ()<UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    BOOL _isLoadCoreData;
    __weak IBOutlet UITableView *_tableView;

}
- (IBAction)backVC:(id)sender;
- (IBAction)addShift:(id)sender;

@end

@implementation ListShiftPatternVC

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
    _isLoadCoreData = YES;
    [self fetchedResultsControllerShiftCategory];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.screenName = @"List Schedule";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Fetch Data

- (NSFetchedResultsController*) fetchedResultsControllerShiftCategory
{
    if (!_fetchedResultsControllerShiftCategory) {
        NSString *entityName = @"CDShiftCategory";
        
        NSString *cacheName = [NSString stringWithFormat:@"%@",entityName];
        [NSFetchedResultsController deleteCacheWithName:cacheName];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[AppDelegate shared].managedObjectContext];
        
        
        NSSortDescriptor *sort0 = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        NSArray *sortList = [NSArray arrayWithObjects:sort0, nil];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != nil"];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = sortList;
        fetchRequest.predicate = predicate;
        _fetchedResultsControllerShiftCategory = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     managedObjectContext:[AppDelegate shared].managedObjectContext
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:cacheName];
        _fetchedResultsControllerShiftCategory.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerShiftCategory performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        }else {
            NSLog(@"appdelegate total shift category : %lu", (unsigned long)[_fetchedResultsControllerShiftCategory.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerShiftCategory;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
    {
    }
    
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
    {
        [_tableView reloadData];
    }
    
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
    {
    }

-(void)handleUpdatedData:(NSNotification *)notification {
    NSLog(@"recieved");
    [_tableView reloadData];
}


#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addShift:(id)sender {
    EditShiftVC *vc                  = [[EditShiftVC alloc] init];
    vc.insertId = 0;
    vc.date                         = [NSDate date];
    vc.typeShift                    = YES;
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = @"シフトパターン一覧";
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
    return [self.fetchedResultsControllerShiftCategory.fetchedObjects  count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShiftCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShiftCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    CDShiftCategory *cdShiftCategory = [self.fetchedResultsControllerShiftCategory.fetchedObjects objectAtIndex:indexPath.row];
    cell.lbName.text = cdShiftCategory.name;
    if (cdShiftCategory.isAllDay) {
        cell.lbShift.text = @"終日";
    }
    else
    {
        cell.lbShift.text = [NSString stringWithFormat:@"%@～%@",cdShiftCategory.timeStart, cdShiftCategory.timeEnd];
    }
    
    cell.lbName.textColor = [UIColor colorWithRed:91/255.0 green:80/255.0 blue:77/255.0 alpha:1.0];
    
    // set image
    if ([cdShiftCategory.color isEqualToString:@"color0"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r1_c1.png"];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color1"])
    {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r1_c3.png"];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color2"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r1_c5.png"];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color3"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r1_c7.png"];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color4"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r1_c9.png"];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color5"]) {
       cell.iconShift.image = [UIImage imageNamed:@"icon_r3_c1.png"];
        cell.lbName.textColor =  [UIColor whiteColor];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color6"])
    {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r3_c3.png"];
        cell.lbName.textColor =  [UIColor whiteColor];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color7"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r3_c5.png"];
        cell.lbName.textColor =  [UIColor whiteColor];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color8"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r3_c7.png"];
    }
    else
    if ([cdShiftCategory.color isEqualToString:@"color9"]) {
        cell.iconShift.image = [UIImage imageNamed:@"icon_r3_c9.png"];
    }
    
    if (cdShiftCategory.isEnable)
        [cell.swichShift setOn:YES animated:NO];
    else
        [cell.swichShift setOn:NO animated:NO];
    
    cell.swichShift.tag = indexPath.row;

    [cell.swichShift addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

//    UISwitch* switcher = (UISwitch*)[cell.contentView viewWithTag:100];
//    [switcher setOn:!switcher.on animated:YES];
//
//    cell.swichShift.transform = CGAffineTransformMakeScale(0.8, 0.65);
//    cell.swichShift.onTintColor = [UIColor colorWithRed:0.0/255.0 green:131.0/255.0 blue:234.0/255.0 alpha:1.0];
    return cell;
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    
    if ([self.fetchedResultsControllerShiftCategory.fetchedObjects objectAtIndex:switchControl.tag]) {
        CDShiftCategory *cdShiftCategory = [self.fetchedResultsControllerShiftCategory.fetchedObjects objectAtIndex:switchControl.tag];
        if (switchControl.on)
            cdShiftCategory.isEnable = YES;
        else
            cdShiftCategory.isEnable = NO;
        
        [[AppDelegate shared] saveContext];
        
    }
    
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    CDShiftCategory *shiftCategory = [self.fetchedResultsControllerShiftCategory.fetchedObjects objectAtIndex:indexPath.row];
    
    EditShiftVC *vc                 = [[EditShiftVC alloc] init];
    vc.typeShift                    = NO;
    vc.insertId = shiftCategory.id  ;
    [vc loadShiftCategory:shiftCategory];
    
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];

}
@end
