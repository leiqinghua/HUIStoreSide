//
//  HLHotSekillInputController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillInputController.h"
#import "HLHotSekillInputController+SubType.h"

@interface HLHotSekillInputController () <UITableViewDelegate,UITableViewDataSource,HLRightDownSelectCellDelegate,HLRightInputViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HLHotSekillInputController

#pragma mark - Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布爆款秒杀";
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    [self creatFootViewWithButtonTitle:@"下一步 套餐详情"];
    
    /// 释放参数
    [[HLHotSekillTransporter sharedTransporter] resetAllParams];
    
    // 加载可以选择的两项数据
    [self loadDownSelectData];
    
    // 如果是编辑，则拉取详情
    if (self.isEdit) {
        [HLHotSekillTransporter sharedTransporter].isEdit = YES;
        [self loadEditDetailData];
    }
    
    // 设置编辑的 id参数和 type
    [[HLHotSekillTransporter sharedTransporter] appendParams:@{@"bidd":self.editId ?: @"", @"type":@(self.sekillType)}];
}

#pragma mark - Methods

- (void)hl_goback{
    NSString *message = self.isEdit ? @"确定要退出商品编辑吗？" : @"确定要退出商品发布吗？";
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:message buttonTitles:@[@"确定",@"取消"] buttonColors:@[UIColorFromRGB(0xFF9900),UIColorFromRGB(0x666666)] callBack:^(NSInteger index) {
        if (index == 0) {
            [super hl_goback];
        }
    }];
}

/// 编辑时拉取详情
- (void)loadEditDetailData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSide/SeckillInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"bid":self.editId ?: @"",@"type":@(self.sekillType)};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            // 数据回显
            if (self.sekillType == HLHotSekillTypeNormal || self.sekillType == HLHotSekillType40) {
                [self handleNormalAnd40EditData:responseObject.data];
            }else{
                [self handle20And30EditData:responseObject.data];
            }
            // 存储编辑的数据
            [HLHotSekillTransporter sharedTransporter].editModelData = responseObject.data;
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
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
            
            for (HLBaseTypeInfo *info in self.dataSource) {
                if ([info.leftTip containsString:@"是否提前预约"]) {
                    HLDownSelectInfo *orderTimeInfo = (HLDownSelectInfo *)info;
                    orderTimeInfo.subInfos = needOrderSubInfos;
                    [orderTimeInfo resetSelectSubInfo];
                    [orderTimeInfo buildParams];
                }else if([info.leftTip containsString:@"适用人数"]){
                    HLDownSelectInfo *presonNumInfo = (HLDownSelectInfo *)info;
                    presonNumInfo.subInfos = personNumSubInfos;
                    [presonNumInfo resetSelectSubInfo];
                    [presonNumInfo buildParams];
                }
            }
            
            [self.tableView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 保存信息
- (void)saveButtonClick{
    
    // 构建参数
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
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
    }
    
    NSArray *roles = @[];
    switch (self.sekillType) {
        case HLHotSekillTypeNormal:
            roles = [self sekillTypeNormalRoles];
            break;
        case HLHotSekillType20:
        {
            roles = [self sekillType20];
        }
            break;
        case HLHotSekillType30:
        {
            roles = [self sekillType30];
        }
            break;
        case HLHotSekillType40:
        {
            roles = [self sekillType40];
        }
            break;
    }
    
    for (NSDictionary *subRole in roles) {
        BOOL roleValue = [subRole[@"role"] boolValue];
        if (roleValue == YES) {
            HLShowHint(subRole[@"tip"], self.view);
            return;
        }
    }
    
    if (mParams) {
        // 设置参数缓存
        [[HLHotSekillTransporter sharedTransporter] appendParams:mParams];
        HLHotSekillDetailController *sekillDetail = [[HLHotSekillDetailController alloc] init];
        [self.navigationController pushViewController:sekillDetail animated:YES];
    }
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

/// 输入
- (void)inputViewCell:(HLRightInputViewCell *)cell textChanged:(HLRightInputTypeInfo *)inputInfo {
    
    if ([inputInfo.leftTip containsString:@"售价"]) {
        // 获取分佣的下标，修改分佣的价格
        NSInteger index = [self.dataSource indexOfObject:inputInfo] + 1;
        HLRightInputTypeInfo *fyInfo = [self.dataSource objectAtIndex:index];
        double fyMoney = inputInfo.text.doubleValue * 0.06;
        fyInfo.text = [NSString stringWithFormat:@"%.2lf",fyMoney];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    
    HLInputDateInfo *dateInfo = self.dataSource[indexPath.row];
    // 修改秒杀有效期
    if ([dateInfo.leftTip containsString:@"秒杀有效期"]) {
        if (!dateInfo.enabled) {return;}
        HLCalendarViewController *overView = [[HLCalendarViewController alloc] initWithCallBack:^(NSDate *start, NSDate *end) {
            dateInfo.text = [NSString stringWithFormat:@"%@ 至 %@",[HLTools formatterWithDate:start formate:@"yyyy-MM-dd"],[HLTools formatterWithDate:end formate:@"yyyy-MM-dd"]];
            dateInfo.mParams = @{
                @"startTime":[HLTools formatterWithDate:start formate:@"yyyy-MM-dd"],
                @"endTime":[HLTools formatterWithDate:end formate:@"yyyy-MM-dd"]
            };
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self presentViewController:overView animated:false completion:nil];
    }
    
    // 选择截止日期
    if ([dateInfo.leftTip containsString:@"消费截止日期"]) {
        if (!dateInfo.enabled) {return;}
        [HLTimeSingleSelectView showEditTimeView:dateInfo.text startWithToday:YES callBack:^(NSString * _Nonnull date) {
            dateInfo.text = date;
            dateInfo.mParams = @{@"closingDate":date};
            [self.tableView reloadData];
        }];
        return;
    }
}



#pragma mark - Getter

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
        _dataSource = [self buildDataSourceWithType:self.sekillType];
    }
    return _dataSource;
}

@end

// 获取详情
//https://sapi.51huilife.cn/HuiLife_Api/MerchantSide/SeckillInfo.php

//id    60528
//uid    1954147
//pid    1346191
//token    geXNqmoI2gcIFTPFuB53
//type    10
//bid    44714

//{
//    "code": 200,
//    "data": {
//        "id": "44714",
//        "title": "\u54c8\u54c8",
//        "logo": "http:\/\/aimg8.oss-cn-shanghai.aliyuncs.com\/HotSKAlbum\/47979_16283434241318.jpg",
//        "orgPrice": "100.00",
//        "price": "15.00",
//        "offerNum": "50",
//        "isSold": "0",
//        "upOrDown": "2",
//        "startTime": "2021-08-07",
//        "endTime": "2021-08-26",
//        "limitNum": "50",
//        "closingDate": "2021-08-07",
//        "booking": "0",
//        "setMealDetails": "[{\"remarks\":\"\u54c8\u54c8\",\"num\":\"1\",\"price\":\"10\",\"name\":\"\u963f\u554a\",\"unit\":\"\u4efd\"}]",
//        "summary": "",
//        "orderCnt": 0,
//        "usedCnt": 0,
//        "hitsCnt": 0,
//        "state": "\u5df2\u4e0b\u67b6",
//        "stateCode": 5,
//        "displayRack": "\u6682\u672a\u5f00\u653e\u6b64\u529f\u80fd",
//        "qrCode": "\u6682\u672a\u5f00\u653e\u6b64\u529f\u80fd",
//        "wechatMoments": "\u6682\u672a\u5f00\u653e\u6b64\u529f\u80fd",
//        "friendCircle": "\u6682\u672a\u5f00\u653e\u6b64\u529f\u80fd",
//        "popularize": "\u4e00\u822c",
//        "popularColor": "#80BCFF",
//        "album": "[{\"id\":\"32720\",\"business_id\":\"1954147\",\"store_id\":\"47979\",\"pro_id\":\"44714\",\"image\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283440061766.jpg\",\"is_del\":\"0\",\"input_time\":\"2021-08-07 21:46:46\",\"type\":\"0\",\"up_time\":\"2021-08-07 21:47:07\",\"del_time\":\"2021-08-07 21:46:46\",\"imgPath\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283440061766.jpg\"}]",
//        "master": "[{\"id\":\"32716\",\"business_id\":\"1954147\",\"store_id\":\"47979\",\"pro_id\":\"44714\",\"image\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283434241318.jpg\",\"is_del\":\"0\",\"input_time\":\"2021-08-07 21:37:04\",\"type\":\"1\",\"up_time\":\"2021-08-07 21:47:07\",\"del_time\":\"2021-08-07 21:37:04\",\"imgPath\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283434241318.jpg\"},{\"id\":\"32717\",\"business_id\":\"1954147\",\"store_id\":\"47979\",\"pro_id\":\"44714\",\"image\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283434261517.png\",\"is_del\":\"0\",\"input_time\":\"2021-08-07 21:37:06\",\"type\":\"1\",\"up_time\":\"2021-08-07 21:47:07\",\"del_time\":\"2021-08-07 21:37:06\",\"imgPath\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283434261517.png\"},{\"id\":\"32718\",\"business_id\":\"1954147\",\"store_id\":\"47979\",\"pro_id\":\"44714\",\"image\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283434261048.png\",\"is_del\":\"0\",\"input_time\":\"2021-08-07 21:37:06\",\"type\":\"1\",\"up_time\":\"2021-08-07 21:47:07\",\"del_time\":\"2021-08-07 21:37:06\",\"imgPath\":\"http:\\\/\\\/aimg8.oss-cn-shanghai.aliyuncs.com\\\/HotSKAlbum\\\/47979_16283434261048.png\"}]",
//        "invite_amount": "5.00",
//        "peoType": "1",
//        "type": 10
//    }
//}
