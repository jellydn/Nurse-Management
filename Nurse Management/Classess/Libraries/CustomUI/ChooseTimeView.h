//
//  ChooseTimeView.h
//  NurseManagementDemoControl
//
//  Created by phungduythien on 2/14/14.
//  Copyright (c) 2014 GreenGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseTimeViewDelegate;

@interface ChooseTimeView : UIView

@property (nonatomic, strong) id <ChooseTimeViewDelegate> delegate;

- (void)setStartDate:(NSDate *)date;

- (void)setColorForActiontionChoose:(UIColor *)color;


@end

@protocol ChooseTimeViewDelegate <NSObject>

- (void)didChooseTimeWithIndex:(NSInteger)index arrayChooseTime:(NSMutableArray *)arrayChooseTime;

@end