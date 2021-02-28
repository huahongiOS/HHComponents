//
//  HHTimer.h
//  HHTimer
//
//

#import <Foundation/Foundation.h>

@interface HHTimer : NSObject

/**
 创建dispatch定时器
 
 @param timerName 定时器名称
 @param interval 时间间隔
 @param queue 运行的队列(默认为全局并发队列)
 @param repeats 是否重复
 @param action 执行的动作
 */
+ (void)scheduleQKTimerWithName:(NSString *)timerName
                   timeInterval:(double)interval
                          queue:(dispatch_queue_t)queue
                        repeats:(BOOL)repeats
                         action:(dispatch_block_t)action;

/// 挂起定时器
/// @param timerName 定时器名称
- (void)suspendTimerWithName:(NSString *)timerName;


/// 重新启动定时器
/// @param timerName 定时器名称
- (void)resumeTimerWithName:(NSString *)timerName;

/**
 取消dispatch定时器
 
 @param timerName 定时器名称
 */
+ (void)cancelTimerWithName:(NSString *)timerName;

/**
 取消所有创建的dispatch定时器
 */
+ (void)cancelAllTimer;

@end


@interface HHProxy : NSProxy
@property (nonatomic,weak) id target;
@end
