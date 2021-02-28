//
//  QKPrivacyTool.m
//  HuaHong
//
//  Created by 华宏 on 2020/8/9.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "QKPrivacyTool.h"
@import AVKit;
@import AVFoundation;
@import Photos;
@import CoreLocation;
@import Contacts;                          //通讯录
@import AddressBook;                       //通讯录 < iOS 9.0
@import CoreBluetooth;
@import Speech;
@import Intents;                           //Siri
@import UserNotifications;
@import EventKit;                          //日历、提醒
@import CoreTelephony;
@interface QKPrivacyTool ()<CLLocationManagerDelegate>

//定位授权回调
@property (nonatomic,copy) void (^kCLCallBackBlock)(CLAuthorizationStatus state);
@property (strong, nonatomic) CLLocationManager *locationManager; //定位

@end

@implementation QKPrivacyTool

//MARK: - 单例
+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL]init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedManager];
}


//MARK: - 检测权限入口

/// 检查和请求对应类型的隐私权限
/// @param type 权限类型
/// @param handler 回调
- (void)requestAuthorizationWithType:(QKPrivacyType)type
                      completionHandler:(CompletionHandle)handler{
    
    switch (type) {
            
        case QKPrivacyTypePhotoLibrary:
        
            // 相册
            [self p_PhotoLibraryAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeCamera:
        
            // 相机
            [self p_CameraAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeLocateAlways:
        case QKPrivacyTypeLocateWhenInUse:
        case QKPrivacyTypeLocateBoth:
        
            // 定位
            [self p_LocationAuthStatusWithType:type
            CompletionHandler:handler];
        
            break;
        case QKPrivacyTypeMicrophone:
        
            // 麦克风
            [self p_MicrophoneAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeContacts:
        
            // 通讯录
            [self p_ContactsAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeBluetooth:
        
            // 蓝牙
            [self p_BluetoothAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeSpeechRecognizer:
        
            // 语音识别
            [self p_SpeechRecognizerAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeSiri:
        
            // Siri
            [self p_SiriAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeNotification:
        
            // 通知
            [self p_NotificationAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeCalendar:
        
            // 日历
            [self p_CalendarAuthStatusWithCompletionHandler:handler];
        
            break;
        case QKPrivacyTypeReminder:
        
            // 提醒
            [self p_ReminderAuthStatusWithCompletionHandler:handler];
        
            break;
            
        case QKPrivacyTypeCellularNetWork:
        
            // 网络
            [self p_CellularNetWorkAuthStatusWithCompletionHandler:handler];
        
            break;
//        case QKPrivacyTypeHealth:
//
//            // 健康
//            [self p_HealthAuthStatusWithCompletionHandler:handler];
//
//            break;
//        case QKPrivacyTypeMotion:
//
//            // 运动
//            [self p_MotionAuthStatusWithCompletionHandler:handler];
//
//            break;
                
        default:
            break;
    }
    
}


//MARK: - 相册权限
- (void)p_PhotoLibraryAuthStatusWithCompletionHandler:(CompletionHandle)handler{
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                QKAuthStatus newStatus = QKAuthStatusNotDetermined;
                switch (status) {
                    case PHAuthorizationStatusNotDetermined:
                         break;
                    case PHAuthorizationStatusRestricted:
                         newStatus = QKAuthStatusRestricted;
                         break;
                    case PHAuthorizationStatusDenied:
                         newStatus = QKAuthStatusDenied_system;
                         break;
                    case PHAuthorizationStatusAuthorized:
                         newStatus = QKAuthStatusAuthorized;
                         break;
                        
                    default:
                        break;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   !handler ?: handler(newStatus);
                });
                
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {    //未授权，家长限制
            !handler ?: handler(QKAuthStatusRestricted);
        }
            break;
        case PHAuthorizationStatusDenied:
        {   //拒绝
            !handler ?: handler(QKAuthStatusDenied);
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {   //已授权
            !handler ?: handler(QKAuthStatusAuthorized);
        }
            break;
            
        default:
            break;
    }
        
}

//MARK: - 摄像头权限
- (void)p_CameraAuthStatusWithCompletionHandler:(CompletionHandle)handler{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

                    dispatch_async(dispatch_get_main_queue(), ^{
                        !handler ?: handler(newStatus);
                    });
                    
                }];
            }
                break;
            case AVAuthorizationStatusRestricted:
            {   //未授权，家长限制
                !handler ?: handler(QKAuthStatusRestricted);
            }
                break;
            case AVAuthorizationStatusDenied:
            {   //拒绝
                !handler ?: handler(QKAuthStatusDenied);
            }
                break;
            case AVAuthorizationStatusAuthorized:
            {   //已授权
                !handler ?: handler(QKAuthStatusAuthorized);
            }
                break;
            default:
                break;
        }
                
    }else{
        //硬件不支持
        !handler ?: handler(QKAutStatusNotSupport);
    }
    
}


//MARK: - 定位权限
- (void)p_LocationAuthStatusWithType:(QKPrivacyType)type CompletionHandler:(CompletionHandle)handler{
        
    BOOL isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];
    if (!isLocationServicesEnabled) {
        !handler ?: handler(QKAutStatusNotSupport);
        
    }else{
                
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        switch (authStatus) {
            case kCLAuthorizationStatusNotDetermined:
            {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                
                // 定位模式：
                if (type == QKPrivacyTypeLocateWhenInUse) {
                    
                    [self.locationManager requestWhenInUseAuthorization];
                    
                }else if (type == QKPrivacyTypeLocateAlways){
                    
                  [self.locationManager requestAlwaysAuthorization];
                    
                }else if (type == QKPrivacyTypeLocateBoth){
                   
                    [self.locationManager requestWhenInUseAuthorization];
                    [self.locationManager requestAlwaysAuthorization];
                }
                
                
                [self setKCLCallBackBlock:^(CLAuthorizationStatus state){
                    
                    QKAuthStatus newStatus = QKAuthStatusNotDetermined;
                    switch (state) {
                       case kCLAuthorizationStatusNotDetermined:
                            break;
                       case kCLAuthorizationStatusRestricted:
                            newStatus = QKAuthStatusRestricted;
                            break;
                       case kCLAuthorizationStatusDenied:
                            newStatus = QKAuthStatusDenied_system;
                            break;
                       case kCLAuthorizationStatusAuthorizedAlways:
                            newStatus = QKAuthStatusAuthorized;
                            break;
                       case kCLAuthorizationStatusAuthorizedWhenInUse:
                             newStatus = QKAuthStatusAuthorized;
                             break;
                       default:
                           break;
                   }
                                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (newStatus != QKAuthStatusNotDetermined) {
                           !handler ?: handler(newStatus);
                       }
                      
                   });
                    
                }];
                
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {   //未授权，家长限制
                !handler ?: handler(QKAuthStatusRestricted);
                
            }
                break;
            case kCLAuthorizationStatusDenied:
            {   //拒绝
                !handler ?: handler(QKAuthStatusDenied);
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            {   //总是
                !handler ?: handler(QKAuthStatusAuthorized);
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {   //使用期间
                !handler ?: handler(QKAuthStatusAuthorized);
            }
                break;
            default:
                break;
        }
        
    }
    
}

// - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    !self.kCLCallBackBlock ?: self.kCLCallBackBlock(status);
}


//MARK: - 麦克风权限
- (void)p_MicrophoneAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
    
       AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
       switch (authStatus) {
           case AVAuthorizationStatusNotDetermined:
           {   //第一次进来
               [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                   
                   QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

                  dispatch_async(dispatch_get_main_queue(), ^{
                     !handler ?: handler(newStatus);
                  });
                                      
               }];
           }
               break;
           case AVAuthorizationStatusRestricted:
           {   //未授权，家长限制
               !handler ?: handler(QKAuthStatusRestricted);
           }
               break;
           case AVAuthorizationStatusDenied:
           {   //拒绝
               !handler ?: handler(QKAuthStatusDenied);
           }
               break;
           case AVAuthorizationStatusAuthorized:
           {   //已授权
               !handler ?: handler(QKAuthStatusAuthorized);
           }
               break;
           default:
               break;
       }
                
       
}


//MARK: - 通讯录权限
- (void)p_ContactsAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
    
    if (@available(iOS 9.0, *)) {
            CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (authStatus) {
            case CNAuthorizationStatusNotDetermined:
            {
               CNContactStore *contactStore = [[CNContactStore alloc] init];
               [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                   
                   QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

                   dispatch_async(dispatch_get_main_queue(), ^{
                       !handler ?: handler(newStatus);
                   });
               }];
            }
                break;
            case CNAuthorizationStatusRestricted:
                 !handler ?: handler(QKAuthStatusRestricted);
                break;
            case CNAuthorizationStatusDenied:
                !handler ?: handler(QKAuthStatusDenied);
                break;
            case CNAuthorizationStatusAuthorized:
                !handler ?: handler(QKAuthStatusAuthorized);
                break;
            default:
                break;
        }
            
    } else {
            
    //iOS9.0 eariler
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        switch (authStatus) {
            case kABAuthorizationStatusNotDetermined:
                {
                    ABAddressBookRef addressBook = ABAddressBookCreate();
                    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                        
                        QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

                        dispatch_async(dispatch_get_main_queue(), ^{
                            !handler ?: handler(newStatus);
                        });
                    });
                    
                    if (addressBook) {
                        CFRelease(addressBook);
                    }
                }
                break;
            case kABAuthorizationStatusAuthorized:
                 !handler ?: handler(QKAuthStatusAuthorized);
                break;
            case kABAuthorizationStatusRestricted:
                 !handler ?: handler(QKAuthStatusRestricted);
                 break;
            case kABAuthorizationStatusDenied:
                 !handler ?: handler(QKAuthStatusDenied);
                 break;
            default:
                break;
        }
            
    #pragma clang diagnostic pop
            
        }
}

//MARK: - 蓝牙权限
- (void)p_BluetoothAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
  CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    switch (authStatus) {
        case CBPeripheralManagerAuthorizationStatusNotDetermined:
        {
            CBCentralManager *cbManager = [[CBCentralManager alloc] init];
            [cbManager scanForPeripheralsWithServices:nil
                                              options:nil];
        }
            break;
        case CBPeripheralManagerAuthorizationStatusAuthorized:
             !handler ?: handler(QKAuthStatusAuthorized);
             break;
        case CBPeripheralManagerAuthorizationStatusRestricted:
             !handler ?: handler(QKAuthStatusRestricted);
             break;
        case CBPeripheralManagerAuthorizationStatusDenied:
             !handler ?: handler(QKAuthStatusDenied);
             break;
        default:
            break;
    }
    
}


//MARK: - 语音识别权限
- (void)p_SpeechRecognizerAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
   if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus authStatus = [SFSpeechRecognizer authorizationStatus];
       
       switch (authStatus) {
           case SFSpeechRecognizerAuthorizationStatusNotDetermined:
           {
               [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                   
                   QKAuthStatus newStatus = QKAuthStatusNotDetermined;
                    switch (status) {
                       case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                            break;
                       case SFSpeechRecognizerAuthorizationStatusRestricted:
                            newStatus = QKAuthStatusRestricted;
                            break;
                       case SFSpeechRecognizerAuthorizationStatusDenied:
                            newStatus = QKAuthStatusDenied_system;
                            break;
                       case SFSpeechRecognizerAuthorizationStatusAuthorized:
                            newStatus = QKAuthStatusAuthorized;
                            break;
                       default:
                           break;
                   }
                                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                      !handler ?: handler(newStatus);
                   });
                   
               }];
           }
               break;
           case SFSpeechRecognizerAuthorizationStatusAuthorized:
                !handler ?: handler(QKAuthStatusAuthorized);
                break;
           case SFSpeechRecognizerAuthorizationStatusRestricted:
                !handler ?: handler(QKAuthStatusRestricted);
                break;
           case SFSpeechRecognizerAuthorizationStatusDenied:
                !handler ?: handler(QKAuthStatusDenied);
                break;
           default:
               break;
       }
       
        
    }
}

//MARK: - Siri权限
- (void)p_SiriAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
   if (@available(iOS 10.0, *)) {
        INSiriAuthorizationStatus authStatus = [INPreferences siriAuthorizationStatus];
       
       switch (authStatus) {
        case INSiriAuthorizationStatusNotDetermined:
           {
               [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
                   
                   QKAuthStatus newStatus = QKAuthStatusNotDetermined;
                   switch (status) {
                     case INSiriAuthorizationStatusNotDetermined:
                          break;
                     case INSiriAuthorizationStatusRestricted:
                          newStatus = QKAuthStatusRestricted;
                          break;
                     case INSiriAuthorizationStatusDenied:
                          newStatus = QKAuthStatusDenied_system;
                          break;
                     case INSiriAuthorizationStatusAuthorized:
                          newStatus = QKAuthStatusAuthorized;
                          break;
                     default:
                         break;
                 }
                                 
                  dispatch_async(dispatch_get_main_queue(), ^{
                     !handler ?: handler(newStatus);
                  });
                   
               }];
           }
            break;
        case INSiriAuthorizationStatusRestricted:
            !handler ?: handler(QKAuthStatusRestricted);
            break;
        case INSiriAuthorizationStatusDenied:
            !handler ?: handler(QKAuthStatusDenied);
            break;
        case INSiriAuthorizationStatusAuthorized:
            !handler ?: handler(QKAuthStatusAuthorized);
            break;
        default:
            break;
      }
   }
}


//MARK: - 通知权限
- (void)p_NotificationAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
   if (@available(iOS 10.0, *)) {
        //iOS 10 later
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            QKAuthStatus status = QKAuthStatusNotDetermined;
            switch (settings.authorizationStatus) {
                    case UNAuthorizationStatusNotDetermined:
                         status = QKAuthStatusNotDetermined;
                         break;
                    case UNAuthorizationStatusDenied:
                        status = QKAuthStatusDenied;
                        break;
                    case UNAuthorizationStatusAuthorized:
                    case UNAuthorizationStatusProvisional:
                        status = QKAuthStatusAuthorized;
                        break;
                    
                default:
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !handler ?: handler(status);
            });
        }];
    }else if (@available(iOS 8.0, *)){
       
        QKAuthStatus status = QKAuthStatusNotDetermined;
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            
           UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            
             status = (settings.types == UIUserNotificationTypeNone) ? QKAuthStatusDenied : QKAuthStatusAuthorized;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !handler ?: handler(status);
         });
        
    }
        
}

- (void)p_requestNotificationAccessWithCompletionHandler:(CompletionHandle)handler{

    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

            dispatch_async(dispatch_get_main_queue(), ^{
                !handler ?: handler(newStatus);
            });
        }];
    } else if (@available(iOS 8.0, *)) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
#pragma clang diagnostic pop
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
}

//MARK: - 日历权限
- (void)p_CalendarAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
   EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authStatus) {
      case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                
                QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

                dispatch_async(dispatch_get_main_queue(), ^{
                    !handler ?: handler(newStatus);
                });
            }];
        }
            break;
      case EKAuthorizationStatusAuthorized:
           !handler ?: handler(QKAuthStatusAuthorized);
           break;
      case EKAuthorizationStatusRestricted:
          !handler ?: handler(QKAuthStatusRestricted);
          break;
      case EKAuthorizationStatusDenied:
          !handler ?: handler(QKAuthStatusDenied);
          break;
      default:
          break;
  }
    
}


//MARK: - 提醒权限
- (void)p_ReminderAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
      
      switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:
          {
              EKEventStore *eventStore = [[EKEventStore alloc] init];
              [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                  
                  QKAuthStatus newStatus = granted ? QKAuthStatusAuthorized : QKAuthStatusDenied_system;

                  dispatch_async(dispatch_get_main_queue(), ^{
                      !handler ?: handler(newStatus);
                  });
              }];
          }
              break;
        case EKAuthorizationStatusAuthorized:
             !handler ?: handler(QKAuthStatusAuthorized);
             break;
        case EKAuthorizationStatusRestricted:
            !handler ?: handler(QKAuthStatusRestricted);
            break;
        case EKAuthorizationStatusDenied:
            !handler ?: handler(QKAuthStatusDenied);
            break;
        default:
            break;
    }
}

////MARK: - 健康权限
//- (void)p_HealthAuthStatusWithCompletionHandler:(CompletionHandle)handler
//{
//
//}
//
////MARK: - 运动权限
//- (void)p_MotionAuthStatusWithCompletionHandler:(CompletionHandle)handler
//{
//
//}


//MARK: - 网络权限
- (void)p_CellularNetWorkAuthStatusWithCompletionHandler:(CompletionHandle)handler
{
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        CTCellularDataRestrictedState authState = cellularData.restrictedState;
        if (authState == kCTCellularDataRestrictedStateUnknown) {
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
                
                QKAuthStatus newStatus = (state == kCTCellularDataNotRestricted) ? QKAuthStatusAuthorized : QKAuthStatusDenied;

                dispatch_async(dispatch_get_main_queue(), ^{
                    !handler ?: handler(newStatus);
                });
                
            };
        }else if (authState == kCTCellularDataNotRestricted){
            !handler ?: handler(QKAuthStatusAuthorized);
        }else{
            !handler ?: handler(QKAuthStatusDenied);
        }
    }
}


//MARK: - 以下内容跟权限无关，提示去系统设置还是返回首页

/// 弹出Alert，提示去系统设置还是返回
/// @param vc 当前viewController
/// @param title Alert标题
/// @param message Alert message
- (void)pushSettingWithCurrentVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message/* withHandle:(void(^) (NSInteger i))handler*/{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
        __weak typeof(self) weakSelf = self;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            !handler ?: handler(0);
            [weakSelf popToRootViewController:vc];
        }];
        [alert addAction:cancelAction];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            !handler ?: handler(1);
            [weakSelf gotoSystemSetting];

        }];
        [alert addAction:okAction];

        [vc presentViewController:alert animated:YES completion:nil];

      });

}

///返回首页
- (void)popToRootViewController:(UIViewController *)vc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc.navigationController popToRootViewControllerAnimated:YES];
    });
}

///跳到系统设置
- (void)gotoSystemSetting
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSURL *url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:nil];
            }
        }else{
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
    });
    
}

 // 判断用户是否允许接收通知
+ (BOOL)isUserNotificationEnable
{
    BOOL isEnable = NO;
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    
    return isEnable;
}

@end
