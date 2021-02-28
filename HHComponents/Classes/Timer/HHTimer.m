//
//  HHTimer.m
//  HHTimer
//
//

#import "HHTimer.h"

@implementation HHTimer

static NSMutableDictionary * _timerContainer;

+ (void)initialize
{
    _timerContainer = [NSMutableDictionary dictionary];
}

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
                         action:(dispatch_block_t)action{
    
    if (nil == timerName) {
        return;
    }
    
    if (nil == queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    dispatch_source_t timer = [_timerContainer objectForKey:timerName];
    if (timer == nil) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [_timerContainer setObject:timer forKey:timerName];
        
        dispatch_resume(timer);
    }
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval * NSEC_PER_SEC, 0);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        action();
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
}


//MARK: - 挂起定时器
/// @param timerName 定时器名称
- (void)suspendTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [_timerContainer objectForKey:timerName];
    if (!timer) {
        return;
    }
    dispatch_suspend(timer);
}

//MARK: - 重新启动定时器
/// @param timerName 定时器名称
- (void)resumeTimerWithName:(NSString *)timerName {
    dispatch_source_t gcd_timer = [_timerContainer objectForKey:timerName];
    if (gcd_timer) {
        dispatch_resume(gcd_timer);
    }
}

//MARK: - 取消单个定时器
/// @param timerName 定时器名称
+ (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [_timerContainer objectForKey:timerName];
    
    if (timer == nil) {
        return;
    }
    
    [_timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

//MARK: - 取消全部定时器
+ (void)cancelAllTimer
{
    [_timerContainer enumerateKeysAndObjectsUsingBlock:^(NSString * timerName, dispatch_source_t timer, BOOL * _Nonnull stop) {
        [_timerContainer removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }];
}

//MARK: -

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end

@implementation HHProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}
@end
