//
//  HLHotSekillInputController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillInputController.h"
#import "HLRightInputViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLRightDownSelectCell.h"
#import "HLDownSelectView.h"
#import "HLHotSekillDetailController.h"
#import "HLCalendarViewController.h"
#import "HLTimeSingleSelectView.h"
#import "HLInputUseDescViewCell.h"

NSString * const kOrinalLeftTip = @"*原价";
NSString * const kSaleLeftTip = @"*售价";
NSString * const kSumNumLeftTip = @"*提供数量";
NSString * const kLimitNumLeftTip = @"*限购数量";
NSString * const kfyLeftTip = @"*跨店分佣";

@interface HLHotSekillInputController () <UITableViewDelegate,UITableViewDataSource,HLRightDownSelectCellDelegate,HLRightInputViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@property(nonatomic, strong) NSString *fyMoney;

@end

@implementation HLHotSekillInputController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布爆款秒杀";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"下一步 套餐详情"];
    
    // 加载可以选择的两项数据
    [self loadDownSelectData];
}

/// 加载可以选择的两项数据
- (void)loadDownSelectData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/HotSeckillParam.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([responseObject code] == 200) {
            // 处理数据
            NSArray *needOrderSubInfos = [HLDownSelectSubInfo mj_objectArrayWithKeyValuesArray:responseObject.data[@"booking"]];
            NSArray *personNumSubInfos = [HLDownSelectSubInfo mj_objectArrayWithKeyValuesArray:responseObject.data[@"peoType"]];
            
            HLDownSelectInfo *orderTimeInfo = self.dataSource[4];
            orderTimeInfo.subInfos = needOrderSubInfos;
            orderTimeInfo.selectSubInfo = orderTimeInfo.subInfos.firstObject;
            [orderTimeInfo buildParams];
            
            HLDownSelectInfo *presonNumInfo = self.dataSource[5];
            presonNumInfo.subInfos = personNumSubInfos;
            presonNumInfo.selectSubInfo = presonNumInfo.subInfos.firstObject;
            [presonNumInfo buildParams];
            
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 保存信息
- (void)saveButtonClick{
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    HLBaseTypeInfo *orinalInfo = nil; // 原价
    HLBaseTypeInfo *saleInfo = nil;   // 售价
    HLBaseTypeInfo *sumNumInfo = nil; // 总共的数量
    HLBaseTypeInfo *limitNumInfo = nil;   // 限购的数量
    HLBaseTypeInfo *fyInfo = nil;   //分销佣金
    for (HLBaseTypeInfo *info in self.dataSource) {
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self.view);
            return;
        }else{
            if (info.mParams.count > 0) {
                [mParams setValuesForKeysWithDictionary:info.mParams];
            }else{
                [mParams setValue:info.text forKey:info.saveKey];
            }
        }
        
        if ([info.leftTip isEqualToString:kOrinalLeftTip]) {orinalInfo = info;}
        if ([info.leftTip isEqualToString:kSaleLeftTip]) {saleInfo = info;}
        if ([info.leftTip isEqualToString:kSumNumLeftTip]) {sumNumInfo = info;}
        if ([info.leftTip isEqualToString:kLimitNumLeftTip]) {limitNumInfo = info;}
        if ([info.leftTip isEqualToString:kfyLeftTip]) {fyInfo = info;}
    }
    
    // 额外增加的判断
    if (orinalInfo.text.doubleValue == 0 || saleInfo.text.doubleValue == 0) {
        HLShowHint(@"售价或原价不能为0", self.view);
        return;
    }
    
    if (fyInfo.text.doubleValue <_fyMoney.doubleValue) {
        HLShowHint(@"最低分佣金额为销售金额的6%", self.view);
        return;
    }
    
    if (fyInfo.text.doubleValue > saleInfo.text.doubleValue) {
        HLShowHint(@"跨店分佣不能高于售价", self.view);
        return;
    }
    
    // 额外增加的判断
    if (orinalInfo.text.doubleValue <= saleInfo.text.doubleValue) {
        HLShowHint(@"售价必须低于于原价", self.view);
        return;
    }
    
    // 额外增加的判断
    if (sumNumInfo.text.integerValue == 0 || limitNumInfo.text.integerValue == 0) {
        HLShowHint(@"提供数量或限购数量不能为0", self.view);
        return;
    }
    
    // 额外增加的判断
    if (sumNumInfo.text.integerValue < limitNumInfo.text.integerValue) {
        HLShowHint(@"提供数量不能小于限购数量", self.view);
        return;
    }
    
    HLHotSekillDetailController *sekillDetail = [[HLHotSekillDetailController alloc] init];
    sekillDetail.buildParams = mParams;
    [self.navigationController pushViewController:sekillDetail animated:YES];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(110));
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - HLRightDownSelectCellDelegate

/// 选择
- (void)downSeletCell:(HLRightDownSelectCell *)cell selectInfo:(HLDownSelectInfo *)selectInfo appendView:(UIView *)view{
    [self.view endEditing:YES];
    [HLDownSelectView showSelectViewWithTitles:selectInfo.titles currentTitle:selectInfo.selectSubInfo.name needShowSelect:YES showSeperator:NO itemHeight:FitPTScreen(40) dependView:view showType:HLDownSelectTypeDown maxNum:6 hideCallBack:^{
        
    } callBack:^(NSInteger index) {
        selectInfo.selectSubInfo = selectInfo.subInfos[index];
        selectInfo.mParams = @{selectInfo.saveKey:selectInfo.selectSubInfo.Id};
        [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - HLRightInputViewCellDelegate
- (void)inputViewCell:(HLRightInputViewCell *)cell textChanged:(HLRightInputTypeInfo *)inputInfo {
    NSInteger index = [self.dataSource indexOfObject:inputInfo] + 1;
    HLRightInputTypeInfo *fyInfo = [self.dataSource objectAtIndex:index];
    if ([inputInfo.leftTip isEqualToString:kSaleLeftTip]) {
        double fyMoney = inputInfo.text.doubleValue * 0.06;
        fyInfo.text = [NSString stringWithFormat:@"%.2lf",fyMoney];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        _fyMoney = fyInfo.text;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseTypeInfo *info = self.dataSource[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeDownSelect:
        {
            HLRightDownSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightDownSelectCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeDate:
        {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            return cell;
        }
        case HLInputCellTypeUseDesc:
        {
            HLInputUseDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputUseDescViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    // 选择有效期
    if (indexPath.row == 8) {
        HLInputDateInfo *dateInfo = self.dataSource[indexPath.row];
        if (!dateInfo.enabled) {return;}
        HLCalendarViewController *overView = [[HLCalendarViewController alloc] initWithCallBack:^(NSDate *start, NSDate *end) {
            dateInfo.text = [NSString stringWithFormat:@"%@ 至 %@",[HLTools formatterWithDate:start formate:@"yyyy.MM.dd"],[HLTools formatterWithDate:end formate:@"yyyy.MM.dd"]];
            dateInfo.mParams = @{
                @"startTime":[HLTools formatterWithDate:start formate:@"yyyy-MM-dd"],
                @"endTime":[HLTools formatterWithDate:end formate:@"yyyy-MM-dd"]
            };
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self presentViewController:overView animated:false completion:nil];
    }
    
    // 选择截止日期
    if (indexPath.row == 9) {
        HLInputDateInfo *invaldTimeInfo = self.dataSource[indexPath.row];
        if (!invaldTimeInfo.enabled) {return;}
        [HLTimeSingleSelectView showEditTimeView:invaldTimeInfo.text startWithToday:YES callBack:^(NSString * _Nonnull date) {
            invaldTimeInfo.text = date;
            invaldTimeInfo.mParams = @{@"closingDate":date};
            [self.tableView reloadData];
        }];
        return;
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLInputUseDescViewCell class] forCellReuseIdentifier:@"HLInputUseDescViewCell"];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLRightDownSelectCell class] forCellReuseIdentifier:@"HLRightDownSelectCell"];
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
    }
    return _tableView;
}


- (NSArray *)dataSource{
    if (!_dataSource) {
        
        HLRightInputTypeInfo *goodNameInfo = [[HLRightInputTypeInfo alloc] init];
        goodNameInfo.leftTip = @"*标题";
        goodNameInfo.placeHoder = @"请输入抢购商品或套餐名称";
        goodNameInfo.cellHeight = FitPTScreen(53);
        goodNameInfo.canInput = YES;
        goodNameInfo.saveKey = @"title";
        goodNameInfo.errorHint = @"请输入抢购商品或套餐名称";
        goodNameInfo.needCheckParams = YES;
        
        HLRightInputTypeInfo *orinalPriceInfo = [[HLRightInputTypeInfo alloc] init];
        orinalPriceInfo.leftTip = kOrinalLeftTip;
        orinalPriceInfo.placeHoder = @"¥商品原价";
        orinalPriceInfo.needCheckParams = YES;
        orinalPriceInfo.cellHeight = FitPTScreen(53);
        orinalPriceInfo.canInput = YES;
        orinalPriceInfo.saveKey = @"orgPrice";
        orinalPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        orinalPriceInfo.errorHint = @"请输入商品原价";
        
        HLRightInputTypeInfo *salePriceInfo = [[HLRightInputTypeInfo alloc] init];
        salePriceInfo.leftTip = kSaleLeftTip;
        salePriceInfo.placeHoder = @"¥商品抢购价格";
        salePriceInfo.cellHeight = FitPTScreen(53);
        salePriceInfo.canInput = YES;
        salePriceInfo.saveKey = @"price";
        salePriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        salePriceInfo.errorHint = @"请输入商品抢购价格";
        salePriceInfo.needCheckParams = YES;
        
        //        佣金
        HLRightInputTypeInfo *yjInfo = [[HLRightInputTypeInfo alloc] init];
        yjInfo.leftTip = @"*跨店分佣";
        yjInfo.placeHoder = @"¥请输入商品跨店分佣";
        yjInfo.cellHeight = FitPTScreen(53);
        yjInfo.canInput = YES;
        yjInfo.saveKey = @"invite_amount";
        yjInfo.errorHint = @"请输入商品跨店分佣";
        yjInfo.needCheckParams = YES;
        yjInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        
        // 构建子类选择，如果数据请求错误的时候，用本地的
        NSArray *needOrderSubInfoDicts = @[@{@"Id":@"0",@"name":@"不需要"},@{@"Id":@"1",@"name":@"提前24小时"},@{@"Id":@"2",@"name":@"提前48小时"}];
        NSArray *needOrderSubInfos = [HLDownSelectSubInfo mj_objectArrayWithKeyValuesArray:needOrderSubInfoDicts];
        
        HLDownSelectInfo *needOrderInfo = [[HLDownSelectInfo alloc] init];
        needOrderInfo.subInfos = needOrderSubInfos;
        needOrderInfo.leftTip = @"*是否提前预约";
        needOrderInfo.selectSubInfo = needOrderInfo.subInfos.firstObject;
        needOrderInfo.saveKey = @"booking";
        needOrderInfo.needCheckParams = YES;
        needOrderInfo.cellHeight = FitPTScreen(70);
        needOrderInfo.type = HLInputCellTypeDownSelect;
        [needOrderInfo buildParams];
        
        NSArray *presonNumInfoDicts = @[@{@"Id":@"1",@"name":@"1-2人"},@{@"Id":@"2",@"name":@"2-3人"},@{@"Id":@"3",@"name":@"3-4人"},
                                        @{@"Id":@"4",@"name":@"5-6人"},@{@"Id":@"5",@"name":@"7-10人"},@{@"Id":@"6",@"name":@"10人以上"}];
        NSArray *presonNumInfos = [HLDownSelectSubInfo mj_objectArrayWithKeyValuesArray:presonNumInfoDicts];
        
        HLDownSelectInfo *presonNumInfo = [[HLDownSelectInfo alloc] init];
        presonNumInfo.subInfos = presonNumInfos;
        presonNumInfo.leftTip = @"*适用人数";
        presonNumInfo.selectSubInfo = presonNumInfo.subInfos.firstObject;
        presonNumInfo.saveKey = @"peoType";
        presonNumInfo.cellHeight = FitPTScreen(70);
        presonNumInfo.needCheckParams = YES;
        presonNumInfo.type = HLInputCellTypeDownSelect;
        [presonNumInfo buildParams];
        
        HLRightInputTypeInfo *sumNumInfo = [[HLRightInputTypeInfo alloc] init];
        sumNumInfo.leftTip = kSumNumLeftTip;
        sumNumInfo.placeHoder = @"抢购总数量";
        sumNumInfo.rightText = @"份";
        sumNumInfo.cellHeight = FitPTScreen(53);
        sumNumInfo.canInput = YES;
        sumNumInfo.needCheckParams = YES;
        sumNumInfo.saveKey = @"offerNum";
        sumNumInfo.errorHint = @"请输入抢购总数量";
        sumNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
        
        HLRightInputTypeInfo *buyNumInfo = [[HLRightInputTypeInfo alloc] init];
        buyNumInfo.leftTip = kLimitNumLeftTip;
        buyNumInfo.placeHoder = @"每人限购数量";
        buyNumInfo.cellHeight = FitPTScreen(53);
        buyNumInfo.canInput = YES;
        buyNumInfo.saveKey = @"limitNum";
        buyNumInfo.needCheckParams = YES;
        buyNumInfo.rightText = @"份";
        buyNumInfo.errorHint = @"请输入限购数量";
        buyNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
        
        HLInputDateInfo *timeInfo = [[HLInputDateInfo alloc] init];
        timeInfo.leftTip = @"*秒杀有效期";
        timeInfo.placeHoder = @"请选择秒杀有效期";
        timeInfo.dateType = 0;
        timeInfo.errorHint = @"请选择秒杀有效期";
        timeInfo.needCheckParams = YES;
        timeInfo.cellHeight = FitPTScreen(76);
        timeInfo.type = HLInputCellTypeDate;
        timeInfo.needCheckParams = YES;
        
        HLInputDateInfo *dateInfo = [[HLInputDateInfo alloc] init];
        dateInfo.leftTip = @"*消费截止日期";
        dateInfo.placeHoder = @"在消费截止日期内可使用";
        dateInfo.dateType = 0;
        dateInfo.errorHint = @"请选择消费截止日期";
        dateInfo.needCheckParams = YES;
        dateInfo.cellHeight = FitPTScreen(76);
        dateInfo.type = HLInputCellTypeDate;
        dateInfo.needCheckParams = YES;
        
        HLInputUseDescInfo *useInfo = [[HLInputUseDescInfo alloc]init];
        useInfo.leftTip = @"商品描述";
        useInfo.placeHolder = @"请输入使用描述";
        useInfo.type = HLInputCellTypeUseDesc;
        useInfo.cellHeight = FitPTScreen(149);
        useInfo.saveKey = @"summary";
        
        _dataSource = @[goodNameInfo,orinalPriceInfo,salePriceInfo,yjInfo,needOrderInfo,presonNumInfo,sumNumInfo,buyNumInfo,timeInfo,dateInfo,useInfo];
    }
    return _dataSource;
}



@end

