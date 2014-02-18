//
//  AddScheduleView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTimeView.h"

@protocol AddScheduleViewDelegate;

@interface AddScheduleView : UIView<UIScrollViewDelegate, ChooseTimeViewDelegate>

@property (nonatomic) int scheduleCategoryID;
@property (nonatomic) BOOL isShowPicker;

@property (nonatomic, weak) IBOutlet UIView         *viewMask;
@property (nonatomic, weak) IBOutlet UIView         *viewContainer;
@property (nonatomic, weak) IBOutlet UIView         *viewTime;
@property (nonatomic, weak) IBOutlet UIView         *viewTimePicker;
@property (nonatomic, weak) IBOutlet UIScrollView   *scrollScheduleView;
@property (nonatomic, weak) IBOutlet UIPageControl  *pageControl;
@property (nonatomic, strong)        UIView         *viewSelect;
@property (nonatomic, strong)        ChooseTimeView *chooseTimeView;

@property (nonatomic, weak) id<AddScheduleViewDelegate> delegate;


//method
- (void) initLayoutView;
- (void) show;
- (void) hide;

- (void) loadScheduleCategoryInfo:(NSMutableArray*)schedules;

//Action
- (IBAction)selectCategory:(id)sender;
- (IBAction)choiceTime:(id)sender;
- (IBAction)backChoiceCategory:(id)sender;
- (IBAction)saveSchedule:(id)sender;
- (IBAction)selectItem:(id)sender;

- (IBAction)selectTimeForSchedule:(id)sender;
- (IBAction)cancelPickerTime:(id)sender;
- (IBAction)donePickerTime:(id)sender;

@end

@protocol AddScheduleViewDelegate <NSObject>

@required
- (void) didShowCategoryName:(AddScheduleView*)addScheduleView;
- (void) didSaveSchedule:(AddScheduleView*)addScheduleView;

@optional
- (void) didShowView:(AddScheduleView*)addScheduleView;
- (void) didHideView:(AddScheduleView*)addScheduleView;

- (void) didChoiceTime:(AddScheduleView*)addScheduleView;

@end
