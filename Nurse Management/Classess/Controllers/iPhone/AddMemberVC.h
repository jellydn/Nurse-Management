//
//  AddMemberVC.h
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXViewController.h"

@class CDMember;
@protocol AddMemberDelegate;
@interface AddMemberVC : FXViewController

@property (nonatomic, assign) int32_t insertId;     // to distinguish add or edit member
@property (nonatomic, weak) id<AddMemberDelegate> delegate;

- (void) loadSelectedMember: (CDMember *) selectedMember;

@end

@protocol AddMemberDelegate <NSObject>

- (void) saveMemberName: (NSString*)name andInsertId:(int32_t)insertId;

@end
