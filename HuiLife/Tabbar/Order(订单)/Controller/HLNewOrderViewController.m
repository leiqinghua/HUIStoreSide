//
//  HLNewOrderViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/14.
//

#import "HLNewOrderViewController.h"
//#import "HLNewOrderSubViewController.h"
#import "HLSubOrderController.h"
#import "HLShowCalenderView.h"
#import "HLNewSearchViewController.h"
#import "HLRefundViewController.h"
#import "HLOrderTitleView.h"
#import "HLFilterView.h"
#import "MMScanViewController.h"

#define SELECT_VIEW_W 80.0
#define BOTTOM_VIEW_H 74.0

@interface HLNewOrderViewController ()<UIScrollViewDelegate,HLOrderTitleViewDelegate>

@property(strong,nonatomic)UIView * titleView;

@property(strong,nonatomic)UIView * tabBarView;
//选择时间
@property (strong,nonatomic)UIButton * titleButton;

@property (strong,nonatomic)UILabel * titleLable;

@property (strong,nonatomic)NSArray * titles;

//底部滚动的scrollview
@property (strong,nonatomic)UIScrollView * bottomScrollView;

@property(strong,nonatomic)NSMutableArray * subControllers;

@property(strong,nonatomic)HLOrderTitleView * orderTitleView;

@property(copy,nonatomic)NSString * date;
//所有的日期
@property(strong,nonatomic)NSMutableArray * searchDates;
//收益筛选
@property(nonatomic, strong) NSMutableArray *profits;

//选择的日期(年月日)
@property(strong,nonatomic)NSArray * selectDates;
//当前选择的所有item,本来为了每个分组都可以选择，现在是全部单选，只能选一个条件
@property(strong,nonatomic)NSArray * selectItems;

@end

@implementation HLNewOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _titleView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarController *rootVC = [HLTools rootViewController];
    rootVC.clickOrder = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    _titleView.hidden = YES;
}

//更新每一页的数据
- (void)hl_resetNetworkForAction {
    [super hl_resetNetworkForAction];
    for (HLSubOrderController* sub in self.subControllers) {
        HLFilterModel * model = self.selectItems.firstObject;
        [sub reloadDataWithDates:self.selectDates tag:model.Id.integerValue];
    }
}

#pragma mark - Request
//扫一扫
- (void)scanOrderWithUrl:(NSString *)url {
    MMScanViewController *topScanVC = (MMScanViewController *)self.navigationController.topViewController;
    HLLoading(topScanVC.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessScan.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"url":url};
    } onSuccess:^(id responseObject) {
        HLHideLoading(topScanVC.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLTools pushAppPageLink:result.data[@"iosAddress"] params:result.data[@"iosParam"] needBack:false];
            NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
            [controllers removeObject:topScanVC];
            [self.navigationController setViewControllers:controllers];
            return;
        }
        [topScanVC restartScan];
    } onFailure:^(NSError *error) {
        HLHideLoading(topScanVC.view);
        [topScanVC restartScan];
    }];
}

//请求筛选数据
- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/OrderSearchDateTag.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleDataWithModel:result];
            return;
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithModel:(XMResult*)result {
    [self.searchDates removeAllObjects];
    [self.profits removeAllObjects];
    
    NSArray *dates = (NSArray *)result.data;
    NSArray *profits = result.profit;
    
    //    快捷筛选
    for (NSDictionary * dateDict in dates) {
        HLFilterModel *filterModel = [[HLFilterModel alloc]init];
        filterModel.title = dateDict[@"val"];
        filterModel.Id = dateDict[@"key"];
        [self.searchDates addObject:filterModel];
        //        设置选中状态
        //1、默认选中’今天订单‘
        if (!self.selectItems.count && !self.selectDates.count && filterModel.Id.integerValue == 2) {
            filterModel.selected = YES;
        } else if (self.selectItems.count) {
            HLFilterModel *selectInfo = self.selectItems.firstObject;
            if (filterModel.Id.integerValue == selectInfo.Id.integerValue) {
                filterModel.selected = YES;
            }
        }
    }
    
    //    收益筛选
    for (NSDictionary *profit in profits) {
        HLFilterModel *filterModel = [[HLFilterModel alloc]init];
        filterModel.title = profit[@"val"];
        filterModel.Id = profit[@"key"];
        [self.profits addObject:filterModel];
        if (self.selectItems.count ) {
            HLFilterModel *selectInfo = self.selectItems.firstObject;
            if (filterModel.Id.integerValue == selectInfo.Id.integerValue) {
                filterModel.selected = YES;
            }
        }
    }
    
    //    展示遮挡层
    [self tabBarViewWithShow:_titleButton.selected];
    
    //    展示筛选框
    [HLFilterView showSelectViewWithSectionTitles:@[@"快捷筛选",@"收益筛选",@"按日期筛选"] dataSource:[self selectModels] dates:self.selectDates callBack:^(NSInteger clickIndex, NSArray *dates, NSArray *selectItems) {
        if (clickIndex == 1) {
            self.titleButton.selected = NO;
            self.selectDates = dates;
            self.selectItems = selectItems;
            [self configerTitle];
            [self hl_resetNetworkForAction];
            [self tabBarViewWithShow:self.titleButton.selected];
        }
    }];
}

#pragma mark - Method
- (NSArray *)selectModels{
    NSMutableArray * modelArr = [NSMutableArray array];
    [modelArr addObject:self.searchDates?:@[]];
    [modelArr addObject:self.profits];
    return modelArr;
}

- (void)tabBarViewWithShow:(BOOL)show{
    if (show && !_tabBarView) {
        _tabBarView = [[UIView alloc]init];
        _tabBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [KEY_WINDOW addSubview:_tabBarView];
        [_tabBarView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.width.equalTo(KEY_WINDOW);
            make.height.equalTo(Height_TabBar);
        }];
    }
    
    if (show) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.tabBarView removeFromSuperview];
    }];
}

- (void)configerTitle{
    if ([self.selectItems hl_isAvailable]) {
        HLFilterModel * model = self.selectItems.firstObject;
        [_titleButton setTitle:[NSString stringWithFormat:@"  %@",model.title] forState:UIControlStateNormal];
        return;
    }
    NSString * begin = self.selectDates.firstObject;
    NSString * end = self.selectDates.lastObject;
    NSMutableString * title = [NSMutableString string];
    if ([begin hl_isAvailable]) {
        [title appendString:begin];
    }
    if ([begin hl_isAvailable] && [end hl_isAvailable]) {
        [title appendFormat:@"至%@",end];
    }else if (![begin hl_isAvailable] && [end hl_isAvailable]){
        [title appendFormat:@"%@",end];
    }
    if (![title hl_isAvailable]) {
        [_titleButton setTitle:@"  今天订单" forState:UIControlStateNormal];
        return;
    }
    [_titleButton setTitle:[NSString stringWithFormat:@"  %@",title] forState:UIControlStateNormal];
}

#pragma mark - Event
- (void)titleButtonClick:(UIButton *)sender{
    _titleButton.selected = !_titleButton.selected;
    [_titleButton layoutIfNeeded];
    if (!_titleButton.selected) {
        [HLFilterView remove];
        [self tabBarViewWithShow:_titleButton.selected];
        return;
    }
    [self loadData];
    
}

- (void)searchBtnClick:(UIButton *)sender {
    HLNewSearchViewController * search = [[HLNewSearchViewController alloc] init];
    [self hl_pushToController:search];
    if (self.titleButton.selected) {
        [self titleButtonClick:_titleButton];
    }
}

//离店收益 或 本店收益
- (void)configStoreProfitData {
    HLFilterModel *selectInfo = [[HLFilterModel alloc]init];
    selectInfo.title = _profitDict[@"title"];
    selectInfo.Id = _profitDict[@"type"];
    self.selectItems = @[selectInfo];
    self.selectDates = @[];
    [self configerTitle];
    [self hl_resetNetworkForAction];
    //    默认选中 已完成
    [_orderTitleView setSelectIndex:2];
}

/// 扫一扫
/// @param sender 按钮
- (void)scanBtnClick:(UIButton *)sender {
    
    weakify(self);
    MMScanViewController *scan = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        [weak_self scanOrderWithUrl:result];
    }];
    [self.navigationController pushViewController:scan animated:YES];

}

- (void)changeTitleNumbers:(NSNotification *)sender {
    NSArray * nums = sender.object;
    [_orderTitleView configerNumbers:nums];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFFF2F2F2);
    [self initNaviBarItem];
    [self initTopView];
    [self initBottomScrollView];
    if (_profitDict) {
        [self configStoreProfitData];
    } else {
//        默认选中第一个
        [_orderTitleView setSelectIndex:0];
    }
    [HLNotifyCenter addObserver:self selector:@selector(changeTitleNumbers:) name:HLNewOrderTitleNumsNotifi object:nil];
}

#pragma mark - HLOrderTitleViewDelegate
- (void)headView:(HLOrderTitleView *)headView selectItem:(UIButton *)selectBtn{
    NSInteger count = selectBtn.tag;
    [_bottomScrollView setContentOffset:CGPointMake(count* ScreenW, 0) animated:YES];
    HLSubOrderController * sub =self.subControllers[count];
    [sub loadList];
}

#pragma mark - UIScrollViewDelegate

- (void)setOffsetForTipScroll{
    [_orderTitleView setSelectIndex:[self currentPage]];
}

- (NSInteger)currentPage{
    CGFloat offsetX = _bottomScrollView.contentOffset.x;
    NSInteger page = offsetX / ScreenW;
    return page;
}

//停止滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    HLSubOrderController *sub =self.subControllers[[self currentPage]];
    [sub loadList];
    [self setOffsetForTipScroll];
}

#pragma mark - UIView
- (void)initNaviBarItem{
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.titleView = _titleView;
    
    _titleButton = [[UIButton alloc]init];
    [_titleButton setTitle:@"  今天订单" forState:UIControlStateNormal];
    [_titleButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [_titleButton setImage:[UIImage imageNamed:@"arrow_down_darkBlack"] forState:UIControlStateNormal];
    [_titleButton setImage:[UIImage imageNamed:@"arrow_up_black"] forState:UIControlStateSelected];
    [_titleView addSubview:_titleButton];
    [_titleButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(_titleView);
    }];
    [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(17), FitPTScreen(17))];
    [searchBtn setImage:[UIImage imageNamed:@"search_black"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search_black"] forState:UIControlStateHighlighted];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * scanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(17), FitPTScreen(17))];
    [scanBtn setImage:[UIImage imageNamed:@"scan_scan"] forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"scan_scan"] forState:UIControlStateHighlighted];
    UIBarButtonItem * scanItem = [[UIBarButtonItem alloc]initWithCustomView:scanBtn];
    [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 20;
    
    self.navigationItem.rightBarButtonItems = @[searchItem,spaceItem,scanItem];
}

- (void)initTopView{
    _orderTitleView = [[HLOrderTitleView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(BOTTOM_VIEW_H)) titles:self.titles];
    _orderTitleView.backgroundColor = UIColor.whiteColor;
    _orderTitleView.delegate = self;
    [self.view addSubview:_orderTitleView];
}

- (void)initBottomScrollView{
    CGFloat hight = ScreenH-(Height_NavBar + FitPTScreen(BOTTOM_VIEW_H))- Height_TabBar;
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar + FitPTScreen(BOTTOM_VIEW_H), ScreenW, hight)];
    _bottomScrollView.contentSize = CGSizeMake(ScreenW * self.titles.count, 0);
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.delegate = self;
    [self.view addSubview:_bottomScrollView];
    
    for (int i = 0; i<self.titles.count; i++) {
        HLSubOrderController * sub = [[HLSubOrderController alloc]init];
        sub.type = i;
        sub.view.frame = CGRectMake(i*ScreenW, 0, ScreenW, _bottomScrollView.bounds.size.height);
        [sub updateFrame:CGRectMake(i*ScreenW, 0, ScreenW, _bottomScrollView.bounds.size.height)];
        [_bottomScrollView addSubview:sub.view];
        [self.subControllers addObject:sub];
    }
}

#pragma mark - SET & GET
-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"待处理",@"配送中",@"已完成",@"退款",@"未使用"];
    }
    return _titles;
}

- (NSMutableArray *)subControllers{
    if (!_subControllers) {
        _subControllers = [NSMutableArray array];
    }
    return _subControllers;
}

- (NSMutableArray *)searchDates{
    if (!_searchDates) {
        _searchDates = [NSMutableArray array];
    }
    return _searchDates;
}

- (NSMutableArray *)profits {
    if (!_profits) {
        _profits = [NSMutableArray array];
    }
    return _profits;
}

- (void)dealloc{
    [HLNotifyCenter removeObserver:self];
}

@end
