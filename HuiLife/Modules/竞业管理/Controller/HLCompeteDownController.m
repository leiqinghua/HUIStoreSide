//
//  HLCompeteDownController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
//

#import "HLCompeteDownController.h"
#import "HLCompeteBaseTableCell.h"
#import "HLCompeteStoreInfo.h"

@interface HLCompeteDownController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) UIView *noDataView;
@end

@implementation HLCompeteDownController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self loadListWithHud:YES];
    //上架页面通知 本页面 增加对应店铺
    [HLNotifyCenter addObserver:self selector:@selector(updateDownStateNotifi:) name:@"KcompeteDownReloadNotifi" object:nil];
    // 搜索 通知本页面 删除对应 店铺
    [HLNotifyCenter addObserver:self selector:@selector(upReloadDataNotifi:) name:@"KupReloadDataNotifi" object:nil];
}


#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    HLAccount *account = [HLAccount shared];
    NSDictionary *pargram = @{
        @"big_id":@"0",
        @"pageNo"  : @(_page),
        @"latitude":account.latitude?:@"",
        @"longitude": account.longitude?:@"",
        @"location" : account.locateJSON
    };
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handPageList:result.data[@"stores"]];
            return;
        }
        if (self.page > 1) --self.page;
    }onFailure:^(NSError *error) {
        [self.tableView endRefresh];
        HLHideLoading(self.view);
        if (self.page > 1) --self.page;
    }];
}

- (void)handPageList:(NSArray *)list {
    NSArray *stores = [HLCompeteStoreInfo mj_objectArrayWithKeyValuesArray:list];
    if (_page == 1) {
        [self.datasource removeAllObjects];
    }
    [self.datasource addObjectsFromArray:stores];
    [self.tableView reloadData];
    [self showNodataView:!self.datasource.count];
    if (!stores.count) {
        [_tableView endNomorData];
    }
    [_tableView hideFooter:!self.datasource.count];
}

//更新
- (void)updateWithStoreInfo:(HLCompeteStoreInfo *)storeInfo{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"store_id":storeInfo.store_id,@"action":storeInfo.state==1?@(1):@(2)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            storeInfo.state = 1-storeInfo.state;
            [HLNotifyCenter postNotificationName:@"KupdateCompeteUpNotifi" object:storeInfo];
            [self.datasource removeObject:storeInfo];
            [self.tableView reloadData];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - Event
- (void)updateDownStateNotifi:(NSNotification *)sender {
    HLCompeteStoreInfo *storeInfo = sender.object;
    [self.datasource addObject:storeInfo];
    [self.tableView reloadData];
}

- (void)upReloadDataNotifi:(NSNotification *)sender {
    HLCompeteStoreInfo *storeInfo = sender.object;
    HLCompeteStoreInfo *upInfo;
    for (HLCompeteStoreInfo *info in self.datasource) {
        if ([info.store_id isEqualToString:storeInfo.store_id]) {
            upInfo = info;
            break;
        }
    }
    if (upInfo) {
        [self.datasource removeObject:upInfo];
        [self.tableView reloadData];
    }
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.whiteColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_card_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无店铺信息";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    _noDataView.hidden = !show;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCompeteBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCompeteBaseTableCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.storeInfo = self.datasource[indexPath.row];
    weakify(self);
    cell.upDownCallBack = ^(HLCompeteStoreInfo * _Nonnull storeInfo) {
        [weak_self updateWithStoreInfo:storeInfo];
    };
    return cell;
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(137);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLCompeteBaseTableCell class] forCellReuseIdentifier:@"HLCompeteBaseTableCell"];
    //下拉刷新
    [_tableView headerNormalRefreshingBlock:^{
        self.page = 1;
        [self loadListWithHud:NO];
    }];
    
    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        self.page +=1;
        [self loadListWithHud:NO];
    }];
    
    [_tableView hideFooter:YES];
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
