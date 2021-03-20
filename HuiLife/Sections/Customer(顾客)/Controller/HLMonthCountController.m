//
//  HLMonthCountController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/7.
//

#import "HLMonthCountController.h"
#import "HLMonthCardTableCell.h"
#import "HLCustomerInfo.h"
#import "LZPickViewManager.h"

@interface HLMonthCountController () <UITableViewDelegate, UITableViewDataSource, HLMonthCountHeaderDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noDataView;//缺省图
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) NSString *date;//日期
@property(nonatomic, assign) NSInteger num;//日用户
@end

@implementation HLMonthCountController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"月活跃用户数"];
    [self hl_setBackImage:@"back_oriange"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    默认当前月
    NSDate *date = [NSDate date];
    _date = [HLTools formatterWithDate:date formate:@"yyyy-MM"];
    [self loadListWithHud:YES date:_date];
}

#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud date:(NSString *)date{
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerActive.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"userIdBuss":[HLAccount shared].userIdBuss?:@"",@"date":date};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            self.date = result.data[@"date"];
            self.num = [result.data[@"sum"] integerValue];
            [self handleDatas:result.data[@"actives"]];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDatas:(NSArray *)datas {
    NSArray *list = [HLMonthActiveInfo mj_objectArrayWithKeyValuesArray:datas];
    [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:list];
    [self.tableView reloadData];
    [self showNodataView:!list.count];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show {
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(FitPTScreen(127), FitPTScreen(121), FitPTScreen(133), FitPTScreen(150))];
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_cus_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(10));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"没有找到相关的信息";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    
    _noDataView.hidden = !show;
}

#pragma mark - HLMonthCountHeaderDelegate
- (void)monthHeader:(HLMonthCountHeader *)header selectDate:(NSString *)date {
    [self loadListWithHud:YES date:date];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLMonthCardTableCell *cell = (HLMonthCardTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLMonthCardTableCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.monthInfo = self.datasource[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HLMonthCountHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLMonthCountHeader"];
    header.delegate = self;
    [header configDate:_date num:_num];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FitPTScreen(51);
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = FitPTScreen(140);
    _tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[HLMonthCountHeader class] forHeaderFooterViewReuseIdentifier:@"HLMonthCountHeader"];
}

#pragma mark - Getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end


//section header

@interface HLMonthCountHeader ()
@property(nonatomic, strong) UIButton *dateBtn;
@property(nonatomic, strong) UILabel *numLb;
@end

@implementation HLMonthCountHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.contentView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    _dateBtn = [UIButton hl_regularWithTitle:@" 2020-07" titleColor:@"#9A9A9A" font:12 image:@"time_grey"];
    _dateBtn.backgroundColor = UIColor.whiteColor;
    _dateBtn.layer.cornerRadius = FitPTScreen(12.5);
    [self.contentView addSubview:_dateBtn];
    [_dateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(13));
        make.size.equalTo(CGSizeMake(FitPTScreen(115), FitPTScreen(24)));
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
    [self.contentView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12.5));
        make.centerY.equalTo(self.dateBtn);
    }];
    
    [_dateBtn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configDate:(NSString *)date num:(NSInteger)num {
    [_dateBtn setTitle:[NSString stringWithFormat:@" %@",date] forState:UIControlStateNormal];
    _numLb.text = [NSString stringWithFormat:@"日新增用户数：%ld",num];
}

- (void)dateClick:(UIButton *)sender {
    NSString * max = [HLTools formatterWithDate:[NSDate date] formate:@"yyyy-MM"];
    [[LZPickViewManager initLZPickerViewManager]showYearMonthWithMax:max withMinDateString:@"2010-01" didSeletedDateStringBlock:^(NSString *dateString) {
        [self.dateBtn setTitle:[NSString stringWithFormat:@" %@",dateString] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(monthHeader:selectDate:)]) {
            [self.delegate monthHeader:self selectDate:dateString];
        }
    }];
}
@end
