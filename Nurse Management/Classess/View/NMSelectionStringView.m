//
//  NMSelectionStringView.m
//  NurseManagementDemoControl
//
//  Created by phungduythien on 2/15/14.
//  Copyright (c) 2014 GreenGlobal. All rights reserved.
//

#import "NMSelectionStringView.h"

//---------define--------------

#define WIDTH_ITEM       50.0f
#define HEIGHT_ITEM      44.0f
#define DELTA_ITEM       10.0

#define TAG_VIEW         1000
#define TAG_LABEL        2000
#define TAG_BUTTON       3000

#define KEY_VALUE      5000
#define KEY_STATUS     6000

#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithRed:215/255.0 green:224/255.0 blue:221/255.0 alpha:1.0]
#define DEFAULT_TEXT_COLOR          [UIColor colorWithRed:93/255.0 green:80/255.0 blue:76/255.0 alpha:1.0]
#define SELECTED_BACKGROUND_COLOR   [UIColor colorWithRed:101/255.0 green:135/255.0 blue:199/255.0 alpha:1.0]
#define DEFAULT_PAGE_CONTROL_COLOR   [UIColor colorWithRed:127/255.0 green:96/255.0 blue:41/255.0 alpha:1.0]
//---------end define-----------

@interface NMSelectionStringView()<UIScrollViewDelegate>
{
    UIScrollView        *_scrollView;
    UIPageControl       *_pageControl;
    
    NSMutableArray      *_arrayString;
    UIColor             *_colorSelectBackground;
}
@end

@implementation NMSelectionStringView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _colorSelectBackground = SELECTED_BACKGROUND_COLOR;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, rect.size.width + 10, 98)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 90, rect.size.width, 37)];
    _pageControl.pageIndicatorTintColor = DEFAULT_BACKGROUND_COLOR;
    _pageControl.currentPageIndicatorTintColor = DEFAULT_PAGE_CONTROL_COLOR;
    int numberOfPage = round(_arrayString.count/10) + 1;
    _pageControl.numberOfPages = numberOfPage;
    [_pageControl addTarget:self action:@selector(tapToScrollCollectionView) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
    
    for (int i = 0; i < _arrayString.count; i++) {
        CGPoint point = CGPointZero;
        if (i%2 == 0) {
            point.y = 0;
        }else {
            point.y = HEIGHT_ITEM + DELTA_ITEM;
        }
        point.x = 10 + (WIDTH_ITEM + DELTA_ITEM)*(i/2);
        
        [_scrollView addSubview:[self viewWithPoint:point andIndex:i]];
    }
    [_scrollView setContentSize:CGSizeMake(((_arrayString.count/10)+1)*(self.frame.size.width+10), 98)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = round(_scrollView.contentOffset.x/(self.frame.size.width+10));
}

#pragma mark - Methods Other

- (void)tapToScrollCollectionView
{

    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * (self.frame.size.width+10) , 0) animated:YES];
}

- (UIView *)viewWithPoint:(CGPoint)point andIndex:(NSInteger)index
{
    NSMutableDictionary *dic = _arrayString[index];
    //init view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, WIDTH_ITEM, HEIGHT_ITEM)];
    view.tag = index+TAG_VIEW;
    view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    //init label
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_ITEM, HEIGHT_ITEM)];
    lable.tag = index+TAG_LABEL;
    lable.text = dic[[NSString stringWithFormat:@"%d",index+KEY_VALUE]];
    lable.numberOfLines = 2;
    lable.font = [UIFont fontWithName:@"Helvetica Neue" size:11];
    lable.textColor = DEFAULT_TEXT_COLOR;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor clearColor];
    //init button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_ITEM, HEIGHT_ITEM)];
    button.tag = index+TAG_BUTTON;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(tapToChooseItem:) forControlEvents:UIControlEventTouchUpInside];
    //add supview into view
    [view addSubview:lable];
    [view addSubview:button];
    
    //add into self
    [self addSubview:view];
    //add value disselect item into dictionary
    [dic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",index+KEY_STATUS]];
    
    return view;
}


- (void)callReturnDataWithIndex:(NSInteger)tapIndex
{
    if ([self.delegate respondsToSelector:@selector(didSelectionStringWithIndex:arraySelectionString:)]) {
        NSMutableArray *arrReturn = [NSMutableArray array];
        for (int i = 0; i < _arrayString.count; i++) {
            NSMutableDictionary *dic = _arrayString[i];
            int statusButton = [[dic objectForKey:[NSString stringWithFormat:@"%d",i+KEY_STATUS]] intValue];
            if (statusButton == 1) {
                [arrReturn addObject:[dic objectForKey:[NSString stringWithFormat:@"%d",i+KEY_VALUE]]];
            }
        }
        [self.delegate didSelectionStringWithIndex:tapIndex arraySelectionString:arrReturn];
    }
}

- (void)setArrayString:(NSArray *)arrayStr
{
    if (_arrayString.count) {
        _arrayString = nil;
    }
    _arrayString = [NSMutableArray array];
    for (int i = 0; i < arrayStr.count; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arrayStr[i] forKey:[NSString stringWithFormat:@"%d",i+KEY_VALUE]];
        [dic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i+KEY_STATUS]];
        
        [_arrayString addObject:dic];
    }
}


- (void)setColorForSelectionString:(UIColor *)color
{
    if (color == nil) {
        _colorSelectBackground = SELECTED_BACKGROUND_COLOR;
    }else {
        _colorSelectBackground = color;
    }
    
    for (int i = 0; i < _arrayString.count; i++) {
        
        //check status
        NSMutableDictionary *dic = _arrayString[i];
        int statusButton = [dic[[NSString stringWithFormat:@"%d",i+KEY_STATUS]] intValue];
        if (statusButton == 1) {
            //change UI
            UIView *view = [self viewWithTag:i+TAG_VIEW];
            view.backgroundColor = _colorSelectBackground;
        }
    }
}

- (void)tapToChooseItem:(UIButton *)button
{
    //index tap to choose item
    int tapIndex = button.tag - TAG_BUTTON;
    //check status
    NSMutableDictionary *dic = _arrayString[tapIndex];
    int statusButton = [dic[[NSString stringWithFormat:@"%d",tapIndex+KEY_STATUS]] intValue];
    if (statusButton == 1) {
        //set value
        NSMutableDictionary *dic = _arrayString[tapIndex];
        [dic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",tapIndex+KEY_STATUS]];
        //change UI
        UIView *view   = [_scrollView viewWithTag:tapIndex+TAG_VIEW];
        view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        UILabel *label = (UILabel *)[view viewWithTag:tapIndex+TAG_LABEL];
        label.textColor      = DEFAULT_TEXT_COLOR;
    }else {
        //set value
        NSMutableDictionary *dic = _arrayString[tapIndex];
        [dic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",tapIndex+KEY_STATUS]];
        //change UI
        UIView *view = [_scrollView viewWithTag:tapIndex+TAG_VIEW];
        view.backgroundColor = _colorSelectBackground;
        UILabel *label = (UILabel *)[view viewWithTag:tapIndex+TAG_LABEL];
        label.textColor      = [UIColor whiteColor];
    }
    
    //set delegate
    [self callReturnDataWithIndex:tapIndex];
}

@end
