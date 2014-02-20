//
//  HomeCellSchedule.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCellSchedule : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel        *lbTimeStart;
@property (nonatomic, weak) IBOutlet UILabel        *lbTimeEnd;
@property (nonatomic, weak) IBOutlet UILabel        *lbCategoryName;
@property (nonatomic, weak) IBOutlet UILabel        *lbMemo;

@property (nonatomic, weak) IBOutlet UIImageView    *imgCategory;

@end
