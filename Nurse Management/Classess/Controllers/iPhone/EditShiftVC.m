//
//  EditShiftVC.m
//  Nurse Management
//
//  Created by Le Phuong Tien on 2/14/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "EditShiftVC.h"

@interface EditShiftVC ()

@end

@implementation EditShiftVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (IBAction)save:(id)sender {
    NSLog(@"save ban");
}

- (IBAction)selectButton:(id)sender {
    UIButton *button = (UIButton*)sender;
    _reviewCategory.textColor = [UIColor colorWithRed:93.0/255.0 green:80.0/255.0 blue:76.0/255.0 alpha:1.0];
    switch (button.tag) {
        case 0:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c1.png"];
            break;
        case 1:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c3.png"];
            break;
        case 2:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c5.png"];
            break;
        case 3:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c7.png"];
            break;
        case 4:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r1_c9.png"];
            break;
        case 5:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c1.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 6:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c3.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 7:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c5.png"];
            _reviewCategory.textColor = [UIColor whiteColor];
            break;
        case 8:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c7.png"];
            break;
        case 9:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c9.png"];
            break;
        default:
            _backgrounReview.image = [UIImage imageNamed:@"icon_r3_c1.png"];
            break;
    }
}
@end
