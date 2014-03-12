//
//  ADView.h
//  Nurse Management
//
//  Created by Tien Le Phuong on 3/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADViewDelegate;
@interface ADView : UIView

@property (nonatomic, weak) id <ADViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView     *viewContainerWeb;
@property (nonatomic, weak) IBOutlet UIWebView  *webView;
@property (nonatomic, weak) IBOutlet UIButton   *btOpen;

- (void) initADView;
- (void) show;
- (void) hide;

- (IBAction)closeAdView:(id)sender;
- (IBAction)openUrlAD:(id)sender;

@end

@protocol ADViewDelegate <NSObject>

- (void) adViewDidClose:(ADView*)adView;
- (void) adViewDidShow:(ADView*)adView;

@end
