//
//  HLDayDealGoodController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/17.
// 秒杀商品

#import "HLDayDealGoodController.h"
#import "HLDayDealGoodTableCell.h"
#import "HLDayDealGoodInfo.h"
#import "HLHotSekillInputController.h"

@interface HLDayDealGoodController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noDataView;
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, assign) NSInteger page;
@end

@implementation HLDayDealGoodController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"选择秒杀商品"];
    [self hl_setBackImage:@"back_black"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self loadListWithHud:YES];
    [HLNotifyCenter addObserver:self selector:@selector(reloadListData) name:@"dayDealListReloadData" object:nil];
}

#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SeckillProductList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"pageNo":@(self.page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handleList:result.data[@"seckills"]];
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
    NSArray *datas = [HLDayDealGoodInfo mj_objectArrayWithKeyValuesArray:list];
    if (_page ==1) [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:datas];
    [self showNodataView:!self.datasource.count];
    [self.tableView hideFooter:!self.datasource.count];
    if (!datas.count)[self.tableView endNomorData];
    [self.tableView reloadData];
}

#pragma mark - Event
- (void)addClick {
    HLHotSekillInputController *addGoods = [[HLHotSekillInputController alloc] init];
    [self.navigationController pushViewController:addGoods animated:YES];
}

- (void)reloadListData{
    self.page = 1;
    [self loadListWithHud:NO];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.clearColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_hui_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无秒杀商品";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    _noDataView.hidden = !show;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLDayDealGoodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLDayDealGoodTableCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    HLDayDealGoodInfo *goodInfo = self.datasource[indexPath.row];
    goodInfo.click = [goodInfo.Id isEqualToString:_goodId];
    cell.goodInfo = goodInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLDayDealGoodInfo *goodInfo = self.datasource[indexPath.row];
    if (goodInfo.isSelected) return;

    if (self.dayDealBlock) {
        self.dayDealBlock(goodInfo.title, goodInfo.Id);
        [self hl_goback];
    }
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _tableView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(106);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLDayDealGoodTableCell class] forCellReuseIdentifier:@"HLDayDealGoodTableCell"];
    
    [_tableView headerNormalRefreshingBlock:^{
        self.page = 1;
        [self loadListWithHud:NO];
    }];

    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        self.page +=1;
        [self loadListWithHud:NO];
    }];
    [_tableView hideFooter:YES];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(30))];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xFD9E2F) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        for (int i = 0; i<10; i++) {
            HLDayDealGoodInfo *info = [[HLDayDealGoodInfo alloc]init];
            [_datasource addObject:info];
        }
    }
    return _datasource;
}
@end

