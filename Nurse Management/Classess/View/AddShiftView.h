//
//  AddShiftView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddShiftViewDelegate;

@interface AddShiftView : UIView<UIScrollViewDelegate>

@property(nonatomic, weak) id<AddShiftViewDelegate> delegate;

@property(nonatomic, weak) IBOutlet UIScrollView    *scrollView;
@property(nonatomic, weak) IBOutlet UIPageControl   *pageControl;
@property(nonatomic, weak) IBOutlet UIButton        *btClose;
@property (weak, nonatomic) IBOutlet UIView *viewMask;



- (IBAction)selectItem:(id)sender;
- (IBAction)showListShiftPattern:(id)sender;
- (IBAction)closeAddShiftView:(id)sender;

- (void) loadInfoWithShiftCategories:(NSMutableArray*)shifts;

@end

@protocol AddShiftViewDelegate <NSObject>

- (void) addShiftView:(AddShiftView*)addShiftView didSelectWithIndex:(int)index;
- (void) addShiftViewDidSelectShowListShiftPattern:(AddShiftView*)addShiftView;
- (void) addShiftViewDidSelectCloseView:(AddShiftView*)addShiftView;

@end
