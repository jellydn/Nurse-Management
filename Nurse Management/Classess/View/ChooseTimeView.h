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

@property(nonatomic) BOOL isAllDay;

- (void)setStartDate:(NSDate *)date;

- (void)setColorForActiontionChoose:(UIColor *)color;

- (void)resetChooseTimeView;

- (void)reloadDataWithArrayDate:(NSMutableArray *)arrDate andStartDate:(NSDate *)startDate;

@end

@protocol ChooseTimeViewDelegate <NSObject>

- (void)didChooseTimeWithIndex:(NSInteger)index arrayChooseTime:(NSMutableArray *)arrayChooseTime;

@end