//
//  AddScheduleCategoryNameVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXViewController.h"

@interface AddScheduleCategoryNameVC : FXViewController
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) NSString *name;
@property(nonatomic) BOOL typeShift;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)selectButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *reviewCategory;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounReview;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btDelete;

@end
