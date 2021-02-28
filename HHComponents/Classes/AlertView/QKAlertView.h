//
//  QKAlertView.h
//  TheHousing
//
//  Created by 华宏 on 2019/3/13.
//  Copyright © 2019年 com.qk365. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QKAlertView;
@protocol QKAlertViewDelegate <NSObject>

- (void)alertView:(QKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

typedef void(^QKAlertBlock)(QKAlertView *alertView,NSString *message,NSInteger buttonIndex);

@interface QKAlertView : UIView

@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UIButton *leftButton;
@property (strong, nonatomic)  UIButton *rightButton;
@property (strong, nonatomic)  UIButton *singleButton;//单按钮

/** 此处不适合单例创建，每次都需重新初始化 */
+ (instancetype)sharedAlertView;

- (void)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <QKAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitle buttonClickback:(void(^)(QKAlertView *alertView,NSString *message,NSInteger buttonIndex))callback;

/** 设置标题，只有set，没有get */
@property (nonatomic,copy,nullable) NSString *title;

/** 展示的文字内容 */
@property (nonatomic,copy) NSString *message;

/** 字体 */
@property (nonatomic,strong) UIFont *font;

/** 属性文本 */
@property(/*null_resettable*/nonatomic,copy) NSAttributedString *attributedMessage;

/** 对齐方式 - 默认居中对齐 */
@property(nonatomic) NSTextAlignment textAlignment;

@property (nonatomic,weak,nullable) id<QKAlertViewDelegate> delegate;

/** 设置输入框可编辑 */
@property(nonatomic,getter=isEditable) BOOL editable;

/** 限制字数 */
@property (nonatomic,assign) NSInteger limitCount;

/** 只有可编辑时，才有placeholder */
@property (nonatomic, copy) NSString *placeholder;

/** 是否禁止输入emoj表情😊，默认禁止YES */
@property (nonatomic,assign) BOOL forbiddenEmoji;

/** 交换两个按钮的位置 */
- (void)exchangeTwoButton;

/** 弹出提示框 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
