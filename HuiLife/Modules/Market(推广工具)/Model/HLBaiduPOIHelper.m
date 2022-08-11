//
//  HLBaiduPOIHelper.m
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/12/24.
//  Copyright © 2018 wce. All rights reserved.
//

#import "HLBaiduPOIHelper.h"


@interface HLBaiduPOIHelper () <BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

@property (copy, nonatomic) HLPOIHelperBlock callBack;

@property (strong, nonatomic) BMKPoiSearch *poiSearcher;

@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *areaName;


@end

@implementation HLBaiduPOIHelper

- (void)configProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName{
    self.provinceName = provinceName;
    self.cityName = cityName;
    self.areaName = areaName;
}

#pragma mark - POI检索

// 根据关键字检索poi信息
- (void)startPOISearchWithCityName:(NSString *)cityName keyWord:(NSString *)keyWord page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize callBack:(HLPOIHelperBlock)callBack{
    self.callBack = callBack;
    
    //发起检索
    BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageIndex = pageIndex;
    option.pageSize = pageSize == 0 ? 20 : pageSize;
    option.keyword = keyWord;
    option.city = cityName;
    BOOL flag = [self.poiSearcher poiSearchInCity:option];
    if(flag)
    {
        HLLog(@"周边检索发送成功");
    }
    else
    {
        HLLog(@"周边检索发送失败");
        self.callBack(nil);
    }
}

/// poi 检索回调 BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    [self handleResult:poiResult.poiInfoList errorCode:errorCode];
}

#pragma mark - 反地理位置编码获取周边POI

// 根据经纬度检索周边poi信息
- (void)startReverseGeoCodeWithLat:(double)latitude long:(double)longitude radius:(NSInteger)radius callBack:(HLPOIHelperBlock)callBack{
    
    self.callBack = callBack;
    
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeOption.location = CLLocationCoordinate2DMake(latitude, longitude);
    // 是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeOption.isLatestAdmin = YES;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if (flag) {
        NSLog(@"逆geo检索发送成功");
    }  else  {
        NSLog(@"逆geo检索发送失败");
        self.callBack(nil);
    }
}

// 回调 BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    [self handleResult:result.poiList errorCode:error];
}

#pragma mark - 对返回数据的处理

- (void)handleResult:(NSArray <BMKPoiInfo *>*)poiInfoList errorCode:(BMKSearchErrorCode)error{
    
    if (error != BMK_SEARCH_NO_ERROR) {
        self.callBack(nil);
        return;
    }
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (BMKPoiInfo *info in poiInfoList) {
        HLAddressPOIInfo *poiInfo = [HLAddressPOIInfo new];
        poiInfo.select = NO;
        poiInfo.all = info.address;
        poiInfo.detail = info.name;
        poiInfo.province = info.province;
        poiInfo.city = info.city;
        poiInfo.area = info.area;
        poiInfo.latitude = info.pt.latitude;
        poiInfo.longitude = info.pt.longitude;
        
        NSString *name = [self filterAddress:info.name];
        NSString *address = [self filterAddress:info.address];
        
        if ([address containsString:name]) {
            poiInfo.realDetailAddress = [NSString stringWithFormat:@"%@",address];
        }else{
            poiInfo.realDetailAddress = [NSString stringWithFormat:@"%@%@",address,name];
        }
        [mArr addObject:poiInfo];
    }
    
    // 第一个默认选中
    if (mArr.count > 0) {
        HLAddressPOIInfo *firstPoiInfo = mArr.firstObject;
        firstPoiInfo.select = YES;
    }
 
    dispatch_main_async_safe(^{
        if (self.callBack) {
            self.callBack(mArr);
        }
    });
}

/// 去除省市区
- (NSString *)filterAddress:(NSString *)address{
    address = [address stringByReplacingOccurrencesOfString:@"省" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"市" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:self.provinceName?:@"" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:self.cityName?:@"" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:self.areaName?:@"" withString:@""];
    return address;
}

#pragma mark - Getter

- (BMKPoiSearch *)poiSearcher{
    if (!_poiSearcher) {
        _poiSearcher = [[BMKPoiSearch alloc] init];
        _poiSearcher.delegate = self;
    }
    return _poiSearcher;
}

-(BMKGeoCodeSearch *)geoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

@end
