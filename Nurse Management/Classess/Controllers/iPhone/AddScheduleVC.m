//
//  AddScheduleVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/15/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddScheduleVC.h"
#import "ChooseTimeView.h"
#import "AddScheduleView.h"
#import "FXThemeManager.h"
#import "Define.h"
#import "NMTimePickerView.h"
#import "Common.h"
#import "CDScheduleCategory.h"
#import "ScheduleCategoryItem.h"
#import "AppDelegate.h"
#import "FXCalendarData.h"
#import "ScheduleCategoryVC.h"
#import "CDScheduleAlert.h"
#import "CDSchedule.h"
#import "FXViewController.h"
#import "FXCalendarData.h"

@interface AddScheduleVC ()<UITextViewDelegate, NSFetchedResultsControllerDelegate, ChooseTimeViewDelegate, AddScheduleViewDelegate, NMTimePickerViewDelegate, ChooseTimeViewDelegate, UIActionSheetDelegate>{
    NSDate *_startTime;
    NSDate *_endTime;
    AddScheduleView *_addScheduleView;
    NMTimePickerView *_timePickerView;
    int _getIDScheduleCategory;
    NSDate  *_getDate;
    NSMutableArray *_arrAlerts;
    ChooseTimeView *_chooseTimeView;
    CDSchedule *_schedule;
    BOOL _isShowAddScheduleView, _isSeletedCategory, _isAddNew;
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerScheduleCategory;

- (IBAction)chooseTime:(id)sender;
@end

@implementation AddScheduleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_scheduleEditItem) {
        self.screenName = @"Add Schedule";
    }else{
        self.screenName = @"Edit Schedule";
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrayTimeAlerts = [[NSMutableArray alloc] init];
    //set tag for button
    _btStarTime.tag = START_TIME;
    _btEndTime.tag = END_TIME;
    // init time picker view
    _getDate = [FXCalendarData dateWithSetHourWithHour:[FXCalendarData getHourWithDate:[NSDate date]] date:_selectDate];
    _timePickerView = [[NMTimePickerView alloc] init];
    _timePickerView.delegate = self;
    _timePickerView.datePicker.datePickerMode = UIDatePickerModeTime;
    _timePickerView.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    // view choose time

    _chooseTimeView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(15, 210, 320 - 15*2, 44)];
    _chooseTimeView.delegate = self;
    [_chooseTimeView setStartDate:_selectDate];
    
    [self.view addSubview:_chooseTimeView];
    //[self setDefaultTime];
    [self fetchedResultsControllerScheduleCategory];
    
    if ([self.fetchedResultsControllerScheduleCategory.fetchedObjects count] > 0) {
        CDScheduleCategory *scheduleCategory = self.fetchedResultsControllerScheduleCategory.fetchedObjects[0];
        _getIDScheduleCategory = scheduleCategory.id;
//        _lbName.text     = scheduleCategory.name;
//        _reviewName.text = scheduleCategory.name;
//        ScheduleCategoryItem *item = [ScheduleCategoryItem convertForCDObject:scheduleCategory];
//        _bgReview.image = [UIImage imageNamed:item.image];
        
    }

    self.lbTile.text = [NSString stringWithFormat:@"%d月%d日",[FXCalendarData getMonthWithDate:_selectDate], [FXCalendarData getDayWithDate:_selectDate]];
    
    [self setDataEdit];
}
-(void) setDataEdit
{
    if (_scheduleEditItem) {
        _btDelete.hidden = NO;
        _getIDScheduleCategory = _scheduleEditItem.scheduleCategoryId;
        
        _lbName.text     = _scheduleEditItem.category.name;
        _reviewName.text = _scheduleEditItem.category.name;
        _bgReview.image = [UIImage imageNamed:_scheduleEditItem.category.image];
        
        
        _startTime = _scheduleEditItem.timeStart;
        _endTime = _scheduleEditItem.timeEnd;

        if (!_scheduleEditItem.isAllDay) {
            _isAllDay = NO;
            [_btIsAllTime setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]];
            _beginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
            _EndTime.text     = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
            _btEndTime.enabled = YES;
            _btStarTime.enabled = YES;
            
        } else {
            _isAllDay = YES;
            [_btIsAllTime setBackgroundColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorMain]];
            _beginTime.text   = @"00:00";
            _EndTime.text     = @"00:00";
            _btEndTime.enabled = NO;
            _btStarTime.enabled = NO;
        }
        
        _textViewContent.text = _scheduleEditItem.memo;
        if (_arrAlerts) {
            _arrAlerts = nil;
        }
        _arrAlerts = [[NSMutableArray alloc] init];
        CDSchedule *cdSchedule = [[AppDelegate shared] getScheduleByID:_scheduleEditItem.scheduleID];
        for (CDScheduleAlert *item in cdSchedule.pk_schedule) {
            NSLog(@"alert: %d --- : %f",item.id, item.onTime);
            [_arrAlerts addObject:[NSDate dateWithTimeIntervalSince1970:item.onTime]];
        }
        
        [_chooseTimeView reloadDataWithArrayDate:_arrAlerts andStartDate:_scheduleEditItem.timeStart];

        
    }else{
        _btDelete.hidden = YES;
        _isAddNew = YES;
        _isSeletedCategory = NO;
        
        // set nearest time in roof
        _startTime = [FXCalendarData dateNexHourFormDate:[NSDate date]];
        _beginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
        
        _endTime = [FXCalendarData dateNexHourFormDate:_startTime];
        _EndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
        
        [_chooseTimeView reloadDataWithArrayDate:_arrAlerts andStartDate:_startTime];
    }
}
-(void)loadScheduleDate
{
    NSArray *_arrAlertDates = [_schedule.pk_schedule allObjects];
    if (_arrAlerts)
        _arrAlerts = nil;
    _arrAlerts = [[NSMutableArray alloc] init];
    for (CDScheduleAlert *scheduleAlert in _arrAlertDates) {
        [_arrAlerts addObject:[NSDate dateWithTimeIntervalSince1970:scheduleAlert.onTime]];
    }
    [_chooseTimeView reloadDataWithArrayDate:_arrAlerts andStartDate:[NSDate date]];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    CGRect rect = _viewContent.frame;
    rect.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _viewContent.frame = rect;
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rect = _viewContent.frame;
    if (textView    == _textViewContent) {
        rect.origin.y = -100;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _viewContent.frame = rect;
    }];
    return YES;
}

- (IBAction)changeName:(id)sender {
    
    
    if (_addScheduleView) {
        [_addScheduleView removeFromSuperview];
        _addScheduleView = nil;
    }
    
    _addScheduleView                    = [[NSBundle mainBundle] loadNibNamed:[[FXThemeManager shared] getThemeValueWithKey:_fxThemeXibHomeAddSchedule]
                                                                        owner:self
                                                                      options:nil][0];
    _addScheduleView.delegate           = self;
    _addScheduleView.viewScheduleCategoryTitle.hidden = NO;
    _addScheduleView.btNextSchedule.hidden = YES;
    _addScheduleView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_addScheduleView initLayoutView];
    
    [self.view addSubview:_addScheduleView];
     _isShowAddScheduleView = YES;
    [_addScheduleView loadScheduleCategoryInfo:[self convertScheduleCategory] selectDate:[NSDate date]];
    [_addScheduleView show];
}
- (IBAction)btAllTime:(id)sender {
    _beginTime.text = @"00:00";
    _EndTime.text = @"00:00";
}
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)delete:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取り消し" destructiveButtonTitle:nil otherButtonTitles:@"削除", nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:     // delete
            {
                CDSchedule *item = [[AppDelegate shared] getScheduleByID:_scheduleEditItem.scheduleID];
                [[AppDelegate shared].managedObjectContext deleteObject:item];
                [[AppDelegate shared] saveContext];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];}];
            }
            break;
            
        case 1:     // cancel
            break;
            
        default:
            break;
    }
}
- (IBAction)saveData:(id)sender {
    
    if (_isAddNew && !_isSeletedCategory) {
        [Common showAlert:@"Please, choice schedule category." title:APP_NAME];
        return;
    }
    
    NSArray *keys = @[@"schedule_category_id",
                      @"start_time",
                      @"end_time",
                      @"is_all_day",
                      @"array_alert",
                      @"select_date",
                      @"memo"];
    
    NSArray *values = @[[NSString stringWithFormat:@"%d",_getIDScheduleCategory],
                        (_startTime != nil) ? _startTime : @"",
                        (_endTime != nil) ? _endTime : @"",
                        [NSString stringWithFormat:@"%d",_isAllDay],
                        (_arrayTimeAlerts == nil) ? @"" : _arrayTimeAlerts,
                        _getDate,
                        _textViewContent.text];
    
    
    NSDictionary *info = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    NSLog(@"aaaaaa: %@",info);
    
    if (_scheduleEditItem) {
        [[AppDelegate shared] editScheduleWithInfo:info scheduleID:_scheduleEditItem.scheduleID];
    }else{
        [[AppDelegate shared] addQuickScheduleWithInfo:info];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) setDefaultTime {
    
    // set nearest time in roof
    _startTime = [FXCalendarData dateNexHourFormDate:[NSDate date]];
    _beginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
    
    _endTime = [FXCalendarData dateNexHourFormDate:_startTime];
    _EndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
    
}
- (IBAction)chooseTime:(id)sender {
    if ([sender tag] == 3){
        
        if (_isAllDay) {
            _isAllDay = NO;
            [_btIsAllTime setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]];
            _beginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
            _EndTime.text     = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
            _btEndTime.enabled = YES;
            _btStarTime.enabled = YES;
        } else {
            _isAllDay = YES;
            [_btIsAllTime setBackgroundColor:[[FXThemeManager shared] getColorWithKey:_fxThemeColorMain]];
            _beginTime.text   = @"00:00";
            _EndTime.text     = @"00:00";
            _btEndTime.enabled = NO;
            _btStarTime.enabled = NO;
        }
        return;
        
    } else {
        if ([sender tag] == START_TIME) {
            
            [_timePickerView.datePicker setDate:_startTime?_startTime:[NSDate date] animated:NO];
            _isSetTimeStart = YES;
            
            if (_startTime) {
                _timePickerView.datePicker.minimumDate = nil;
                _timePickerView.datePicker.maximumDate = _endTime;
            }
            
            
            
        } else if ([sender tag] == END_TIME){
            
            [_timePickerView.datePicker setDate:_endTime?_endTime:[NSDate date] animated:NO];
            _isSetTimeStart = NO;
            
            if (_endTime) {
                _timePickerView.datePicker.minimumDate = _startTime;
                _timePickerView.datePicker.maximumDate = nil;
            }
        }
        
        _timePickerView.datePicker.tag = [sender tag];
        [_timePickerView showActionSheetInView:self.view];
        
    }
    
}
#pragma mark - NMTimePickerViewDelegate

- (void) datePicker:(NMTimePickerView *)picker dismissWithButtonDone:(BOOL)done {
    
    if (!done) {
        
    }else{
        if (picker.datePicker.tag == START_TIME) {
            
            _startTime = picker.datePicker.date;
            _beginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
            
        } else if (picker.datePicker.tag == END_TIME) {
            
            _endTime = picker.datePicker.date;
            _EndTime.text     = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
            
        }
    }
    
    
}

#pragma mark - AddScheduleViewDelegate
- (void) didShowCategoryName:(AddScheduleView*)addScheduleView
{
    ScheduleCategoryVC *vc = [[ScheduleCategoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void) didSaveSchedule:(AddScheduleView*)addScheduleView info:(NSDictionary*)info
{
    
}

- (void) didSelectCategory:(AddScheduleView*)addScheduleView categoryID:(int)categoryID
{
    _isSeletedCategory = YES;
    
    _getIDScheduleCategory = categoryID;
    AppDelegate *appdelagate = [AppDelegate shared];
    CDScheduleCategory *scheduleCategory = [appdelagate getScheduleCategoryWithID:categoryID];
    _lbName.text     = scheduleCategory.name;
    _reviewName.text = scheduleCategory.name;
    [_addScheduleView hide];
    
    
    ScheduleCategoryItem *item = [ScheduleCategoryItem convertForCDObject:scheduleCategory];
    _bgReview.image = [UIImage imageNamed:item.image];
    
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
#pragma mark - ChooseTimeViewDelegate

- (void)didChooseTimeWithIndex:(NSInteger)index arrayChooseTime:(NSMutableArray *)arrayChooseTime
{
    _arrayTimeAlerts = arrayChooseTime;
}
#pragma mark - CoreData
- (void) didShowView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = YES;
}

- (void) didHideView:(AddScheduleView*)addScheduleView
{
    _isShowAddScheduleView = NO;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (_isShowAddScheduleView) {
        [_addScheduleView loadScheduleCategoryInfo:[self convertScheduleCategory] selectDate:_selectDate];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
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
@end
