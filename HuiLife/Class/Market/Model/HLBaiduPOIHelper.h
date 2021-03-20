//
//  HLBaiduPOIHelper.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/12/24.
//  Copyright © 2018 wce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAddressPOIInfo.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h> // 引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>

typedef void(^HLPOIHelperBlock)(NSArray <HLAddressPOIInfo *> *poiList);

NS_ASSUME_NONNULL_BEGIN

@interface HLBaiduPOIHelper : NSObject

/// 配置过滤的省市区
- (void)configProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName;

// 根据关键字检索poi信息
- (void)startPOISearchWithCityName:(NSString *)cityName keyWord:(NSString *)keyWord page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize callBack:(HLPOIHelperBlock)callBack;

/// 根据经纬度检索周边poi信息
- (void)startReverseGeoCodeWithLat:(double)latitude long:(double)longitude radius:(NSInteger)radius callBack:(HLPOIHelperBlock)callBack;

@end

NS_ASSUME_NONNULL_END
