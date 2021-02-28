//
//  DecimalNumberHelper.h
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
typedef enum:NSInteger {
    Add, //加
    Subtract, //减
    Multiply, //乘
    Divid, //除
    Rais, //n次方
    Power//指数运算
}DecimalNumberType;

@interface DecimalNumberHelper : NSObject


SingletonH()

//加减乘除
- (NSDecimalNumber *)decimalNumberType:(DecimalNumberType)type withDecimalNumberA:(NSString *)operateA withDecimalNumberB:(NSString *)operateB;

//n次方、指数运算
- (NSDecimalNumber *)decimalNumberType:(DecimalNumberType)type withDecimalNumberA:(NSString *)operateA withPower:(int)power;

//四舍五入
- (NSDecimalNumber *)decimalNumber:(NSString *)operateA scale:(int)scale;

//比较大小
- (NSComparisonResult)decimalNumber:(NSString *)operateA compareNumber:(NSString *)operateB;

@end
