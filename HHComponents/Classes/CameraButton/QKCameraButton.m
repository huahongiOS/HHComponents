//
//  QKCameraButton.m
//
//  Created by 华宏 on 2019/11/19.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "QKCameraButton.h"

// 默认按钮大小
#define CAMERABUTTONWIDTH 70
#define TOUCHVIEWWIDTH 50

// 录制按钮动画轨道宽度
#define PROGRESSLINEWIDTH 6

#define RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface QKCameraButton ()

@property (strong, nonatomic) UIView *touchView;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (copy, nonatomic) LongPressEventBlock longPressEventBlock;
@property (assign,nonatomic) QKCameraButtonType type;

@end

@implementation QKCameraButton

#pragma mark - 工厂方法

+ (instancetype)cameraButtonWithType:(QKCameraButtonType)type
{
    // 设置camera view
    QKCameraButton *cameraButton = [[QKCameraButton alloc] initWithFrame:CGRectMake(0, 0, CAMERABUTTONWIDTH, CAMERABUTTONWIDTH)];
    [cameraButton.layer setCornerRadius:(CAMERABUTTONWIDTH / 2)];
    cameraButton.backgroundColor = [UIColor clearColor];
    cameraButton.type = type;
    [cameraButton addSubview:cameraButton.touchView];
    
    [cameraButton initLayers];
    
    [cameraButton addObserver:cameraButton forKeyPath:@"selected" options:(NSKeyValueObservingOptionNew) context:nil];
    
    return cameraButton;
}

- (UIView *)touchView
{
    if (!_touchView) {
         CGFloat touchViewX = (CAMERABUTTONWIDTH - TOUCHVIEWWIDTH) / 2;
           CGFloat touchViewY = (CAMERABUTTONWIDTH - TOUCHVIEWWIDTH) / 2;
           _touchView = [[UIView alloc] initWithFrame:CGRectMake(touchViewX, touchViewY, TOUCHVIEWWIDTH, TOUCHVIEWWIDTH)];
           [_touchView.layer setCornerRadius:(TOUCHVIEWWIDTH / 2)];
        UIColor *backgroundColor = _type == QKCameraButtonTypePhoto ? [UIColor whiteColor] : [UIColor redColor];
        _touchView.backgroundColor = backgroundColor;
        _touchView.userInteractionEnabled = NO;
        
    }
    
    return _touchView;
}


#pragma mark - 点击事件与长按事件


/**
 *  配置按压事件
 */
- (void)longPressEventWithBlock:(LongPressEventBlock)longPressEventBlock
{

    self.longPressEventBlock = longPressEventBlock;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCameraButtonEvent:)];
    
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)longPressCameraButtonEvent:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (self.longPressEventBlock)
    {
        self.longPressEventBlock(longPressGestureRecognizer);
    }
}

#pragma mark - 录制视频按钮动画

// 初始化背景圆环和进度
- (void)initLayers
{
    float centerX = self.bounds.size.width / 2.0;
    float centerY = self.bounds.size.height / 2.0;
    //半径
    float radius = (self.bounds.size.width - PROGRESSLINEWIDTH) / 2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f * M_PI) endAngle:(1.5f * M_PI) clockwise:YES];
    
    //添加背景圆环
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.fillColor =  [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    circleLayer.lineWidth = PROGRESSLINEWIDTH;
    circleLayer.path = [path CGPath];
    circleLayer.strokeEnd = 1;
    [self.layer addSublayer:circleLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapSquare;//kCALineCapRound;
    _progressLayer.lineWidth = PROGRESSLINEWIDTH;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    // 渐变颜色
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB(76, 192, 29, 1.0f) CGColor], (id)[RGB(76, 192, 29, 1.0f) CGColor],  nil]];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer];     //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
    
}

// 设置按钮百分比
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [_progressLayer removeAllAnimations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //selected状态改变
    [self startAnimationWithDuration:0.25];

}


//开始动画
- (void)startAnimationWithDuration:(NSTimeInterval)duration
{
        
    if (_type == QKCameraButtonTypePhoto) {
           
          [UIView animateWithDuration:duration animations:^{
                 
                 self.touchView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                 
             } completion:^(BOOL finished) {
                  [self stopAnimation];
             }];
           
       }else if (_type == QKCameraButtonTypeVideo)
       {
          
           [UIView animateWithDuration:duration animations:^{
                 
              if (self.selected)
              {
                  self.touchView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                  self.touchView.layer.cornerRadius = self.touchView.bounds.size.width * 0.25;
                  
             }else
             {
                [self stopAnimation];
             }
                 
             } completion:nil];
       }
}


//停止动画
- (void)stopAnimation
{
    self.touchView.transform = CGAffineTransformIdentity;
    self.touchView.layer.cornerRadius = self.touchView.bounds.size.width * 0.5;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self removeObserver:self forKeyPath:@"selected"];
}
@end
