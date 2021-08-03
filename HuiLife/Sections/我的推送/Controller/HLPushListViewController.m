//
//  HLPushListViewController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLPushListViewController.h"
#import "HLPushListViewCell.h"
#import "HLPushAddViewController.h"
#import "HLPushHistoryViewController.h"

@interface HLPushListViewController () <UITableViewDelegate,UITableViewDataSource,HLPushListViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *placeView;    // 占位图

@property (nonatomic, assign) NSInteger page;       // page， 默认为1
@property (nonatomic, assign) NSInteger pageSize;   // 默认为10

@end

@implementation HLPushListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _type = -1;
        _pageSize = 10;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xF8F8F8);
    
    [self.view addSubview:self.placeView];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.navigationItem.title = @"我的推送";
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"创建推送"];
    
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
    NSDictionary *params = @{@"pageNo":@(_page),@"type":@(self.type)};
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/list.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = params;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLPushListModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
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
    HLPushAddViewController *addVC = [[HLPushAddViewController alloc] init];
    addVC.addBlock = ^{
        [self reloadListData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - HLPushListViewCellDelegate

- (void)listViewCell:(HLPushListViewCell *)cell stateBtnClick:(HLPushListModel *)model{
    // 0 活动推送  10 审核中 // 15 审核失败
    if (model.state == 10) {
        
    }
    
    else if(model.state == 15){
        HLPushAddViewController *addVC = [[HLPushAddViewController alloc] init];
        addVC.pushId = model.push_id;
        addVC.addBlock = ^{
            [self reloadListData];
        };
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
    else if (model.state == 0){
        HLPushHistoryViewController *history = [[HLPushHistoryViewController alloc] init];
        history.push_id = model.push_id;
        [self.navigationController pushViewController:history animated:YES];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLPushListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLPushListViewCell" forIndexPath:indexPath];
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
        _tableView.estimatedRowHeight = FitPTScreen(260);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(0))];
        [_tableView registerClass:[HLPushListViewCell class] forCellReuseIdentifier:@"HLPushListViewCell"];
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_record_default"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(213));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(93));
            make.height.equalTo(FitPTScreen(72));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无数据";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(13));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end


