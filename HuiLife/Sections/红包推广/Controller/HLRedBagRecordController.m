//
//  HLRedBagRecordController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/19.
//
#import "HLRedBagRecordController.h"
#import "HLRedBagPromoteInfo.h"

@interface HLRedBagRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *Id;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) UIView *noDataView;
@end

@implementation HLRedBagRecordController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
}

#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SeckillHistory.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"pageNo":@(self.page),@"type":@(_type),@"redbagId":_Id};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handleList:result.data[@"historys"]];
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
    NSArray *datas = [HLRedBagRecordInfo mj_objectArrayWithKeyValuesArray:list];
    if (_page ==1) [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:datas];
    [self showNodataView:!self.datasource.count];
    [self.tableView hideFooter:!self.datasource.count];
    if (!datas.count)[self.tableView endNomorData];
    [self.tableView reloadData];
}

#pragma mark - Method
//0-1-2(从领取用户开始)
- (NSString *)titleWithStatu:(NSInteger)statu {
    if (statu == 2) {
        if (_type == 0) return @"领取时间";
        if (_type == 1) return @"充值时间";
        if (_type == 2) return @"退款时间";
    }
    if (statu == 1) {
        if (_type == 0) return @"领取金额";
        if (_type == 1) return @"充值金额";
        if (_type == 2) return @"退款金额";
    }
    return @"领取用户";
}

- (void)startLoadListWithId:(NSString *)Id {
    _Id = Id;
    if (!self.datasource.count) {
        _page = 1;
        [self loadListWithHud:YES];
    }
}

- (void)showNodataView:(BOOL)show{
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = UIColor.clearColor;
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_record_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(228));
            make.centerX.equalTo(self.noDataView);
        }];
         
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无数据";
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
    HLRedBagRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRedBagRecordTableCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.hideUser = self.hideUser;
    cell.recordInfo = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLRedBagRecordTableCell class] forCellReuseIdentifier:@"HLRedBagRecordTableCell"];
    
    UIView *tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(30))];
    _tableView.tableHeaderView = tableHeader;
    
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    bagView.frame = CGRectMake(FitPTScreen(12), 0,CGRectGetMaxX(tableHeader.bounds)-FitPTScreen(24), FitPTScreen(30));
    [tableHeader addSubview:bagView];
    
    UILabel *lqLb = [UILabel hl_regularWithColor:@"#999999" font:12];
    lqLb.text = [self titleWithStatu:2];
    [bagView addSubview:lqLb];
    [lqLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-45));
        make.centerY.equalTo(bagView);
    }];
    
    UILabel *priceLb = [UILabel hl_regularWithColor:@"#999999" font:12];
    priceLb.text = [self titleWithStatu:1];
    [bagView addSubview:priceLb];
    [priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lqLb.left).offset(FitPTScreen(-72));
        make.centerY.equalTo(bagView);
    }];
    
    if (!_hideUser) {
        UILabel *userLb = [UILabel hl_regularWithColor:@"#999999" font:12];
        userLb.text = [self titleWithStatu:0];
        [bagView addSubview:userLb];
        [userLb makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceLb.left).offset(FitPTScreen(-37));
            make.centerY.equalTo(bagView);
        }];
    }
    
    UILabel *idLb = [UILabel hl_regularWithColor:@"#999999" font:12];
    idLb.text = @"ID";
    [bagView addSubview:idLb];
    [idLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.centerY.equalTo(bagView);
    }];
    
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

@end


@interface HLRedBagRecordTableCell ()
@property(nonatomic, strong) UILabel *timeLb;
@property(nonatomic, strong) UILabel *priceLb;
@property(nonatomic, strong) UILabel *userLb;
@property(nonatomic, strong) UILabel *IdLb;
@end

@implementation HLRedBagRecordTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _timeLb = [UILabel hl_regularWithColor:@"#555555" font:12];
    [self.contentView addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.right).offset(FitPTScreen(-79));
        make.centerY.equalTo(self.contentView);
    }];
    
    _priceLb = [UILabel hl_regularWithColor:@"#555555" font:12];
    [self.contentView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeLb.centerX).offset(FitPTScreen(-126));
        make.centerY.equalTo(self.contentView);
    }];
    
    _userLb = [UILabel hl_regularWithColor:@"#555555" font:12];
    [self.contentView addSubview:_userLb];
    [_userLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.priceLb.centerX).offset(FitPTScreen(-86));
        make.centerY.equalTo(self.contentView);
    }];
    
    _IdLb = [UILabel hl_regularWithColor:@"#555555" font:12];
    [self.contentView addSubview:_IdLb];
    [_IdLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.left).offset(FitPTScreen(27));
        make.centerY.equalTo(self.contentView);
    }];
    
//    _IdLb.text = @"1";
//    _userLb.text = @"150***3930";
//    _priceLb.text = @"¥0.02";
//    _timeLb.text = @"2020.10.27 16:37:20";
}

- (void)setHideUser:(BOOL)hideUser {
    _userLb.hidden = hideUser;
}

- (void)setRecordInfo:(HLRedBagRecordInfo *)recordInfo {
    _recordInfo = recordInfo;
    _IdLb.text = recordInfo.Id;
//    [HLTools getMiddleHideTextWithPhoneNum:recordInfo.mobile];
    _userLb.text = recordInfo.mobile;
    _priceLb.text = [NSString stringWithFormat:@"¥%@",recordInfo.money];
    _timeLb.text = recordInfo.time;
}
@end
