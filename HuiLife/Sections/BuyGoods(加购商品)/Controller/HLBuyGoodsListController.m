//
//  HLBuyGoodsListController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBuyGoodsListController.h"
#import "HLAlertController.h"
#import "HLBottomControlView.h"
#import "HLBuyGoodAddController.h"
#import "HLBuyGoodListCell.h"
#import "HLDownSelectView.h"

@interface HLBuyGoodsListController () <UITableViewDelegate, UITableViewDataSource, HLBuyGoodListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page; // page， 默认为1

@property (nonatomic, strong) UIView *placeView; // 占位图

@end

@implementation HLBuyGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self.view addSubview:self.placeView];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"买单加购商品";
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"添加加购商品"];
    
    /// 加载数据
    [self loadGoodsList];
    
    /// 注册加载成功之后的回调
    [HLNotifyCenter addObserver:self selector:@selector(reloadListData) name:@"buyGoodListReloadData" object:nil];
}

- (void)reloadListData {
    // 重新拉取第一页的数据
    self.page = 1;
    [self loadGoodsList];
}

/// 加载数据
- (void)loadGoodsList {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
        request.api = @"/Shopplus/Billpurchased/purchasedList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{ @"page": @(_page) };
    }
                onSuccess:^(XMResult *_Nullable responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLBuyGoodListModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            [self handleBuyGoodsModels:models];
        } else {
            self.page > 1 ? 1 : --self.page;
        }
    }
                onFailure:^(NSError *_Nullable error) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        self.page > 1 ? 1 : --self.page;
    }];
}

/// 处理数据
- (void)handleBuyGoodsModels:(NSArray *)models {
    [self.tableView.mj_header endRefreshing];
    
    // 如果是第一页
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (models.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.dataSource addObjectsFromArray:models];
    [self.tableView reloadData];
    self.tableView.hidden = self.dataSource.count == 0;
    self.placeView.hidden = self.dataSource.count > 0;
    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
}

/// 添加
- (void)addButtonClick {
    HLBuyGoodAddController *addGoods = [[HLBuyGoodAddController alloc] init];
    [self.navigationController pushViewController:addGoods animated:YES];
}

#pragma mark - HLBuyGoodListCellDelegate

/// 显示底部view
- (void)listCell:(HLBuyGoodListCell *)cell controlGoodModel:(HLBuyGoodListModel *)goodModel {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *stateTitle = goodModel.status == 0 ? @"上架" : @"下架";
    
    HLAlertController *alert = [[HLAlertController alloc] init];
    HLAlertAction *action = [[HLAlertAction alloc] initWithTitle:stateTitle
                                                           color:UIColorFromRGB(0xFF8604)
                                                      completion:^{
        //
        HLLoading(self.view);
        NSInteger status = goodModel.status == 0 ? 1 : 0;
        [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
            request.api = @"/Shopplus/Billpurchased/upAndDown";
            request.serverType = HLServerTypeStoreService;
            request.parameters = @{ @"goodsId": goodModel.goodsId,
                                    @"status": @(status) };
        }
                    onSuccess:^(XMResult *_Nullable responseObject) {
            HLHideLoading(self.view);
            
            if ([responseObject code] == 200) {
                goodModel.stateTitle = responseObject.data[@"stateTitle"];
                goodModel.state = [responseObject.data[@"state"] integerValue];
                goodModel.status = [responseObject.data[@"status"] integerValue];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
                    onFailure:^(NSError *_Nullable error) {
            HLHideLoading(self.view);
        }];
    }];
    [alert addActions:@[action]];
    [self presentViewController:alert animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBuyGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLBuyGoodListCell" forIndexPath:indexPath];
    cell.goodModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(91));
    
    // 加按钮
    UIButton *addButton = [[UIButton alloc] init];
    [footView addSubview:addButton];
    [addButton setTitle:title forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [addButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(134);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(10))];
        [_tableView registerClass:[HLBuyGoodListCell class] forCellReuseIdentifier:@"HLBuyGoodListCell"];
        weakify(self);
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.page = 1;
            [weak_self loadGoodsList];
        }];
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        
        _tableView.mj_header = mj_header;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.page++;
            [weak_self loadGoodsList];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

- (UIView *)placeView {
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _placeView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_buy_bgplace"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(172));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(99));
            make.height.equalTo(FitPTScreen(66));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无进行中加购商品";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(13));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
