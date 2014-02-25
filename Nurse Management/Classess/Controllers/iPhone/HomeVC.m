//
//  HomeVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//
#import "AppDelegate.h"

#import <MessageUI/MessageUI.h>

#import "HomeVC.h"
#import "FXThemeManager.h"
#import "Common.h"
#import "Define.h"
#import "FXCalendarData.h"
#import "CSLINEOpener.h"

#import "HomeNaviBarView.h"
#import "HomeToolBarView.h"
#import "AddShiftView.h"
#import "AddScheduleView.h"

#import "RankingVC.h"
#import "MoreVC.h"
#import "ListShiftPatternVC.h"
#import "ScheduleCategoryVC.h"

#import "FXCalendarView.h"
#import "ListMembersVC.h"

#import "HomeCellAddShift.h"
#import "HomeCellAddSchedule.h"
#import "HomeCellSchedule.h"
#import "AddScheduleVC.h"
#import "FXNavigationController.h"
#import "AddShiftVC.h"

#import "CDMember.h"
#import "CDShiftCategory.h"
#import "ShiftCategoryItem.h"
#import "CDScheduleCategory.h"
#import "ScheduleCategoryItem.h"
#import "ScheduleItem.h"

@interface HomeVC ()<HomeNaviBarViewDelegate, HomeToolBarViewDelegate, AddShiftViewDelegate, AddScheduleViewDelegate, FXCalendarViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    HomeNaviBarView *_naviView ;
    HomeToolBarView *_toolBarView;
    
    AddShiftView    *_addShiftView;
    AddScheduleView *_addScheduleView;
    
    FXCalendarView  *_calendarView;
    
    __weak IBOutlet UITableView *_tableView;
    
    BOOL _isShowAddShiftView, _isShowAddScheduleView;
}

@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, strong) NSMutableArray *scheduleOnDate;

@end

@implementation HomeVC

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
    
    self.selectDate = [NSDate date];
    
    [self loadCalendar];
    [self resetLayoutTableWithAnimate:NO];
    [self.view bringSubviewToFront:_tableView];
    
    [self loadHomeNaivBar];
    [self loadHomeToolBar];
    [self loadHomeAddShiftView];
    [self loadHomeAddScheduleView];
    
    // load core data
    [self fetchedResultsControllerMember];
    [self fetchedResultsControllerShiftCategory];
    [self fetchedResultsControllerScheduleCategory];
    
}

- (void)viewDidUnload {
    self.fetchedResultsControllerMember = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = GA_HOMEVC;
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
        NSLog(@"total item : %d",[_fetchedResultsControllerMember.fetchedObjects count]);
    }

    
    return _fetchedResultsControllerMember;
    
}

- (NSFetchedResultsController*) fetchedResultsControllerShiftCategory
{
    if (!_fetchedResultsControllerShiftCategory) {
        NSString *entityName = @"CDShiftCategory";
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
        _fetchedResultsControllerShiftCategory = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:_appDelegate.managedObjectContext
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:cacheName];
        _fetchedResultsControllerShiftCategory.delegate = self;
        
        NSError *error = nil;
        [_fetchedResultsControllerShiftCategory performFetch:&error];
        if (error) {
            NSLog(@"%@ core data error: %@", [self class], error.localizedDescription);
        }
        
        if ([_fetchedResultsControllerShiftCategory.fetchedObjects count] == 0) {
            NSLog(@"add data for Shift Category item");
            
            //read file
            NSString *path = [[NSBundle mainBundle] pathForResource:@"predefault" ofType:@"plist"];
            
            // Load the file content and read the data into arrays
            if (path)
            {
                NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSArray *totalCategory = [dict objectForKey:@"ShiftCategory"];
                NSLog(@" totalCategory %@",totalCategory);
                //Creater coredata
                for (int i = 0 ; i < [totalCategory count]; i++) {
                    NSLog(@" key %d object %@",i, totalCategory[i]);
                    CDShiftCategory *cdShiftCategory = (CDShiftCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"CDShiftCategory" inManagedObjectContext:_appDelegate.managedObjectContext];
                    NSArray *tmpArr = totalCategory[i];
                    
                    cdShiftCategory.id = i + 1;
                    cdShiftCategory.name = tmpArr[0];
                    cdShiftCategory.timeStart = tmpArr[1];
                    cdShiftCategory.timeEnd = tmpArr[2];
                    cdShiftCategory.isEnable = YES;
                    if ([tmpArr[3] integerValue]) {
                        cdShiftCategory.isAllDay = YES;
                    }
                    else
                    {
                        cdShiftCategory.isAllDay = NO ;
                    }
                    
                    cdShiftCategory.color = tmpArr[4];
                    
                    NSLog(@" name %@ is All Day %d", cdShiftCategory.name, cdShiftCategory.isAllDay);
                    
                }
                
                [_appDelegate saveContext];
                
            } else {
                NSLog(@"path error");
            }
            
        } else {
            NSLog(@"total shift item : %d",(int)[_fetchedResultsControllerShiftCategory.fetchedObjects count]);
        }
    }
    
    return _fetchedResultsControllerShiftCategory;
}

- (NSFetchedResultsController*) fetchedResultsControllerScheduleCategory
{
    
    if (!_fetchedResultsControllerScheduleCategory) {
        
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
            NSLog(@"add data for schedule Category item");
            
            //read file
            NSString *path = [[NSBundle mainBundle] pathForResource:@"predefault" ofType:@"plist"];
            
            // Load the file content and read the data into arrays
            if (path)
            {
                NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSArray *totalScheduleCategory = [dict objectForKey:@"ScheduleCategory"];
                
                //Creater coredata
                for (int i = 0 ; i < [totalScheduleCategory count]; i++) {
                    CDScheduleCategory *cdScheduleCategory = (CDScheduleCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"CDScheduleCategory"
                                                                                                        inManagedObjectContext:_appDelegate.managedObjectContext];
                    
                    cdScheduleCategory.id          = i + 1;
                    cdScheduleCategory.name        = [totalScheduleCategory objectAtIndex:i];
                    cdScheduleCategory.color       = [NSString stringWithFormat:@"%d",i%10];
                    cdScheduleCategory.isDefault   = YES;
                    cdScheduleCategory.isEnable    = YES;
                }
                
                [_appDelegate saveContext];
                
            } else {
                NSLog(@"path error");
            }
            
        } else {
            NSLog(@"total schedule item : %d",[_fetchedResultsControllerScheduleCategory.fetchedObjects count]);
        }
        
    }
    
    return _fetchedResultsControllerScheduleCategory;
}

#pragma mark - Fetch CoreData

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (controller == _fetchedResultsControllerShiftCategory) {
        
        if (_isShowAddShiftView) {
            [_addShiftView loadInfoWithShiftCategories:[self convertShiftObject]];
        }
        
    } else if (controller == _fetchedResultsControllerScheduleCategory) {
        
        if (_isShowAddScheduleView) {
            [_addScheduleView loadScheduleCategoryInfo:[self convertScheduleCategory] selectDate:_selectDate];
        }
        
    } if (controller == _fetchedResultsControllerMember) {
        
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
}



#pragma mark - Notification
- (void)eventListenerDidReceiveNotification:(NSNotification *)notif
{
    [super eventListenerDidReceiveNotification:notif];
    
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme]) {
        [self loadHomeNaivBar];
        [self loadHomeToolBar];
        [self loadHomeAddShiftView];
        [self loadHomeAddScheduleView];
        
        [_calendarView reloadTheme];
    } else if ([[notif name] isEqualToString:DID_ADD_SCHEDULE]) {
        [_calendarView reloadData];
        self.scheduleOnDate = [[AppDelegate shared] getSchedulesOnDate:_selectDate];
        [_tableView reloadData];
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if ([[notif name] isEqualToString:FIRST_OF_CALENDAR]) {
        
        [_calendarView reloadChangeFirstDayOfCalendar];
        
    }
}


#pragma mark - Others

- (void) loadCalendar
{
    int detalIOS = [Common isIOS7] ? 0 : - 20;
    
    _calendarView                   = [[NSBundle mainBundle] loadNibNamed:@"FXCalendarView" owner:self options:nil][0];
    _calendarView.delegate          = self;
    _calendarView.frame             = CGRectMake(0, 64 + detalIOS, 320, 350);
    [_calendarView initCalendar];
    
    [self.view addSubview:_calendarView];
    
    [_calendarView reloadViewisFull:YES];
}

- (void)loadHomeNaivBar
{
    if (_naviView) {
        [_naviView removeFromSuperview];
        _naviView = nil;
    }
    
    int detalIOS = [Common isIOS7] ? 0 : - 20;
    
    _naviView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeNaviBar]
                                                                 owner:self
                                                               options:nil][0];
    _naviView.delegate           = self;
    _naviView.frame              = CGRectMake(0, detalIOS, 320, 64);
    _naviView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    [self.view addSubview:_naviView];
    
    NSDate *date = [NSDate date];
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
}

- (void)loadHomeToolBar
{
    if (_toolBarView) {
        [_toolBarView removeFromSuperview];
        _toolBarView = nil;
    }
    
    float detalIOS = [Common isIOS7] ? 0 : 20;
    float height   = [Common checkScreenIPhone5] ? 568 : 480;
    
    _toolBarView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeToolBar]
                                                                    owner:self
                                                                  options:nil][0];
    _toolBarView.delegate           = self;
    _toolBarView.frame              = CGRectMake(0, height - detalIOS - 49, 320, 49);
    _toolBarView.backgroundColor    = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    
    [self.view addSubview:_toolBarView];
}

- (void)loadHomeAddShiftView
{
    if (_addShiftView) {
        [_addShiftView removeFromSuperview];
        _addShiftView = nil;
    }
    
    float detalIOS = [Common isIOS7] ? 0 : 20;
    float height   = [Common checkScreenIPhone5] ? 568 : 480;
    
    _addShiftView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddShift]
                                                                    owner:self
                                                                  options:nil][0];
    _addShiftView.delegate           = self;
    _addShiftView.frame = CGRectMake(0, height - detalIOS, 320, 200);
    
    [self.view addSubview:_addShiftView];
}

- (void)loadHomeAddScheduleView
{
    if (_addScheduleView) {
        [_addScheduleView removeFromSuperview];
        _addScheduleView = nil;
    }
    
    _addScheduleView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddSchedule]
                                                                     owner:self
                                                                   options:nil][0];
    _addScheduleView.delegate           = self;
    _addScheduleView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_addScheduleView initLayoutView];
    
    [self.view addSubview:_addScheduleView];
    
}

- (NSData *) captureScreenshot {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * data = UIImagePNGRepresentation(image);
    
    return data;
    
}

#pragma mark - HomeNaviBarViewDelegate
- (void) homeNaviBarViewDidSelectToDay:(HomeNaviBarView*)homeNaviBarView
{
    NSDate *date = [NSDate date];
    self.selectDate = date;
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    
    [_calendarView reloadToday];
}

- (void) homeNaviBarViewDidSelectMail:(HomeNaviBarView*)homeNaviBarView
{
    NSLog(@"send mail");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"シフトカレンダーをシェア" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"シフトをメールで送信", @"シフトをLINEで送信", @"カレンダー画像を保存", @"カレンダー画像をLINEで送信", nil];
    [actionSheet showInView:self.view];

}

#pragma mark - HomeToolBarViewDelegate 
- (void) homeToolBarView:(HomeToolBarView*) homeToolBarView didSelectWithIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [self showAddShift];
            break;
        }
        case 1:
        {
            if (!_isShowAddScheduleView) {
                _isShowAddScheduleView = YES;
                [_addScheduleView loadScheduleCategoryInfo:[self convertScheduleCategory] selectDate:_selectDate];
                [_addScheduleView show];
            }
           
            break;
        }
        case 2:
        {
            RankingVC *rankingVC = [[RankingVC alloc] init];
            [self.navigationController pushViewController:rankingVC animated:YES];
            
            break;
        }
        case 3:
        {
            MoreVC *moreVC = [[MoreVC alloc] init];
            [self.navigationController pushViewController:moreVC animated:YES];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Add Shift
- (NSMutableArray*) convertShiftObject
{
    NSMutableArray *shifts = [[NSMutableArray alloc] init];
    
    for (CDShiftCategory *cdShift in self.fetchedResultsControllerShiftCategory.fetchedObjects) {
        
        if (cdShift.isEnable) {
            ShiftCategoryItem *item = [[ShiftCategoryItem alloc] init];
            
            item.shiftCategoryID = cdShift.id;
            item.name            = cdShift.name;
            item.color           = cdShift.color;
            
            [shifts addObject:item];
        }
        
    }
    
    return shifts;
}

- (void) showAddShift
{
    if (_isShowAddShiftView) {
        return;
    }
    
    _isShowAddShiftView = YES;
    [_addShiftView loadInfoWithShiftCategories:[self convertShiftObject]];
    
    CGRect rect = _addShiftView.frame;
    rect.origin.y -= _addShiftView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _addShiftView.frame = rect;
    } completion:^(BOOL finished) {
        _isShowAddShiftView = YES;
        
        
        
    }];
}

- (void) hideAddShift
{
    if (!_isShowAddShiftView) {
        return;
    }
    
    _isShowAddShiftView = NO;
    CGRect rect     = _addShiftView.frame;
    rect.origin.y   += _addShiftView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _addShiftView.frame = rect;
    } completion:^(BOOL finished) {
        _isShowAddShiftView = NO;
    }];
}

#pragma mark - AddShiftViewDelegate
- (void) addShiftView:(AddShiftView*)addShiftView didSelectWithIndex:(int)index
{
    [[AppDelegate shared] addQuickShiftWithShiftCategoryID:index date:_selectDate];
    [_calendarView setNextSelectDate];
}

- (void) addShiftViewDidSelectShowListShiftPattern:(AddShiftView*)addShiftView
{
    ListShiftPatternVC *vc = [[ListShiftPatternVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) addShiftViewDidSelectCloseView:(AddShiftView*)addShiftView
{
    [self hideAddShift];
}

#pragma mark - AddScheduleViewDelegate 
- (void) didShowCategoryName:(AddScheduleView*)addScheduleView
{
    ScheduleCategoryVC *vc = [[ScheduleCategoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) didSaveSchedule:(AddScheduleView*)addScheduleView info:(NSDictionary*)info
{
    NSLog(@"save schedule info: %@",info);
    [[AppDelegate shared] addQuickScheduleWithInfo:info];
}

- (void) didShowView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = YES;
}

- (void) didHideView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = NO;
}

- (NSMutableArray*) convertScheduleCategory
{
    NSMutableArray *schedules = [[NSMutableArray alloc] init];
    
    for (CDScheduleCategory *cdSchedule in self.fetchedResultsControllerScheduleCategory.fetchedObjects) {
        
        if (cdSchedule.isEnable) {
            ScheduleCategoryItem *item  = [[ScheduleCategoryItem alloc] init];
            
            item.scheduleCategoryID     = cdSchedule.id;
            item.name                   = cdSchedule.name;
            item.color                  = cdSchedule.color;
            
            [schedules addObject:item];
        }
        
    }
    
    return schedules;
}


#pragma mark - FXCalendarViewDelegate
- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didChangeMonthWithFirstDay:(NSDate*)date
{
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    self.selectDate = date;
    [self resetLayoutTableWithAnimate:YES];
}

- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didSelectDay:(NSDate*)date
{
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    self.selectDate = date;
    [self resetLayoutTableWithAnimate:YES];
}

- (void) fXCalendarView:(FXCalendarView*)fXCalendarView didSelectNextDay:(NSDate*)date
{
    [_naviView setTitleWithDay:[FXCalendarData getDayWithDate:date]
                         month:[FXCalendarData getMonthWithDate:date]
                          year:[FXCalendarData getYearWithDate:date]];
    self.selectDate = date;
    [self resetLayoutTableWithAnimate:YES];
}

- (void) fxcalendarView:(FXCalendarView*)fXCalendarView didFull:(BOOL)isFull
{
     _tableView.hidden   = isFull;
}

#pragma mark - Table view
- (void) resetLayoutTableWithAnimate:(BOOL)isAnimate
{
    float detalIOS      = [Common isIOS7] ? 0 : 20;
    float height        = [Common checkScreenIPhone5] ? 568 : 480;
    
    CGRect rect = CGRectMake(0,
                             [_calendarView heightCalendarWithCurrentMonth] + 64 - detalIOS ,
                             320,
                             height - 49 - [_calendarView heightCalendarWithCurrentMonth]);
    
    if (isAnimate) {
        [UIView animateWithDuration:0.3 animations:^{
            
            _tableView.frame = rect;
            
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _tableView.frame = rect;
    }
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2) {
        return 44;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [_scheduleOnDate count];
    } else if (section == 2) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        HomeCellAddShift *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellAddShift"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCellAddShift" owner:self options:nil] lastObject];
        }
        
        CDShift *shift = [[AppDelegate shared] getShiftWithDate:_selectDate];
        [cell loadInfoWithNSDate:_selectDate shift:shift];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        HomeCellAddSchedule *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellAddSchedule"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCellAddSchedule" owner:self options:nil] lastObject];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        HomeCellSchedule *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellSchedule"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCellSchedule" owner:self options:nil] lastObject];
        }
        
        ScheduleItem *item = [_scheduleOnDate objectAtIndex:indexPath.row];
        
        cell.lbTimeStart.text       = [item getStringTimeStart:YES];
        cell.lbTimeEnd.text         = [item getStringTimeStart:NO];
        cell.lbMemo.text            = item.memo;
        cell.lbCategoryName.text    = item.category.name;
        cell.imgCategory.image      = [UIImage imageNamed:item.category.image];
        
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        ScheduleItem *item = [_scheduleOnDate objectAtIndex:indexPath.row];
        NSLog(@"schedule ID: %d",item.scheduleID);
        AddScheduleVC *vc                  = [[AddScheduleVC alloc] init];
        vc.selectDate = _selectDate;
        vc.scheduleEditItem = item;
        FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
        
        [self.navigationController presentViewController:navi animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:     // send email
        {
            int month = [FXCalendarData getMonthWithDate:_selectDate];
            
            NSString *emailTitle = [NSString stringWithFormat:@"%d月の勤務", month];
            NSString *messageBody = [NSString stringWithFormat:@"%d月の勤務表を送ります", month];
//            NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
//            [mc setToRecipients:toRecipents];
            
            NSData *data = [self captureScreenshot];
            [data writeToFile:@"screenshot.png" atomically:YES];
            [mc addAttachmentData:data mimeType:@"image/png" fileName:@"screenshot.png"];
            
            [self presentViewController:mc animated:YES completion:NULL];
            break;
        }
            
        case 1:     // send LINE with a shift
        {
            
            CDShift *shift = [[AppDelegate shared] getShiftWithDate:self.selectDate];
            NSLog(@"selected date: %@", self.selectDate);
            if ([CSLINEOpener canOpenLINE]) {
                
                if (shift) {
                    ShiftCategoryItem *shiftCategory = [ShiftCategoryItem convertForCDObject:shift.fk_shift_category];
                    
                    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:shift.timeStart];
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:shift.timeEnd];
                    NSInteger endHour = [FXCalendarData getHourWithDate:endDate];
                    NSString *strStartTime = [Common convertTimeToStringWithFormat:@"HH:mm" date:startDate];
                    NSString *strEndTime = (endHour == 0) ? @"24:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:endDate] ;
                    
                    NSString *shiftInformation = [NSString stringWithFormat:@"Shift category: %@ \nDuration: %@ \n", shiftCategory.name, shift.isAllDay?TEXT_ALL_DAY:[NSString stringWithFormat:@"%@～%@", strStartTime, strEndTime]];
                    
                    NSString *member = @"";
                    if ([shift.pk_shift count] == 0) {
                        member = [member stringByAppendingString:@"0 members"];
                    } else {
                        int count = 0;
                        for (CDMember *item in shift.pk_shift) {
                            
                            if (count == [shift.pk_shift count] - 1) {
                                member = [member stringByAppendingFormat:@"%@",item.name];
                            } else {
                                member = [member stringByAppendingFormat:@"%@, ",item.name];
                            }
                            
                            count++;
                        }
                    }
                    
                    shiftInformation = [shiftInformation stringByAppendingString:[NSString stringWithFormat:@"Members: %@\n", member]];
                    
                    NSString *alert = @"";
                    if ([shift.pk_shiftalert count] == 0)
                        alert = @"0 alerts";
                    else {
                        int count = 0;
                        for (CDShiftAlert *alarm in [shift.pk_shiftalert allObjects]) {
                            // get the interval of the alarm time
                            double duration = shift.timeStart - alarm.onTime;
                            NSString *strAlert = [Common durationFromUnixTime:duration];
                            if ([strAlert isEqualToString:@""]) {
                                strAlert = [Common stringFromDate:[NSDate dateWithTimeIntervalSince1970:alarm.onTime] withFormat:@"HH:mm"];
                            }
                            if (count == [shift.pk_shiftalert count] - 1) {
                                alert = [alert stringByAppendingString:strAlert];
                            } else {
                                alert = [alert stringByAppendingString:[NSString stringWithFormat:@"%@, ", strAlert]];
                            }
                            count++;
                        }
                    }
                    
                    shiftInformation = [shiftInformation stringByAppendingString:[NSString stringWithFormat:@"Alarms: %@\n", alert]];
                    
                    [CSLINEOpener openLINEAppWithText:shiftInformation];
                    
                } else {
                    [CSLINEOpener openLINEAppWithText:@"No shift at this date"];
                }
                
            } else {
                [CSLINEOpener openAppStore];
            }
            
            break;
        }
            
        case 2:     // save calendar image
        {
            NSData *data = [self captureScreenshot];
            UIImage *image = [UIImage imageWithData:data];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            
            break;
        }
            
        case 3:     // send LINE with captured calendar
            
            if ([CSLINEOpener canOpenLINE]) {
                NSData *data = [self captureScreenshot];
                UIImage *image = [UIImage imageWithData:data];
                [CSLINEOpener openLINEAppWithImage:image];
            } else {
                [CSLINEOpener openAppStore];
            }
            
            break;
            
        default:
            break;
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            [Common showAlert:@"メールが保存された。" title:@""];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [Common showAlert:@"メールが送信された。" title:@""];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            [Common showAlert:[NSString stringWithFormat:@"メールは失敗を送った %@", [error localizedDescription]] title:@""];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if (error)
        [Common showAlert:[NSString stringWithFormat:@"エラー： %@", [error localizedDescription]] title:@""];
    else
        [Common showAlert:@"写真が保存された。" title:@""];
}

#pragma mark - Action
- (IBAction)addShift:(id)sender
{
    NSLog(@"show view Add shift");
    
    AddShiftVC *addShiftVC = [[AddShiftVC alloc] init];
    addShiftVC.isNewShift = YES;
    addShiftVC.date = _selectDate;
    FXNavigationController *nc = [[FXNavigationController alloc] initWithRootViewController:addShiftVC];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)editShif:(id)sender
{
    NSLog(@"show view Edit shift");
    
    AddShiftVC *addShiftVC = [[AddShiftVC alloc] init];
    addShiftVC.isNewShift = NO;
    addShiftVC.date = _selectDate;
    addShiftVC.shiftID = [sender tag];
    FXNavigationController *nc = [[FXNavigationController alloc] initWithRootViewController:addShiftVC];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)addSchedule:(id)sender {
    
    AddScheduleVC *vc                  = [[AddScheduleVC alloc] init];
    vc.selectDate = _selectDate;
    FXNavigationController *navi    = [[FXNavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];

}

#pragma mark - Setter
- (void) setSelectDate:(NSDate *)selectDate
{
    _selectDate = selectDate;
    self.scheduleOnDate = [[AppDelegate shared] getSchedulesOnDate:selectDate];
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
















@end
