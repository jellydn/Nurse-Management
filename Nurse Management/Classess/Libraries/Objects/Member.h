//
//  Member.h
//  Nurse Management
//
//  Created by PhuNQ on 2/13/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isOfficial;
@property (nonatomic, assign) BOOL isEnable;

@end
