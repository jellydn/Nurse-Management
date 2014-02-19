//
//  NMSelectionStringView.h
//  NurseManagementDemoControl
//
//  Created by phungduythien on 2/15/14.
//  Copyright (c) 2014 GreenGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMSelectionStringViewDelegate;

@interface NMSelectionStringView : UIView

@property (nonatomic, strong) id <NMSelectionStringViewDelegate> delegate;

- (void)setArrayString:(NSArray *)arrString;
- (void)setArrayCDMember:(NSMutableArray *)arrayCDMember;
- (void)setColorForSelectionString:(UIColor *)color;

@end

@protocol NMSelectionStringViewDelegate <NSObject>
@optional
- (void)didSelectionCDMemberWithIndex:(NSInteger)index arraySelectionCDMember:(NSMutableArray *)arraySelectionCDMember;
- (void)didSelectionStringWithIndex:(NSInteger)index arraySelectionString:(NSMutableArray *)arraySelectionString;

@end