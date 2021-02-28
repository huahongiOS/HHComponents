//
//  QKAudioRecorder.h
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKAudioRecorder : NSObject

+(QKAudioRecorder *)shared;
 
///最小录音时长,默认0
@property (nonatomic,assign) NSTimeInterval minDuration;

///最大录音时长，默认CGFLOAT_MAX
@property (nonatomic,assign) NSTimeInterval maxDuration;

///文件路径，默认：Documents/Audios/
@property (copy  ,nonatomic) NSString *filePath;

///文件名称，默认：时间戳,(不用加后缀，录音完成会自动添加.caf和.mp3)
@property (copy  ,nonatomic) NSString *fileName;

/// 开始录音
/// @param complate  录音完成回调
- (void)startWithComplate:(void(^)(NSString *MP3Path,float totalTime))complate;

/**
 *  暂停录音
 */
-(void)pause;

/**
 *  暂停后 继续开始录音
 */
-(void)continueRecord;

/**
 *  结束录音
 */
-(void)stop;


/**
 *  删除录音
 */
-(void)deleteRecord;

- (void)deleteMP3;


@end
