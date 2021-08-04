//
//  HLLocationViewController.m
//  HuiLife
//
//  Created by 王策 on 2019/9/29.
//

#import "HLLocationViewController.h"
#import "HLAddressSearchView.h"
#import "HLAddressListCell.h"
#import "HLBaiduPOIHelper.h"

@interface HLLocationViewController () <UITableViewDelegate,UITableViewDataSource,HLAddressSearchViewDelegate,UIScrollViewDelegate>
{
    double _latitude;
    double _longitude;
    NSString *_province;
    NSString *_city;
    NSString *_area;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, strong) HLAddressSearchView *searchView;

@property (nonatomic, strong) HLBaiduPOIHelper *poiHelper;

@property (nonatomic, copy) NSArray *firstLoadData;

@property (nonatomic, strong) UIView *placeView;

@property (nonatomic, copy) NSString *keyWord;

@end

@implementation HLLocationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"选择店铺地址" andTitleColor:UIColorFromRGB(0x333333)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
    [self firstLoadAddressList];
}

// 右上角刷新
- (void)refreshControlClick{
    NSString *searchWord = [self.searchView inputText];
    if (searchWord.length) {
        HLLoading(self.view);
        [self loadAddressListWithKeyWord:searchWord];
    }else{
        [self firstLoadAddressList];
    }
}

// 第一次加载数据
- (void)firstLoadAddressList{
    
    HLLoading(self.view);
    [[HLLocationManager shared] startLocationWithCallBack:^(BMKLocation *location) {
        CLLocation *clLocation = location.location;
        _latitude = clLocation.coordinate.latitude;
        _longitude = clLocation.coordinate.longitude;
        
        _province = location.rgcData.province;
        _city = location.rgcData.city;
        _area = location.rgcData.district;
        
        NSString *provinceName = [_province stringByReplacingOccurrencesOfString:@"省" withString:@""];
        NSString *cityName = [_city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        NSString *districtName = _area;

        weakify(self);
        [self.poiHelper configProvinceName:provinceName cityName:cityName areaName:districtName];
        
        [self.poiHelper startReverseGeoCodeWithLat:_latitude long:_longitude radius:10000 callBack:^(NSArray<HLAddressPOIInfo *> *poiList) {
            HLHideLoading(weak_self.view);
            weak_self.firstLoadData = poiList;
            [weak_self handelAddressList:poiList];
            
            weak_self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"address_refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:weak_self action:@selector(refreshControlClick)];

        }];
    }];
}

// 根据关键字获取数据
- (void)loadAddressListWithKeyWord:(NSString *)keyWord{
    self.keyWord = keyWord;
    weakify(self);
    [self.poiHelper startPOISearchWithCityName:_city keyWord:keyWord page:1 pageSize:20 callBack:^(NSArray<HLAddressPOIInfo *> *poiList) {
        [weak_self handelAddressList:poiList];
        HLHideLoading(weak_self.view);
        weak_self.tableView.backgroundView = poiList.count ? nil : self.placeView;
    }];
}

// 处理数据
- (void)handelAddressList:(NSArray *)poiList{
    self.dataSource = poiList;
    [self.tableView reloadData];
}

// 创建视图
- (void)creatSubViews{
    
    _searchView = [[HLAddressSearchView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(50))];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchView.frame),ScreenW, ScreenH - Height_NavBar - CGRectGetHeight(_searchView.frame))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = FitPTScreen(65);
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[HLAddressListCell class] forCellReuseIdentifier:@"HLAddressListCell"];
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
}

#pragma mark - HLAddressSearchViewDelegate

- (void)searchView:(HLAddressSearchView *)searchView editChanged:(NSString *)inputText canSearch:(BOOL)canSearch{

    if (inputText.length == 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadAddressListWithKeyWord:) object:nil];
        self.keyWord = @"";
        self.tableView.backgroundView = nil;
        self.dataSource = self.firstLoadData;
        [self.tableView reloadData];
    }else if(canSearch){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadAddressListWithKeyWord:) object:nil];
            // 0.5秒后调用搜索方法
        [self performSelector:@selector(loadAddressListWithKeyWord:) withObject:inputText afterDelay:0.2];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLAddressListCell" forIndexPath:indexPath];
    cell.poiInfo = self.dataSource[indexPath.row];
    cell.keyWord = self.keyWord;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HLAddressPOIInfo *info = self.dataSource[indexPath.row];
    if (self.locationBlock) {
        self.locationBlock(info.latitude?:_latitude, info.longitude?:_longitude, info.province?:_province, info.city?:_city, info.area?:_area, info.realDetailAddress);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (HLBaiduPOIHelper *)poiHelper{
    if (!_poiHelper) {
        _poiHelper = [[HLBaiduPOIHelper alloc] init];
    }
    return _poiHelper;
}

-(UIView *)placeView{
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:self.tableView.frame];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_address_default"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(129));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(104));
            make.height.equalTo(FitPTScreen(71));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无匹配到关键字";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(19));
            make.centerX.equalTo(_placeView);
        }];
        
    }
    return _placeView;
}

@end
