//
//  EditShiftVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//
#import "Define.h"
#import "Common.h"
#import "FXThemeManager.h"
#import "FXCalendarData.h"
#import "EditShiftVC.h"
#import "CDShiftCategory.h"
#import "NMTimePickerView.h"

#import "AppDelegate.h"
#define ALERT_BG_COLOR	 [UIColor colorWithRed:100.0/255.0 green:137.0/255.0 blue:199.0/255.0 alpha:1.0]
#define BUTTON_BG_COLOR	 [UIColor colorWithRed:216.0/255.0 green:224.0/255.0 blue:221.0/255.0 alpha:1.0]
#define TITLE_COLOR	 [UIColor colorWithRed:126.0/255.0 green:96.0/255.0 blue:39.0/255.0 alpha:1.0]
#import "FXViewController.h"
@interface EditShiftVC ()<UITextFieldDelegate,NMTimePickerViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate>{
    CDShiftCategory *_shiftCategory;
    NSDate *_startTime;
    NSDate *_endTime;
    
    NSString * _color;
    BOOL _isAllDay;
    NSString * _name;
    __weak IBOutlet UIButton *_btnAllDay;
    
    NMTimePickerView *_timePickerView;
}

@end

@implementation EditShiftVC

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
    
    _btnBeginTime.tag = START_TIME;
    _btnEndTime.tag = END_TIME;

    NSLog(@"viewDidLoad");

    // init time picker view
    _timePickerView = [[NMTimePickerView alloc] init];
    _timePickerView.delegate = self;
    _timePickerView.datePicker.datePickerMode = UIDatePickerModeTime;
    _timePickerView.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    
    [self configView];
    
    //fix add new
    if (_typeShift) {
        self.lbTile.text = @"シフト追加";
        //_backgrounReview.image = [UIImage imageNamed:@"bg_dashed_frame.png"];
        //_reviewCategory.text = @"";
        
    } else {
        self.lbTile.text = @"シフト編集";
    }
}

-(void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
    
        self.screenName = @"Edit Shift";
}


- (void) configView
{
    NSLog(@"_insertId %d",_insertId);
    if (!_insertId) {
        _txtName.text = @"";
        _startTime = [FXCalendarData dateNexHourFormDate:[NSDate date]];
        _txtBeginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
        
        _endTime = [FXCalendarData dateNexHourFormDate:_startTime];
        _txtEndTime.text   = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
        _color = @"color0";
        _btDelete.hidden = YES;

    } else {
        _name = _txtName.text = _shiftCategory.name;
        NSLog(@"name %@", _name);
        _color = _shiftCategory.color;
        _isAllDay = _shiftCategory.isAllDay;
        if (_shiftCategory.isAllDay) {
            _btnAllDay.backgroundColor = ALERT_BG_COLOR;
            _btnBeginTime.enabled = NO;
            _txtBeginTime.textColor = [UIColor grayColor];
            _txtBeginTime.text = @"00:00";
            _btnEndTime.enabled = NO;
            _txtEndTime.textColor = [UIColor grayColor];
            _txtEndTime.text = @"24:00";
            
            // set edit time
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            _endTime = _startTime = [dateFormatter dateFromString:@"00:00"];
            
        }
        else
        {
            _txtBeginTime.text = _shiftCategory.timeStart;
            _txtEndTime.text = _shiftCategory.timeEnd;

            // set edit time
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            _startTime = [dateFormatter dateFromString:_shiftCategory.timeStart];
            _endTime = [dateFormatter dateFromString:_shiftCategory.timeEnd];

        }
        
        if ([_shiftCategory.color isEqualToString:@"color0"]) {
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c1.png"];
        }
        else
            if ([_shiftCategory.color isEqualToString:@"color1"])
            {
                _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c3.png"];
            }
            else
                if ([_shiftCategory.color isEqualToString:@"color2"]) {
                    _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c5.png"];
                }
                else
                    if ([_shiftCategory.color isEqualToString:@"color3"]) {
                        _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c7.png"];
                    }
                    else
                        if ([_shiftCategory.color isEqualToString:@"color4"]) {
                            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c9.png"];
                        }
                        else
                            if ([_shiftCategory.color isEqualToString:@"color5"]) {
                                _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c1.png"];
                                _reviewCategory.textColor = [UIColor whiteColor];

                            }
                            else
                                if ([_shiftCategory.color isEqualToString:@"color6"])
                                {
                                    _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c3.png"];
                                    _reviewCategory.textColor = [UIColor whiteColor];

                                }
                                else
                                    if ([_shiftCategory.color isEqualToString:@"color7"]) {
                                        _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c5.png"];
                                        _reviewCategory.textColor = [UIColor whiteColor];

                                    }
                                    else
                                        if ([_shiftCategory.color isEqualToString:@"color8"]) {
                                            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c7.png"];
                                        }
                                        else
                                            if ([_shiftCategory.color isEqualToString:@"color9"]) {
                                                _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c9.png"];
                                            }
        
        _reviewCategory.text = _shiftCategory.name;


    }
        
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - NMTimePickerViewDelegate
    
- (void) datePicker:(NMTimePickerView *)picker dismissWithButtonDone:(BOOL)done {
    if (done) {
        if (picker.datePicker.tag == START_TIME) {
            
            _startTime = picker.datePicker.date;
            _txtBeginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
            
            _endTime            = [FXCalendarData dateNexHourFormDateNoTrimMin:picker.datePicker.date];
            _txtEndTime.text    = [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
       
        } else if (picker.datePicker.tag == END_TIME) {
            
            _endTime = picker.datePicker.date;
            _txtEndTime.text     = (_endTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
           
        }
    
    }
}

    
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) loadShiftCategory:(CDShiftCategory *)selectedCategory {
    _shiftCategory = selectedCategory;
}


- (IBAction)save:(id)sender {
    
    
    //check textfield
    if ([[Common trimString:_txtName.text] length] > 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                        message:TEXT_VALIDATION_NAME_SHIFT_CATEGORY
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        return;
    } else {
        _name = _txtName.text;
    }
    
   
    if (!_insertId) {
        
        _shiftCategory = (CDShiftCategory *) [NSEntityDescription insertNewObjectForEntityForName:@"CDShiftCategory" inManagedObjectContext:[AppDelegate shared].managedObjectContext];
        _shiftCategory.isEnable = YES;
        
    } else {
        
        _shiftCategory = [[AppDelegate shared] getshiftCategoryWithID:_insertId];
    }

    
    if (!_insertId) {
        // get last id
        if ([[AppDelegate shared].fetchedResultsControllerShiftCategory.fetchedObjects count] == 0) {
            _shiftCategory.id = 1;
        } else {
            CDShiftCategory *cdShiftCategory = [[AppDelegate shared].fetchedResultsControllerShiftCategory.fetchedObjects lastObject];
            _shiftCategory.id = cdShiftCategory.id +1;
            NSLog(@" id : %d", _shiftCategory.id);
        }
    }
    
    _shiftCategory.name = _name;
    _shiftCategory.color = _color;
    _shiftCategory.timeStart = _txtBeginTime.text;
    _shiftCategory.timeEnd = _txtEndTime.text;
    _shiftCategory.isAllDay = _isAllDay;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TableShiftCategoryUpdate"
                                                        object:self];
    [[AppDelegate shared] saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];

}

- (IBAction)selectButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    _reviewCategory.textColor = [UIColor colorWithRed:93.0/255.0 green:80.0/255.0 blue:76.0/255.0 alpha:1.0];
    _color = [NSString stringWithFormat:@"color%ld",(long)button.tag];
    switch (button.tag) {
        case 0:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c1.png"];
            break;
        case 1:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c3.png"];
            break;
        case 2:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c5.png"];
            break;
        case 3:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c7.png"];
            break;
        case 4:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c9.png"];
            break;
        case 5:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c1.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 6:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c3.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 7:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c5.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 8:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c7.png"];
            break;
        case 9:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c9.png"];
            break;
        default:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c1.png"];
            break;
    }
}


#pragma mark - UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] <= 2) {
        _reviewCategory.text = newString;
    }
    
    return YES;
    
    
    _reviewCategory.text = newString;
//    _name = newString;
//    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // _reviewCategory.text = textField.text;
}
- (IBAction)btAllTime:(id)sender {
    _isAllDay = !_isAllDay;

    if (_isAllDay == YES) {
        
        _btnAllDay.backgroundColor = ALERT_BG_COLOR;
        _btnBeginTime.enabled = NO;
        _txtBeginTime.textColor = [UIColor grayColor];
        _txtBeginTime.text = @"00:00";
        _btnEndTime.enabled = NO;
        _txtEndTime.textColor = [UIColor grayColor];
        _txtEndTime.text = @"24:00";
        
    } else {
        
        _btnAllDay.backgroundColor = BUTTON_BG_COLOR;
        
        _btnBeginTime.enabled = YES;
        _txtBeginTime.textColor = TITLE_COLOR;
        if (_startTime)
            _txtBeginTime.text   = (_startTime == nil) ? @"00:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_startTime];
        else
            _txtBeginTime.text = @"00:00";
        
        NSInteger endHour = [FXCalendarData getHourWithDate:_endTime];
        _btnEndTime.enabled = YES;
        _txtEndTime.textColor = TITLE_COLOR;
        
        NSLog(@"%@", _endTime);
        
        if (_endTime)
            _txtEndTime.text   = (_endTime == nil || endHour == 0) ? @"24:00" : [Common convertTimeToStringWithFormat:@"HH:mm" date:_endTime];
        else
            _txtEndTime.text = @"24:00";
        
    }
    

}

- (IBAction)chooseTime:(id)sender {
    _isAllDay = NO;
    if ([sender tag] == START_TIME){
        [_timePickerView.datePicker setDate:_startTime?_startTime:[NSDate date] animated:NO];
    }
    else if ([sender tag] == END_TIME){
        [_timePickerView.datePicker setDate:_endTime?_endTime:[NSDate date] animated:NO];
    }
    
    _timePickerView.datePicker.tag = [sender tag];
    [_timePickerView showActionSheetInView:self.view];

}

- (IBAction)delete:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取り消し" destructiveButtonTitle:nil otherButtonTitles:@"削除", nil];
    [actionSheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:     // delete
            
            for (CDShiftCategory *item in [AppDelegate shared].fetchedResultsControllerShiftCategory.fetchedObjects) {
                if (item.id == _insertId) {
                    [[AppDelegate shared].managedObjectContext deleteObject:item];
                    
                    //TODO: Remove all shift relate shift category
                    
                    [[AppDelegate shared] saveContext];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_SCHEDULE object:nil userInfo:nil];

                    break;
                }
            }

            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            
        case 1:     // cancel
            break;
            
        default:
            break;
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [_txtName becomeFirstResponder];
}




@end