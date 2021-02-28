//
//  QKDatePicker.m
//  QK_Online
//
//  Created by 华宏 on 2019/4/15.
//  Copyright © 2019年 qk365. All rights reserved.
//

#import "QKDatePicker.h"

#define ToolbarHeight 40
@interface QKDatePicker ()

@property (strong,nonatomic) UIToolbar        *toolBar;
@property (strong,nonatomic) NSDate           *defaultDate;
@property (strong,nonatomic) UIDatePicker     *datePicker;
@property (assign,nonatomic) UIDatePickerMode datePickerModel;

@end

@implementation QKDatePicker

- (instancetype)initDatePickWithDate:(NSDate *)defaultDate datePickerModel:(UIDatePickerMode)datePickerModel{
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.frame = [UIScreen mainScreen].bounds;
        self.datePickerModel = datePickerModel;
        [self addSubview:self.toolBar];
        
    }
    
    return self;
}

- (UIToolbar *)toolBar
{
    if (_toolBar == nil) {
        
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ToolbarHeight - self.datePicker.frame.size.height, [UIScreen mainScreen].bounds.size.width, ToolbarHeight)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
        _toolBar.items = @[leftItem,centerSpace,rightItem];
        
        
    }
    
    return _toolBar;
}


- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.datePickerMode = self.datePickerModel;
        if (_defaultDate) {
            [_datePicker setDate:_defaultDate];
        }
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-_datePicker.frame.size.height, [UIScreen mainScreen].bounds.size.width, _datePicker.frame.size.height);
        [self addSubview:_datePicker];
    }
    
    return _datePicker;
}


//设置最小可选时间
- (void)setMinimumDate:(NSDate *)minimumDate
{
   [_datePicker setMinimumDate:minimumDate];
}

//设置最大可选时间
- (void)setMaximumDate:(NSDate *)maximumDate
{
   [_datePicker setMaximumDate:maximumDate];
}

//设置日期输出格式
- (void)setDateFormat:(NSString *)dateFormat
{
   _dateFormat = dateFormat;
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
    
    _dateFormat = _dateFormat?:@"yyyy-MM-dd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:_dateFormat];
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateString = [formatter stringFromDate:_datePicker.date];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectDate:StringDate:)]) {
        [self.delegate datePicker:self didSelectDate:_datePicker.date StringDate:dateString];
    }
    
    [self removeFromSuperview];
}

- (void)setDatePickerBackgroundColor:(UIColor *)color
{
    _datePicker.backgroundColor = color;
}

@end
