//
//  NMTimePickerView.h
//  NurseManagementDemoControl
//
//  Created by phungduythien on 2/19/14.
//  Copyright (c) 2014 GreenGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NMTimePickerViewDelegate;

@interface NMTimePickerView : NSObject

@property (nonatomic, strong) id <NMTimePickerViewDelegate>   delegate;

@property (nonatomic, strong) UINavigationBar           *navigationBar;
@property (nonatomic, strong) UIDatePicker              *datePicker;

- (void)showWithSupperViewFrame:(UITabBar *)tabbar;
- (void)showActionSheetInView:(UIView *)view;

@end

@protocol NMTimePickerViewDelegate <NSObject>

- (void) datePicker:(NMTimePickerView *)picker dismissWithButtonDone:(BOOL)done;

@end
