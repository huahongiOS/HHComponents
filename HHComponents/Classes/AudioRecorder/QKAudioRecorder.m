//
//  QKAudioRecorder.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "QKAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <lame/lame.h>
//#import "QKPrivacyTool.h"

@interface QKAudioRecorder()<AVAudioRecorderDelegate>

/**  录音对象  */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 当前暂停的时间 */
@property (nonatomic,assign) NSTimeInterval pauseTime;

//录音完成回调
@property (nonatomic,copy) void(^complateCallBack)(NSString *MP3Path,float totalTime);

//来电监听
@property (nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation QKAudioRecorder

@synthesize minDuration = _minDuration;
@synthesize maxDuration = _maxDuration;

+(QKAudioRecorder *)shared
{
    static QKAudioRecorder *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance)
        {
            instance = [super allocWithZone:NULL];
        }
        
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shared];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[self class] shared];
}

//MARK: - 麦克风权限
- (void)p_MicrophoneAuthStatusWithCompletionHandler:(void(^)(AVAuthorizationStatus status))handler
{
    
       AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
       switch (authStatus) {
           case AVAuthorizationStatusNotDetermined:
           {   //第一次进来
               [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                   
                    AVAuthorizationStatus newStatus = granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied;

                    dispatch_async(dispatch_get_main_queue(), ^{
                       !handler ?: handler(newStatus);
                    });
                   
               }];
           }
               break;
           
           default:
               !handler ?: handler(authStatus);
               break;
       }
                
       
}

/// 开始录音
/// @param complate  录音完成回调
- (void)startWithComplate:(void(^)(NSString *MP3Path,float totalTime))complate
{
     
    [self p_MicrophoneAuthStatusWithCompletionHandler:^(AVAuthorizationStatus status) {
       
        if (status == AVAuthorizationStatusAuthorized) {
            
            NSURL *recordeURL = [NSURL fileURLWithPath:[self getFilePath]];
              
               NSError *error;
               self.recorder = [[AVAudioRecorder alloc]initWithURL:recordeURL settings:[self recorderSetting] error:&error];
               if (error){
                   NSLog(@"error:%@",error);
                   return;
               }
               
               if (self.maxDuration <= self.minDuration) {
                   self.maxDuration = CGFLOAT_MAX;
               }
               [self.recorder recordForDuration:self.maxDuration];
               
               AVAudioSession *audioSession = [AVAudioSession sharedInstance];
               [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
               [audioSession setActive:YES error:nil];
               
               self.recorder.delegate = self;
               
               if (self.recorder && ![self.recorder isRecording])
               {
                   NSLog(@"开始录音");
                   self.complateCallBack = complate;
                   [self.recorder prepareToRecord];
                   [self.recorder record];
                   
                   //来电监听
                   [self incomingCallMonitoring];
               }
              
        }
    }];
    
   
   
}

 //来电监听
- (void)incomingCallMonitoring
{
      _callCenter = [[CTCallCenter alloc] init];
    __weak typeof(self) weakSelf = self;
      _callCenter.callEventHandler = ^(CTCall * _Nonnull call) {
        __strong typeof(weakSelf) self = weakSelf;
          if ([call.callState isEqualToString:CTCallStateDisconnected]) {
              
              NSLog(@"挂断了电话 Call has been disconnected");
              [self continueRecord];
              
          } else if ([call.callState isEqualToString:CTCallStateConnected]) {
              NSLog(@"电话通了 call has just been connected");
          } else if ([call.callState isEqualToString:CTCallStateIncoming]) {
              
              NSLog(@"来电话了Call is incoming");
              //暂停录音
              [self pause];
              
          } else if ([call.callState isEqualToString:CTCallStateDialing]) {
              NSLog(@"正在播出电话 call is dialing");
          }
      };
    
}

//设置录音参数
- (NSDictionary *)recorderSetting
{
    
    NSMutableDictionary *recorderSetting = [[NSMutableDictionary alloc] init];
    //采样率 8000/11025/22050/44100/96000(影响音频的质量)
    [recorderSetting setObject:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    //设置音频格式
    [recorderSetting setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样位数 8、16、24、32 默认为16
    [recorderSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //音频通道数
    [recorderSetting setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //录音质量
    [recorderSetting setObject:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    return recorderSetting;
}

- (void)setMinDuration:(NSTimeInterval)minDuration
{
    _minDuration = minDuration;
    if (_minDuration <= 0) {
        _minDuration = 0;
    }
}

- (NSTimeInterval)minDuration
{
    if (_minDuration <= 0) {
        _minDuration = 0;
    }
    
    return _minDuration;
}

- (void)setMaxDuration:(NSTimeInterval)maxDuration
{
    _maxDuration = maxDuration;
    if (_maxDuration <= 0) {
        _maxDuration = CGFLOAT_MAX;
    }
}

- (NSTimeInterval)maxDuration
{
    if (_maxDuration <= 0) {
           _maxDuration = CGFLOAT_MAX;
       }
    
    return _maxDuration;
}


- (NSString *)filePath
{
  if (_filePath == nil || _filePath.length == 0) {
      NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"Audios"];
      NSFileManager *fileManager = [NSFileManager defaultManager];
      BOOL isDir;
      BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
      if (!(isDir && existed)) {
          [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
      }
        _filePath = path;
    }
    
    return _filePath;
}


- (NSString *)fileName
{
   if (!_fileName || _fileName.length == 0) {
       NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
       _fileName = [NSString stringWithFormat:@"%.0f",timeStamp];
   }
    
    return _fileName;
}
-(void)pause
{
   if ([_recorder isRecording]) {
        _pauseTime = _recorder.currentTime;
        NSLog(@"_pauseTime = %f",_pauseTime);
        [_recorder pause];
    }
}

-(void)continueRecord
{
     if (![_recorder isRecording])
     {
        [_recorder recordAtTime:_pauseTime];
     }
}

-(void)stop
{
    //如果录音时长小于最小设置时间，则不能停止
    if (_recorder.currentTime < _minDuration) {
        return;
    }
    
    if (_recorder && _recorder.isRecording)
    {
         NSLog(@"停止录音");
       [_recorder stop];
    }
    
}

//重置数据
- (void)resetData
{
    _callCenter = nil;
    _minDuration = 0;
    _maxDuration = CGFLOAT_MAX;
    _filePath = nil;
    _fileName = nil;
}
- (NSString *)getFilePath
{
    return [[self.filePath stringByAppendingPathComponent:self.fileName]stringByAppendingString:@".caf"];
}

-(NSString *)getMP3Path
{
   return [[self.filePath stringByAppendingPathComponent:self.fileName]stringByAppendingString:@".mp3"];
}

-(void)deleteRecord
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getFilePath]]) {
        [fileManager removeItemAtPath:[self getFilePath] error:nil];
    }
}

- (void)deleteMP3
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getMP3Path]]) {
        [fileManager removeItemAtPath:[self getMP3Path] error:nil];
    }
}


#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
//    if (flag == NO) {
//        return;
//    }
   
    NSString *filePath = [self getFilePath];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:audioURL options:nil];
       CMTime audioDuration = audioAsset.duration;
       float totalDuration = CMTimeGetSeconds(audioDuration);
    
    NSString *MP3Path = [self transformToMP3:audioURL];
    
    if (self.complateCallBack) {
           self.complateCallBack(MP3Path,totalDuration);
       }
    
    [self resetData];
    
    //删除原.caf格式录音
    [self deleteRecord];
    
   
   
}

//被打断
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    //暂停录音
    [self pause];
}

//被打断结束
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    [self continueRecord];
}

//MARK: - 转mp3
- (NSString *)transformToMP3:(NSURL *)sourceUrl
{
    NSFileManager *manager = [NSFileManager defaultManager];
        unsigned long long size = [manager attributesOfItemAtPath:[sourceUrl path] error:nil].fileSize;
        
        
        NSURL *mp3FilePath,*audioFileSavePath;
        mp3FilePath = [NSURL URLWithString:[self getMP3Path]];
        
        @try {
            int read, write;
            
            FILE *pcm = fopen([[sourceUrl path] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
            fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
            FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 8000);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            //TODO:待处理
            NSLog(@"%@",[exception description]);
            NSLog(@"MP3转换失败");
        }
        @finally {
            audioFileSavePath = mp3FilePath;
            NSLog(@"MP3生成成功: %@",audioFileSavePath);
            NSString *mp3Path = audioFileSavePath.path;
            NSLog(@"str == %@",mp3Path);

            unsigned long long size1 = [manager attributesOfItemAtPath:mp3Path error:nil].fileSize;
            
            NSLog(@"转换前 == %@, 转换后 == %@",[self size:size], [self size:size1]);
            
            
        }
        
        return audioFileSavePath.path;
    
   
}

-(NSString *)size:(unsigned long long)size
{
    NSString *sizeText = @"";
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%lluB", size];
    }
    return sizeText;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
