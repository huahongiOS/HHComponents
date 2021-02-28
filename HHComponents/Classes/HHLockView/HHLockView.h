//
//  HHLockView.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^LockBlock)(NSString *pwd);
@interface HHLockView : UIView

@property (nonatomic, copy) LockBlock lockBlock;
@end
