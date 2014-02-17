//
//  ListMembersVC.h
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXViewController.h"

@interface ListMembersVC : FXViewController<NSFetchedResultsControllerDelegate>
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerMember;

@end
