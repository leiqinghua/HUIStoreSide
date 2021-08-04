//
//  HLNavigateViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/26.
//

#import "HLNavigateViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "HLActionSheet.h"
#import "HLLocationManager.h"
#import <MapKit/MapKit.h>
#import "JZLocationConverter.h"
#import "RouteAnnotation.h"

@interface HLNavigateViewController ()<BMKMapViewDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate,WHActionSheetDelegate>{
    BMKRouteSearch *_routeSearch;
    BMKGeoCodeSearch *_codeSearch;
}

@property(nonatomic, strong)BMKMapView *mapView;

@property (strong, nonatomic) NSArray *maps;

@end

@implementation HLNavigateViewController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setBackgroundColor:UIColorFromRGB(0xFF8D26)];
    [self hl_setTitle:@"导航" andTitleColor:UIColor.whiteColor];
    [self hl_hideBack:false];
    [_mapView viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
}

-(void)goBtnClick{
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary *dict in self.maps) {
        [titleArr addObject:dict[@"title"]];
    }
    [HLActionSheet showActionSheetWithDataSource:titleArr  delegate:self];
}

#pragma mark - WHActionSheetDelegate
/// 点击下边弹出
- (void)actionSheet:(WHActionSheet *)actionSheet clickButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self navAppleMap];
        return;
    }
    NSDictionary *dic = self.maps[buttonIndex];
    NSString *urlString = dic[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)navAppleMap{
    //当前的位置
    MKMapItem *current = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D coordinate = [JZLocationConverter bd09ToGcj02:_end];
    //目的地的位置，百度坐标转为苹果自带坐标
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    toLocation.name       = self.address;
    NSArray *items        = [NSArray arrayWithObjects:current, toLocation, nil];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hl_StringToColor:@"#FAFAFA"];
    [self initSubView];
    [[HLLocationManager shared] startLocationWithCallBack:^(BMKLocation *location) {
        if (location) {
            CLLocation *clLocation = location.location;
            self.start = clLocation.coordinate;
            [self initLoacate];
        }
    }];
}

-(void)initLoacate{
    [HLTools startLoadingAnimation];
    _codeSearch = [[BMKGeoCodeSearch alloc] init];
    _codeSearch.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    HLLog(@"address= %@",_address);
    geoCodeSearchOption.address =_address;
    BOOL flag = [_codeSearch geoCode: geoCodeSearchOption];
    if (flag) {
        NSLog(@"geo检索发送成功");
    }  else  {
        NSLog(@"geo检索发送失败");
    }
}


-(void)initSearch{
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.pt = _start;
    
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.pt = _end;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if (flag) {
        HLLog(@"驾车规划检索发送成功");
    } else{
        HLLog(@"驾车规划检索发送失败");
    }
}

-(void)initSubView{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

-(void)initBottomViewWithDistance:(NSString *)distance{
    // 底部视图
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = UIColor.whiteColor;
    bottomView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    bottomView.backgroundColor = UIColor.whiteColor;
    bottomView.layer.shadowOpacity = 0.05f;
    bottomView.layer.shadowOffset = CGSizeMake(0,-4);
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(FitPTScreen(65) + Height_Bottom_Margn);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    // 按钮
    UIButton *goBtn = [[UIButton alloc] init];
    [bottomView addSubview:goBtn];
    [goBtn setBackgroundImage:[UIImage imageNamed:@"carservice_go_bg"] forState:UIControlStateNormal];
    [goBtn setImage:[UIImage imageNamed:@"carservice_go_feiji"] forState:UIControlStateNormal];
    [goBtn setTitle:@"导航" forState:UIControlStateNormal];
    [goBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    goBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [goBtn addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(bottomView);
        make.height.equalTo(FitPTScreen(65));
        make.width.equalTo(FitPTScreen(110));
    }];
    
    UILabel *shopAddressLab = [[UILabel alloc] init];
    shopAddressLab.text = self.address;
    shopAddressLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    shopAddressLab.textColor = UIColorFromRGB(0xA9A9A9);
    [bottomView addSubview:shopAddressLab];
    [shopAddressLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(bottomView);
        make.right.lessThanOrEqualTo(goBtn.left).offset(FitPTScreen(-5) - [HLTools estmateWidthString:distance Font:[UIFont systemFontOfSize:FitPTScreen(12)]]);
        
    }];
    
    // 距离
    UILabel *distanceLab = [[UILabel alloc] init];
    distanceLab.text = distance;
    distanceLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    distanceLab.textColor = UIColorFromRGB(0xA9A9A9);
    [bottomView addSubview:distanceLab];
    [distanceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopAddressLab.right);
        make.centerY.equalTo(shopAddressLab);
    }];
}

//计算距离
-(NSString *)distance{
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_end.latitude longitude:_end.longitude];
    CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:_start.latitude longitude:_start.longitude];
    CLLocationDistance locationDistance = [userLocation distanceFromLocation:shopLocation];
    NSString *distance = [NSString stringWithFormat:@" %.2lfkm",locationDistance/1000];
    return distance;
}

#pragma mark -BMKGeoCodeSearchDelegate

-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    [HLTools endLoadingAnimation];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _end = result.location;
        //路线规划
        [self initSearch];
        
        // 封装几个地图
        self.maps = [self getInstalledMapAppWithEndLocation:_end];
    }
    else {
        [HLTools showWithText:@"配送地址不正确"];
    }
    [self initBottomViewWithDistance:[self distance]];
}

#pragma mark -BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:mapView];
    }
    return nil;
}

// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = UIColorFromRGB(0x68B335);
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}


#pragma mark - BMKRouteSearchDelegate

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    if (error == BMK_SEARCH_NO_ERROR) {
        __block NSUInteger pointCount = 0;
        //获取所有驾车路线中第一条路线
        BMKDrivingRouteLine *routeline = (BMKDrivingRouteLine *)result.routes[0];
        //遍历驾车路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取驾车路线中的每条路段
            BMKDrivingStep *step = routeline.steps[idx];
            if (idx == 0) {
                RouteAnnotation* annotation = [[RouteAnnotation alloc]init];
                annotation.coordinate = routeline.starting.location;
                annotation.title = @"起点";
                annotation.type = 0;
                [self.mapView addAnnotation:annotation];
            }
            
            if (idx == routeline.steps.count - 1) {
                RouteAnnotation* annotation = [[RouteAnnotation alloc]init];
                annotation.coordinate = routeline.terminal.location;
                annotation.title = @"终点";
                annotation.type = 1;
                [self.mapView addAnnotation:annotation];
            }
            pointCount += step.pointsCount;
            
        }];
        
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        __block NSUInteger j = 0;
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BMKDrivingStep *step = routeline.steps[idx];
            for (NSUInteger i = 0; i < step.pointsCount; i ++) {
                points[j].x = step.points[i].x;
                points[j].y = step.points[i].y;
                j ++;
            }
        }];
        //根据指定直角坐标点生成一段折线
        BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointCount];
        [_mapView addOverlay:polyline];
        
        [self mapViewFitPolyline:polyline withMapView:self.mapView];
        
    } else {
        //检索失败
    }
}

//-(void)onGetRidingRouteResult:(BMKRouteSearch*)searcher result:(BMKRidingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
//
//    [_mapView removeOverlays:_mapView.overlays];
//    [_mapView removeAnnotations:_mapView.annotations];
//
//    if (error == BMK_SEARCH_NO_ERROR) {
//        __block NSUInteger pointCount = 0;
//        //获取所有驾车路线中第一条路线
//        BMKRidingRouteLine *routeline = (BMKRidingRouteLine *)result.routes[0];
//        //遍历驾车路线中的所有路段
//        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            //获取驾车路线中的每条路段
//            BMKRidingStep *step = routeline.steps[idx];
//            if (idx == 0) {
//                BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//                annotation.coordinate = step.entrace.location;
//                annotation.title = @"起点";
//                [self.mapView addAnnotation:annotation];
//            }
//
//            if (idx == routeline.steps.count - 1) {
//                BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//                annotation.coordinate = step.entrace.location;
//                annotation.title = @"终点";
//                [self.mapView addAnnotation:annotation];
//            }
//            pointCount += step.pointsCount;
//        }];
//
//        BMKMapPoint *points = new BMKMapPoint[pointCount];
//        __block NSUInteger j = 0;
//        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            BMKRidingStep *step = routeline.steps[idx];
//            for (NSUInteger i = 0; i < step.pointsCount; i ++) {
//                points[j].x = step.points[i].x;
//                points[j].y = step.points[i].y;
//                j ++;
//            }
//        }];
//        //根据指定直角坐标点生成一段折线
//        BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointCount];
//        [_mapView addOverlay:polyline];
//
//        [self mapViewFitPolyline:polyline withMapView:self.mapView];
//
//    } else {
//        //检索失败
//    }
//}


- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation{
    NSMutableArray *maps = [NSMutableArray array];
    //苹果地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]) {
        NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
        iosMapDic[@"title"] = @"苹果地图";
        [maps addObject:iosMapDic];
    }
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name={目的地}&mode=driving",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    CLLocationCoordinate2D coordinate = [JZLocationConverter bd09ToGcj02:endLocation];
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    return maps;
}


//根据polyline设置地图范围
- (void)mapViewFitPolyline:(BMKPolyline *)polyline withMapView:(BMKMapView *)mapView {
    double leftTop_x, leftTop_y, rightBottom_x, rightBottom_y;
    if (polyline.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyline.points[0];
    leftTop_x = pt.x;
    leftTop_y = pt.y;
    //左上方的点lefttop坐标（leftTop_x，leftTop_y）
    rightBottom_x = pt.x;
    rightBottom_y = pt.y;
    for (int i = 1; i < polyline.pointCount; i++) {
        BMKMapPoint point = polyline.points[i];
        if (point.x < leftTop_x) {
            leftTop_x = point.x;
        }
        if (point.x > rightBottom_x) {
            rightBottom_x = point.x;
        }
        if (point.y < leftTop_y) {
            leftTop_y = point.y;
        }
        if (point.y > rightBottom_y) {
            rightBottom_y = point.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTop_x , leftTop_y);
    rect.size = BMKMapSizeMake(rightBottom_x - leftTop_x, rightBottom_y - leftTop_y);
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 20, 10);
    [mapView fitVisibleMapRect:rect edgePadding:padding withAnimated:YES];
}

@end
