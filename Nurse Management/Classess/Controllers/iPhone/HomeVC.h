//
//  HomeVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXViewController.h"

@interface HomeVC : FXViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerMember;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerShiftCategory;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerScheduleCategory;


- (IBAction)addShift:(id)sender;
- (IBAction)editShif:(id)sender;
@end
