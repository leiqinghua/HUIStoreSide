//
//  HLOrderPickupDetailController.m
//  HuiLife
//
//  Created by 王策 on 2020/1/15.
//

#import "HLOrderPickupDetailController.h"
#import "HLPickUpDetailHead.h"
#import "HLPickUpMoneyViewCell.h"
#import "HLPickUpGoodViewCell.h"

// 顶部高度
#define kTableHeadHeight FitPTScreen(78)
// 展示钱的 cell 的高度
#define kTableMoneyCellHeight FitPTScreen(34)
// 展示商品的 cell 的高度
#define kTableGoodCellHeight FitPTScreen(112)

// tableView临界点高度
#define kTableMaxHeight FitPTScreen(450)


@interface HLOrderPickupDetailController () <UITableViewDataSource, UITableViewDelegate, HLPickUpDetailHeadDelegate>

// tableViewHeaderView 包含：订单号 自提状态 商品总数 展开按钮
@property (nonatomic, strong) HLPickUpDetailHead *headView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isExpand; // 是否展开，默认为 NO

@property (nonatomic, copy) NSArray *section0Arr;
@property (nonatomic, copy) NSArray *section1Arr;
@property (nonatomic, strong)UIView *bottomView;
@end

@implementation HLOrderPickupDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"商超自提核单" andTitleColor:UIColorFromRGB(0x333333)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
    
    [self loadOrderData];
}

#pragma mark - Method

// 创建视图
- (void)creatSubViews{
    
    self.view.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self.view addSubview:self.tableView];
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    _headView = [[HLPickUpDetailHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, kTableHeadHeight)];
    _headView.delegate = self;
    self.tableView.tableHeaderView = _headView;
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:_bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self.view);
        make.height.equalTo(FitPTScreen(193));
    }];
    
    
    UILabel *bottomTipLab = [[UILabel alloc] init];
    [_bottomView addSubview:bottomTipLab];
    bottomTipLab.text = @"商品核销成功后不可修改";
    bottomTipLab.textColor = UIColorFromRGB(0xFF9920);
    bottomTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [bottomTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-40) - Height_Bottom_Margn);
        make.centerX.equalTo(self.bottomView.centerX).offset(FitPTScreen(5));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [_bottomView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"waring_oriange_light"];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomTipLab.left).offset(FitPTScreen(-5));
        make.centerY.equalTo(bottomTipLab);
        make.width.height.equalTo(FitPTScreen(11));
    }];
    
    // 加按钮
    UIButton *nextBtn = [[UIButton alloc] init];
    [_bottomView addSubview:nextBtn];
    [nextBtn setTitle:@"确认自提" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(bottomTipLab.top).offset(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

// 点击确认自提按钮
- (void)nextBtnClick{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHxOrderAC.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":self.order_id};
    }onSuccess:^(id responseObject) {
         HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowHint(@"订单核销成功", nil);
            [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0",@"1",@"2",@"3",@"4"]];
            [self hl_goback];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - 请求数据
- (void)loadOrderData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHxOrderBySuper.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id": self.order_id?:@""};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleTableDataWithDict:result.data];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

// 获取到数据之后的操作
- (void)handleTableDataWithDict:(NSDictionary*)dict{
    
    BOOL isHx = [dict[@"is_hx"] boolValue];
    // 配置顶部数据
    [_headView configDefaultSelect:_isExpand orderNum:dict[@"order_id"] goodNum:dict[@"goods_num"] state:isHx?@"已自提":@"未自提"];
    
    // 配置 cell 数据
    [self buildMoneySection0ArrWithDict:dict];
    [self buildGoodSection1ArrWithDict:dict];
    
    [self.tableView reloadData];
    
    // 根据内容高度改变 tableView 的高度
    [self resizeTableHeight];
    
    _bottomView.hidden = isHx;
    
}

// 构建展示价格的数据
- (void)buildMoneySection0ArrWithDict:(NSDictionary *)dict{
    double salePrice = [dict[@"total_price"] doubleValue]; // 售价
    double redPrice = [dict[@"ddlj_money"] doubleValue];   // 红包
    double payPrice = [dict[@"pay_price"] doubleValue];  // 实付
    self.section0Arr = @[
        @{@"tip":@"售价",@"attr":[self buildAttrWithMoney: salePrice color:UIColorFromRGB(0xFC992F)]},
        @{@"tip":@"红包",@"attr":[self buildAttrWithMoney: redPrice color:UIColorFromRGB(0xFC992F)]},
        @{@"tip":@"实付",@"attr":[self buildAttrWithMoney: payPrice color:UIColorFromRGB(0xFF4040)]},
    ];
}

// 构建展示商品的数据
- (void)buildGoodSection1ArrWithDict:(NSDictionary *)dict{
    // 改为 model 数组啊
    NSArray *list = dict[@"goods_info"];
    self.section1Arr = [HLPickUpGoodModel mj_objectArrayWithKeyValuesArray:list];
}

// 构建钱
- (NSAttributedString *)buildAttrWithMoney:(double)money color:(UIColor *)color{
    NSString *allStr = [NSString stringWithFormat:@"¥%@",[NSString hl_stringNoZeroWithDoubleValue:money]];
    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:FitPTScreen(13)],
        NSForegroundColorAttributeName : color
    }];
    UIFont *font = [UIFont systemFontOfSize:FitPTScreen(15)];
    if ([allStr containsString:@"."]) {
        NSRange dotRange = [allStr rangeOfString:@"."];
        [moneyAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(1, dotRange.location - 1)];
    }else{
        [moneyAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(1, allStr.length - 1)];
    }
    return moneyAttr;
}

// 改变 tableView 的高度
- (void)resizeTableHeight{
    CGFloat tableHeight = 0;
    
    // tableViewHeader 的高度
    HLPickUpDetailHead *headView = (HLPickUpDetailHead *)self.tableView.tableHeaderView;
    tableHeight += headView.lx_height;
    
    // 计算cell 的高度
    NSInteger sectionNum = [self numberOfSectionsInTableView:self.tableView];
    for (NSInteger i = 0; i < sectionNum; i++) {
        NSInteger rowNum = [self tableView:self.tableView numberOfRowsInSection:i];
        for (NSInteger j = 0; j < rowNum; j++) {
            tableHeight += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
    // 控制 tableView 的滑动
    self.tableView.scrollEnabled = tableHeight >= kTableMaxHeight;
    tableHeight = tableHeight >= kTableMaxHeight ? kTableMaxHeight : tableHeight;
    
    CGRect frame = self.tableView.frame;
    frame.size.height = tableHeight;
    self.tableView.frame = frame;
}

#pragma mark - HLPickUpDetailHeadDelegate

// 点击展开收起
- (void)detailHead:(HLPickUpDetailHead *)head expand:(BOOL)expand{
    _isExpand = expand;
    [self.tableView reloadData];
    [self resizeTableHeight];
}

#pragma mark - UITableViewDataSource

// 一共两个 section 第一个展示价格，第二个展示商品
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _isExpand ? self.section0Arr.count : 0;
    }
    return self.section1Arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dict = self.section0Arr[indexPath.row];
        HLPickUpMoneyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLPickUpMoneyViewCell" forIndexPath:indexPath];
        BOOL showCorner = indexPath.row == self.section0Arr.count - 1;
        [cell configTip:dict[@"tip"] moneyAttr:dict[@"attr"] showCorner:showCorner];
        return cell;
    }else{
        // 还没键 model
        HLPickUpGoodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLPickUpGoodViewCell" forIndexPath:indexPath];
        cell.goodModel = self.section1Arr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {return kTableMoneyCellHeight;};
    if (indexPath.section == 1) {return kTableGoodCellHeight;};
    return 44;
}

- (UITableView *)tableView{
    if (!_tableView) {
        // 初始状态下tableView 高度为 0，之后拉取数据，判断内容高度，如果超过临界值就是临界值，否则，内容多高就多高
        CGFloat margin = FitPTScreen(10);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, Height_NavBar, ScreenW - 2 * margin, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = FitPTScreen(8);
        _tableView.layer.masksToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HLPickUpMoneyViewCell class] forCellReuseIdentifier:@"HLPickUpMoneyViewCell"];
        [_tableView registerClass:[HLPickUpGoodViewCell class] forCellReuseIdentifier:@"HLPickUpGoodViewCell"];
    }
    return _tableView;
}

@end

