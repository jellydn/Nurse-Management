//
//  AddShiftVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXViewController.h"

@interface AddShiftVC : FXViewController

@property(nonatomic,strong) NSDate *date;
@property(nonatomic,assign) BOOL isNewShift;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerMember;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShiftCategory;

@end
