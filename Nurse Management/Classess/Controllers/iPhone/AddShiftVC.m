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
//#define kOFFSET_FOR_KEYBOARD 160.0
#define kOFFSET_FOR_KEYBOARD 217.0
#define MEMO_PLACEHOLDER_TEXT    @"メモがあったら入力しよう"
#define KEYBOARD_SHOW_FIRST     1
#define KEYBOARD_SHOW_SECOND     2

#define IS_IPHONE_5 (((double)[[UIScreen mainScreen] bounds].size.height) == ((double)568))

@interface AddShiftVC () <UITextViewDelegate, UIActionSheetDelegate, ChooseTimeViewDelegate, AddShiftViewDelegate, NMSelectionStringViewDelegate, NSFetchedResultsControllerDelegate, NMTimePickerViewDelegate>
{
    __weak IBOutlet UIView *_viewNavi;
    __weak IBOutlet UILabel *_lbTile;
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UIButton *_btnStartTime;
    __weak IBOutlet UIButton *_btnEndTime;
    __weak IBOutlet UIButton *_btnSave;
    __weak IBOutlet UIButton *_btnSaveAndNext;
    __weak IBOutlet UIButton *_btnAllDay;
    __weak IBOutlet UIButton *_btnSaveAndNextDate;
    __weak IBOutlet UILabel *_lblStartTime;
    __weak IBOutlet UILabel *_lblEndTime;
    __weak IBOutlet UILabel *_lblShiftCategoryName;
    
    __weak IBOutlet UITextView *_txvMemo;
    __weak IBOutlet UIImageView *_imvShiftCategoryBG;
    
    NSDate *_startTime;
    NSDate *_endTime;
    NSMutableArray *_arrMember;
    NSMutableArray *_arrAlerts;
    
    BOOL _isShowAddShiftView;
    BOOL _isAllDay;
    
    UIPickerActionSheet *_pickerActionSheet;
    NMTimePickerView *_timePickerView;
    AddShiftView    *_addShiftView;
    NMSelectionStringView *_nMSelectionStringView;
    ChooseTimeView *_chooseTimeView;
    
    CDShift *_shift;
    
    NSInteger _indexSelectShiftCategory;
    int _subKeyBoard;
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

//FIXME: Home - 1 alert

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
    
    if (_indexSelectShiftCategory >= 0) {
        [self addshiftViewWithIndex:_indexSelectShiftCategory];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    
    _btnStartTime.tag = START_TIME;
    _btnEndTime.tag = END_TIME;
    
    _indexSelectShiftCategory = -1;
    _subKeyBoard = 0;
    
    // init time picker view
    _timePickerView = [[NMTimePickerView alloc] init];
    _timePickerView.delegate = self;
    _timePickerView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _timePickerView.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    
    // load core data
    [self fetchedResultsControllerMember];
    [self fetchedResultsControllerShiftCategory];
    
    [self setDefaultTime];
    
    // init Choose Time view
    [self loadChooseTimeView];
    
    // init Add Shift view
    [self loadHomeAddShiftView];
    
    // init Choose Member view
    [self loadChooseMemberView];
    
    if (_isNewShift) {
        
        _shift = (CDShift *) [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SHIFT inManagedObjectContext:[AppDelegate shared].managedObjectContext];
//        [self setDefaultTime];
        _txvMemo.text = MEMO_PLACEHOLDER_TEXT;
        _txvMemo.textColor = [UIColor lightGrayColor];
        
    } else {
        _shift = [[AppDelegate shared] getShiftWithShiftID:_shiftID];
        [self loadShiftFromCoreData];
//        _btnSave.enabled = YES;
//        _btnSaveAndNext.enabled = YES;
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = GA_ADDSHIFTVC;
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
        
//        [_scrollView scrollRectToVisible:_txvMemo.frame animated:YES];
        
//        CGRect frame = _txvMemo.frame;
//        frame.origin.y += _txvMemo.frame.size.height;
//        [_scrollView scrollRectToVisible:frame animated:YES];
        
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
//            [self setViewMovedUp:YES];
        }
        
        if ([textView.text isEqualToString:MEMO_PLACEHOLDER_TEXT]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    _btnSaveAndNext.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = MEMO_PLACEHOLDER_TEXT;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    _btnSaveAndNext.hidden = NO;
}

#pragma mark - AddShiftViewDelegate
- (void) addShiftView:(AddShiftView*)addShiftView didSelectWithIndex:(int)index
{
    [self addshiftViewWithIndex:index];
}

- (void)addshiftViewWithIndex:(NSInteger)index
{
    NSLog(@"Add Shift select item with index: %d", index);
    CDShiftCategory *shiftCategory = [[AppDelegate shared] getshiftCategoryWithID:index];
    _shift.fk_shift_category = shiftCategory;
    _shift.shiftCategoryId = shiftCategory.id;
    _shift.isAllDay = shiftCategory.isAllDay;
    _isAllDay = shiftCategory.isAllDay;
    
    // get time from shift category
    _startTime = [Common dateAppenedFromDate:_date andTime:shiftCategory.timeStart];
    _endTime = [Common dateAppenedFromDate:_date andTime:shiftCategory.timeEnd];
    [self setAllDay:_isAllDay];
    
//    _btnSave.enabled = YES;
//    _btnSaveAndNext.enabled = YES;
    
    NSMutableArray *shiftItems = [self convertShiftObject];
    for (ShiftCategoryItem *item in shiftItems)
    {
        if (item.shiftCategoryID == index) {
            _indexSelectShiftCategory = index;
            _imvShiftCategoryBG.image = [UIImage imageNamed:item.image];
            _lblShiftCategoryName.text = item.name;
            _lblShiftCategoryName.textColor = item.textColor;
        }
    }
    
    [_chooseTimeView setStartDate:_startTime];
    [self hideAddShift];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide_mask_view_addShiftView" object:nil];
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
            
            _startTime          = picker.datePicker.date;
            _lblStartTime.text  = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_startTime];
            
            _endTime            = [FXCalendarData dateNexHourFormDateNoTrimMin:picker.datePicker.date];
            _lblEndTime.text    = [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_endTime];
            
        } else if (picker.datePicker.tag == END_TIME) {
            
            _endTime = picker.datePicker.date;
            _lblEndTime.text     = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_endTime];
            
        }
    }
    
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    
    if (!_shift.fk_shift_category) {
        [Common showAlert:@"シフトカテゴリーを\n選択してください。" title:@""];
    } else {
        [self saveShiftToCoreData];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (IBAction)chooseShiftCategory:(id)sender {
    
    [self showAddShift];
    
}

- (IBAction)chooseTimeMode:(id)sender {
    
    _isAllDay = !_isAllDay;
    [self setAllDay:_isAllDay];
    
}

- (IBAction)chooseTime:(id)sender {
    NSLog(@"chon thoi gian");
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
        _lbTile.text = [NSString stringWithFormat:@"%d月%d日", [FXCalendarData getMonthWithDate:_date], [FXCalendarData getDayWithDate:_date]];
        [self clearDataFromUI];
        
    } else
        [Common showAlert:@"シフトカテゴリーを\n選択してください。" title:@""];

}

#pragma mark - Shift Category

- (void) showAddShift
{
    if (_isShowAddShiftView) {
        return;
    }
    
    _addShiftView.hidden = NO;
    [self.view bringSubviewToFront:_addShiftView];
    
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
        _addShiftView.hidden = YES;
    }];
}

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

#pragma mark - Keyboard Notifications

- (IBAction)tapHideKeyboard:(UITapGestureRecognizer *)sender {
    [_txvMemo resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboard show");
    
//    if (_subKeyBoard == 0) {
//        
//    } else if (_subKeyBoard == 1) {
//        
//    } else if (_subKeyBoard == 2) {
//        
//    }
    
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0 && _subKeyBoard == 0)
    {
        [self setViewMovedUp:YES withOffset:kOFFSET_FOR_KEYBOARD];
        _subKeyBoard = KEYBOARD_SHOW_FIRST;
    }
    else if (self.view.frame.origin.y < 0)
    {
        if (_subKeyBoard == KEYBOARD_SHOW_FIRST) {
            [self setViewMovedUp:YES withOffset:30.0];
            _subKeyBoard = KEYBOARD_SHOW_SECOND;
        }
//        else
//            [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        if (_subKeyBoard == KEYBOARD_SHOW_FIRST)
            [self setViewMovedUp:NO withOffset:kOFFSET_FOR_KEYBOARD];
        else
            [self setViewMovedUp:NO withOffset:kOFFSET_FOR_KEYBOARD + 30.0];
        _subKeyBoard = 0;
    }
    
}

#pragma mark - Others
- (void) configView
{
    _viewNavi.backgroundColor = [[FXThemeManager shared] getColorWithKey:_fxThemeColorNaviBar];
    _lbTile.text = [NSString stringWithFormat:@"%d月%d日",[FXCalendarData getMonthWithDate:_date], [FXCalendarData getDayWithDate:_date]];
    [_scrollView setContentOffset:CGPointMake(0.0, 64.0)];
    [_scrollView setContentSize:CGSizeMake(320.0, 510.0)];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [self.view bringSubviewToFront:_scrollView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    int number = 0;
    if (!IS_IPHONE_5)
        number = 40;
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD + number;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD + number;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)setViewMovedUp:(BOOL)movedUp withOffset: (float)keyboardOffset
{
    [self.view bringSubviewToFront:_scrollView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    int number = 0;
    if (!IS_IPHONE_5)
        number = 40;
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        if (_subKeyBoard == KEYBOARD_SHOW_FIRST)
            number = 0;
        
        rect.origin.y -= keyboardOffset + number;
        rect.size.height += keyboardOffset;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += keyboardOffset + number;
        rect.size.height -= keyboardOffset;
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
    _addShiftView.hidden = YES;
}

- (void) loadChooseMemberView {
    
    if (_nMSelectionStringView) {
        [_nMSelectionStringView removeFromSuperview];
        _nMSelectionStringView = nil;
    }
    _nMSelectionStringView = [[NMSelectionStringView alloc] initWithFrame:CGRectMake(15, 152, 320 - 15*2, 118)];
    _nMSelectionStringView.delegate = self;
    [_nMSelectionStringView setArrayCDMember:(NSMutableArray *)_fetchedResultsControllerMember.fetchedObjects];
    
    [_scrollView addSubview:_nMSelectionStringView];
    
}

- (void) loadChooseTimeView {
    _chooseTimeView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(15, 302, 320 - 15*2, 44)];
    _chooseTimeView.delegate = self;
    [_chooseTimeView setStartDate:_startTime];
    [_scrollView addSubview:_chooseTimeView];
}

- (void) clearDataFromUI {
    
    _isAllDay = NO;
    [self setAllDay:_isAllDay];
    _indexSelectShiftCategory = -1;
    _imvShiftCategoryBG.image = [UIImage imageNamed:@""];
    _lblShiftCategoryName.text = @"";
    [self setDefaultTime];
    [_chooseTimeView resetChooseTimeView];
    [_nMSelectionStringView resetSelectionStringView];
    _arrMember = nil;
    _arrAlerts = nil;
    _txvMemo.text = MEMO_PLACEHOLDER_TEXT;
    _txvMemo.textColor = [UIColor lightGrayColor];
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, 320, _scrollView.frame.size.height) animated:YES];
    
}

- (void) setDefaultTime {
    
    // set nearest time in roof
    NSDate *currentDate = [FXCalendarData dateWithSetHourWithHour:[FXCalendarData getHourWithDate:[NSDate date]] date:_date];
    
    _startTime = [FXCalendarData dateNexHourFormDate:currentDate];
    _lblStartTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_startTime];
    
    _endTime = [FXCalendarData dateNexHourFormDate:_startTime];
    _lblEndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_endTime];
    
}

- (void) setAllDay: (BOOL)isAllDay {
    
    if (isAllDay == YES) {
        
        _btnAllDay.backgroundColor = ALERT_BG_COLOR;
        _btnStartTime.enabled = NO;
        _lblStartTime.textColor = [UIColor grayColor];
        _lblStartTime.text = [Common convertTimeToStringWithFormat:@"M月d日" date:_date];
        _btnEndTime.enabled = NO;
        _lblEndTime.textColor = [UIColor grayColor];
        _lblEndTime.text = [Common convertTimeToStringWithFormat:@"M月d日" date:_date];;
        
    } else {
        
        _btnAllDay.backgroundColor = BUTTON_BG_COLOR;
        
        _btnStartTime.enabled = YES;
        _lblStartTime.textColor = TITLE_COLOR;
        if (_startTime)
            _lblStartTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_startTime];
        else
            _lblStartTime.text = @"00:00";
        
        NSInteger endHour = [FXCalendarData getHourWithDate:_endTime];
        _btnEndTime.enabled = YES;
        _lblEndTime.textColor = TITLE_COLOR;
        if (_endTime)
            _lblEndTime.text   = (_endTime == nil || endHour == 0) ? @"24:00" : [Common convertTimeToStringWithFormat:@"M月d日 HH:mm" date:_endTime];
        else
            _lblEndTime.text = @"24:00";
        
    }
    
}

- (void) addLocalNotificationForDate: (CDShiftAlert *) alarm {
    NSDate *alarmDate = [NSDate dateWithTimeIntervalSince1970:alarm.onTime];
    
    if ([[FXCalendarData trimSecOfDateWithDate:alarmDate] timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970])
    {
        NSLog(@"shift alarm date: %@", alarmDate);
        
        NSArray *keys = @[@"shift_id",
                          @"alarm_id",
                          @"alarm_date",
                          ];
        
        NSArray *values = @[[NSString stringWithFormat:@"%d",alarm.shiftId],
                            [NSString stringWithFormat:@"%d",alarm.id],
                            alarmDate];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = alarmDate;
        localNotification.alertBody = [NSString stringWithFormat:@"Shift on %@", [Common convertTimeToStringWithFormat:@"MMM dd, yyyy" date:alarmDate]];
        localNotification.alertAction = @"View";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = 0;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = info;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
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
    if (_isNewShift) {
        _shift.id = [[AppDelegate shared] lastShiftID] + 1;
    }
    
    _shift.isAllDay = _isAllDay;
    
    if (!_isAllDay) {
        _shift.timeStart = [_startTime timeIntervalSince1970];
        _shift.timeEnd = [_endTime timeIntervalSince1970];
    } else {
        _shift.timeStart = [_date timeIntervalSince1970];
        _shift.timeEnd = [[FXCalendarData nextDateFrom:_date] timeIntervalSince1970];
        
    }
    
    _shift.onDate = [_date timeIntervalSince1970];
    
    if ([_txvMemo.text isEqualToString:MEMO_PLACEHOLDER_TEXT])
        _shift.memo = @"";
    else
        _shift.memo = _txvMemo.text;
    
    if (_arrMember) {
        [_shift removePk_shift:_shift.pk_shift];
        for (CDMember *member in _arrMember)
            [_shift addPk_shiftObject:member];
    }
    
    if (_arrAlerts) {
        if (_isNewShift) {
            for (NSDate *alertDate in _arrAlerts) {
                CDShiftAlert *shiftAlert = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SHIFT_ALERT inManagedObjectContext:[AppDelegate shared].managedObjectContext];
                shiftAlert.id = [[AppDelegate shared] lastShiftAlertID] + 1;
                NSLog(@"shift alert id: %d", shiftAlert.id);
                shiftAlert.shiftId = _shift.id;
                shiftAlert.onTime = [alertDate timeIntervalSince1970];
                [_shift addPk_shiftalertObject:shiftAlert];
                [[AppDelegate shared] saveContext];
                [self addLocalNotificationForDate:shiftAlert];
            }
        } else {
            // get all alarms of this shift
            NSMutableArray *alarms = (NSMutableArray *)[_shift.pk_shiftalert allObjects];
            // remove all unavailable alarms
            for (CDShiftAlert *item in alarms) {
                BOOL isIt = NO;
                for (NSDate *alertDate in _arrAlerts) {
                    if ([alertDate compare:[NSDate dateWithTimeIntervalSince1970:item.onTime]] == NSOrderedSame) {
                        isIt = YES;
                        break;
                    }
                }
                if (!isIt) {
                    [_shift removePk_shiftalertObject:item];
                    [[AppDelegate shared] saveContext];
                }
            }
            // add new alarm if existing
            for (NSDate *alertDate in _arrAlerts) {
                BOOL isNew = YES;
                for (CDShiftAlert *item in alarms) {
                    if ([alertDate compare:[NSDate dateWithTimeIntervalSince1970:item.onTime]] == NSOrderedSame) {
                        isNew = NO;
                        break;
                    }
                }
                if (isNew) {
                    CDShiftAlert *shiftAlert = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SHIFT_ALERT inManagedObjectContext:[AppDelegate shared].managedObjectContext];
                    shiftAlert.id = [[AppDelegate shared] lastShiftAlertID] + 1;
                    NSLog(@"shift alert id: %d", shiftAlert.id);
                    shiftAlert.shiftId = _shift.id;
                    shiftAlert.onTime = [alertDate timeIntervalSince1970];
                    [_shift addPk_shiftalertObject:shiftAlert];
                    [[AppDelegate shared] saveContext];
                    [self addLocalNotificationForDate:shiftAlert];
                }
            }
        }
        
    }
    
    [[AppDelegate shared] saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];
    
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
    if (!_shift.isAllDay) {
        _isAllDay = NO;
        _startTime = [NSDate dateWithTimeIntervalSince1970:_shift.timeStart];
        _endTime = [NSDate dateWithTimeIntervalSince1970:_shift.timeEnd];
    } else {
        _isAllDay = YES;
        
        [self setDefaultTime];
    }
    
    [self setAllDay:_isAllDay];
    
    // shift members
    _arrMember = (NSMutableArray *) [_shift.pk_shift allObjects];
    [_nMSelectionStringView reloadArrayCDMember:(NSMutableArray *)_fetchedResultsControllerMember.fetchedObjects selected:(NSMutableArray *)_arrMember];
    
    // shift alerts
    NSArray *_arrAlertDates = [_shift.pk_shiftalert allObjects];
    if (_arrAlerts)
        _arrAlerts = nil;
    _arrAlerts = [[NSMutableArray alloc] init];
    for (CDShiftAlert *shiftAlert in _arrAlertDates) {
        [_arrAlerts addObject:[NSDate dateWithTimeIntervalSince1970:shiftAlert.onTime]];
    }
    
    [_chooseTimeView reloadDataWithArrayDate:_arrAlerts andStartDate:_startTime];
    
    if (_shift.memo == nil || [_shift.memo isEqualToString:@""]) {
        _txvMemo.text = MEMO_PLACEHOLDER_TEXT;
        _txvMemo.textColor = [UIColor lightGrayColor];
    } else {
        _txvMemo.text = _shift.memo;
        _txvMemo.textColor = [UIColor blackColor];
    }

}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (controller == _fetchedResultsControllerMember)
        [self loadChooseMemberView];
    else if (controller == _fetchedResultsControllerShiftCategory)
        [_addShiftView loadInfoWithShiftCategories:[self convertShiftObject]];
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
