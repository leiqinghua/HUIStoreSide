//
//  HLHUIProfitInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/25.
//

#import "HLHUIProfitInfo.h"
#import "HLProfitGoodInfo.h"

@interface HLHUIProfitInfo ()

@property(nonatomic, strong)HLRightInputTypeInfo *dateInfo;

@end

@implementation HLHUIProfitInfo

- (void)setEditProfitInfo:(HLProfitGoodInfo *)editProfitInfo {
    _editProfitInfo = editProfitInfo;
    self.type = editProfitInfo.gainType;
}

- (void)setType:(NSInteger)type {
    _type = type;
    switch (_type) {
        case 1:
        case 3:
        case 2:
            [self.datasource removeAllObjects];
            break;
        case 43:
        case 27:
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:self.serviceSource];
        }
            break;
        case 42:case 26:
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:self.voucherSource];
        }
            break;
        case 41:
        case 25:
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:self.discountSource];
        }
            break;
        case 21:
        case 22:
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:self.giftSource];
        }
            break;
        case 61:
        {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:self.redPacketSource];
        }
        default:
            break;
    }
}

#pragma mark - 服务卡数据

- (NSMutableArray *)serviceSource {
    if (!_serviceSource) {
        
        HLProfitServiceInfo *info = (HLProfitServiceInfo *)_editProfitInfo;
        
        _serviceSource = [NSMutableArray array];
        HLRightInputTypeInfo *name = [[HLRightInputTypeInfo alloc]init];
        name.leftTip = @"* 卡名称";
        name.placeHoder = @"请输入卡名称";
        name.errorHint = @"请输入卡名称";
        name.needCheckParams = YES;
        name.canInput = YES;
        name.cellHeight = FitPTScreen(50);
        name.text = info?info.gainName:@"";
        name.saveKey = @"gainName";
        [_serviceSource addObject:name];
        
        HLRightInputTypeInfo *num = [[HLRightInputTypeInfo alloc]init];
        num.leftTip = @"* 卡次数";
        num.placeHoder = @"请输入体验卡次数";
        num.errorHint = @"请输入体验卡次数";
        num.needCheckParams = YES;
        num.canInput = YES;
        num.keyBoardType = UIKeyboardTypeNumberPad;
        num.cellHeight = FitPTScreen(50);
        num.saveKey = @"gainNum";
        num.text = info?[NSString stringWithFormat:@"%ld",info.gainNum]:@"";
        [_serviceSource addObject:num];
        
        HLInputDateInfo *gift = [[HLInputDateInfo alloc]init];
        gift.type = HLInputCellTypeDate;
        gift.leftTip = @"月月赠送";
        gift.placeHoder = @"开启后，按月给顾客赠送服务卡";
        gift.cellHeight = FitPTScreen(67);
        gift.dateType = 1;
        gift.swithOn = info.open;
        gift.saveKey = @"open";
        gift.text = [NSString stringWithFormat:@"%d",info.open];
        gift.swithOn = info.open;
        [_serviceSource addObject:gift];
        
        if (!info.open) {
            _dateInfo = [[HLRightInputTypeInfo alloc]init];
            _dateInfo.leftTip = @"* 使用有效期";
            _dateInfo.placeHoder = @"请选择使用有效期";
            _dateInfo.errorHint = @"请选择使用有效期";
            _dateInfo.needCheckParams = YES;
            _dateInfo.showRightArrow = YES;
            _dateInfo.keyBoardType = UIKeyboardTypeNumberPad;
            _dateInfo.cellHeight = FitPTScreen(50);
            _dateInfo.text = info?[NSString stringWithFormat:@"%@-%@",info.startDate,info.endDate]:@"";
            _dateInfo.mParams = @{@"startDate":info.startDate?:@"",@"endDate":info.endDate?:@""};
            [_serviceSource addObject:_dateInfo];
        }
        
        HLInputUseDescInfo *desc = [[HLInputUseDescInfo alloc]init];
        desc.type = HLInputCellTypeUseDesc;
        desc.placeHolder = @"请填写使用说明 如：填写商品特色或其他说明";
        desc.leftTip = @"* 使用说明";
        desc.errorHint = @"请填写使用说明";
        desc.needCheckParams = YES;
        desc.singleLine = YES;
        desc.cellHeight = FitPTScreen(110);
        desc.showNum = YES;
        desc.maxNum = 50;
        desc.hideBorder = YES;
        desc.saveKey = @"gainDesc";
        desc.text = info?[info.gainDesc filterwithRegex:@"\n"]:@"";
        [_serviceSource addObject:desc];
    }
    return _serviceSource;
}

#pragma mark - 代金券数据

- (NSMutableArray *)voucherSource {
    if (!_voucherSource) {
        
        HLProfitVoucherInfo *info = (HLProfitVoucherInfo *)_editProfitInfo;
        
        _voucherSource = [NSMutableArray array];
        HLRightInputTypeInfo *price = [[HLRightInputTypeInfo alloc]init];
        price.leftTip = @"* 券金额";
        price.errorHint = @"输入使用时优惠的金额";
        price.rightText = @"元";
        price.placeHoder = @"使用时优惠的金额";
        price.needCheckParams = YES;
        price.canInput = YES;
        price.keyBoardType = UIKeyboardTypeDecimalPad;
        price.cellHeight = FitPTScreen(50);
        price.saveKey = @"gainPrice";
        price.text = info?info.gainPrice:@"";
        [_voucherSource addObject:price];
        
        HLRightInputTypeInfo *limit = [[HLRightInputTypeInfo alloc]init];
        limit.leftTip = @"限额使用";
        limit.rightText = @"元";
        limit.placeHoder = @"满多少元可使用券，可不填";
        limit.canInput = YES;
        limit.keyBoardType = UIKeyboardTypeDecimalPad;
        limit.cellHeight = FitPTScreen(50);
        limit.saveKey = @"limit";
        limit.text = info?info.limit:@"";
        [_voucherSource addObject:limit];
        
        HLRightInputTypeInfo *num = [[HLRightInputTypeInfo alloc]init];
        num.leftTip = @"* 数量";
        num.placeHoder = @"请输入要赠送的数量";
        num.errorHint = @"请输入要赠送的数量";
        num.canInput = YES;
        num.needCheckParams = YES;
        num.keyBoardType = UIKeyboardTypeNumberPad;
        num.cellHeight = FitPTScreen(50);
        num.saveKey = @"gainNum";
        num.text = info?[NSString stringWithFormat:@"%ld",info.gainNum]:@"";
        [_voucherSource addObject:num];
        
        HLInputDateInfo *gift = [[HLInputDateInfo alloc]init];
        gift.type = HLInputCellTypeDate;
        gift.leftTip = @"月月赠送";
        gift.placeHoder = @"开启后，按月给顾客赠送代金券";
        gift.cellHeight = FitPTScreen(67);
        gift.dateType = 1;
        gift.swithOn = info.open;
        gift.saveKey = @"open";
        gift.text = [NSString stringWithFormat:@"%d",info.open];
        gift.swithOn = info.open;
        [_voucherSource addObject:gift];
        
        if (!info.open) {
            _dateInfo = [[HLRightInputTypeInfo alloc]init];
            _dateInfo.leftTip = @"* 使用有效期";
            _dateInfo.placeHoder = @"请选择使用有效期";
            _dateInfo.errorHint = @"请选择使用有效期";
            _dateInfo.needCheckParams = YES;
            _dateInfo.showRightArrow = YES;
            _dateInfo.keyBoardType = UIKeyboardTypeNumberPad;
            _dateInfo.cellHeight = FitPTScreen(50);
            _dateInfo.text = info?[NSString stringWithFormat:@"%@-%@",info.startDate,info.endDate]:@"";
            _dateInfo.mParams = @{@"startDate":info.startDate?:@"",@"endDate":info.endDate?:@""};
            [_voucherSource addObject:_dateInfo];
        }
        
        HLInputUseDescInfo *desc = [[HLInputUseDescInfo alloc]init];
        desc.type = HLInputCellTypeUseDesc;
        desc.placeHolder = @"请填写使用说明 如：填写商品特色或其他说明";
        desc.leftTip = @"* 使用说明";
        desc.errorHint = @"请填写使用说明";
        desc.needCheckParams = YES;
        desc.cellHeight = FitPTScreen(110);
        desc.showNum = YES;
        desc.maxNum = 50;
        desc.singleLine = YES;
        desc.hideBorder = YES;
        desc.saveKey = @"gainDesc";
        desc.text = info?[info.gainDesc filterwithRegex:@"\n"]:@"";
        [_voucherSource addObject:desc];
    }
    return _voucherSource;
}


#pragma mark - 打折券

- (NSMutableArray *)discountSource {
    if (!_discountSource) {
        _discountSource = [NSMutableArray array];
        
        HLProfitDiscountInfo *info = (HLProfitDiscountInfo *)_editProfitInfo;
        
        HLRightEditNumInfo *numInfo = [[HLRightEditNumInfo alloc]init];
        numInfo.leftTip = @"* 设置券折扣";
        numInfo.needCheckParams = YES;
        numInfo.type = HLInputCellRightEditNum;
        numInfo.rightTip = @"折";
        numInfo.intMin = 0;
        numInfo.dotMin = 1;
        numInfo.saveKey = @"gainPrice";
        numInfo.text = info?info.gainPrice:@"0.1";
        numInfo.cellHeight = FitPTScreen(65);
        [_discountSource addObject:numInfo];
        
        HLRightInputTypeInfo *price = [[HLRightInputTypeInfo alloc]init];
        price.leftTip = @"限额使用";
        price.rightText = @"元";
        price.placeHoder = @"满多少元可使用券，可不填";
        price.canInput = YES;
        price.keyBoardType = UIKeyboardTypeDecimalPad;
        price.cellHeight = FitPTScreen(50);
        price.saveKey = @"limit";
        price.text = info?info.limit:@"";
        [_discountSource addObject:price];
        
        HLRightInputTypeInfo *num = [[HLRightInputTypeInfo alloc]init];
        num.leftTip = @"* 数量";
        num.placeHoder = @"请输入要赠送的数量";
        num.errorHint = @"请输入要赠送的数量";
        num.canInput = YES;
        num.needCheckParams = YES;
        num.keyBoardType = UIKeyboardTypeNumberPad;
        num.cellHeight = FitPTScreen(50);
        num.saveKey = @"gainNum";
        num.text = info?[NSString stringWithFormat:@"%ld",info.gainNum]:@"";
        [_discountSource addObject:num];
        
        HLInputDateInfo *gift = [[HLInputDateInfo alloc]init];
        gift.type = HLInputCellTypeDate;
        gift.leftTip = @"月月赠送";
        gift.placeHoder = @"开启后，按月给顾客赠送打折券";
        gift.cellHeight = FitPTScreen(67);
        gift.dateType = 1;
        gift.swithOn = info.open;
        gift.saveKey = @"open";
        gift.text = [NSString stringWithFormat:@"%d",info.open];
        gift.swithOn = info.open;
        [_discountSource addObject:gift];
        
        if (!info.open) {
            _dateInfo = [[HLRightInputTypeInfo alloc]init];
            _dateInfo.leftTip = @"* 使用有效期";
            _dateInfo.placeHoder = @"请选择使用有效期";
            _dateInfo.errorHint = @"请选择使用有效期";
            _dateInfo.needCheckParams = YES;
            _dateInfo.showRightArrow = YES;
            _dateInfo.keyBoardType = UIKeyboardTypeNumberPad;
            _dateInfo.cellHeight = FitPTScreen(50);
            _dateInfo.text = info?[NSString stringWithFormat:@"%@-%@",info.startDate,info.endDate]:@"";
            _dateInfo.mParams = @{@"startDate":info.startDate?:@"",@"endDate":info.endDate?:@""};
            [_discountSource addObject:_dateInfo];
        }
        
        HLInputUseDescInfo *desc = [[HLInputUseDescInfo alloc]init];
        desc.type = HLInputCellTypeUseDesc;
        desc.placeHolder = @"请填写使用说明 如：填写商品特色或其他说明";
        desc.leftTip = @"* 使用说明";
        desc.errorHint = @"请填写使用说明";
        desc.needCheckParams = YES;
        desc.cellHeight = FitPTScreen(110);
        desc.showNum = YES;
        desc.maxNum = 50;
        desc.singleLine = YES;
        desc.hideBorder = YES;
        desc.saveKey = @"gainDesc";
        desc.text = info?[info.gainDesc filterwithRegex:@"\n"]:@"";
        [_discountSource addObject:desc];
    }
    return _discountSource;
}

#pragma mark - 礼品/赠品

- (NSMutableArray *)giftSource {
    if (!_giftSource) {
        _giftSource = [NSMutableArray array];
        
        HLProfitGiftInfo *info = (HLProfitGiftInfo *)_editProfitInfo;
        
        HLRightInputTypeInfo *name = [[HLRightInputTypeInfo alloc]init];
        name.leftTip = @"* 商品名称";
        name.placeHoder = @"请输入商品名称";
        name.errorHint = @"请输入商品名称";
        name.needCheckParams = YES;
        name.canInput = YES;
        name.cellHeight = FitPTScreen(50);
        name.saveKey = @"gainName";
        name.text = info?info.gainName:@"";
        [_giftSource addObject:name];
        
        HLRightInputTypeInfo *price = [[HLRightInputTypeInfo alloc]init];
        price.leftTip = @"* 商品价值";
        price.placeHoder = @"请输入商品价值多少钱";
        price.errorHint = @"请输入商品价值多少钱";
        price.canInput = YES;
        price.needCheckParams = YES;
        price.keyBoardType = UIKeyboardTypeDecimalPad;
        price.cellHeight = FitPTScreen(50);
        price.saveKey = @"gainPrice";
        price.text = info?info.gainPrice:@"";
        [_giftSource addObject:price];
        
        HLInputImagesInfo *imageInfo = [[HLInputImagesInfo alloc]init];
        imageInfo.leftTip = @"* 商品图片";
        imageInfo.single = YES;
        imageInfo.type = HLInputPickImagesType;
        imageInfo.saveKey = @"imgLogo";
        imageInfo.text = info?info.imgLogo:@"";
        imageInfo.pics = info?@[info.imgLogo]:@[];
        imageInfo.errorHint = @"请选择图片";
        [_giftSource addObject:imageInfo];
        
        HLRightInputTypeInfo *num = [[HLRightInputTypeInfo alloc]init];
        num.leftTip = @"* 数量";
        num.placeHoder = @"请输入要赠送的数量";
        num.errorHint = @"请输入要赠送的数量";
        num.canInput = YES;
        num.needCheckParams = YES;
        num.keyBoardType = UIKeyboardTypeNumberPad;
        num.cellHeight = FitPTScreen(50);
        num.saveKey = @"gainNum";
        num.text = info?[NSString stringWithFormat:@"%ld",info.gainNum]:@"";
        [_giftSource addObject:num];
        
        HLInputDateInfo *gift = [[HLInputDateInfo alloc]init];
        gift.type = HLInputCellTypeDate;
        gift.leftTip = @"月月赠送";
        gift.placeHoder = @"开启后，按月给顾客赠送实物";
        gift.cellHeight = FitPTScreen(67);
        gift.dateType = 1;
        gift.saveKey = @"open";
        gift.text = [NSString stringWithFormat:@"%d",info.open];
        gift.swithOn = info.open;
        [_giftSource addObject:gift];
        
        if (!info.open) {
            _dateInfo = [[HLRightInputTypeInfo alloc]init];
            _dateInfo.leftTip = @"* 使用有效期";
            _dateInfo.placeHoder = @"请选择使用有效期";
            _dateInfo.errorHint = @"请选择使用有效期";
            _dateInfo.needCheckParams = YES;
            _dateInfo.showRightArrow = YES;
            _dateInfo.keyBoardType = UIKeyboardTypeNumberPad;
            _dateInfo.cellHeight = FitPTScreen(50);
            _dateInfo.text = info?[NSString stringWithFormat:@"%@-%@",info.startDate,info.endDate]:@"";
            _dateInfo.mParams = @{@"startDate":info.startDate?:@"",@"endDate":info.endDate?:@""};
            [_giftSource addObject:_dateInfo];
        }
        
        HLInputUseDescInfo *desc = [[HLInputUseDescInfo alloc]init];
        desc.type = HLInputCellTypeUseDesc;
        desc.placeHolder = @"请填写使用说明 如：填写商品特色或其他说明";
        desc.leftTip = @"* 使用说明";
        desc.errorHint = @"请填写使用说明";
        desc.needCheckParams = YES;
        desc.cellHeight = FitPTScreen(110);
        desc.showNum = YES;
        desc.maxNum = 50;
        desc.singleLine = YES;
        desc.hideBorder = YES;
        desc.saveKey = @"gainDesc";
        desc.text = info?[info.gainDesc filterwithRegex:@"\n"]:@"";
        [_giftSource addObject:desc];
    }
    return _giftSource;
}

#pragma mark - 外卖红包

- (NSMutableArray *)redPacketSource{
    if (!_redPacketSource) {
        _redPacketSource = [NSMutableArray array];
        HLProfitRedPacketInfo *info = (HLProfitRedPacketInfo *)_editProfitInfo;

        HLRightInputTypeInfo *name = [[HLRightInputTypeInfo alloc]init];
        name.leftTip = @"* 赠送金额";
        name.placeHoder = @"请输入赠送外卖红包金额";
        name.errorHint = @"请输入赠送外卖红包金额";
        name.needCheckParams = YES;
        name.canInput = YES;
        name.rightText = @"元";
        name.keyBoardType = UIKeyboardTypeDecimalPad;
        name.cellHeight = FitPTScreen(50);
        name.saveKey = @"gainPrice";
        name.separatorInset = UIEdgeInsetsMake(0, ScreenW, 0, 0);
        name.text = info ? info.gainPrice :@"";
        [_redPacketSource addObject:name];
        
        NSArray *gainInfos = info ? info.disOut : [HLProfitRedPacketGainInfo mj_objectArrayWithKeyValuesArray:self.redPacketMenuItems];
        
        for (NSInteger i = 0; i < gainInfos.count; i++) {
            HLProfitRedPacketGainInfo *gainInfo = gainInfos[i];
            HLRedPacketClassInfo *classInfo = [[HLRedPacketClassInfo alloc] init];
            classInfo.leftTip = gainInfo.title;
            classInfo.text = gainInfo.discount;
            classInfo.class_id = gainInfo.class_id;
            classInfo.gain_id = gainInfo.gain_id;
            classInfo.type = HLInputRedPacketClassType;
            if (i == 0) {
                classInfo.showTopPlace = YES;
            }
            if (i == gainInfos.count - 1) {
                classInfo.showBottomPlace = YES;
                
            }
            [_redPacketSource addObject:classInfo];
        }
        
        HLInputUseDescInfo *desc = [[HLInputUseDescInfo alloc]init];
        desc.type = HLInputCellTypeUseDesc;
        desc.placeHolder = @"请填写外卖红包使用规则说明";
        desc.leftTip = @"* 使用说明";
        desc.errorHint = @"请填写使用说明";
        desc.needCheckParams = YES;
        desc.cellHeight = FitPTScreen(110);
        desc.showNum = YES;
        desc.maxNum = 50;
        desc.singleLine = YES;
        desc.hideBorder = YES;
        desc.saveKey = @"gainDesc";
        desc.text = info ? [info.gainDesc filterwithRegex:@"\n"]:@"";
        [_redPacketSource addObject:desc];
    }
    return _redPacketSource;
}

//是否开启月月赠送
- (void)monthGiftOpen:(BOOL)open {
    if (!open && !_dateInfo) {
        _dateInfo = [[HLRightInputTypeInfo alloc]init];
        _dateInfo.leftTip = @"* 使用有效期";
        _dateInfo.placeHoder = @"请选择使用有效期";
        _dateInfo.errorHint = @"请选择使用有效期";
        _dateInfo.needCheckParams = YES;
        _dateInfo.showRightArrow = YES;
        _dateInfo.keyBoardType = UIKeyboardTypeNumberPad;
        _dateInfo.cellHeight = FitPTScreen(50);
    }
  
    if (open) { //打开，给时间置空
        _dateInfo.mParams = @{@"startDate":@"",@"endDate":@""};
        if (_editProfitInfo) {
            [_editProfitInfo mj_setKeyValues:_dateInfo.mParams];
        }
    }
    
    if (_type == 43||_type == 27) {
         _type = open?27:43;
        if (!open) {
            if (![self.serviceSource containsObject:_dateInfo]) {
                [self.serviceSource insertObject:_dateInfo atIndex:3];
            }
        } else {
            if ([self.serviceSource containsObject:_dateInfo]) {
                [self.serviceSource removeObject:_dateInfo];
            }
        }
    }
    
    if (_type == 42||_type == 26) {
        _type = open?26:42;
        if (!open) {
            if (![self.voucherSource containsObject:_dateInfo]) {
                [self.voucherSource insertObject:_dateInfo atIndex:4];
            }
        } else {
            if ([self.voucherSource containsObject:_dateInfo]) {
                [self.voucherSource removeObject:_dateInfo];
            }
        }
    }
    
    if (_type == 41 || _type == 25) {
        _type = open?25:41;
        if (!open) {
            if (![self.discountSource containsObject:_dateInfo]) {
                [self.discountSource insertObject:_dateInfo atIndex:4];
            }
        } else {
            if ([self.discountSource containsObject:_dateInfo]) {
                [self.discountSource removeObject:_dateInfo];
            }
        }
    }
    
    if (_type == 21 || _type == 22) {
        _type = open?22:21;
        if (!open) {
            if (![self.giftSource containsObject:_dateInfo]) {
                [self.giftSource insertObject:_dateInfo atIndex:5];
            }
        } else {
            if ([self.giftSource containsObject:_dateInfo]) {
                [self.giftSource removeObject:_dateInfo];
            }
        }
    }
    [self setType:_type];
}

- (HLProfitGoodInfo *)createProfitGoodInfo {
    HLProfitGoodInfo *goodInfo;
    if (_type == 43 || _type == 27) {
        goodInfo = [[HLProfitServiceInfo alloc]init];
    }
    
    if (_type == 42 || _type == 26) {
        goodInfo = [[HLProfitVoucherInfo alloc]init];
    }
    
    if (_type == 41 || _type == 25) {
        goodInfo = [[HLProfitDiscountInfo alloc]init];
    }
    
    if (_type == 21 || _type == 22) {
        goodInfo = [[HLProfitGiftInfo alloc]init];
    }
    
    if (_type == 61) {
        goodInfo = [[HLProfitRedPacketInfo alloc] init];
    }
    
    // 外卖红包和其他的不一样
    if (_type == 61) {
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        for (HLBaseTypeInfo *info in self.datasource) {
            if ([info isMemberOfClass:[HLRedPacketClassInfo class]]) {
                HLProfitRedPacketGainInfo *gainInfo = [[HLProfitRedPacketGainInfo alloc] init];
                gainInfo.title = info.leftTip;
                gainInfo.discount = info.text;
                gainInfo.class_id = ((HLRedPacketClassInfo *)info).class_id;
                gainInfo.gain_id = ((HLRedPacketClassInfo *)info).gain_id;
                [mArr addObject:gainInfo];
            }else{
                if (info.saveKey.length) {
                    [goodInfo setValue:info.text forKey:info.saveKey];
                }
                if (info.mParams.count) {
                    [goodInfo mj_setKeyValues:info.mParams];
                }
            }
        }
        [(HLProfitRedPacketInfo *)goodInfo setDisOut:[mArr copy]];
    }else{
        for (HLBaseTypeInfo *info in self.datasource) {
            if (info.saveKey.length) {
                [goodInfo setValue:info.text forKey:info.saveKey];
            }
            if (info.mParams.count) {
                [goodInfo mj_setKeyValues:info.mParams];
            }
        }
    }
    // 设置类型
    goodInfo.gainType = _type;
    // 如果是 21 或者 22，区分是首单还是月月
    if(_type == 21 || _type == 22){
        BOOL isOpen = [(HLProfitGiftInfo *)goodInfo open];
        [(HLProfitGiftInfo *)goodInfo setGainType: isOpen ? 22 : 21];
    }
    
    return goodInfo;
}

- (void)configEditProfitGoodInfo {
    
    // 外卖红包和其他的不一样
    if (self.type == 61) {
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        for (HLBaseTypeInfo *info in self.datasource) {
            if ([info isMemberOfClass:[HLRedPacketClassInfo class]]) {
                HLProfitRedPacketGainInfo *gainInfo = [[HLProfitRedPacketGainInfo alloc] init];
                gainInfo.title = info.leftTip;
                gainInfo.discount = info.text;
                gainInfo.class_id = ((HLRedPacketClassInfo *)info).class_id;
                gainInfo.gain_id = ((HLRedPacketClassInfo *)info).gain_id;
                [mArr addObject:gainInfo];
            }else{
                if (info.saveKey.length) {
                    [_editProfitInfo setValue:info.text forKey:info.saveKey];
                }
                if (info.mParams.count) {
                    [_editProfitInfo mj_setKeyValues:info.mParams];
                }
            }
        }
        [(HLProfitRedPacketInfo *)_editProfitInfo setDisOut:[mArr copy]];
    }else{
        for (HLBaseTypeInfo *info in self.datasource) {
            if (info.saveKey.length) {
                [_editProfitInfo setValue:info.text forKey:info.saveKey];
            }
            if (info.mParams.count) {
                [_editProfitInfo mj_setKeyValues:info.mParams];
            }
        }
    }
    _editProfitInfo.gainType = self.type;
    
    // 如果是 21 或者 22，区分是首单还是月月
    if(_type == 21 || _type == 22){
        BOOL isOpen = [(HLProfitGiftInfo *)_editProfitInfo open];
        [(HLProfitGiftInfo *)_editProfitInfo setGainType: isOpen ? 22 : 21];
    }
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end

