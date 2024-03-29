//
// UIPickerActionSheet.m
// Version 0.1
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Copyright (c) 2013 José Enrique Bolaños Gudiño
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIPickerActionSheet.h"
#import "Define.h"

@interface UIPickerActionSheet ()

- (void)initSheetWithWidth:(CGFloat)aWidth;

@end

@implementation UIPickerActionSheet

- (id)initForView:(UIView*)aView
{
    if (self = [super init])
    {
        self.containerView = aView;
        [self initSheetWithWidth:aView.bounds.size.width];
        
        _selectedItem = [[NSMutableDictionary alloc] init];
        
        _hours = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 24; i++) {
            [_hours addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        
        _minutes = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 60; i++) {
            [_minutes addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return self;
}

- (void)initSheetWithWidth:(CGFloat)aWidth
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    
    UIToolbar *toolbar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, 0, aWidth, 0)];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"肖去" style:UIBarButtonItemStylePlain target:self action:@selector(pickerSheetCancel)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(pickerSheetDone)];
    
    [toolbar setItems:@[flexibleSpace, cancelButton, doneButton]];
    
    UIPickerView *picker = [[UIPickerView alloc]
                            initWithFrame:CGRectMake(0, toolbar.bounds.size.height, aWidth, 0)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    
    [sheet addSubview:toolbar];
    [sheet addSubview:picker];
    
    self.sheet = sheet;
    self.picker = picker;
}

//- (void)show:(NSArray*)aItems
//{
//    self.items = aItems;
//    
//    // Do not show if items are invalid...
//    if (!self.items || self.items.count <= 0)
//        return;
//    
//    [self.sheet showInView:self.containerView];
//    
//    // XXX: Kinda hacky, but seems to be the only way to make it display correctly.
//    [self.sheet
//     setBounds:CGRectMake(0, 0,
//                          self.containerView.frame.size.width,
//                          self.sheet.frame.size.height + 478.0)];
//    
//    // Reload and select first item
//    [self.picker reloadComponent:0];
//    [self.picker selectRow:0 inComponent:0 animated:NO];
//    [self.picker.delegate pickerView:self.picker didSelectRow:0 inComponent:0];
//}


//- (void)show:(NSArray*)aItems
//{
//    self.items = aItems;
//
//    // Do not show if items are invalid...
//    if (!self.items || self.items.count <= 0)
//        return;
//
//    [self.sheet showInView:self.containerView];
//
//    // XXX: Kinda hacky, but seems to be the only way to make it display correctly.
//    [self.sheet
//     setBounds:CGRectMake(0, 0,
//                          self.containerView.frame.size.width,
//                          self.sheet.frame.size.height + 478.0)];
//
//    // Reload and select first item
//    [self.picker reloadComponent:0];
//    [self.picker selectRow:0 inComponent:0 animated:NO];
//    [self.picker.delegate pickerView:self.picker didSelectRow:0 inComponent:0];
//}

- (void)show:(NSMutableDictionary *)timeItem
{
    
    [self.sheet showInView:self.containerView];
    
    // XXX: Kinda hacky, but seems to be the only way to make it display correctly.
    [self.sheet
     setBounds:CGRectMake(0, 0,
                          self.containerView.frame.size.width,
                          self.sheet.frame.size.height + 478.0)];
    
    // Reload and select first item
    if (timeItem) {
        [self.picker selectRow:[[timeItem objectForKey:HOUR_KEY] intValue] inComponent:0 animated:NO];
        [self.picker.delegate pickerView:self.picker didSelectRow:[[timeItem objectForKey:HOUR_KEY] intValue] inComponent:0];
        [self.picker selectRow:[[timeItem objectForKey:MINUTE_KEY] intValue] inComponent:1 animated:NO];
        [self.picker.delegate pickerView:self.picker didSelectRow:[[timeItem objectForKey:MINUTE_KEY] intValue] inComponent:1];
    } else {
        [self.picker selectRow:0 inComponent:0 animated:NO];
        [self.picker.delegate pickerView:self.picker didSelectRow:0 inComponent:0];
        [self.picker selectRow:0 inComponent:1 animated:NO];
        [self.picker.delegate pickerView:self.picker didSelectRow:0 inComponent:1];
    }
//    [self.picker reloadComponent:0];
//    [self.picker selectRow:0 inComponent:0 animated:NO];
//    [self.picker.delegate pickerView:self.picker didSelectRow:0 inComponent:0];
}

- (int)numberOfComponentsInPickerView:(UIPickerView*)aPickerView
{
    return 2;
}

- (int)pickerView:(UIPickerView*)aPickerView numberOfRowsInComponent:(NSInteger)aComponent
{
//    return self.items.count;
    NSLog(@"component: %d", aComponent);
    if (aComponent == 0)
        return _hours.count;
    else if (aComponent == 1)
        return _minutes.count;
    
    return 0;
}

- (NSString*)pickerView:(UIPickerView*)aPickerView titleForRow:(NSInteger)aRow forComponent:(NSInteger)aComponent
{
//    id item = [self.items objectAtIndex:aRow];
//    return [item description];
    NSString *item = nil;
    if (aComponent == 0)
        item = [_hours objectAtIndex:aRow];
    else if (aComponent == 1)
        item = [_minutes objectAtIndex:aRow];
    
    return item;
}

- (void)pickerView:(UIPickerView*)aPickerView didSelectRow:(NSInteger)aRow inComponent:(NSInteger)aComponent
{
//    self.selectedItem = [self.items objectAtIndex:aRow];
    int hour = [aPickerView selectedRowInComponent:0];
    int minute = [aPickerView selectedRowInComponent:1];
    
    [_selectedItem setObject:[NSNumber numberWithInt:hour] forKey:HOUR_KEY];
    [_selectedItem setObject:[NSNumber numberWithInt:minute] forKey:MINUTE_KEY];
    
}

- (void)pickerSheetCancel
{
    [self.sheet dismissWithClickedButtonIndex:0 animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerActionSheetDidCancel:)])
        [self.delegate pickerActionSheetDidCancel:  self];
}

- (void)pickerSheetDone
{
    [self.sheet dismissWithClickedButtonIndex:0 animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerActionSheet:didSelectItem:)])
        [self.delegate pickerActionSheet:self didSelectItem:self.selectedItem];
    
    [_selectedItem removeAllObjects];
}

@end
