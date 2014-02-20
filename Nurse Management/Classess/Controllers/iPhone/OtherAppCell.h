//
//  OtherAppCell.h
//  MovingHouse
//
//  Created by Nick Lee on 4/4/13.
//  Copyright (c) 2013 tienlp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherAppCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel       *lbAppName;
@property(nonatomic,weak) IBOutlet UILabel       *lbAppBy;
@property(nonatomic,weak) IBOutlet UILabel       *lbAppTest;
@property(nonatomic,weak) IBOutlet UIImageView   *imgApp;

- (void)setBorderImage;

@end
