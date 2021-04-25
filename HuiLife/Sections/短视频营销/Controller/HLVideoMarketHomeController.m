//
//  HLVideoMarketHomeController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketHomeController.h"
#import "HLVideoMarketListCell.h"
#import "HLVideoMarketAddController.h"
#import "HLVideoMarketPlayController.h"

@interface HLVideoMarketHomeController () <UITableViewDelegate,UITableViewDataSource,HLVideoMarketListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *placeView;    // 占位图

@property (nonatomic, assign) NSInteger page;       // page， 默认为1
@property (nonatomic, assign) NSInteger pageSize;   // 默认为10

@property (nonatomic, strong) UIView *reasonView;   // 驳回原因展示视图
@property (nonatomic, strong) UILabel *reasonLab;   // 驳回原因

@end

@implementation HLVideoMarketHomeController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _pageSize = 10;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.view addSubview:self.placeView];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"短视频营销";
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"创建短视频"];
    
    /// 加载数据
    [self reloadListData];
    
}

#pragma mark - Private Method

// 重新加载页面数据，page置为1
- (void)reloadListData{
    self.page = 1;
    [self loadVideoMarketList:YES];
}

// 加载数据
- (void)loadVideoMarketList:(BOOL)showHud{
        
    if (showHud) {
        HLLoading(self.view);
    }
    NSDictionary *params = @{@"pageNo":@(_page)};
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/sortVideo/list.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLVideoMarketModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            [self handleBuyGoodsModels:models];
        }else{
            self.page > 1 ? 1 : --self.page;
        }
    } onFailure:^(NSError * _Nullable error) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        self.page > 1 ? 1 : --self.page;
    }];
}

/// 处理数据
- (void)handleBuyGoodsModels:(NSArray *)models{
    
    [self.tableView.mj_header endRefreshing];
    
    // 如果是第一页
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (models.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.dataSource addObjectsFromArray:models];
    [self.tableView reloadData];
    
    self.tableView.hidden = self.dataSource.count == 0;
    self.placeView.hidden = self.dataSource.count > 0;
    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
}

/// 添加
- (void)addButtonClick{
    HLVideoMarketAddController *addVC = [[HLVideoMarketAddController alloc] init];
    addVC.addBlock = ^{
        [self reloadListData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

/// 隐藏理由视图
- (void)hideReasonView{
    [self.reasonView removeFromSuperview];
}

#pragma mark - HLVideoMarketListCellDelegate

/// 上下架
- (void)marketListCell:(HLVideoMarketListCell *)cell controlClickWithModel:(HLVideoMarketModel *)model{
    NSInteger state = 0;
    if (model.state ==  0) {
        state = 1;
    }
    HLLoading(self.view);
    NSDictionary *params = @{@"video_id":model.id,@"state":@(state)};
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/sortVideo/change.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            model.state = state;
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 编辑
- (void)marketListCell:(HLVideoMarketListCell *)cell editClickWithModel:(HLVideoMarketModel *)model{
    HLVideoMarketAddController *addVC = [[HLVideoMarketAddController alloc] init];
    addVC.marketModel = model;
    addVC.addBlock = ^{
        [self reloadListData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

/// 展示驳回的原因
- (void)marketListCell:(HLVideoMarketListCell *)cell reasonClickWithModel:(HLVideoMarketModel *)model{
    [self.view addSubview:self.reasonView];
    self.reasonLab.text = model.reason;
}

/// 播放
- (void)marketListCell:(HLVideoMarketListCell *)cell playClickWithModel:(HLVideoMarketModel *)model{
    HLVideoMarketPlayController *playManager = [[HLVideoMarketPlayController alloc] initWithVideoUrl:model.videoUrl preImgUrl:model.pic];
    playManager.marketModel = model;
    [self.navigationController pushViewController:playManager animated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLVideoMarketListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLVideoMarketListCell" forIndexPath:indexPath];
    cell.listModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
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
     

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorFromRGB(0xEDEDED);
        _tableView.rowHeight = FitPTScreen(184);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(10))];
        [_tableView registerClass:[HLVideoMarketListCell class] forCellReuseIdentifier:@"HLVideoMarketListCell"];
        weakify(self);
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.page = 1;
            [weak_self loadVideoMarketList:NO];
        }];
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        
        _tableView.mj_header = mj_header;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.page++;
            [weak_self loadVideoMarketList:NO];
        }];
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

- (UIView *)placeView{
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _placeView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_sekill_place"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(213));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(93));
            make.height.equalTo(FitPTScreen(72));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无短视频营销数据";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(13));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

- (UIView *)reasonView{
    if (!_reasonView) {
        
        _reasonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _reasonView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        
        CGFloat contentWidth = FitPTScreen(260);
        CGFloat contentHeight = FitPTScreen(160);
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake((ScreenW - contentWidth)/2, (ScreenH - contentHeight)/2, contentWidth, contentHeight)];
        contentV.backgroundColor = UIColor.whiteColor;
        contentV.layer.cornerRadius = FitPTScreen(10);
        contentV.layer.masksToBounds = YES;
        [_reasonView addSubview:contentV];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [contentV addSubview:tipLab];
        tipLab.text = @"驳回说明";
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(FitPTScreen(0));
            make.height.equalTo(FitPTScreen(45));
        }];
        
        UIButton *okBtn = [[UIButton alloc] init];
        [contentV addSubview:okBtn];
        [okBtn setTitle:@"知道了" forState:UIControlStateNormal];
        okBtn.backgroundColor = UIColorFromRGB(0xFF9900);
        [okBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [okBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(0);
            make.height.equalTo(FitPTScreen(45));
        }];
        [okBtn addTarget:self action:@selector(hideReasonView) forControlEvents:UIControlEventTouchUpInside];
        
        self.reasonLab = [[UILabel alloc] init];
        [contentV addSubview:self.reasonLab];
        self.reasonLab.textColor = UIColorFromRGB(0x333333);
        self.reasonLab.numberOfLines = 3;
        self.reasonLab.textAlignment = NSTextAlignmentCenter;
        self.reasonLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [self.reasonLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLab.bottom).offset(FitPTScreen(0));
            make.left.equalTo(FitPTScreen(12));
            make.right.equalTo(FitPTScreen(-12));
            make.bottom.equalTo(okBtn.top).offset(FitPTScreen(-13));
        }];
    }
    return _reasonView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end


