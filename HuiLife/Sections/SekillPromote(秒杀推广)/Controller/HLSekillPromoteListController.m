//
//  HLSeillPromoteListController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLSekillPromoteListController.h"
#import "HLSekillPromoteListCell.h"
#import "HLSekillPromoteAddController.h"
#import "HLAlertController.h"

@interface HLSekillPromoteListController () <UITableViewDelegate,UITableViewDataSource,HLSekillPromoteListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page; // page， 默认为1

@property (nonatomic, strong) UIView *placeView; // 占位图

@end

@implementation HLSekillPromoteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self.view addSubview:self.placeView];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"爆款秒杀推广";
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"添加推广秒杀"];
    
    /// 加载数据
    [self loadGoodsList];
}

/// 加载数据
- (void)loadGoodsList{

    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/HotSeckillPopulList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@(_page)};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *models = [HLSekillPromoteListModel mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
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
    self.placeView.hidden = self.dataSource.count > 0;
    self.tableView.hidden = self.dataSource.count == 0;
}

/// 添加
- (void)addButtonClick{
    HLSekillPromoteAddController *addGoods = [[HLSekillPromoteAddController alloc] init];
    addGoods.addBlock = ^{
        self.page = 1;
        [self loadGoodsList];
    };
    [self.navigationController pushViewController:addGoods animated:YES];
}

#pragma mark - HLSekillPromoteListCellDelegate

/// 点击更多
- (void)sekillPromoteCell:(HLSekillPromoteListCell *)cell moreBtnClickListModel:(HLSekillPromoteListModel *)listModel{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HLAlertController *alert = [[HLAlertController alloc] init];
    HLAlertAction *action = [[HLAlertAction alloc] initWithTitle:@"暂停推广" color:UIColorFromRGB(0xFF8E16) completion:^{
        //
        HLLoading(self.view);
        [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
            request.api = @"/MerchantSide/HotSeckillPopulStop.php";
            request.serverType = HLServerTypeNormal;
            request.parameters = @{@"proId":listModel.Id};
        } onSuccess:^(XMResult *  _Nullable responseObject) {
            HLHideLoading(self.view);
            if ([responseObject code] == 200) {
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } onFailure:^(NSError * _Nullable error) {
            HLHideLoading(self.view);
        }];
    }];
    [alert addActions:@[action]];
    [self presentViewController:alert animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLSekillPromoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSekillPromoteListCell" forIndexPath:indexPath];
    cell.listModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLSekillPromoteListModel *listModel = self.dataSource[indexPath.row];
    HLSekillPromoteAddController *addGoods = [[HLSekillPromoteAddController alloc] init];
    addGoods.listModel = listModel;
    addGoods.addBlock = ^{
        self.page = 1;
        [self loadGoodsList];
    };
    [self.navigationController pushViewController:addGoods animated:YES];}

/// 构建底部的view
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(134);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(18))];
        [_tableView registerClass:[HLSekillPromoteListCell class] forCellReuseIdentifier:@"HLSekillPromoteListCell"];
        
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
        tipLab.text = @"暂无秒杀商品进行推广";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(13));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
