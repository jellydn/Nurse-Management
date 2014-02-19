//
//  EditShiftVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDShiftCategory;
@protocol AddShiftCategoryDelegate;

@interface EditShiftVC : UIViewController
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
- (IBAction)btAllTime:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *txtBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *txtEndTime;

- (void) loadShiftCategory: (CDShiftCategory *) selectedCategory;
@property (nonatomic, weak) id<AddShiftCategoryDelegate> delegate;
@property (nonatomic, assign) int32_t insertId;     // to distinguish add or edit member
@end

@protocol AddShiftCategoryDelegate <NSObject>

- (void) saveShiftCategory: (CDShiftCategory*)category andInsertId:(int32_t)insertId;

@end
