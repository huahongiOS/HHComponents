//
//  HHCapture.h
//  HuaHong
//
//  Created by HH-huahong on 2019/8/21.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//捕获类型
typedef NS_ENUM(NSUInteger,HHCaptureType){
    HHCaptureTypeVideo = 0,   //视频
    HHCaptureTypeAudio,       //音频
    HHCaptureTypeMovie,       //影片(movie file output)
    HHCaptureTypeStillImage,  //静态图片
    HHCaptureTypeQRCode,      //二维码
    HHCaptureTypeFace         //人脸识别
    
};


@protocol HHCaptureDelegate <NSObject>
@optional

//AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

//AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections;
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;

//AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection;

//
-(void)captureOutput:(AVCaptureOutput *)captureOutput captureStillImage:(NSData *)imageData;
@end

/**捕获音视频*/
@interface HHCapture : NSObject

@property (nonatomic, strong, readonly) AVCaptureDevice *device;
@property (nonatomic, strong) UIView *preview;/**预览层*/
@property (nonatomic, weak) id<HHCaptureDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isRecording;//正在录制
@property (copy,   nonatomic) dispatch_queue_t captureQueue;//录制队列
@property (atomic, assign) NSUInteger witdh;/**捕获视频的宽*/
@property (atomic, assign) NSUInteger height;/**捕获视频的高*/

/********************公共*************/
@property (strong, nonatomic,readonly) AVCaptureSession           *captureSession;//捕捉会话

/********************音频相关**********/
@property (strong, nonatomic,readonly) AVCaptureDeviceInput       *audioInput;//音频输入
@property (strong, nonatomic,readonly) AVCaptureAudioDataOutput   *audioOutput;//音频输出
@property (strong, nonatomic,readonly) AVCaptureConnection        *audioConnection;//音频连接

/********************视频相关**********/
@property (strong, nonatomic,readonly) AVCaptureDeviceInput       *videoInput;//视频输入
@property (strong, nonatomic,readonly) AVCaptureVideoDataOutput   *videoOutput;//视频输出
@property (strong, nonatomic,readonly) AVCaptureConnection        *videoConnection;//视频连接
@property (strong, nonatomic,readonly) AVCaptureMovieFileOutput   *movieOutput;//影片输出

/********************静态图片捕捉**********/
@property (strong, nonatomic,readonly) AVCaptureStillImageOutput  *imageOutPut;//静态图片输出

/********************元数据输出**********/
@property (strong, nonatomic,readonly) AVCaptureMetadataOutput  *metadataOutPut;//二维码，人脸识别


/********************预览层**********/
@property (strong, nonatomic,readonly) AVCaptureVideoPreviewLayer *previewLayer;//预览层layer

- (instancetype)initWithType:(HHCaptureType)type;

/** 准备工作(只捕获音频时调用)*/
- (void)prepare;

//捕获内容包括视频时调用（预览层大小，添加到view上用来显示）
- (void)prepareWithPreviewFrame:(CGRect)frame;

/**开始*/
- (void)startRunning;

/**结束*/
- (void)stopRunning;

/**切换摄像头*/
- (void)switchCamera;

//设置手电筒模式
- (void)setTorchModel:(AVCaptureTorchMode)torchModel;

//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode)flashModel;

//MARK: - movie
- (void)startMovieRecording;
- (void)stopMovieRecording;
- (CMTime)movieRecordDuration;


/// 捕捉静态图片
/// @param videoScaleAndCropFactor  缩放比例
- (void)captureStillImage:(CGFloat)videoScaleAndCropFactor;

//自动对焦
- (void)focusAtPoint:(CGPoint)point;

////设置对焦兴趣点 和 持续自动对焦模式
- (void)setFocusAndExposureModes:(CGPoint)point;

//设置平滑对焦模式，即减慢摄像头对焦速度，当用户移动拍摄时，摄像头会尝试快速自动对焦
- (void)setSmoothAutoFocus;

//MARK: - 授权检测
+ (int)checkMicrophoneAuthor;
+ (int)checkCameraAuthor;

@end
