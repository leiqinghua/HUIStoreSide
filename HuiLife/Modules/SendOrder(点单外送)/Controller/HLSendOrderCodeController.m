//
//  HLSendOrderCodeController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderCodeController.h"
#import "HLSendOrderCodeListCell.h"
#import "HLSendOrderCodeAddController.h"

@interface HLSendOrderCodeController () <UITableViewDelegate,UITableViewDataSource,HLSendOrderCodeListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *placeView; // 占位图

@property (nonatomic, assign) NSInteger page;

@end

@implementation HLSendOrderCodeController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点单牌管理";
    
    [self.view addSubview:self.placeView];
    
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"添加桌号"];
    
    // 加载数据
    [self loadData];
}

/// 加载数据
- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/TableNumberList.php";
        request.parameters = @{@"type":self.type,@"page":@(self.page)};
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            NSArray *models = [HLSendOrderCodeInfo mj_objectArrayWithKeyValuesArray:[XMResult dataDict:responseObject][@"list"]];
            [self handleDataModels:models];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 处理数据
- (void)handleDataModels:(NSArray *)models{
    
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

/// 添加按钮
- (void)addButtonClick{
    HLSendOrderCodeAddController *add = [[HLSendOrderCodeAddController alloc] init];
    add.type = self.type;
    add.addBlock = ^{
        self.page = 1;
        [self loadData];
    };
    [self.navigationController pushViewController:add animated:YES];
}

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

#pragma mark - HLSendOrderCodeListCellDelegate

/// 编辑
-(void)listCell:(HLSendOrderCodeListCell *)cell editCodeInfo:(HLSendOrderCodeInfo *)codeInfo{
    HLSendOrderCodeAddController *add = [[HLSendOrderCodeAddController alloc] init];
    add.tableId = codeInfo.tableId;
    add.type = self.type;
    add.addBlock = ^{
        self.page = 1;
        [self loadData];
    };
    [self.navigationController pushViewController:add animated:YES];
}

/// 删除
- (void)listCell:(HLSendOrderCodeListCell *)cell delCodeInfo:(HLSendOrderCodeInfo *)codeInfo{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"确定删除吗？" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x666666),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
        if (index == 1) {
            HLLoading(self.view);
            [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
                request.serverType = HLServerTypeNormal;
                request.api = @"/MerchantSideA/TableNumberInfoDel.php";
                request.parameters = @{@"tableId":codeInfo.tableId,@"type":self.type};
            } onSuccess:^(id  _Nullable responseObject) {
                HLHideLoading(self.view);
                
                if ([(XMResult *)responseObject code] == 200) {
                    HLShowHint(@"删除成功", self.view);
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    // 判断是否需要展示空页面
                    self.tableView.hidden = self.dataSource.count == 0;
                    self.placeView.hidden = self.dataSource.count > 0;
                    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
                }
            } onFailure:^(NSError * _Nullable error) {
                HLHideLoading(self.view);
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLSendOrderCodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLSendOrderCodeListCell" forIndexPath:indexPath];
    cell.codeInfo = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLSendOrderCodeInfo *codeInfo = self.dataSource[indexPath.row];
    return codeInfo.cellHeight;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(210);
        [_tableView registerClass:[HLSendOrderCodeListCell class] forCellReuseIdentifier:@"HLSendOrderCodeListCell"];
        
        weakify(self);
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.page = 1;
            [weak_self loadData];
        }];
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        
        _tableView.mj_header = mj_header;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.page++;
            [weak_self loadData];
        }];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)placeView{
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _placeView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_order_default"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(178));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(104));
            make.height.equalTo(FitPTScreen(71));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无点单牌";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(18));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}


@end
