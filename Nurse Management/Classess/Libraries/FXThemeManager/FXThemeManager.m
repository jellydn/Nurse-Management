//
//  FXThemeManager.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/11/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "FXThemeManager.h"

static FXThemeManager *shared = nil;

@implementation FXThemeManager

+ (FXThemeManager*) shared
{
    if (!shared) {
        shared = [[FXThemeManager alloc] init];
    }
    
    return shared;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - Setter
- (void) setThemeName:(NSString *)themeName
{
    _themeName = themeName;
    
    if ([themeName isEqualToString:_fxThemeNameDefault]) {
        
        _themeType      = FXThemeManagerTypeDefault;
        _themeFileData  = @"theme_default";
        
    } else if ([themeName isEqualToString:_fxThemeNameDefaultGreen]) {
        
        _themeType      = FXThemeManagerTypeDefaultGreen;
        _themeFileData  = @"theme_default_green";
        
    } else if ([themeName isEqualToString:_fxThemeNameDefaultOrange]) {
        
        _themeType      = FXThemeManagerTypeDefaultGreen;
        _themeFileData  = @"theme_default_orange";
        
    } else if ([themeName isEqualToString:_fxThemeNameDefaultPink]) {
        
        _themeType      = FXThemeManagerTypeDefaultGreen;
        _themeFileData  = @"theme_default_pink";
        
    } else if ([themeName isEqualToString:_fxThemeNameGirlie]) {
        
        _themeType      = FXThemeManagerTypeDefaultGreen;
        _themeFileData  = @"theme_girlie";
        
    } else if ([themeName isEqualToString:_fxThemeNameSweet]) {
        
        _themeType      = FXThemeManagerTypeDefaultGreen;
        _themeFileData  = @"theme_sweet";
        
    }
}

#pragma mark - Private Method
- (void) loadDataForTheme
{
    NSString *plistPath     = [[NSBundle mainBundle] pathForResource:_themeFileData ofType:@"plist"];
    _themeData              =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSLog(@"%@", _themeData);
}

#pragma mark - Public Method
- (void) loadTheme
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:_fxThemeStringName]) {
        
        self.themeName = _fxThemeNameDefault;
        [[NSUserDefaults standardUserDefaults] setObject:self.themeName forKey:_fxThemeStringName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        self.themeName = [[NSUserDefaults standardUserDefaults] objectForKey:_fxThemeStringName];
        
    }
    
    //load data for theme
    [self loadDataForTheme];
}

- (void) changeThemeWithName:(NSString*)themeName
{
    self.themeName = themeName;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.themeName forKey:_fxThemeStringName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //load data for theme
    [self loadDataForTheme];
    
    //post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:_fxThemeNotificationChangeTheme object:nil userInfo:nil];
}

#pragma mark - get value
- (NSString*)getThemeValueWithKey:(NSString*)key
{
    return [_themeData objectForKey:key];
}

#pragma mark - Color
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (UIColor*)getColorWithKey:(NSString*)key
{
    return [self colorFromHexString:[_themeData objectForKey:key]];
}












@end
