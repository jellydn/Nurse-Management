//
//  HomeNaviBarView.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNaviBarViewDelegate;

@interface HomeNaviBarView : UIView

@property(nonatomic, weak) IBOutlet UILabel *lbDay;
@property(nonatomic, weak) IBOutlet UILabel *lbMonth;
@property(nonatomic, weak) IBOutlet UILabel *lbYear;

@property(nonatomic, weak) id<HomeNaviBarViewDelegate> delegate;

- (IBAction)toDay:(id)sender;
- (IBAction)sendMail:(id)sender;

- (void) setTitleWithDay:(int)day month:(int)month year:(int)year;

@end

@protocol HomeNaviBarViewDelegate <NSObject>

- (void) homeNaviBarViewDidSelectToDay:(HomeNaviBarView*)homeNaviBarView;
- (void) homeNaviBarViewDidSelectMail:(HomeNaviBarView*)homeNaviBarView;

@end
