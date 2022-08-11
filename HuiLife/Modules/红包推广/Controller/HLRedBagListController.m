//
//  HLRedBagListController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import "HLRedBagListController.h"
#import "HLRedBagGoodTableCell.h"
#import "HLRedBagAlertController.h"
#import "HLRedBagPromoteController.h"
#import "HLPaySuccessController.h"

@interface HLRedBagListController ()<UITableViewDelegate, UITableViewDataSource, HLRedBagGoodTableCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noDataView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *datasource;
@end

@implementation HLRedBagListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"红包推广"];
    [self hl_setBackImage:@"back_black"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [HLNotifyCenter addObserver:self selector:@selector(reloadPageData) name:HLReloadRedBagDataNotifi object:nil];
    _page = 1;
    [self loadListWithHud:YES];
}

#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SeckillList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"pageNo":@(self.page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handleList:result.data[@"redbags"]];
            return;
        }
        if (self.page >1) --self.page;
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        if (self.page >1) --self.page;
    }];
}

- (void)handleList:(NSArray *)list {
    NSArray *datas = [HLRedBagPromoteInfo mj_objectArrayWithKeyValuesArray:list];
    if (_page ==1) [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:datas];
    [self showNodataView:!self.datasource.count];
    [self.tableView hideFooter:!self.datasource.count];
    if (!datas.count)[self.tableView endNomorData];
    [self.tableView reloadData];
}

//更新状态
- (void)updateWithInfo:(HLRedBagPromoteInfo *)info {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SeckillAction.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"redbagId":info.Id,@"action":@(1-info.state)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            info.state = 1-info.state;
            [self.tableView reloadData];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
#pragma mark - Event
- (void)addClick {
    [HLTools pushAppPageLink:@"HLRedBagAddController" params:@{} needBack:NO];
}

- (void)reloadPageData {
    _page = 1;
    [self loadListWithHud:NO];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.clearColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_redBag_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
         
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无红包推广数据";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    _noDataView.hidden = !show;
}

#pragma mark - HLRedBagGoodTableCellDelegate
- (void)redBagCell:(HLRedBagGoodTableCell *)cell promoteInfo:(HLRedBagPromoteInfo *)info type:(NSInteger)type {
    
    if (type == 0) {
        HLRedBagPromoteController *promoteVC = [[HLRedBagPromoteController alloc]init];
        promoteVC.redBagId = info.Id;
        [self hl_pushToController:promoteVC];
        return;
    }
    
    if (type == 1) {
        HLRedBagAlertController *alertVC = [[HLRedBagAlertController alloc]init];
        alertVC.proId = info.proId;
        alertVC.extendId = info.Id;
        alertVC.hideTime = info.timeType == 0;
        weakify(self);
        alertVC.successBlock = ^(NSString * _Nonnull price) {
            HLPaySuccessController *successVC = [[HLPaySuccessController alloc]init];
            successVC.price = price;
            [weak_self hl_pushToController:successVC];
        };
        [self presentViewController:alertVC animated:NO completion:nil];
        return;
    }
    if (info.state == 2) {
        [HLTools showWithText:@"该红包已结束推广"];
        return;
    }
    [self updateWithInfo:info];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLRedBagGoodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRedBagGoodTableCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.delegate = self;
    cell.info = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    
    CGFloat bottomHeight = FitPTScreen(91);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - bottomHeight)];
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(200);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLRedBagGoodTableCell class] forCellReuseIdentifier:@"HLRedBagGoodTableCell"];
//    //下拉刷新
    [_tableView headerNormalRefreshingBlock:^{
        self.page = 1;
        [self loadListWithHud:NO];
    }];

    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        self.page +=1;
        [self loadListWithHud:NO];
    }];
    [_tableView hideFooter:YES];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds) - bottomHeight, ScreenW,bottomHeight)];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"添加红包推广" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)dealloc {
    [HLNotifyCenter removeObserver:self];
}
@end
