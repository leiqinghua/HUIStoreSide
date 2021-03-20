//
//  HLNavigateViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/26.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface HLNavigateViewController : HLBaseViewController

@property(assign,nonatomic)CLLocationCoordinate2D start;

@property(assign,nonatomic)CLLocationCoordinate2D end;

@property(copy,nonatomic)NSString * address;

@end

