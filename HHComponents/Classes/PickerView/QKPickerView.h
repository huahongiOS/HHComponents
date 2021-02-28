//
//  QKPickerView.h
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QKPickerView;
@protocol QKPickerViewDelegate <NSObject>

- (void)pickerView:(QKPickerView *)pickerView didSelectRow:(NSInteger)row selectData:(NSString *)selectStr;
@end

@interface QKPickerView : UIView

@property (nonatomic, assign)id<QKPickerViewDelegate> delegate;

- (instancetype)initWithDataSource:(NSArray *)datasource;

- (void)show;

- (void)setPickerViewBackgroundColor:(UIColor *)color;
@end
