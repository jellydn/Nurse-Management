//
//  AddScheduleVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/15/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
