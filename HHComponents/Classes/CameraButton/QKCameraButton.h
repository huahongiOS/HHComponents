//
//  QKCameraButton.h
//
//  Created by 华宏 on 2019/11/19.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LongPressEventBlock)(UILongPressGestureRecognizer *longPressGestureRecognizer);

typedef NS_ENUM(NSUInteger, QKCameraButtonType) {
    QKCameraButtonTypePhoto,
    QKCameraButtonTypeVideo,
};

@interface QKCameraButton : UIButton

/**
 *  设置进度条的录制视频时长百分比 = 当前录制时间 / 最大录制时间
 */
@property (nonatomic, assign) CGFloat progress;

//默认长宽70
+ (instancetype)cameraButtonWithType:(QKCameraButtonType)type;


/**
 *  按压事件
 */
- (void)longPressEventWithBlock:(LongPressEventBlock)longPressEventBlock;

//停止动画,开始动画是监听selected,自动启动
- (void)stopAnimation;

@end
