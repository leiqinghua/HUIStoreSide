//
//  RouteAnnotation.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/8/31.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#ifndef RouteAnnotation_h
#define RouteAnnotation_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RouteAnnotation : BMKPointAnnotation

///<0:起点 1：终点 2：小哥位置
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger degree;

//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;

@end


#endif /* RouteAnnotation_h */
