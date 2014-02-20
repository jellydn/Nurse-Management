//
//  AddShiftVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "AddShiftVC.h"
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "FXCalendarData.h"
#import "UIPickerActionSheet.h"
#import "ListMembersVC.h"
#import "FXNavigationController.h"
#import "ChooseTimeView.h"
#import "AddShiftView.h"
#import "ListShiftPatternVC.h"
#import "NMSelectionStringView.h"
#import "NMTimePickerView.h"
#import "AppDelegate.h"
#import "ShiftCategoryItem.h"

#import "CDMember.h"
#import "CDShift.h"
#import "CDShiftMember.h"
#import "CDShiftAlert.h"

#define ALERT_BG_COLOR	 [UIColor colorWithRed:100.0/255.0 green:137.0/255.0 blue:199.0/255.0 alpha:1.0]
#define BUTTON_BG_COLOR	 [UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]
#define TITLE_COLOR	 [UIColor colorWithRed:126.0/255.0 green:96.0/255.0 blue:39.0/255.0 alpha:1.0]
#define kOFFSET_FOR_KEYBOARD 160.0
#define MEMO_PLACEHOLDER_TEXT    @"メモがあったら入力しよう"

@interface AddShiftVC () <UITextViewDelegate, UIActionSheetDelegate, ChooseTimeViewDelegate, AddShiftViewDelegate, NMSelectionStringViewDelegate, NSFetchedResultsControllerDelegate, NMTimePickerViewDelegate>
{
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    
    __weak IBOutlet UIButton *_btnStartTime;
    __weak IBOutlet UIButton *_btnEndTime;
    __weak IBOutlet UIButton *_btnSave;
    __weak IBOutlet UIButton *_btnSaveAndNext;
    __weak IBOutlet UILabel *_lblStartTime;
    __weak IBOutlet UILabel *_lblEndTime;
    __weak IBOutlet UILabel *_lblShiftCategoryName;
    
    __weak IBOutlet UITextView *_txvMemo;
    __weak IBOutlet UIImageView *_imvShiftCategoryBG;
    
    NSDate *_startTime;
    NSDate *_endTime;
    NSArray *_arrMember;
    NSArray *_arrAlerts;
    
    BOOL _isShowAddShiftView;
    BOOL _isAllDay;
    
    UIPickerActionSheet *_pickerActionSheet;
    NMTimePickerView *_timePickerView;
    AddShiftView    *_addShiftView;
    NMSelectionStringView *_nMSelectionStringView;
    ChooseTimeView *_chooseTimeView;
    
    CDShift *_shift;
}

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)chooseShiftCategory:(id)sender;
- (IBAction)chooseTimeMode:(id)sender;
- (IBAction)chooseTime:(id)sender;
- (IBAction)chooseMembers:(id)sender;
- (IBAction)tapHideKeyboard:(UITapGestureRecognizer *)sender;
- (IBAction)saveAndMoveToNextDay:(id)sender;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;


@end

@implementation AddShiftVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    
    // set tag for time buttons
    _btnStartTime.tag = START_TIME;
    _btnEndTime.tag = END_TIME;
    
    // init time picker view
    _timePickerView = [[NMTimePickerView alloc] init];
    _timePickerView.delegate = self;
    _timePickerView.datePicker.datePickerMode = UIDatePickerModeTime;
    _timePickerView.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    
    // Choose Time view
    _chooseTimeView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(15, 362, 320 - 15*2, 44)];
    _chooseTimeView.delegate = self;
    [_chooseTimeView setStartDate:[NSDate date]];
    [self.view addSubview:_chooseTimeView];
    
    // load core data
    [self fetchedResultsControllerMember];
    [self fetchedResultsControllerShiftCategory];
    
    // init Add Shift view
    [self loadHomeAddShiftView];
    
    // init Choose Member view
    [self loadChooseMemberView];
    
    if (_isNewShift) {
        
        _shift = (CDShift *) [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SHIFT inManagedObjectContext:[AppDelegate shared].managedObjectContext];
        [self setDefaultTime];
        _txvMemo.text = MEMO_PLACEHOLDER_TEXT;
        _txvMemo.textColor = [UIColor lightGrayColor];
        
    } else {
        
        _shift = [[AppDelegate shared] getShiftWithShiftID:_shiftID];
        [self loadShiftFromCoreData];
        _btnSave.enabled = YES;
        _btnSaveAndNext.enabled = YES;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView isEqual:_txvMemo])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        
        if ([textView.text isEqualToString:MEMO_PLACEHOLDER_TEXT]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = MEMO_PLACEHOLDER_TEXT;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
//    [textView resignFirstResponder];
}

#pragma mark - AddShiftViewDelegate
- (void) addShiftView:(AddShiftView*)addShiftView didSelectWithIndex:(int)index
{
    NSLog(@"Add Shift select item with index: %d", index);
    CDShiftCategory *shiftCategory = [[AppDelegate shared] getshiftCategoryWithID:index];
    _shift.fk_shift_category = shiftCategory;
    _shift.shiftCategoryId = shiftCategory.id;
    _btnSave.enabled = YES;
    _btnSaveAndNext.enabled = YES;
    
    NSMutableArray *shiftItems = [self convertShiftObject];
    for (ShiftCategoryItem *item in shiftItems)
    {
        if (item.shiftCategoryID == index) {
            _imvShiftCategoryBG.image = [UIImage imageNamed:item.image];
            _lblShiftCategoryName.text = item.name;
            _lblShiftCategoryName.textColor = item.textColor;
        }
    }
    
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

#pragma mark - NMSelectionStringViewDelegate

- (void)didSelectionCDMemberWithIndex:(NSInteger)index arraySelectionCDMember:(NSMutableArray *)arraySelectionCDMember
{
    _arrMember = arraySelectionCDMember;
    
}

#pragma mark - ChooseTimeViewDelegate

- (void) didChooseTimeWithIndex:(NSInteger)index arrayChooseTime:(NSMutableArray *)arrayChooseTime {
    NSLog(@"choose time: %@", arrayChooseTime);
    _arrAlerts = arrayChooseTime;
}

#pragma mark - NMTimePickerViewDelegate

- (void) datePicker:(NMTimePickerView *)picker dismissWithButtonDone:(BOOL)done {
    
    if (done) {
        if (picker.datePicker.tag == START_TIME) {
            
            _startTime = picker.datePicker.date;
            _lblStartTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
            
        } else if (picker.datePicker.tag == END_TIME) {
            
            _endTime = picker.datePicker.date;
            _lblEndTime.text     = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
            
        }
    }
    
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    [self saveShiftToCoreData];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)chooseShiftCategory:(id)sender {
    
    [self showAddShift];
    
}

- (IBAction)chooseTimeMode:(id)sender {
    UIButton *btnAllDay = (UIButton *)sender;
    
    if ([btnAllDay tag] == 1) {
        
        _isAllDay = YES;
        btnAllDay.tag = 2;
        btnAllDay.backgroundColor = ALERT_BG_COLOR;
        
        _lblStartTime.enabled = NO;
        _lblStartTime.textColor = [UIColor grayColor];
        _lblStartTime.text = @"00:00";
        _lblEndTime.enabled = NO;
        _lblEndTime.textColor = [UIColor grayColor];
        _lblEndTime.text = @"00:00";
        
    } else if ([btnAllDay tag] == 2) {
        
        _isAllDay = NO;
        btnAllDay.tag = 1;
        btnAllDay.backgroundColor = BUTTON_BG_COLOR;
        
        _lblStartTime.enabled = YES;
        _lblStartTime.textColor = TITLE_COLOR;

        if (_startTime)
            _lblStartTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
        else
            _lblStartTime.text = @"00:00";
        
        _lblEndTime.enabled = YES;
        _lblEndTime.textColor = TITLE_COLOR;
        
        if (_endTime)
            _lblEndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
        else
            _lblEndTime.text = @"00:00";
        
    }
}

- (IBAction)chooseTime:(id)sender {
    
    if ([sender tag] == START_TIME)
        [_timePickerView.datePicker setDate:_startTime?_startTime:[NSDate date] animated:NO];
    else if ([sender tag] == END_TIME)
        [_timePickerView.datePicker setDate:_endTime?_endTime:[NSDate date] animated:NO];
    
    _timePickerView.datePicker.tag = [sender tag];
    [_timePickerView showActionSheetInView:self.view];
    
}

- (IBAction)chooseMembers:(id)sender {
    
    ListMembersVC *listMembersVC = [[ListMembersVC alloc] init];
    [self.navigationController pushViewController:listMembersVC animated:YES];
    
}

- (IBAction)saveAndMoveToNextDay:(id)sender {
    
    if (_shift.fk_shift_category) {     // shift category required
    
        [self saveShiftToCoreData];
        if (_shift)
            _shift = nil;
        _shift = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SHIFT inManagedObjectContext:[AppDelegate shared].managedObjectContext];
        _date = [FXCalendarData nextDateFrom:_date];
        _lbTile.text = [NSString stringWithFormat:@"%d月%d日",[FXCalendarData getDayWithDate:_date], [FXCalendarData getMonthWithDate:_date]];
        [self clearDataFromUI];
        
    } else {
        
        [Common showAlert:@"継続してシフトカテゴリを選択してください。" title:@""];
        
    }

}

#pragma mark - Shift Category

- (void) showAddShift
{
    if (_isShowAddShiftView) {
        return;
    }
    
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
    
    CGRect rect     = _addShiftView.frame;
    rect.origin.y   += _addShiftView.frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _addShiftView.frame = rect;
    } completion:^(BOOL finished) {
        _isShowAddShiftView = NO;
    }];
}

- (NSMutableArray*) convertShiftObject
{
    NSMutableArray *shifts = [[NSMutableArray alloc] init];
    
    for (CDShiftCategory *cdShift in self.fetchedResultsControllerShiftCategory.fetchedObjects) {
        
        ShiftCategoryItem *item = [[ShiftCategoryItem alloc] init];
        
        item.shiftCategoryID = cdShift.id;
        item.name            = cdShift.name;
        item.color           = cdShift.color;
        
        [shifts addObject:item];
        
    }
    
    return shifts;
}

#pragma mark - Keyboard Notifications

- (IBAction)tapHideKeyboard:(UITapGestureRecognizer *)sender {
    [_txvMemo resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboard show");
    
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = [NSString stringWithFormat:@"%d月%d日",[FXCalendarData getDayWithDate:_date], [FXCalendarData getMonthWithDate:_date]];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
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

- (void) loadChooseMemberView {
    
    if (_nMSelectionStringView) {
        [_nMSelectionStringView removeFromSuperview];
        _nMSelectionStringView = nil;
    }
    _nMSelectionStringView = [[NMSelectionStringView alloc] initWithFrame:CGRectMake(15, 215, 320 - 15*2, 118)];
    _nMSelectionStringView.delegate = self;
    [_nMSelectionStringView setArrayCDMember:(NSMutableArray *)_fetchedResultsControllerMember.fetchedObjects];
    
    [self.view addSubview:_nMSelectionStringView];
    
}

- (NSDate *) dateAfterSetHour: (int)hour andMinute: (int)minute fromDate: (NSDate *)currentDate {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: currentDate];
    [components setHour: hour];
    [components setMinute: minute];
    [components setSecond: 0];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    return newDate;
}

- (void) clearDataFromUI {
    
    _btnSave.enabled = NO;
    _imvShiftCategoryBG.image = [UIImage imageNamed:@""];
    _lblShiftCategoryName.text = @"";
    [self setDefaultTime];
    [_chooseTimeView resetChooseTimeView];
    _arrMember = nil;
    _arrAlerts = nil;
    _txvMemo.text = @"";
    _btnSaveAndNext.enabled = NO;
    
}

- (void) setDefaultTime {
    
    // set nearest time in roof
    _startTime = [FXCalendarData dateNexHourFormDate:[NSDate date]];
    _lblStartTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
    
    _endTime = [FXCalendarData dateNexHourFormDate:_startTime];
    _lblEndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
    
}

#pragma mark - Core Data

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

//    _isLoadCoreData = NO;
    
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
            NSString *path = [[NSBundle mainBundle] pathForResource:@"tienlp_predefault" ofType:@"plist"];
            
            // Load the file content and read the data into arrays
            if (path)
            {
                NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSArray *totalShiftCategory = [dict objectForKey:@"ShiftCategory"];
                
                //Creater coredata
                for (int i = 0 ; i < [totalShiftCategory count]; i++) {
                    CDShiftCategory *cdShiftCategory = (CDShiftCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"CDShiftCategory"
                                                                                                        inManagedObjectContext:_appDelegate.managedObjectContext];
                    
                    cdShiftCategory.id      = i + 1;
                    cdShiftCategory.name    = [totalShiftCategory objectAtIndex:i];
                    cdShiftCategory.color   = [NSString stringWithFormat:@"%d",i%10];
                }
                
                [_appDelegate saveContext];
                
            } else {
                NSLog(@"path error");
            }
            
        } else {
            NSLog(@"total shift item : %lu",(unsigned long)[_fetchedResultsControllerShiftCategory.fetchedObjects count]);
        }
    }
    
    return _fetchedResultsControllerShiftCategory;
}

- (void) saveShiftToCoreData {
    
    if (_isNewShift)
        _shift.id = [[AppDelegate shared] lastShiftID] + 1;
    
    _shift.isAllDay = _isAllDay;
    
    if (!_isAllDay) {
        _shift.timeStart = [_startTime timeIntervalSince1970];
        _shift.timeEnd = [_endTime timeIntervalSince1970];
    }
    
    _shift.onDate = [_date timeIntervalSince1970];
    _shift.memo = _txvMemo.text;
    
    if (_arrMember) {
        
        for (CDMember *member in _arrMember)
            [_shift addPk_shiftObject:member];
        
    }
    
    if (_arrAlerts) {
        
        for (NSDate *alertDate in _arrAlerts) {
            CDShiftAlert *shiftAlert = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SHIFT_ALERT inManagedObjectContext:[AppDelegate shared].managedObjectContext];
            shiftAlert.shiftId = _shift.id;
            shiftAlert.onTime = [alertDate timeIntervalSince1970];
            
            [_shift addPk_shiftalertObject:shiftAlert];
        }
        
    }
    
    [[AppDelegate shared] saveContext];
    
}

- (void) loadShiftFromCoreData {
    
    // shift category
    NSMutableArray *shiftItems = [self convertShiftObject];
    for (ShiftCategoryItem *item in shiftItems)
    {
        if (item.shiftCategoryID == _shift.shiftCategoryId) {
            _imvShiftCategoryBG.image = [UIImage imageNamed:item.image];
            _lblShiftCategoryName.text = item.name;
            _lblShiftCategoryName.textColor = item.textColor;
        }
    }
    
    // shift duration
    if (_shift.isAllDay) {
        _startTime = [NSDate dateWithTimeIntervalSince1970:_shift.timeStart];
        _endTime = [NSDate dateWithTimeIntervalSince1970:_shift.timeEnd];
    }
    _lblStartTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
    _lblEndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
    
    // shift members
//    _arrMember = [_shift.pk_shift allObjects];

}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self loadChooseMemberView];
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
    if ([[notif name] isEqualToString:_fxThemeNotificationChangeTheme])
    {
        _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    }
}


@end
