//
//  HLHotSekillInputController+SubType.m
//  HuiLife
//
//  Created by 王策 on 2021/8/7.
//

#import "HLHotSekillInputController+SubType.h"

@implementation HLHotSekillInputController (SubType)


/// 根据不同类型构建数据源数组
- (NSArray *)buildDataSourceWithType:(HLHotSekillType)sekillType{
    
    HLRightInputTypeInfo *goodNameInfo = [[HLRightInputTypeInfo alloc] init];
    goodNameInfo.leftTip = @"*标题";
    goodNameInfo.placeHoder = @"请输入抢购商品或套餐名称";
    goodNameInfo.cellHeight = FitPTScreen(53);
    goodNameInfo.canInput = YES;
    goodNameInfo.saveKey = @"title";
    goodNameInfo.errorHint = @"请输入抢购商品或套餐名称";
    goodNameInfo.needCheckParams = YES;
    
    HLRightInputTypeInfo *orinalPriceInfo = [[HLRightInputTypeInfo alloc] init];
    orinalPriceInfo.leftTip = @"*原价";
    orinalPriceInfo.placeHoder = @"¥商品原价";
    orinalPriceInfo.needCheckParams = YES;
    orinalPriceInfo.cellHeight = FitPTScreen(53);
    orinalPriceInfo.canInput = YES;
    orinalPriceInfo.saveKey = @"orgPrice";
    orinalPriceInfo.keyBoardType = UIKeyboardTypeDecimalPad;
    orinalPriceInfo.errorHint = @"请输入商品原价";
    
    HLRightInputTypeInfo *salePriceInfo = [[HLRightInputTypeInfo alloc] init];
    salePriceInfo.leftTip = @"*售价";
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
    sumNumInfo.leftTip = @"*提供数量";
    sumNumInfo.placeHoder = @"抢购总数量";
    sumNumInfo.rightText = @"份";
    sumNumInfo.cellHeight = FitPTScreen(53);
    sumNumInfo.canInput = YES;
    sumNumInfo.needCheckParams = YES;
    sumNumInfo.saveKey = @"offerNum";
    sumNumInfo.errorHint = @"请输入抢购总数量";
    sumNumInfo.keyBoardType = UIKeyboardTypeNumberPad;
    
    HLRightInputTypeInfo *buyNumInfo = [[HLRightInputTypeInfo alloc] init];
    buyNumInfo.leftTip = @"*每人限购";
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
    
    HLInputDateInfo *dateInfo = [[HLInputDateInfo alloc] init];
    dateInfo.leftTip = @"*消费截止日期";
    dateInfo.placeHoder = @"在消费截止日期内可使用";
    dateInfo.dateType = 0;
    dateInfo.errorHint = @"请选择消费截止日期";
    dateInfo.needCheckParams = YES;
    dateInfo.cellHeight = FitPTScreen(76);
    dateInfo.type = HLInputCellTypeDate;
    dateInfo.saveKey = @"closingDate";
    
    HLInputUseDescInfo *useInfo = [[HLInputUseDescInfo alloc]init];
    useInfo.leftTip = @"商品描述";
    useInfo.placeHolder = @"请输入使用描述";
    useInfo.type = HLInputCellTypeUseDesc;
    useInfo.cellHeight = FitPTScreen(149);
    useInfo.saveKey = @"summary";
    
    // 这里根据不同类型进行区分
    NSArray *result = @[];
    switch (sekillType) {
        case HLHotSekillTypeNormal:
        case HLHotSekillType40:
        {
            result = @[goodNameInfo,orinalPriceInfo,salePriceInfo,yjInfo,needOrderInfo,presonNumInfo,sumNumInfo,buyNumInfo,timeInfo,dateInfo,useInfo];
        }
            break;
        case HLHotSekillType20:
        case HLHotSekillType30:
        {
            orinalPriceInfo.leftTip = @"*价值";
            orinalPriceInfo.placeHoder = @"¥商品价值";
            result = @[goodNameInfo,orinalPriceInfo,needOrderInfo,sumNumInfo,buyNumInfo,timeInfo,dateInfo,useInfo];
        }
            break;
    }
    return result;
}

/// 默认类型
- (NSArray *)sekillTypeNormalRoles{
    
    HLBaseTypeInfo *orinalInfo = self.dataSource[1];    //  原价
    HLBaseTypeInfo *saleInfo = self.dataSource[2];      //  售价
    HLBaseTypeInfo *fyInfo = self.dataSource[3];        //  分销佣金
    HLBaseTypeInfo *sumNumInfo = self.dataSource[6];    //  总共的数量
    HLBaseTypeInfo *limitNumInfo = self.dataSource[7];  //  限购的数量
    
    // 原价*0.1 <= 售价 <= 原价*0.95
    NSString *compareTip = [NSString stringWithFormat:@"请设置售价范围(%.2lf~%.2lf)",orinalInfo.text.doubleValue * 0.1,orinalInfo.text.doubleValue * 0.95];
    
    // 跨店分佣的金额
    NSString *fySmallerTip = [NSString stringWithFormat:@"跨店分佣不能低于%.2lf元",saleInfo.text.doubleValue * 0.06];
    
    NSArray *roles = @[
        @{@"tip":@"原价应大于0",@"role":@(orinalInfo.text.doubleValue == 0)},
        @{@"tip":@"售价应大于0",@"role":@(saleInfo.text.doubleValue == 0)},
        @{@"tip":@"原价应大于售价",@"role":@(orinalInfo.text.doubleValue <= saleInfo.text.doubleValue)},
        @{@"tip":compareTip,@"role":@(saleInfo.text.doubleValue < orinalInfo.text.doubleValue * 0.1 || saleInfo.text.doubleValue > orinalInfo.text.doubleValue * 0.95)},
        @{@"tip":fySmallerTip,@"role":@(fyInfo.text.doubleValue < saleInfo.text.doubleValue * 0.06)},
        @{@"tip":@"跨店分佣不能大于售价",@"role":@(fyInfo.text.doubleValue > saleInfo.text.doubleValue)},
        @{@"tip":@"提供数量应大于0",@"role":@(sumNumInfo.text.integerValue <= 0)},
        @{@"tip":@"限购数量应大于0",@"role":@(limitNumInfo.text.integerValue <= 0)},
        @{@"tip":@"提供数量不能小于限购数量",@"role":@(sumNumInfo.text.integerValue < limitNumInfo.text.integerValue)},
    ];
    
    return roles;
}

///  亿元券兑换
- (NSArray *)sekillType20{
    HLBaseTypeInfo * priceInfo = self.dataSource[1];    //  价值
    HLBaseTypeInfo *sumNumInfo = self.dataSource[3];    //  总共的数量
    HLBaseTypeInfo *limitNumInfo = self.dataSource[4];  //  限购的数量
    NSArray *roles = @[
        @{@"tip":@"价值不能低于5元",@"role":@(priceInfo.text.doubleValue < 5)},
        @{@"tip":@"提供数量应大于0",@"role":@(sumNumInfo.text.integerValue <= 0)},
        @{@"tip":@"限购数量应大于0",@"role":@(limitNumInfo.text.integerValue <= 0)},
        @{@"tip":@"提供数量不能小于限购数量",@"role":@(sumNumInfo.text.integerValue < limitNumInfo.text.integerValue)},
    ];
    return roles;
}

/// 新人引流到店
- (NSArray *)sekillType30{
    HLBaseTypeInfo *priceInfo = self.dataSource[1];    //  价值
    HLBaseTypeInfo *sumNumInfo = self.dataSource[3];    //  总共的数量
    HLBaseTypeInfo *limitNumInfo = self.dataSource[4];  //  限购的数量
    NSArray *roles = @[
        @{@"tip":@"价值不能低于1元",@"role":@(priceInfo.text.doubleValue < 1)},
        @{@"tip":@"提供数量应大于0",@"role":@(sumNumInfo.text.integerValue <= 0)},
        @{@"tip":@"限购数量应大于0",@"role":@(limitNumInfo.text.integerValue <= 0)},
        @{@"tip":@"提供数量不能小于限购数量",@"role":@(sumNumInfo.text.integerValue < limitNumInfo.text.integerValue)},
    ];
    return roles;
}

/// 签约爆客推广
- (NSArray *)sekillType40{
    HLBaseTypeInfo *orinalInfo = self.dataSource[1];    //  原价
    HLBaseTypeInfo *saleInfo = self.dataSource[2];      //  售价
    HLBaseTypeInfo *fyInfo = self.dataSource[3];        //  分销佣金
    HLBaseTypeInfo *sumNumInfo = self.dataSource[6];    //  总共的数量
    HLBaseTypeInfo *limitNumInfo = self.dataSource[7];  //  限购的数量
    
    // 原价*0.1 <= 售价 <= 原价*0.6
    NSString *compareTip = [NSString stringWithFormat:@"请设置售价范围(%.2lf~%.2lf)",orinalInfo.text.doubleValue * 0.1,orinalInfo.text.doubleValue * 0.6];
    
    // 跨店分佣的金额
    NSString *fySmallerTip = [NSString stringWithFormat:@"跨店分佣不能低于%.2lf元",saleInfo.text.doubleValue * 0.06];
    
    NSArray *roles = @[
        @{@"tip":@"原价应大于0",@"role":@(orinalInfo.text.doubleValue == 0)},
        @{@"tip":@"售价应大于0",@"role":@(saleInfo.text.doubleValue == 0)},
        @{@"tip":@"原价应大于售价",@"role":@(orinalInfo.text.doubleValue <= saleInfo.text.doubleValue)},
        @{@"tip":compareTip,@"role":@(saleInfo.text.doubleValue < orinalInfo.text.doubleValue * 0.1 || saleInfo.text.doubleValue > orinalInfo.text.doubleValue * 0.6)},
        @{@"tip":fySmallerTip,@"role":@(fyInfo.text.doubleValue < saleInfo.text.doubleValue * 0.06)},
        @{@"tip":@"跨店分佣不能大于售价",@"role":@(fyInfo.text.doubleValue > saleInfo.text.doubleValue)},
        @{@"tip":@"提供数量应大于0",@"role":@(sumNumInfo.text.integerValue <= 0)},
        @{@"tip":@"限购数量应大于0",@"role":@(limitNumInfo.text.integerValue <= 0)},
        @{@"tip":@"提供数量不能小于限购数量",@"role":@(sumNumInfo.text.integerValue < limitNumInfo.text.integerValue)},
    ];
    
    return roles;
}

/// 默认类型 & 签约爆客推广类型配置编辑的详情数据
- (void)handleNormalAnd40EditData:(NSDictionary *)dataDict{
    // 标题
    HLRightInputTypeInfo *goodNameInfo = self.dataSource[0];
    goodNameInfo.text = dataDict[@"title"];
    // 原价
    HLRightInputTypeInfo *orinalPriceInfo = self.dataSource[1];
    orinalPriceInfo.text = [HLTools safeStringObject:dataDict[@"orgPrice"]];

    // 售价
    HLRightInputTypeInfo *salePriceInfo = self.dataSource[2];
    salePriceInfo.text = [HLTools safeStringObject:dataDict[@"price"]];

    // 佣金
    HLRightInputTypeInfo *yjInfo = self.dataSource[3];
    yjInfo.text = [HLTools safeStringObject:dataDict[@"invite_amount"]];
    // 是否提前预约
    HLDownSelectInfo *needOrderInfo = self.dataSource[4];
    NSInteger bookingId = [dataDict[@"booking"] integerValue];
    needOrderInfo.selectSubInfoId = bookingId;
    needOrderInfo.mParams = @{needOrderInfo.saveKey : @(bookingId)};
    [needOrderInfo resetSelectSubInfo];
    
    // 适用人数
    HLDownSelectInfo *presonNumInfo = self.dataSource[5];
    NSInteger peoType = [dataDict[@"peoType"] integerValue];
    presonNumInfo.selectSubInfoId = peoType;
    presonNumInfo.mParams = @{needOrderInfo.saveKey : @(peoType)};
    [presonNumInfo resetSelectSubInfo];
    
    // 提供数量
    HLRightInputTypeInfo *sumNumInfo = self.dataSource[6];
    sumNumInfo.text = [HLTools safeStringObject:dataDict[@"offerNum"]];

    // 限购数量
    HLRightInputTypeInfo *buyNumInfo = self.dataSource[7];
    buyNumInfo.text = [HLTools safeStringObject:dataDict[@"limitNum"]];

    // 秒杀有效期
    HLInputDateInfo *timeInfo = self.dataSource[8];
    timeInfo.text = [NSString stringWithFormat:@"%@ 至 %@",[HLTools safeStringObject:dataDict[@"startTime"]],[HLTools safeStringObject:dataDict[@"endTime"]]];
    timeInfo.mParams = @{
        @"startTime":[HLTools safeStringObject:dataDict[@"startTime"]],
        @"endTime":[HLTools safeStringObject:dataDict[@"endTime"]]
    };
    // 消费截止日期
    HLInputDateInfo *dateInfo = self.dataSource[9];
    dateInfo.text = [HLTools safeStringObject:dataDict[@"closingDate"]];
    dateInfo.mParams = @{@"closingDate":dateInfo.text};
    
    // 备注
    HLInputUseDescInfo *useInfo = self.dataSource[10];
    useInfo.text = [HLTools safeStringObject:dataDict[@"summary"]];
}

/// 亿元券 & 新客引流类型配置编辑的详情数据
- (void)handle20And30EditData:(NSDictionary *)dataDict{
    // 标题
    HLRightInputTypeInfo *goodNameInfo = self.dataSource[0];
    goodNameInfo.text = dataDict[@"title"];
    // 价值
    HLRightInputTypeInfo *priceInfo = self.dataSource[1];
    priceInfo.text = [HLTools safeStringObject:dataDict[@"orgPrice"]];
    // 是否提前预约
    HLDownSelectInfo *needOrderInfo = self.dataSource[4];
    NSInteger bookingId = [dataDict[@"booking"] integerValue];
    needOrderInfo.selectSubInfoId = bookingId;
    needOrderInfo.mParams = @{needOrderInfo.saveKey : @(bookingId)};
    [needOrderInfo resetSelectSubInfo];
    
    // 提供数量
    HLRightInputTypeInfo *sumNumInfo = self.dataSource[6];
    sumNumInfo.text = [HLTools safeStringObject:dataDict[@"offerNum"]];

    // 限购数量
    HLRightInputTypeInfo *buyNumInfo = self.dataSource[7];
    buyNumInfo.text = [HLTools safeStringObject:dataDict[@"limitNum"]];

    // 秒杀有效期
    HLInputDateInfo *timeInfo = self.dataSource[8];
    timeInfo.text = [NSString stringWithFormat:@"%@ 至 %@",[HLTools safeStringObject:dataDict[@"startTime"]],[HLTools safeStringObject:dataDict[@"endTime"]]];
    timeInfo.mParams = @{
        @"startTime":[HLTools safeStringObject:dataDict[@"startTime"]],
        @"endTime":[HLTools safeStringObject:dataDict[@"endTime"]]
    };
    // 消费截止日期
    HLInputDateInfo *dateInfo = self.dataSource[9];
    dateInfo.text = [HLTools safeStringObject:dataDict[@"closingDate"]];
    // 备注
    HLInputUseDescInfo *useInfo = self.dataSource[10];
    useInfo.text = [HLTools safeStringObject:dataDict[@"summary"]];
}


@end
