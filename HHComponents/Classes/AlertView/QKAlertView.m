//
//  QKAlertView.m
//  TheHousing
//
//  Created by 华宏 on 2019/3/13.
//  Copyright © 2019年 com.qk365. All rights reserved.
//

#import "QKAlertView.h"
#import "UITextView+Placeholder.h"
#import "YYCategories.h"
#import "Masonry.h"
#define klineSpace 3       //行间距
#define kparagraphSpace 4  //段间距
#define kMinHeight 60      //最小高度
#define kcornerRadius 10   //圆角
#define kKeyBoardRemoveHeight 100  //键盘移动高度
#define kHHNavBarHeight  ([UIScreen mainScreen].bounds.size.height > 800 ? 88 : 64)

@interface QKAlertView()<UITextViewDelegate>

@property (copy, nonatomic) QKAlertBlock clickCallback;
@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UILabel *tipsLabel;

@end
@implementation QKAlertView

- (void)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <QKAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitle buttonClickback:(void(^)(QKAlertView *alertView,NSString *message,NSInteger buttonIndex))callback{
    
    self.title = title;
    self.message = message;
    self.delegate = delegate;
    self.clickCallback = [callback copy];
    
    if (otherButtonTitle) {
        [self.leftButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.rightButton setTitle:otherButtonTitle forState:UIControlStateNormal];

    }else
    {
        [self setSingleButton];
        [self.singleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];

    }

}

+ (instancetype)sharedAlertView
{
    static QKAlertView *instance = nil;

//    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
//   NSURL *url = [podBundle URLForResource:@"QKAlertView" withExtension:@"bundle"];
//   NSBundle *bundle = [NSBundle bundleWithURL:url];
//    if (bundle == nil) {
//        bundle = [NSBundle mainBundle];
//    }
//
//    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
//    instance = [[nib instantiateWithOwner:nil options:nil]lastObject];
   
    instance = [[QKAlertView alloc]init];
    return instance;
}

//在awakeFromNib之前调用，可以对xib文件的初始化作代码上的调整
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
   
    [self initData];
}

- (void)initData
{
     self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.bgView.layer.cornerRadius = kcornerRadius;
    //剪裁过，子视图就不需要设置圆角了
    self.bgView.layer.masksToBounds = YES;
//    [self.titleLabel setCornerRadius:kcornerRadius byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    self.leftButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.rightButton.layer.borderColor = self.rightButton.backgroundColor.CGColor;
    self.forbiddenEmoji = YES;
    self.textView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
      
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.textView];
        [self.bgView addSubview:self.leftButton];
        [self.bgView addSubview:self.rightButton];
        [self.bgView addSubview:self.singleButton];
        [self.bgView addSubview:self.tipsLabel];
        
        [self layoutConstraints];
        
        [self initData];

        
    }
    
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

/** 弹出提示框 */
- (void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

/** 取消 */
- (IBAction)cancelAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
         [self removeFromSuperview];
    }];
    
    if (_clickCallback) {
        _clickCallback(self,_textView.text,0);
    }
    
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:0];
    }
}

/** 确定 */
- (IBAction)sureAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
    
    if (_clickCallback) {
        _clickCallback(self,_textView.text,1);
    }
    
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:1];
    }
}

/** 展示的文字内容 */
- (void)setMessage:(NSString *)message
{
    if(message == nil){
        return;
    }
    
    _message = message;
    self.textView.text = message;
    
    /** 设置行间距 段间距 */
    [self setLineSpace:klineSpace ParagraphSpace:kparagraphSpace TextAlignment:self.textView.textAlignment];
    
    /** 根据内容适应高度 */
    [self contentSizeFit];
    
    [self setNeedsLayout];

}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _textView.font = font;
}

/** 属性文本 */
- (void)setAttributedMessage:(NSAttributedString *)attributedMessage
{
    _attributedMessage = attributedMessage;
    self.textView.attributedText = attributedMessage;
    
    /** 设置行间距 段间距 */
    [self setLineSpace:klineSpace ParagraphSpace:kparagraphSpace TextAlignment:self.textView.textAlignment];
    
    /** 根据内容适应高度 */
    [self contentSizeFit];
    
    [self setNeedsLayout];
    
}

/** 设置行间距 段间距 */
- (void)setLineSpace:(CGFloat)lineSpace ParagraphSpace:(CGFloat)paragraphSpace TextAlignment:(NSTextAlignment)textAlignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    paragraphStyle.alignment = textAlignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableAttributedString *attributeText;
    if (self.attributedMessage) {
        attributeText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedMessage];
        [attributeText setAttributes:attributes range:NSMakeRange(0, self.attributedMessage.length)];
    }else
    {
        attributeText = [[NSMutableAttributedString alloc]initWithString:self.textView.text attributes:attributes];
    }
   
    
    self.textView.attributedText = attributeText;
}

/** 根据内容适应高度 */
- (void)contentSizeFit
{
    [self layoutIfNeeded];
    
    CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height - kHHNavBarHeight*2 - (_titleLabel.frame.size.height+_rightButton.frame.size.height+_textView.top+_textView.bottom+_rightButton.bottom);
//    CGSize maxSize = CGSizeMake(_textView.frame.size.width, maxHeight);
//    CGSize newSize = [_textView sizeThatFits:maxSize];
//    CGFloat minHeight = MAX(newSize.height, kMinHeight);
//    CGFloat contentHeight = MIN(minHeight, maxHeight);
    CGFloat contentHeight = MAX(_textView.height, _textView.contentSize.height);
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];

    CGSize newSize = _textView.contentSize;
    /** 上下居中 */
    if (newSize.height <= self.textView.frame.size.height)
    {
        /** 这里不能使用self.textView.frame.size.height，why？*/
        CGFloat offsetY = (_textView.height - newSize.height)/2;
        offsetY += self.textView.textContainerInset.top;
        UIEdgeInsets offset = UIEdgeInsetsMake(offsetY, 0, -offsetY, 0);
        [self.textView setTextContainerInset:offset];
    }
    
    self.textView.scrollEnabled = newSize.height > maxHeight;
}

/** 设置为单个按钮 */
- (void)setSingleButton
{
    _leftButton.hidden = _rightButton.hidden = YES;
    _singleButton.hidden = NO;
}

/** 对齐方式 */
- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textView.textAlignment = textAlignment;
}

/** 设置输入框可编辑 */
- (void)setEditable:(BOOL)editable
{
    if (editable)
    {
        self.textView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.textView.scrollEnabled = editable;
        self.textView.textAlignment = NSTextAlignmentLeft;
        self.textView.placeholder = _placeholder;
        self.tipsLabel.hidden = !_limitCount;
        self.tipsLabel.text = [NSString stringWithFormat:@"0/%ld",_limitCount];
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);

    }
    
    self.textView.editable = editable;

}

- (void)setLimitCount:(NSInteger)limitCount
{
    _limitCount = limitCount;
    
    if (self.textView.editable)
    {
        self.tipsLabel.hidden = !_limitCount;
        self.tipsLabel.text = [NSString stringWithFormat:@"0/%ld",_limitCount];
    }

}
/** 只有可编辑时，才有placeholder */
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (self.textView.editable)
    {
        self.textView.placeholder = placeholder;
    }
    
}

/** 设置标题 */
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}


/** 设置左按钮title,titleColor,backgroundColor,borderColor */
- (void)p_setLeftButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor
{
    [_leftButton setTitle:title forState:UIControlStateNormal];
    [_leftButton setTitleColor:titleColor forState:UIControlStateNormal];
    _leftButton.backgroundColor = backgroundColor;
    _leftButton.layer.borderWidth = 1;
    
    _leftButton.layer.borderColor = borderColor.CGColor;
    
}

/** 设置右按钮title,titleColor,backgroundColor,borderColor */
- (void)p_setRightButtonTitle:(NSString *)title TitleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor
{
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setTitleColor:titleColor forState:UIControlStateNormal];
    _rightButton.backgroundColor = backgroundColor;
    _rightButton.layer.borderWidth = 1;
    _rightButton.layer.borderColor = borderColor.CGColor;
}

- (void)exchangeTwoButton
{
    if (_singleButton.hidden == NO) {
        return;
    }
    
    NSString *oldLeftTitle = [_leftButton titleForState:UIControlStateNormal];
    UIColor *oldLeftTitleColor = [_leftButton titleColorForState:UIControlStateNormal];
    UIColor *oldLeftBgColor = [_leftButton backgroundColor];
    UIColor *oldLeftBorderColor = [UIColor colorWithCGColor:_leftButton.layer.borderColor];

    NSString *oldRightTitle = [_rightButton titleForState:UIControlStateNormal];
    UIColor *oldRightTitleColor = [_rightButton titleColorForState:UIControlStateNormal];
    UIColor *oldRightBgColor = [_rightButton backgroundColor];
    UIColor *oldRightBorderColor = [UIColor colorWithCGColor:_rightButton.layer.borderColor];

    [self p_setRightButtonTitle:oldLeftTitle TitleColor:oldLeftTitleColor backgroundColor:oldLeftBgColor borderColor:oldLeftBorderColor];

    [self p_setLeftButtonTitle:oldRightTitle TitleColor:oldRightTitleColor backgroundColor:oldRightBgColor borderColor:oldRightBorderColor];
    
    [_leftButton removeAllTargets];
    [_rightButton removeAllTargets];
    [_leftButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];


}

#pragma mark - UITextViewDelegate
/** 开始编辑，弹框升高，避免键盘遮挡 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
     
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {

           make.centerY.equalTo(_bgView.superview.mas_centerY).offset(-kKeyBoardRemoveHeight);
       }];
}

/** 结束编辑，弹框恢复居中对齐 */
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {

         make.centerY.equalTo(_bgView.superview.mas_centerY).offset(0);
     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (self.forbiddenEmoji)
    {
        //限制苹果系统输入法  禁止输入表情
        if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]){
            return NO;
        }
        
    }
    
    /** 限制字数 */
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
     //获取高亮部分内容
     //NSString * selectedtext = [textView textInRange:selectedRange];

     //如果有高亮且当前字数开始位置小于最大限制时允许输入
     if (selectedRange && pos)
     {
         NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
         NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
         NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
         return offsetRange.location < _limitCount;
         
     }

     NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];

     NSInteger caninputlen = _limitCount - comcatstr.length;

     if (caninputlen >= 0)
     {
        return YES;
     }else
     {
         NSInteger len = text.length + caninputlen;
         //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
         NSRange rg = {0,MAX(len,0)};

         if (rg.length > 0)
         {
                 NSString *s = @"";
                 //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                 BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                 if (asc)
                 {
                     //因为是ascii码直接取就可以了不会错
                    s = [text substringWithRange:rg];
                 }else
                 {
                     __block NSInteger idx = 0;
                     __block NSString  *trimString = @"";//截取出的字串
                     //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                     [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                                                  options:NSStringEnumerationByComposedCharacterSequences
                                                               usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                            
                                                                       if (idx >= rg.length) {
                                                                               *stop = YES; //取出所需要就break，提高效率
                                                                               return ;
                                                                          }
                            
                                                                       trimString = [trimString stringByAppendingString:substring];
                            
                                                                       idx++;
                                                                   }];
    
                       s = trimString;
                    }
             
                 //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                 [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
             }
         return NO;
        }
   
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView.text.length > self.limitCount) {
//        textView.text = [textView.text substringToIndex:self.limitCount];
//
//    }
    
    UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
     //如果在变化中是高亮部分在变，就不要计算字符了
     if (selectedRange && pos) {
            return;
         }
     NSString  *nsTextContent = textView.text;
     NSInteger existTextNum = nsTextContent.length;

     if (existTextNum > _limitCount)
         {
             //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
             NSString *s = [nsTextContent substringToIndex:_limitCount];
    
             [textView setText:s];
        }
    
    
    if (textView.markedTextRange == nil){
        NSInteger length = textView.text.length;
        _tipsLabel.text = [NSString stringWithFormat:@"%ld/%ld",length,_limitCount];
    }
    
    
}

- (void)layoutConstraints
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.centerY.equalTo(_bgView.superview.mas_centerY);
        make.top.mas_greaterThanOrEqualTo(kHHNavBarHeight);
        make.bottom.mas_lessThanOrEqualTo(-kHHNavBarHeight);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(100);
        
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(20);
       make.right.equalTo(_leftButton.superview.mas_centerX).offset(-10);
       make.height.mas_equalTo(40);
       make.top.equalTo(_textView.mas_bottom).offset(10);
    make.bottom.equalTo(_leftButton.superview.mas_bottom).offset(-20);
        
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(-20);
       make.left.equalTo(_rightButton.superview.mas_centerX).offset(10);
       make.width.height.top.bottom.equalTo(_leftButton);
        
    }];
    
    [_singleButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(20);
       make.right.mas_equalTo(-20);
       make.height.mas_equalTo(40);
       make.top.equalTo(_textView.mas_bottom).offset(10);
    make.bottom.equalTo(_singleButton.superview.mas_bottom).offset(-20);
        
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(15);
        make.bottom.equalTo(_textView.mas_bottom);
    }];
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }

    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"提示";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithRed:32/255.0 green:157/255.0 blue:113/255.0 alpha:1.0];
        
    }

    return _titleLabel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.layer.cornerRadius = 5.0;
        _textView.editable = NO;

    }

    return _textView;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.layer.borderWidth = 1.0;
        _leftButton.layer.cornerRadius = 5.0;
    }

    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor colorWithRed:32/255.0 green:157/255.0 blue:113/255.0 alpha:1.0];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.layer.cornerRadius = 5.0;


    }

    return _rightButton;
}

- (UIButton *)singleButton
{
    if (!_singleButton) {
        _singleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _singleButton.hidden = YES;
        _singleButton.backgroundColor = [UIColor colorWithRed:32/255.0 green:157/255.0 blue:113/255.0 alpha:1.0];
        [_singleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_singleButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _singleButton.layer.cornerRadius = 5.0;



    }

    return _singleButton;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return _tipsLabel;
}

/**
 //系统弹框自动换行
 UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
 
 [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
 
 [self submitData];
 }]];
 
 [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 
 }]];
 
 
 UIView *subView1 = alertCtrl.view.subviews[0];
 UIView *subView2 = subView1.subviews[0];
 UIView *subView3 = subView2.subviews[0];
 UIView *subView4 = subView3.subviews[0];
 UIView *subView5 = subView4.subviews[0];
 UILabel *messageLab = subView5.subviews[2];
 messageLab.textAlignment = NSTextAlignmentLeft;
 
 NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
 style.lineSpacing = lineSpace;
 style.paragraphSpacing = paragraphSpace;
 NSDictionary *attributes = @{NSParagraphStyleAttributeName:style};
 messageLab.attributedText = [[NSAttributedString alloc]initWithString:messageLab.text attributes:attributes];
 
 [self presentViewController:alertCtrl animated:YES completion:nil];
 
 */

@end
