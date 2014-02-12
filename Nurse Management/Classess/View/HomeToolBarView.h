//
//  HomeToolBarView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeToolBarViewDelegate;

@interface HomeToolBarView : UIView

@property(nonatomic, weak) id<HomeToolBarViewDelegate> delegate;

- (IBAction)selectItem:(id)sender;

@end

@protocol HomeToolBarViewDelegate <NSObject>

- (void) homeToolBarView:(HomeToolBarView*) homeToolBarView didSelectWithIndex:(int)index;

@end
