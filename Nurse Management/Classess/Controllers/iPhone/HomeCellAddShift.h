//
//  HomeCellAddShift.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCellAddShift : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbDay;
@property (nonatomic, weak) IBOutlet UILabel *lbMonth;
@property (nonatomic, weak) IBOutlet UILabel *lbWeekDay;

@property (nonatomic, weak) IBOutlet UIView  *viewAdd;
@property (nonatomic, weak) IBOutlet UIView  *viewInfo;

@property (nonatomic, weak) IBOutlet UIButton *btAdd;
@property (nonatomic, weak) IBOutlet UIButton *btEdit;

- (void) loadInfoWithNSDate:(NSDate*)date isAddShift:(BOOL)isAddShift;

@end
