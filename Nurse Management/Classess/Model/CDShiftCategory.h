//
//  CDShiftCategory.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDShiftCategory : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSTimeInterval timeEnd;
@property (nonatomic) NSTimeInterval timeStart;

@end
