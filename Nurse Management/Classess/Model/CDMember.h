//
//  CDMember.h
//  Nurse Management
//
//  Created by Huynh Duc Dung on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDMember : NSManagedObject

@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isDisplay;
@property (nonatomic, retain) NSString * name;

@end
