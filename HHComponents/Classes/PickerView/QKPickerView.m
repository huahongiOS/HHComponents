//
//  QKPickerView.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "QKPickerView.h"

#define ToolbarHeight 40
@interface QKPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,nonatomic) UIToolbar *toolBar;
@property (assign,nonatomic) NSUInteger pickHeight;
@property (strong,nonatomic) UIPickerView *pickerView;
@property (strong,nonatomic) NSArray *datasource;
@property (strong,nonatomic) id selectedData;
@property (assign,nonatomic) NSInteger selectedRow;

@end
@implementation QKPickerView

- (instancetype)initWithDataSource:(NSArray *)datasource{
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.frame = [UIScreen mainScreen].bounds;
        self.datasource = datasource;
        [self addSubview:self.toolBar];
        [self.pickerView selectRow:0 inComponent:0 animated:false];

    }
    
    return self;
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, [UIScreen mainScreen].bounds.size.width, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_pickerView];
        
    }
    
    return _pickerView;
}

- (UIToolbar *)toolBar
{
    if (_toolBar == nil) {
        
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ToolbarHeight - self.pickerView.frame.size.height, [UIScreen mainScreen].bounds.size.width, ToolbarHeight)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
        _toolBar.items = @[leftItem,centerSpace,rightItem];
        
        
    }
    
    return _toolBar;
}



- (void)show
{
    [UIView animateWithDuration:0.25 animations:^{

        [[UIApplication sharedApplication].keyWindow addSubview:self];

    }];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];

}

- (void)sureClick{


    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:selectData:)]) {
        
        [self.delegate pickerView:self didSelectRow:self.selectedRow selectData:self.selectedData];
    }

    [self removeFromSuperview];
}

- (void)setPickerViewBackgroundColor:(UIColor *)color
{
    _pickerView.backgroundColor = color;
}

//MARK: - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.datasource.count;
}

//MARK: - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.bounds.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < self.datasource.count) {
        
        return [self.datasource objectAtIndex:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < self.datasource.count) {
        
        self.selectedData = [self.datasource objectAtIndex:row];
        self.selectedRow = row;
    }
    
}

@end

