//
//  ShiftCell.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *swichShift;
@property (weak, nonatomic) IBOutlet UIImageView *iconShift;
@property (weak, nonatomic) IBOutlet UILabel *lbShift;

@end
