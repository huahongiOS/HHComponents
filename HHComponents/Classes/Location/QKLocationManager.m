//
//  QKLocationManager.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/23.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "QKLocationManager.h"

typedef void(^LocationBlock)(double longitude,double latitude,CLPlacemark *placemark);
@interface QKLocationManager ()<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (copy  ,nonatomic) LocationBlock locationBlock;
@property (nonatomic,copy) void (^kCLCallBackBlock)(CLAuthorizationStatus state);//定位授权回调
@end


@implementation QKLocationManager

+ (instancetype)sharedManager
{
    static QKLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil){
            manager = [[QKLocationManager alloc]init];
        }
    });
    
    return manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[self class] sharedManager];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc]init];
         _locationManager.delegate = self;
        
       //请设置定位精度
       _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       
       //设置定位频率  定位刷新的距离 单位m
       _locationManager.distanceFilter = 1.0;
    }
    
    return _locationManager;
}

 //MARK: - 定位权限
 - (void)requestAuthWithCompletionHandler:(void(^)(QKAuthStatus status))handler{
         
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
                 [self.locationManager requestWhenInUseAuthorization];
//                 [self.locationManager requestAlwaysAuthorization];
                 
                 
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

/// 开启定位
/// @param complate 完成回调
- (void)startLocation:(void(^)(double longitude,double latitude,CLPlacemark *placemark))complate
{
    _locationBlock = complate;
    
    //获取定位权限
    __weak typeof(self) weakSelf = self;

    [self requestAuthWithCompletionHandler:^(QKAuthStatus status) {
        
        if (status == QKAuthStatusAuthorized) {
            [weakSelf.locationManager startUpdatingHeading];
            [weakSelf.locationManager startUpdatingLocation];
        }
    }];
   
}

//停止定位
- (void)stopLocation
{
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
}


//MARK: - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //自己手动停止
//    [self stopLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    double longitude = coordinate.longitude;
    double latitude = coordinate.latitude;
   __block NSString *address;
    

    //反地理编码
    __weak typeof(self) weakSelf = self;

    [self reverseGeocodeLocation:location completionHandler:^(CLPlacemark *placemark, NSError * _Nullable error) {
        
        if (!error && placemark)
       {
           NSDictionary *dic = [placemark addressDictionary];
           NSString *City = [dic objectForKey:@"City"];
           NSString *SubLocality = [dic objectForKey:@"SubLocality"];
           NSString *Street = [dic objectForKey:@"Street"];
           address = [NSString stringWithFormat:@"%@%@%@",City,SubLocality,Street];
          
//           NSLog(@"placemark:%@",placemark);
//           NSLog(@"addressDictionary:%@",dic);

           
       }
       
        
           if (weakSelf.locationBlock) {
              weakSelf.locationBlock(longitude,latitude,placemark);
           }
    }];
    
    
}

/// 授权状态改变
/// @param manager  manager
/// @param status  status
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    !self.kCLCallBackBlock ?: self.kCLCallBackBlock(status);
}


///  更新用户方向
/// @param manager  manager
/// @param newHeading  newHeading
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
}


/// 定位失败
/// @param manager manager
/// @param error error
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败!");

    if (_locationBlock) {
        _locationBlock(0,0,nil);
    }
}

//MARK: - 地理编码
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(void(^)(CLPlacemark *placemark, NSError * _Nullable error))completionHandler
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
           completionHandler(nil,error);
           return ;
        }
       
        CLPlacemark *placemark = [placemarks firstObject];
        completionHandler(placemark,error);
    }];
}

//MARK: - 反地理编码
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(void(^)(CLPlacemark *placemark, NSError * _Nullable error))completionHandler
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
        if (error) {
            completionHandler(nil,error);
            return ;
        }
        
         CLPlacemark *placemark = [placemarks lastObject];
         completionHandler(placemark,error);
        
    }];
}

/// 计算一个坐标与我当前定位点的距离
/// @param latitude 纬度
/// @param longitude 经度
/// @complate 返回两点之间的距离，单位：米
- (void)distanceFromMyLocation:(double)latitude longitude:(double)longitude complate:(void(^)(CLLocationDistance distance))complate
{
  
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    [self startLocation:^(double longitude, double latitude, CLPlacemark *placemark) {
        
         CLLocation *location2 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
         CLLocationDistance distance = [location1 distanceFromLocation:location2];
        if (complate) {
            complate(distance);
        }
        
    }];
    
}

/// 计算两点间距离
/// @param latitude1 纬度1
/// @param longitude1 经度1
/// @param latitude2 纬度2
/// @param longitude2 经度2
/// @return 两点之间的距离，单位：米
- (CLLocationDistance)distanceFromLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double)latitude2 longitude2:(double)longitude2
{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];

   return [location1 distanceFromLocation:location2];
}

//MARK: - 获取当前VC
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
