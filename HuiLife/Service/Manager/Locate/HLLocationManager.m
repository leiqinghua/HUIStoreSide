//
//  HLLocationManager.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/27.
//

#import "HLLocationManager.h"
#import "HLAlertView.h"

@interface HLLocationManager()<BMKLocationAuthDelegate,BMKLocationManagerDelegate>

@property(strong,nonatomic)BMKLocationManager * locationManager;

@property(copy,nonatomic)LocateBlock location;
@end

@implementation HLLocationManager

static HLLocationManager * _instance;

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HLLocationManager alloc]init];
    });
    return _instance;
}

-(void)startLocationWithCallBack:(LocateBlock)callBack{
    _location = callBack;
    [self getLocation];
}

- (void)getLocation{
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        [HLTools endLoadingAnimation];
        if (error) {
            // 检查是否开启了位置权限
            if (![HLLocationManager isLocationServiceOpen]) {
                [HLCustomAlert showNormalStyleTitle:@"定位服务未开启" message:@"请在设置->隐私->定位服务中开启定位服务，HUI生活商家需要知道您的位置才能提供更好的服务~" buttonTitles:@[@"取消",@"去设置"] buttonColors:@[UIColorFromRGB(0x868686),UIColorFromRGB(0xFF8604)] callBack:^(NSInteger index) {
                    if (index == 1) {
                       [HLTools openSystemSetting];
                    }
                }];
            }
            HLAccount * account = [HLAccount shared];
            NSMutableDictionary *json = [NSMutableDictionary dictionary];
            [json setObject:account.latitude forKey:@"latitude"];
            [json setObject:account.longitude forKey:@"longitude"];
            if (!account.locateJSON.length) {
                account.locateJSON = [json mj_JSONString];
                [HLAccount saveAcount];
            }
            self.location(nil);
//            HLLog(@"latitude1 = %f , %@",location.location.coordinate.latitude,error.localizedDescription);
            return ;
        }
//        HLLog(@"latitude = %f",location.location.coordinate.latitude);
        
        CLLocation *realLocation = location.location;
        BMKLocationReGeocode *rgcData = location.rgcData;
        
        HLAccount * account = [HLAccount shared];
        account.latitude = [NSString stringWithFormat:@"%f",realLocation.coordinate.latitude];
        account.longitude = [NSString stringWithFormat:@"%f",realLocation.coordinate.longitude];
        
        NSMutableDictionary *json = [rgcData mj_JSONObject];
        [json setObject:account.latitude forKey:@"latitude"];
        [json setObject:account.longitude forKey:@"longitude"];
        account.locateJSON = [json mj_JSONString];
        [HLAccount saveAcount];
        
        if (self.location) {
            self.location(location);
        }
    }];
}


- (BMKLocationManager *)locationManager{
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = nil;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}


+ (BOOL)isLocationServiceOpen {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}

@end
