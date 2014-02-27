//
//  ListMembersVC.m
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//
#import "AppDelegate.h"
#import "ListMembersVC.h"
#import "CDMember.h"
#import "AddMemberVC.h"
#import "FXNavigationController.h"
#import "MemberCell.h"

@interface ListMembersVC () <UITableViewDataSource, UITableViewDelegate, AddMemberDelegate> {
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UITableView *_tbvMemberList;
    BOOL _isLoadCoreData;

    NSMutableArray *arrMembers;
}

- (IBAction)backVC:(id)sender;
- (IBAction)addMember:(id)sender;
- (IBAction)switchChanged:(id)sender ;

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
    
    _isLoadCoreData = YES;

    [self fetchedResultsControllerMember];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = GA_LISTMEMBERSVC;
}

- (void)viewDidUnload {
    self.fetchedResultsControllerMember = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load Coredata

- (NSFetchedResultsController *)fetchedResultsControllerMember {
    
    if (_fetchedResultsControllerMember != nil) {
        return _fetchedResultsControllerMember;
    }
    
    NSString *entityName = @"CDMember";
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
    _fetchedResultsControllerMember = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:_appDelegate.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:cacheName];
    _fetchedResultsControllerMember.delegate = self;
    
    NSError *error = nil;
    [_fetchedResultsControllerMember performFetch:&error];
    if (error) {
        NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
    }
    
    if ([_fetchedResultsControllerMember.fetchedObjects count] == 0) {
        NSLog(@"add data for member item");
        
        //read file
        NSString *path = [[NSBundle mainBundle] pathForResource:@"predefault" ofType:@"plist"];
        
        // Load the file content and read the data into arrays
        if (path)
        {
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSArray *totalMember = [dict objectForKey:@"Member"];
            
            //Creater coredata
            for (int i = 0 ; i < [totalMember count]; i++) {
                CDMember *cdMember = (CDMember *)[NSEntityDescription insertNewObjectForEntityForName:@"CDMember" inManagedObjectContext:_appDelegate.managedObjectContext];
                
                cdMember.id = i + 1;
                cdMember.isDisplay = TRUE;
                cdMember.name = [totalMember objectAtIndex:i];
                
                [_appDelegate saveContext];
            }
            
        } else {
            NSLog(@"path error");
        }
        
    } else {
        NSLog(@"total item : %lu",(unsigned long)[_fetchedResultsControllerMember.fetchedObjects count]);
    }
    
    [_tbvMemberList reloadData];
    _isLoadCoreData = NO;
    
    return _fetchedResultsControllerMember;
    
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_tbvMemberList reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
}


#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fetchedResultsControllerMember.fetchedObjects  count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MemberCell *cellR = [tableView dequeueReusableCellWithIdentifier:@"MemberCell"];
    if (cellR == nil) {
        cellR = [[NSBundle mainBundle] loadNibNamed:@"MemberCell" owner:self options:nil][0];
        
    }
    
    CDMember *member = [_fetchedResultsControllerMember.fetchedObjects objectAtIndex:indexPath.row];
    cellR.lbTitle.text                      = member.name;
    cellR.switchView.on                     = member.isDisplay;
    cellR.switchView.tag = indexPath.row;
    
    
    return cellR;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDMember *member = [_fetchedResultsControllerMember.fetchedObjects objectAtIndex:indexPath.row];
        AddMemberVC *vc   = [[AddMemberVC alloc] init];
        vc.insertId = member.id;
        [vc loadSelectedMember:member];
        vc.delegate = self;
        FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:navi animated:YES completion:^{
            
        }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AddMemberDelegate

- (void) saveMemberName:(NSString *)name andInsertId:(int32_t)insertId{
    CDMember *member;
    
    if (insertId) {
        member= [_fetchedResultsControllerMember.fetchedObjects objectAtIndex: insertId - 1];
    }
    else
    {
        CDMember *lastMember = [_fetchedResultsControllerMember.fetchedObjects objectAtIndex:(_fetchedResultsControllerMember.fetchedObjects.count - 1)];

        member = [NSEntityDescription
                  insertNewObjectForEntityForName:@"CDMember"
                  inManagedObjectContext: [AppDelegate shared].managedObjectContext];
        member.id = lastMember.id + 1;
        member.isDisplay = YES;
    }
    
    member.name = name;
    
    [[AppDelegate shared] saveContext];
    
}

#pragma mark - Action

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addMember:(id)sender {
    AddMemberVC *vc   = [[AddMemberVC alloc] init];
    vc.insertId = 0;
    vc.delegate = self;
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

- (IBAction)switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    
    if ([_fetchedResultsControllerMember.fetchedObjects objectAtIndex:switchControl.tag]) {
        CDMember *member = [_fetchedResultsControllerMember.fetchedObjects objectAtIndex:switchControl.tag];
        if (switchControl.on)
            member.isDisplay = YES;
        else
            member.isDisplay = NO;
        
        [[AppDelegate shared] saveContext];

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
