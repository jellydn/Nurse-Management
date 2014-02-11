//
//  FXThemeManager.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <Foundation/Foundation.h>

//name
#define _fxThemeNameDefault         @"_fxThemeNameDefault"

//property
#define _fxThemeStringName          @"themeName"

#define _fxThemeColorBackground     @"backgroundColor"
#define _fxThemeColorNaviBar        @"navibarColor"
#define _fxThemeColorToolBar        @"toolbarColor"
#define _fxThemeColorMain           @"mainColor"

#define _fxThemeImageBackground     @"backgroundImage"
#define _fxThemeImageNavi           @"navibarImage"
#define _fxThemeImageToolbar        @"toolbarImage"


typedef enum {
    FXThemeManagerTypeDefault
} FXThemeManagerType;

@interface FXThemeManager : NSObject

+ (FXThemeManager*) shared;

//property
@property (nonatomic, strong) NSString          *themeName;
@property (nonatomic, strong) NSString          *themeFileData;

@property (nonatomic, strong) NSDictionary      *themeData;

@property (nonatomic) FXThemeManagerType        *themeType;

//Method
- (void) loadTheme;

// getValue
- (NSString*)getThemeValueWithKey:(NSString*)key;

// color
- (UIColor*)getColorWithKey:(NSString*)key;

// images

// font

@end
