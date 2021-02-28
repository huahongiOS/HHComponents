//
//  QKDatePicker.h
//  QK_Online
//
//  Created by 华宏 on 2019/4/15.
//  Copyright © 2019年 qk365. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QKDatePicker;
@protocol QKDatePickerDelegate <NSObject>

- (void)datePicker:(QKDatePicker *)datePicker didSelectDate:(NSDate *)date StringDate:(NSString *)dateString;
@end

@interface QKDatePicker : UIView

@property (nonatomic, assign)id<QKDatePickerDelegate> delegate;

- (instancetype)initDatePickWithDate:(NSDate *)defaultDate datePickerModel:(UIDatePickerMode)datePickerModel;

//最小可选时间
@property (strong,nonatomic) NSDate *minimumDate;

//最大可选时间
@property (strong,nonatomic) NSDate *maximumDate;

//日期输出格式
@property (strong,nonatomic) NSString *dateFormat;

- (void)show;

- (void)setDatePickerBackgroundColor:(UIColor *)color;
@end
