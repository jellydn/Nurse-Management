//
//  AddScheduleVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/15/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItem.h"
@interface AddScheduleVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
- (IBAction)changeName:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgReview;
@property (weak, nonatomic) IBOutlet UILabel *reviewName;
- (IBAction)btAllTime:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *EndTime;
- (IBAction)cancel:(id)sender;
- (IBAction)saveData:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btStarTime;
@property (weak, nonatomic) IBOutlet UIButton *btEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btDelete;
@property (weak, nonatomic) IBOutlet UIButton *btIsAllTime;
@property (nonatomic, strong) NSMutableArray *arrayTimeAlerts;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic) BOOL isSetTimeStart;
@property (nonatomic, strong) ScheduleItem *scheduleEditItem;
- (IBAction)delete:(id)sender;
@end
