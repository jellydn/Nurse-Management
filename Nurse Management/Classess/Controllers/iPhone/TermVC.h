//
//  TermVC.h
//  Nurse Management
//
//  Created by Ducvov on 2/24/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermVC : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIWebView *content;
@property (nonatomic) int selectTerm;
@end
