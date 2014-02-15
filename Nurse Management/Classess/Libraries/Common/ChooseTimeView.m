//
//  ChooseTimeView.m
//  NurseManagementDemoControl
//
//  Created by phungduythien on 2/14/14.
//  Copyright (c) 2014 GreenGlobal. All rights reserved.
//

#import "ChooseTimeView.h"

//---------define--------------
#define NUMBER_OF_ITEM   6
#define WIDTH_ITEM       42.0f
#define HEIGHT_ITEM      44.0f

#define TAG_VIEW         10
#define TAG_LABEL        20
#define TAG_BUTTON       30

#define KEY_DEFAULT      40

#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithRed:215/255.0 green:224/255.0 blue:221/255.0 alpha:1.0]
#define DEFAULT_TEXT_COLOR          [UIColor colorWithRed:93/255.0 green:80/255.0 blue:76/255.0 alpha:1.0]
#define SELECTED_BACKGROUND_COLOR   [UIColor colorWithRed:101/255.0 green:135/255.0 blue:199/255.0 alpha:1.0]
//---------end define-----------

@interface ChooseTimeView()
{
    NSMutableDictionary *_dicValueSelect;
    NSInteger           _numberOfItemSelected;
    NSDate              *_startDate;
    NSDate              *_chooseTimeDate;
    UIColor             *_colorSelectBackground;
}

@end

@implementation ChooseTimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor = [UIColor clearColor];
        _dicValueSelect = [NSMutableDictionary dictionary];
        _colorSelectBackground = SELECTED_BACKGROUND_COLOR;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    NSArray *arr = @[@"on time",@"15 minutes",@"30 minutes",@"1 hour",@"2 hours",@"choose time"];
    float deltal = (rect.size.width - WIDTH_ITEM * NUMBER_OF_ITEM)/(NUMBER_OF_ITEM - 1);
    for (int i = 0; i < NUMBER_OF_ITEM; i++) {
        
        float originX = (deltal + WIDTH_ITEM)*i;
        //init view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, WIDTH_ITEM, HEIGHT_ITEM)];
        view.tag = i+TAG_VIEW;
        view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        //init label
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_ITEM, HEIGHT_ITEM)];
        lable.tag = i+TAG_LABEL;
        lable.text = arr[i];
        lable.numberOfLines = 2;
        lable.font = [UIFont fontWithName:@"Helvetica Neue" size:11];
        lable.textColor = DEFAULT_TEXT_COLOR;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = [UIColor clearColor];
        //init button
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_ITEM, HEIGHT_ITEM)];
        button.tag = i+TAG_BUTTON;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(tapToChooseItem:) forControlEvents:UIControlEventTouchUpInside];
        //add supview into view
        [view addSubview:lable];
        [view addSubview:button];
        
        //add into self
        [self addSubview:view];
        //add value disselect item into dictionary
        [_dicValueSelect setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",i+KEY_DEFAULT]];
    }
    
}

- (void)tapToChooseItem:(UIButton *)button
{
    //index tap to choose item
    int tapIndex = button.tag - TAG_BUTTON;
    //check status
    int statusButton = [[_dicValueSelect objectForKey:[NSString stringWithFormat:@"%d",tapIndex+KEY_DEFAULT]] intValue];
    if (statusButton == 1) {
        //set value
        _numberOfItemSelected -=1;
        [_dicValueSelect setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",tapIndex+KEY_DEFAULT]];
        //change UI
        UIView *view   = [self viewWithTag:tapIndex+TAG_VIEW];
        view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        UILabel *label = (UILabel *)[view viewWithTag:tapIndex+TAG_LABEL];
        label.textColor      = DEFAULT_TEXT_COLOR;
    }else {
        //check number of item selected
        if (_numberOfItemSelected >= 3) {
            return;
        }
        //set value
        _numberOfItemSelected +=1;
        [_dicValueSelect setObject:[NSString stringWithFormat:@"%d",1] forKey:[NSString stringWithFormat:@"%d",tapIndex+KEY_DEFAULT]];
        //change UI
        UIView *view = [self viewWithTag:tapIndex+TAG_VIEW];
        view.backgroundColor = _colorSelectBackground;
        UILabel *label = (UILabel *)[view viewWithTag:tapIndex+TAG_LABEL];
        label.textColor      = [UIColor whiteColor];
    }
    
    //set delegate
    [self callReturnDataWithIndex:tapIndex];
}

- (void)callReturnDataWithIndex:(NSInteger)tapIndex
{
    if ([self.delegate respondsToSelector:@selector(didChooseTimeWithIndex:arrayChooseTime:)]) {
        NSMutableArray *arrayNumberOfTimeSelected = [NSMutableArray array];
        for (int i = 0; i < _dicValueSelect.allKeys.count; i++) {
            NSString *key = _dicValueSelect.allKeys[i];
            int statusButton = [[_dicValueSelect objectForKey:key] intValue];
            if (statusButton == 1) {
                NSDate *date = nil;
                switch (key.integerValue - KEY_DEFAULT) {
                    case 0:
                    {
                        date = _startDate;
                    }
                        break;
                        
                    case 1:
                    {
                        NSTimeInterval time = [_startDate timeIntervalSince1970];
                        time -= 15*60;
                        date = [NSDate dateWithTimeIntervalSince1970:time];
                    }
                        break;
                        
                    case 2:
                    {
                        NSTimeInterval time = [_startDate timeIntervalSince1970];
                        time -= 30*60;
                        date = [NSDate dateWithTimeIntervalSince1970:time];
                    }
                        break;
                        
                    case 3:
                    {
                        NSTimeInterval time = [_startDate timeIntervalSince1970];
                        time -= 60*60;
                        date = [NSDate dateWithTimeIntervalSince1970:time];
                    }
                        break;
                        
                    case 4:
                    {
                        NSTimeInterval time = [_startDate timeIntervalSince1970];
                        time -= 120*60;
                        date = [NSDate dateWithTimeIntervalSince1970:time];
                    }
                        break;
                        
                    case 5:
                    {
                        
                        date = _chooseTimeDate;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [arrayNumberOfTimeSelected addObject:date];
            }
        }
        [self.delegate didChooseTimeWithIndex:tapIndex arrayChooseTime:arrayNumberOfTimeSelected];
    }
}

- (void)setStartDate:(NSDate *)date
{
    _startDate = date;
}

- (void)setChooseTimeWithDate:(NSDate *)date
{
    _chooseTimeDate = date;
    //set delegate
    [self callReturnDataWithIndex:5];
}

- (void)setColorForActiontionChoose:(UIColor *)color
{
    if (color == nil) {
        _colorSelectBackground = SELECTED_BACKGROUND_COLOR;
    }else {
        _colorSelectBackground = color;
    }
    
    for (int i = 0; i < NUMBER_OF_ITEM; i++) {
        
        //check status
        int statusButton = [[_dicValueSelect objectForKey:[NSString stringWithFormat:@"%d",i+KEY_DEFAULT]] intValue];
        if (statusButton == 1) {
            //change UI
            UIView *view = [self viewWithTag:i+TAG_VIEW];
            view.backgroundColor = _colorSelectBackground;
        }
    }
}

@end