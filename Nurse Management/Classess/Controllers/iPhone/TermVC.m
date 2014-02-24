//
//  TermVC.m
//  Nurse Management
//
//  Created by Ducvov on 2/24/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#import "TermVC.h"

@interface TermVC (){
    NSString *_nameFile;
}

@end

@implementation TermVC

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
    if (_selectTerm == 8) {
        _lbTitle.text = @"利用規約";
        _nameFile = @"term-privacy_data";
    }else if (_selectTerm == 9){
        _lbTitle.text = @"利用規約 2";
        _nameFile = @"term-privacy_row_two";
    }else{
        _lbTitle.text = @"利用規約 4";
        _nameFile = @"term-privacy_three";
    }
    [self initDataContent];
}
-(void)initDataContent
{
    NSString* path = [[NSBundle mainBundle] pathForResource:_nameFile ofType:@"html"];
    if (path)
    {
        NSString* htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [_content loadHTMLString:htmlString baseURL:nil];
        //        _textContent.text = content;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
