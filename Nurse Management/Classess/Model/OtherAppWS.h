//
//  OtherAppWS.h
//  MovingHouse
//
//  Created by Nick Lee on 4/13/13.
//  Copyright (c) 2013 tienlp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"

@protocol OtherAppWSDelegate;
@class Error;

@interface OtherAppWS : NSObject

@property(nonatomic,weak) id<OtherAppWSDelegate>delegate;

- (void) getAppsWithOffset:(int)offset limit:(int)limit;

@end


@protocol OtherAppWSDelegate <NSObject>

- (void)didFailWithError:(Error*)error;
- (void)didSuccessWithApps:(NSMutableArray*)apps hasnext:(BOOL)hasnext;

@end