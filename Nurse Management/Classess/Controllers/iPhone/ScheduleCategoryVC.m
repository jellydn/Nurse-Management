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
#import "CDScheduleCategory.h"
#import "AppDelegate.h"
#import "FXViewController.h"
#import "ScheduleCategoryCell.h"
@interface ScheduleCategoryVC ()<AddScheduleCategoryDelegate>
{
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UITableView *_tableView;
    
    NSMutableArray *arrItems;

}

- (IBAction)backVC:(id)sender;
- (IBAction)addScheduleName:(id)sender;
- (IBAction)switchChanged:(id)sender;

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
    
    [self fetchedResultsControllerScheduleCategory];
}

-(void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        self.screenName = @"List Schedule Category";
}


- (void)viewDidUnload {
//    self.fetchedResultsControllerScheduleCategory = nil;
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
    return [_fetchedResultsControllerScheduleCategory.fetchedObjects count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleCategoryCell *cellR = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCategoryCell"];
    if (cellR == nil) {
        cellR = [[NSBundle mainBundle] loadNibNamed:@"ScheduleCategoryCell" owner:self options:nil][0];
        
        if (![Common isIOS7]) {
            CGRect rect             = cellR.lbTitle.frame;
            rect.origin.y           += 4;
            cellR.lbTitle.frame     = rect;
            
            cellR.tvTitle.hidden = YES;
            cellR.lbTitle.hidden = NO;
        } else {
            cellR.tvTitle.hidden = NO;
            cellR.lbTitle.hidden = YES;
        }
    }
    
    CDScheduleCategory *scheduleCategory    = [_fetchedResultsControllerScheduleCategory.fetchedObjects objectAtIndex:indexPath.row];
    cellR.lbTitle.text  = scheduleCategory.name;
    cellR.tvTitle.text  = scheduleCategory.name;
    cellR.switchView.on                     = scheduleCategory.isEnable;
    cellR.switchView.tag = indexPath.row;
    
    
    return cellR;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDScheduleCategory *schedule = [_fetchedResultsControllerScheduleCategory.fetchedObjects objectAtIndex:indexPath.row];
    AddScheduleCategoryNameVC *vc   = [[AddScheduleCategoryNameVC alloc] init];
    NSLog(@"ID nhan ve %d", schedule.id);
    vc.insertId = schedule.id;
    [vc loadSelecteScheduleCategory:schedule];
    vc.delegate = self;
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addScheduleName:(id)sender {
    AddScheduleCategoryNameVC *vc   = [[AddScheduleCategoryNameVC alloc] init];
    vc.delegate = self;
    vc.insertId = 0;
    
    
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

- (IBAction)switchChanged:(id)sender {
    
    UISwitch* switchControl = sender;
    
    if ([_fetchedResultsControllerScheduleCategory.fetchedObjects objectAtIndex:switchControl.tag]) {
        CDScheduleCategory *schedule = [_fetchedResultsControllerScheduleCategory.fetchedObjects objectAtIndex:switchControl.tag];
        if (switchControl.on)
            schedule.isEnable = YES;
        else
            schedule.isEnable = NO;
        
        [[AppDelegate shared] saveContext];
        
    }
    
    
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

#pragma mark - load Coredata

- (NSFetchedResultsController *)fetchedResultsControllerScheduleCategory {
    
    if (_fetchedResultsControllerScheduleCategory != nil) {
        return _fetchedResultsControllerScheduleCategory;
    }
    
    NSString *entityName = @"CDScheduleCategory";
    AppDelegate *_appDelegate = [AppDelegate shared];
    
    NSString *cacheName = [NSString stringWithFormat:@"%@",entityName];
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_appDelegate.managedObjectContext];
    
    
    NSSortDescriptor *sort0 = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortList = [NSArray arrayWithObjects:sort0, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != nil"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.fetchBatchSize = 20;
    fetchRequest.sortDescriptors = sortList;
    fetchRequest.predicate = predicate;
    _fetchedResultsControllerScheduleCategory = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:_appDelegate.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:cacheName];
    _fetchedResultsControllerScheduleCategory.delegate = self;
    
    NSError *error = nil;
    [_fetchedResultsControllerScheduleCategory performFetch:&error];
    if (error) {
        NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
    }
    if ([_fetchedResultsControllerScheduleCategory.fetchedObjects count] == 0) {
        
        //read file
        NSString *path = [[NSBundle mainBundle] pathForResource:@"predefault" ofType:@"plist"];
        
        // Load the file content and read the data into arrays
        if (path)
        {
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSArray *totalScheduleCategory = [dict objectForKey:@"ScheduleCategory"];
            
            //Creater coredata
            for (int i = 0 ; i < [totalScheduleCategory count]; i++) {
                CDScheduleCategory *cdScheduleCategory = (CDScheduleCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"CDScheduleCategory" inManagedObjectContext:_appDelegate.managedObjectContext];
                
                cdScheduleCategory.id = i + 1;
//                cdScheduleCategory.isDisplay = TRUE;
                cdScheduleCategory.name = [totalScheduleCategory objectAtIndex:i];
                
                [_appDelegate saveContext];
            }
            
        } else {
            NSLog(@"path error");
        }
        
    } else {
        NSLog(@"total schedule items : %lu",(unsigned long)[_fetchedResultsControllerScheduleCategory.fetchedObjects count]);
    }
    
//    [_tbvMemberList reloadData];
//    _isLoadCoreData = NO;
    
    return _fetchedResultsControllerScheduleCategory;
//    return nil;
    
}
- (void) saveScheduleCategoryName:(NSString *)name andColor:(NSString *)color andInsertId:(int32_t)insertId{
   
    CDScheduleCategory *scheduleCategory;
    if (insertId) {
        scheduleCategory= [_fetchedResultsControllerScheduleCategory.fetchedObjects objectAtIndex: insertId - 1];
        
    }
    else
    {
        CDScheduleCategory *lastScheduleCategory = [_fetchedResultsControllerScheduleCategory.fetchedObjects objectAtIndex:(_fetchedResultsControllerScheduleCategory.fetchedObjects.count - 1)];
        
        scheduleCategory = [NSEntityDescription
                  insertNewObjectForEntityForName:@"CDScheduleCategory"
                  inManagedObjectContext: [AppDelegate shared].managedObjectContext];
        scheduleCategory.id = lastScheduleCategory.id + 1;
        scheduleCategory.isDefault = NO;
        scheduleCategory.isEnable = YES;

    }
    scheduleCategory.name = name;
    scheduleCategory.color = color;
    [[AppDelegate shared] saveContext];
    
}
-(void)deleteScheduleCategoryName:(int)idCategory
{
    AppDelegate *appDelegate = [AppDelegate shared];
    for (CDScheduleCategory *item in _fetchedResultsControllerScheduleCategory.fetchedObjects) {
        if (item.id == idCategory) {
            [appDelegate.managedObjectContext deleteObject:item];
            [appDelegate saveContext];
            break;
        }
    }
}
#pragma mark - Fetch CoreData

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
@end
