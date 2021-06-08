//
//  HLSellTimeSetController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLSellTimeSetController.h"
#import "HLSellTimeTableViewCell.h"
#import "HLTradeDayTableCell.h"
#import "HLTradeTimeTableCell.h"
#import "HLSellModel.h"

@interface HLSellTimeSetController () <UITableViewDelegate, UITableViewDataSource, HLSellTimeTableCellDelegate, HLTradeDayTableCellDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *datasource;

@property(nonatomic, strong) HLSellModel *sellModel;

@property(nonatomic, strong) HLSellModel *sellDay;

@property(nonatomic, strong) HLSellModel *tradeTime;

@property(nonatomic, strong) NSArray *timeData;
//默认的星期
@property(nonatomic, strong) NSMutableArray *sellDays;

@end

@implementation HLSellTimeSetController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"售卖时间设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollsToTop = YES;
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[HLSellTimeTableViewCell class] forCellReuseIdentifier:@"HLSellTimeTableViewCell"];
    [_tableView registerClass:[HLTradeDayTableCell class] forCellReuseIdentifier:@"HLTradeDayTableCell"];
    [_tableView registerClass:[HLTradeTimeTableCell class] forCellReuseIdentifier:@"HLTradeTimeTableCell"];
    
    [self creatFootView];
    
    [self requestMainData];
}

- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
}

//保存
- (void)saveClick {
    NSInteger sell_time = [_sellModel.values.firstObject integerValue];
    if (sell_time == 0) {
        [self saveWithSellTime:sell_time days:@"" hours:@""];
        return;
    }
    //    营业日
    NSArray *dayArr = @[@(0),@(0),@(0),@(0),@(0),@(0),@(0)];
    NSMutableArray *days = [NSMutableArray arrayWithArray:dayArr];
    for (int i = 0; i<_sellDay.values.count; i ++) {
        NSNumber *index = _sellDay.values[i] ;
        [days replaceObjectAtIndex:index.integerValue withObject:@(1)];
    }
    
    [_sellDays enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * muDict = [dict mutableCopy];
        [muDict setObject:days[idx] forKey:@"state"];
        [_sellDays replaceObjectAtIndex:idx withObject:[muDict copy]];
    }];
    NSString *dayStr = [_sellDays mj_JSONString];
    
    //    营业日期
    NSMutableArray *hours = [NSMutableArray array];
    [_tradeTime.values enumerateObjectsUsingBlock:^(HLTimeModel*  _Nonnull time, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *hour = [time mj_keyValues];
        [hours addObject:hour];
    }];
    NSString *hour = [hours mj_JSONString];
    [self saveWithSellTime:sell_time days:dayStr hours:hour];
    
    
}

#pragma mark - HLSellTimeTableCellDelegate
- (void)sellTimeWithModel:(HLSellModel *)model clickIndex:(NSInteger)index {
    if (index == 0) {
        if ([self.datasource containsObject:_sellDay]) {
            [self.datasource removeObject:_sellDay];
        }
        
        if ([self.datasource containsObject:_tradeTime]) {
            [self.datasource removeObject:_tradeTime];
        }
    } else {
        if (![self.datasource containsObject:_sellDay]) {
            [self.datasource addObject:_sellDay];
        }
        if (_sellDay.values.count && ![self.datasource containsObject:_tradeTime]) {
            [self.datasource addObject:_tradeTime];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - HLTradeDayTableCellDelegate
//日期一个也没选中
- (void)tradeDayWithMode:(HLSellModel *)model cancelAll:(BOOL)cancelAll {
    if (cancelAll) {
        if ([self.datasource containsObject:_tradeTime]) {
            [self.datasource removeObject:_tradeTime];
            [self.tableView reloadData];
        }
        return;
    }
    
    if (![self.datasource containsObject:_tradeTime]) {
        [self.datasource addObject:_tradeTime];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HLSellTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLSellTimeTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.datasource[indexPath.section];
        return cell;
    }
    
    if (indexPath.section == 1) {
        HLTradeDayTableCell * cell =  cell = [tableView dequeueReusableCellWithIdentifier:@"HLTradeDayTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.datasource[indexPath.section];
        return cell;
    }
    
    HLTradeTimeTableCell * cell =  cell = [tableView dequeueReusableCellWithIdentifier:@"HLTradeTimeTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeData = _timeData;
    cell.model = self.datasource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return  FitPTScreen(82);
    }
    
    if (indexPath.section == 1) {
        return FitPTScreen(132);
    }
    return FitPTScreen(297);
}

#pragma mark - getter

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

#pragma mark - 请求默认数据
- (void)requestMainData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHours.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleDataWithDict:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithDict:(NSDictionary *)dict {
    
    NSArray *sellTimeArr = dict[@"selling_time"];
    _sellModel = [[HLSellModel alloc]init];
    _sellModel.title = @"可售卖时间";
    NSInteger selectIndex = 0;
    for (NSDictionary *selectItem in sellTimeArr) {
        NSInteger select = [selectItem[@"state"] integerValue];
        if (select == 1) {
            selectIndex = [sellTimeArr indexOfObject:selectItem];
        }
    }
    _sellModel.values = @[@(selectIndex)];
    
    //    营业日
    NSMutableArray *selectDays = [NSMutableArray array];
    NSArray *days = dict[@"business_day"];
    _sellDays = [NSMutableArray arrayWithArray:days];
    for (int i = 0; i< days.count; i++) {
        NSDictionary *day = days[i];
        if ([day[@"state"] integerValue] == 1) {
            [selectDays addObject:@(i)];
        }
    }
    _sellDay = [[HLSellModel alloc]init];
    _sellDay.title = @"* 营业日";
    _sellDay.values = [selectDays copy];
    
    
    //    营业时间
    _tradeTime = [[HLSellModel alloc]init];
    _tradeTime.title = @"* 营业时间";
    
    NSArray *hours = dict[@"business_hours"];
    NSMutableArray *showHours = [NSMutableArray array];
    for (NSDictionary *hour in hours) {
        HLTimeModel *time = [HLTimeModel mj_objectWithKeyValues:hour];
        [showHours addObject:time];
    }
    
    if (!showHours.count) {
        HLTimeModel *time = [[HLTimeModel alloc]init];
        [showHours addObject:time];
    }
    _tradeTime.values = [showHours copy];
    
    //    所有可选择的时间
    _timeData = dict[@"hours_data"];
    
    [self.datasource addObject:_sellModel];
    if (selectIndex == 1) {
        [self.datasource addObject:_sellDay];
    }
    
    if (_sellDay.values.count && selectIndex == 1) {
        [self.datasource addObject:_tradeTime];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 保存
- (void)saveWithSellTime:(NSInteger)sell days:(NSString *)days hours:(NSString *)hours {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHoursSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"selling_time":@(sell),@"business_day":days,@"business_hours":hours};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowHint(@"保存成功", nil);
            [self hl_goback];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
@end
