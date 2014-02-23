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

@interface EditShiftVC ()<UITextFieldDelegate,NMTimePickerViewDelegate,UIActionSheetDelegate>{
    CDShiftCategory *_shiftCategory;
    NSDate *_startTime;
    NSDate *_endTime;
    
    NSString * _color;
    BOOL _isAllDay;
    NSString * _name;
    
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

    
    // init time picker view
    _timePickerView = [[NMTimePickerView alloc] init];
    _timePickerView.delegate = self;
    _timePickerView.datePicker.datePickerMode = UIDatePickerModeTime;
    _timePickerView.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    
    [self configView];
}

- (void) configView
{
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
        _color = _shiftCategory.color;
        _isAllDay = _shiftCategory.isAllDay;
        if (_shiftCategory.isAllDay) {
            _txtBeginTime.text = @"00:00";
            _txtEndTime.text = @"00:00";
        }
        else
        {
            _txtBeginTime.text = _shiftCategory.timeStart;
            _txtEndTime.text = _shiftCategory.timeEnd;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] > 2) {
        return NO;
    }
    _reviewCategory.text = newString;
    _name = newString;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // _reviewCategory.text = textField.text;
}
- (IBAction)btAllTime:(id)sender {
    _txtBeginTime.text = @"00:00";
    _txtEndTime.text = @"00:00";
    _isAllDay = YES;
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
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

@end