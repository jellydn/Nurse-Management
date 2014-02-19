//
//  EditShiftVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "EditShiftVC.h"
#import "CDShiftCategory.h"
@interface EditShiftVC ()<UITextFieldDelegate>{
    CDShiftCategory *_shiftCategory;

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
   
    [self configView];
}

- (void) configView
{
    if (!_insertId) {
        _txtName.text = @"";
        _txtBeginTime.text = @"00:00";
        _txtEndTime.text = @"00:00";

        _btDelete.hidden = YES;

    } else {
        _txtName.text = _shiftCategory.name;
        
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
                            }
                            else
                                if ([_shiftCategory.color isEqualToString:@"color6"])
                                {
                                    _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c3.png"];
                                }
                                else
                                    if ([_shiftCategory.color isEqualToString:@"color7"]) {
                                        _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c5.png"];
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
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) loadShiftCategory:(CDShiftCategory *)selectedCategory {
    _shiftCategory = selectedCategory;
}


- (IBAction)save:(id)sender {
    NSLog(@"save ban");
}

- (IBAction)selectButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    _reviewCategory.textColor = [UIColor colorWithRed:93.0/255.0 green:80.0/255.0 blue:76.0/255.0 alpha:1.0];
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
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // _reviewCategory.text = textField.text;
}
- (IBAction)btAllTime:(id)sender {
    _txtBeginTime.text = @"00:00";
    _txtEndTime.text = @"00:00";
}
@end