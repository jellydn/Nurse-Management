//
//  AddShiftView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddShiftViewDelegate;

@interface AddShiftView : UIView

@property(nonatomic, weak) id<AddShiftViewDelegate> delegate;

- (IBAction)selectItem:(id)sender;
- (IBAction)showListShiftPattern:(id)sender;

@end

@protocol AddShiftViewDelegate <NSObject>

- (void) addShiftView:(AddShiftView*)addShiftView didSelectWithIndex:(int)index;
- (void) addShiftViewDidSelectShowListShiftPattern:(AddShiftView*)addShiftView;

@end
