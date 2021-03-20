//
//  HLPayPromoteController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLPayPromoteController.h"
#import "HLRightInputViewCell.h"
#import "HLDownSelectView.h"
#import "HLRightSwitchViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLPayPromoteDayCell.h"
#import "HLPayPromoteInfo.h"

@interface HLPayPromoteController () <UITableViewDelegate,UITableViewDataSource,HLPayPromoteDayCellDelegate,HLRightSwitchViewCellDelegate,HLInputDateViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation HLPayPromoteController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"买单推广";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self creatFootViewWithButtonTitle:@"保存"];
    
    [self loadPageData];
}

/// 保存数据
- (void)saveButtonClick{
    
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    
    HLBaseTypeInfo *firstDiscount = nil; // 首单折扣
    HLBaseTypeInfo *teHuiDiscount = nil; // 特惠日
    HLBaseTypeInfo *normalDiscount = nil; // 普通日
    
    for (HLBaseTypeInfo *info in self.dataSource) {
        // 如果必须要验证参数，那么就判断参数
        if (info.needCheckParams && ![info checkParamsIsOk]) {
            HLShowHint(info.errorHint, self.view);
            return;
        }
        // 参数验证通过，先判断 mParams ，再去设置text
        if(info.mParams.count > 0){
            [mParams setValuesForKeysWithDictionary:info.mParams];
        }else{
            if (info.text && info.text.length > 0) {
                [mParams setValue:info.text forKey:info.saveKey];
            }
        }
        
        if([info.leftTip containsString:@"首单折扣"]) {firstDiscount = info;};
        if([info.leftTip containsString:@"特惠日折扣"]) {teHuiDiscount = info;};
        if([info.leftTip containsString:@"普通日折扣"]) {normalDiscount = info;};

    }
    
    if (firstDiscount.text.length && (firstDiscount.text.doubleValue >= 10 || firstDiscount.text.doubleValue <= 0)) {
        HLShowHint(@"请输入正确的首单折扣", self.view);
        return;
    }
    if (teHuiDiscount.text.length && (teHuiDiscount.text.doubleValue >= 10 || teHuiDiscount.text.doubleValue <= 0)) {
        HLShowHint(@"请输入正确的特惠日折扣", self.view);
        return;
    }
    if (normalDiscount.text.length && (normalDiscount.text.doubleValue >= 10 || normalDiscount.text.doubleValue <= 0)) {
        HLShowHint(@"请输入正确的普通日折扣", self.view);
        return;
    }
    
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Billpromotion/setBillPromotion";
        request.serverType = HLServerTypeStoreService;
        request.parameters = mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            HLShowText(@"设置成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 加载默认的数据
- (void)loadPageData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Billpromotion/getBillPromotion";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 如果有数据
            if ([responseObject.data count]) {
                HLPayPromoteInfo *promoteInfo = [HLPayPromoteInfo mj_objectWithKeyValues:responseObject.data];
                [self handleWithPromoteInfo:promoteInfo];
            }
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 处理数据
- (void)handleWithPromoteInfo:(HLPayPromoteInfo *)promoteInfo{
    
    // 是否开启推广
    HLRightSwitchInfo *promoteOnInfo = self.dataSource[0];
    promoteOnInfo.switchOn = promoteInfo.status == 1;
    promoteOnInfo.mParams = @{promoteOnInfo.saveKey:promoteOnInfo.switchOn ? @"1" : @"0"};
    
    // 首单折扣
    HLRightInputTypeInfo *firstDiscountInfo = self.dataSource[1];
    firstDiscountInfo.text = promoteInfo.firstDiscount;
    
    // 特惠日折扣
    HLPayPromoteDayInfo *teHuiDayInfo = self.dataSource[2];
    // 判断是否有特惠日
    if (promoteInfo.preDayTitle && promoteInfo.preDayTitle.length > 0) {
        HLPayPromoteDaySubInfo *subInfo = [[HLPayPromoteDaySubInfo alloc] init];
        subInfo.Id = promoteInfo.preDay;
        subInfo.name = promoteInfo.preDayTitle;
        teHuiDayInfo.selectInfo = subInfo;
        teHuiDayInfo.mParams = @{teHuiDayInfo.saveKey:subInfo.Id};
    }
    
    HLRightInputTypeInfo *teHuiDiscountInfo = self.dataSource[3];
    teHuiDiscountInfo.text = promoteInfo.preDiscount;
    
    HLRightInputTypeInfo *normalDiscountInfo = self.dataSource[4];
    normalDiscountInfo.text = promoteInfo.comDiscount;

    HLInputDateInfo *equalInputInfo = self.dataSource[5];
    equalInputInfo.swithOn = promoteInfo.isOrder == 1;
    equalInputInfo.mParams = @{equalInputInfo.saveKey:equalInputInfo.swithOn ? @"1" : @"0"};
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(100));
    
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

#pragma mark - HLPayPromoteDayCellDelegate

/// 选择日期
- (void)dayCell:(HLPayPromoteDayCell *)cell depentView:(UIView *)view{
    HLPayPromoteDayInfo *dayInfo = (HLPayPromoteDayInfo *)cell.baseInfo;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self loadAllDayInfo:dayInfo finish:^(NSArray<HLPayPromoteDaySubInfo *> *subDayInfos) {
        [HLDownSelectView showSelectViewWithTitles:dayInfo.titles currentTitle:dayInfo.selectInfo.name needShowSelect:YES showSeperator:NO itemHeight:FitPTScreen(35) dependView:view showType:HLDownSelectTypeAuto maxNum:7 hideCallBack:^{
            [cell resetImageViewAnimate];
        } callBack:^(NSInteger index) {
            dayInfo.selectInfo = dayInfo.subInfos[index];
            dayInfo.mParams = @{dayInfo.saveKey:dayInfo.selectInfo.Id};
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}

- (void)loadAllDayInfo:(HLPayPromoteDayInfo *)dayInfo finish:(void(^)(NSArray <HLPayPromoteDaySubInfo *>*subDayInfos))finish{
    
    if (dayInfo.subInfos.count) {
        if (finish) {
            finish(dayInfo.subInfos);
        }
        return;
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Billpromotion/getPreDay";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            NSArray *subInfos = [HLPayPromoteDaySubInfo mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            dayInfo.subInfos = subInfos;
            if (finish) {
                finish(dayInfo.subInfos);
            }
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - HLInputDateViewCellDelegate

-(void)dateCell:(HLInputDateViewCell *)cell switchON:(BOOL)on{
    HLInputDateInfo *dateInfo = (HLInputDateInfo *)cell.baseInfo;
    dateInfo.mParams = @{dateInfo.saveKey : dateInfo.swithOn ? @"1" : @"0"};
}

#pragma mark - HLRightSwitchViewCellDelegate

// 开关改变
- (void)switchViewCell:(HLRightSwitchViewCell *)cell switchChanged:(HLRightSwitchInfo *)switchInfo{
    switchInfo.mParams = @{switchInfo.saveKey:switchInfo.switchOn ? @"1" : @"0"};
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellTypeRightSwitch:
        {
            HLRightSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightSwitchViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypeDate:
        {
            HLInputDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLInputDateViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
            break;
        case HLInputCellTypePayPromoteDay:
        {
            HLPayPromoteDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLPayPromoteDayCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.delegate = self;
            return cell;
        }
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLPayPromoteDayCell class] forCellReuseIdentifier:@"HLPayPromoteDayCell"];
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLRightSwitchViewCell class] forCellReuseIdentifier:@"HLRightSwitchViewCell"];
        [_tableView registerClass:[HLInputDateViewCell class] forCellReuseIdentifier:@"HLInputDateViewCell"];
    }
    return _tableView;
}


-(NSArray *)dataSource{
    if (!_dataSource) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        HLRightSwitchInfo *promoteOnInfo = [[HLRightSwitchInfo alloc] init];
        promoteOnInfo.leftTip = @"开启推广";
        promoteOnInfo.cellHeight = FitPTScreen(53);
        promoteOnInfo.saveKey = @"status";
        promoteOnInfo.needCheckParams = NO;
        promoteOnInfo.mParams = @{promoteOnInfo.saveKey:promoteOnInfo.switchOn ? @"1" : @"0"};
        promoteOnInfo.type = HLInputCellTypeRightSwitch;
        promoteOnInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(17), 0, 0);
        [mArr addObject:promoteOnInfo];
        
        HLRightInputTypeInfo *firstDiscountInfo = [[HLRightInputTypeInfo alloc] init];
        firstDiscountInfo.leftTip = @"首单折扣";
        firstDiscountInfo.placeHoder = @"首单买单享受折扣，可不填";
        firstDiscountInfo.cellHeight = FitPTScreen(53);
        firstDiscountInfo.canInput = YES;
        firstDiscountInfo.rightText = @"折";
        firstDiscountInfo.saveKey = @"firstDiscount";
        firstDiscountInfo.needCheckParams = NO;
        firstDiscountInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        firstDiscountInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(17), 0, 0);
        [mArr addObject:firstDiscountInfo];
        
        HLPayPromoteDayInfo *teHuiDayInfo = [[HLPayPromoteDayInfo alloc] init];
        teHuiDayInfo.leftTip = @"特惠日折扣";
        teHuiDayInfo.type = HLInputCellTypePayPromoteDay;
        teHuiDayInfo.placeHorder = @"请选择优惠日";
        teHuiDayInfo.needCheckParams = NO;
        teHuiDayInfo.cellHeight = FitPTScreen(53);
        teHuiDayInfo.saveKey = @"preDay";
        teHuiDayInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(171), 0, 0);
        [mArr addObject:teHuiDayInfo];
        
        HLRightInputTypeInfo *teHuiDiscountInfo = [[HLRightInputTypeInfo alloc] init];
        teHuiDiscountInfo.leftTip = @"";
        teHuiDiscountInfo.placeHoder = @"特惠日可享受折扣，可不填";
        teHuiDiscountInfo.needCheckParams = NO;
        teHuiDiscountInfo.cellHeight = FitPTScreen(53);
        teHuiDiscountInfo.canInput = YES;
        teHuiDiscountInfo.rightText = @"折";
        teHuiDiscountInfo.saveKey = @"preDiscount";
        teHuiDiscountInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        teHuiDiscountInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(17), 0, 0);
        [mArr addObject:teHuiDiscountInfo];
        
        HLRightInputTypeInfo *normalDiscountInfo = [[HLRightInputTypeInfo alloc] init];
        normalDiscountInfo.leftTip = @"普通日折扣";
        normalDiscountInfo.placeHoder = @"除特惠日可享受折扣，可不填";
        normalDiscountInfo.needCheckParams = NO;
        normalDiscountInfo.cellHeight = FitPTScreen(53);
        normalDiscountInfo.canInput = YES;
        normalDiscountInfo.rightText = @"折";
        normalDiscountInfo.saveKey = @"comDiscount";
        normalDiscountInfo.keyBoardType = UIKeyboardTypeDecimalPad;
        normalDiscountInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(17), 0, 0);
        [mArr addObject:normalDiscountInfo];
        
        HLInputDateInfo *equalInputInfo = [[HLInputDateInfo alloc] init];
        equalInputInfo.leftTip = @"点单外卖享受同等折扣";
        equalInputInfo.placeHoder = @"开启点单外卖，可享受买单推广同等折扣";
        equalInputInfo.dateType = 1;
        equalInputInfo.saveKey = @"isOrder";
        equalInputInfo.swithOn = NO;
        equalInputInfo.needCheckParams = NO;
        equalInputInfo.mParams = @{equalInputInfo.saveKey : equalInputInfo.swithOn ? @"1" : @"0"};
        equalInputInfo.cellHeight = FitPTScreen(76);
        equalInputInfo.type = HLInputCellTypeDate;
        equalInputInfo.separatorInset = UIEdgeInsetsMake(0, FitPTScreen(17), 0, 0);
        [mArr addObject:equalInputInfo];
        
        _dataSource = [mArr copy];
    }
    return _dataSource;
}



@end
