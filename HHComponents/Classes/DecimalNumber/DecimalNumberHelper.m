//
//  DecimalNumberHelper.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "DecimalNumberHelper.h"

@implementation DecimalNumberHelper

SingletonM()

//MARK: -

- (NSDecimalNumber *)decimalNumberType:(DecimalNumberType)type withDecimalNumberA:(NSString *)operateA withDecimalNumberB:(NSString *)operateB
{
    NSDecimalNumber *resultNum;
    NSDecimalNumber *decimalNumA = [NSDecimalNumber decimalNumberWithString:operateA];
    NSDecimalNumber *decimalNumB = [NSDecimalNumber decimalNumberWithString:operateB];
    switch (type) {
        case Add:
            resultNum = [decimalNumA decimalNumberByAdding:decimalNumB];
            break;
        case Subtract:
            resultNum = [decimalNumA decimalNumberBySubtracting:decimalNumB];
            break;
        case Multiply:
            resultNum = [decimalNumA decimalNumberByMultiplyingBy:decimalNumB];
            break;
        case Divid:
            resultNum = [decimalNumA decimalNumberByDividingBy:decimalNumB];
            break;
        default:
            break;
    }
    return resultNum;
}

//n次方、指数运算
- (NSDecimalNumber *)decimalNumberType:(DecimalNumberType)type withDecimalNumberA:(NSString *)operateA withPower:(int)power
{
    NSDecimalNumber *resultNum;
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithString:operateA];
    switch (type) {
        case Rais:
            resultNum = [decimalNum decimalNumberByRaisingToPower:power];
            break;
        case Power:
            resultNum = [decimalNum decimalNumberByMultiplyingByPowerOf10:power];
        default:
            break;
    }
    return resultNum;
}

- (NSDecimalNumber *)decimalNumber:(NSString *)operateA scale:(int)scale
{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *decimalNumA = [NSDecimalNumber decimalNumberWithString:operateA];
    NSDecimalNumber *resultNum = [decimalNumA decimalNumberByRoundingAccordingToBehavior:roundUp];
    return resultNum;
}

- (NSComparisonResult)decimalNumber:(NSString *)operateA compareNumber:(NSString *)operateB
{
    NSDecimalNumber *numA = [NSDecimalNumber decimalNumberWithString:operateA];
    NSDecimalNumber *numB = [NSDecimalNumber decimalNumberWithString:operateB];
    NSComparisonResult result = [numA compare:numB];
    if (result == NSOrderedAscending) {
        NSLog(@"85%% < 90%% 小于");
        return NSOrderedAscending;
    } else if (result == NSOrderedSame) {
        NSLog(@"85%% == 90%% 等于");
        return NSOrderedSame;
    } else  {
        NSLog(@"85%% > 90%% 大于");
        return NSOrderedDescending;
    }
}
@end
