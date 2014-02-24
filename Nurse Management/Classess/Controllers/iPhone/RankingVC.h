//
//  RankingVC.h
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/12/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXViewController.h"

@interface RankingVC : FXViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
