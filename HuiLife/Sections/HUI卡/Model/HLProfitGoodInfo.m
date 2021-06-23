//
//  HLProfitGoodInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/30.
//

#import "HLProfitGoodInfo.h"

@implementation HLProfitGoodInfo
//忽略互相转换的 key
+ (NSArray *)mj_ignoredPropertyNames {
    return [self ignoredKeys];
}

//要忽略的keys
+ (NSArray *)ignoredKeys {
    return @[@"discountAttr",@"cellHight",@"detailStr",@"gainTypeName",@"detailAttr",@"gainPriceAttr",@"title",@"maxPlace",@"minPlace",@"discountPlace"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    HLLog(@"forUndefinedKey = %@",key);
}

+ (NSArray *)profitsWithDict:(NSArray *)oriResult {
    NSMutableArray *datasource = [NSMutableArray array];
    for (NSDictionary *dict in oriResult) {
        NSInteger type = [dict[@"gainType"] integerValue];
        switch (type) {
            case 1:case 3: //首单折扣，日常折扣
            {
                HLProfitFirstInfo *info = [HLProfitFirstInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
                
            }break;
            case 2: //外卖
            {
                HLProfitYMInfo *info = [HLProfitYMInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
                
            }break;
            case 43:case 27://服务卡
            {
                HLProfitServiceInfo *info = [HLProfitServiceInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
                
            }break;
            case 42:case 26://代金券
            {
                HLProfitVoucherInfo *info = [HLProfitVoucherInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
                
            }break;
            case 41:case 25://打折券
            {
                HLProfitDiscountInfo *info = [HLProfitDiscountInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
            }break;
            case 21://赠品
            case 22:
            {
                HLProfitGiftInfo *info = [HLProfitGiftInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
                
            }break;
            case 60://话费卷
            {
                HLPhoneFeeInfo *info = [HLPhoneFeeInfo mj_objectWithKeyValues:dict];
                [datasource insertObject:info atIndex:0];
            }break;
            case 61://外卖红包
            {
                HLProfitRedPacketInfo *info = [HLProfitRedPacketInfo mj_objectWithKeyValues:dict];
                [datasource addObject:info];
            }break;
            default:
                break;
        }
    }
    
    return datasource;
}

- (NSString *)gainTypeName {
    if (!_gainTypeName) {
        switch (_gainType) {
            case 1:_gainTypeName = @"首单折扣";break;
            case 3:_gainTypeName = @"日常折扣";break;
            case 2:_gainTypeName = @"外卖折扣";break;
            case 43:case 27:_gainTypeName = @"服务卡";break;
            case 42:case 26:_gainTypeName = @"代金券";break;
            case 41:case 25:_gainTypeName = @"超级打折券";break;
            case 21:case 22:_gainTypeName = @"礼品/赠品";break;
            case 61:_gainTypeName = @"外卖红包";break;
            default:
                break;
        }
    }
    return _gainTypeName;
}

- (NSString *)gainName {
    if (_gainType == 1) {
        return @"首次折扣";
    }
    if (_gainType == 3) {
        return @"普通折扣";
    }
    return _gainName;
}

- (CGFloat)cellHight {
    return FitPTScreen(134);
}


@end

#pragma mark - 外卖红包相关

@implementation HLProfitRedPacketGainInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.discount = @"";
//        self.gain_id = @"";
    }
    return self;
}

@end

@implementation HLProfitRedPacketInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"disOut":@"HLProfitRedPacketGainInfo"};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"开卡送";
        self.gainName = @"外卖单单立减红包";
    }
    return self;
}

- (CGFloat)cellHight{
    CGFloat detailH = [self.gainDesc boundingRectWithSize:CGSizeMake(FitPTScreen(205), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self detailAttributes] context:nil].size.height;
    return detailH + FitPTScreen(125);
}

- (NSAttributedString *)gainPriceAttr {
    NSString *text = [NSString stringWithFormat:@"¥%@",self.gainPrice];
    if (!_gainPriceAttr || ![_gainPriceAttr.string isEqualToString:text]) {
        NSRange tipRange = NSMakeRange(0, 1);
        NSRange priceRange = NSMakeRange(tipRange.length, text.length - tipRange.length);
        _gainPriceAttr = [[NSMutableAttributedString alloc]initWithString:text];
        [_gainPriceAttr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:priceRange];
        [_gainPriceAttr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    }
    return _gainPriceAttr;
}

- (NSDictionary *)detailAttributes {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 2;
    return @{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(11)]};
}

@end

#pragma mark - 首次折扣

@implementation HLProfitFirstInfo

- (NSAttributedString *)discountAttr {
    if (!_disFirst.floatValue) {
        return [[NSAttributedString alloc]initWithString:@"无折扣" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(14)]}];;
    }
    NSString *text = [NSString stringWithFormat:@"%@折",_disFirst];
    NSRange disRange = [text rangeOfString:_disFirst];
    NSRange tipRange = NSMakeRange(disRange.length, 1);
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:disRange];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    return [mutarr copy];
}

- (NSString *)detailStr {
    return self.gainType == 1?@"顾客首次消费使用":@"顾客平时消费使用";
}

- (NSString *)title {
    return @"开卡送";
}

@end

@implementation HLProfitYMInfo

//忽略互相转换的 key
+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"discountAttr",@"cellHight",@"detailStr",@"detailAttr"];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"disOut":@"HLProfitOrderInfo"};
}

- (NSAttributedString *)discountAttr {
    NSString *text = [NSString stringWithFormat:@"%@折起",self.disFirst];
    NSRange disRange = [text rangeOfString:self.disFirst];
    NSRange tipRange = NSMakeRange(disRange.length, 2);
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:disRange];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    return [mutarr copy];
}

- (NSString *)disFirst {
    _disFirst = @"10";
    for (HLProfitOrderInfo *orderInfo in self.disOut) {
        if (orderInfo.discount.floatValue < _disFirst.floatValue) {
            _disFirst = orderInfo.discount;
        }
    }
    return _disFirst;
}

- (NSString *)detailStr {
    NSMutableString *text = [[NSMutableString alloc] init];
    NSInteger maxCount = 6;
    NSInteger limitCount = self.disOut.count > maxCount ? maxCount : self.disOut.count;
    for (NSInteger i = 0; i < limitCount; i++) {
        HLProfitOrderInfo *info = self.disOut[i];
        NSInteger ys = i % 2;
        NSString *date = [NSString stringWithFormat:@"%@-%@元%@折",info.priceStart,info.priceEnd,info.discount];
        [text appendString:date];
        if (self.disOut.count > limitCount && i + 1 == limitCount) {
            [text appendString:@"..."];
        }
        if (ys != 0) [text appendString:@"\n"];
        if (ys == 0 && i != (limitCount-1)) [text appendString:@"，"];
    }
    if (self.disOut.count == 1 || limitCount % 2) [text appendString:@"\n"];
    return [text copy];
}

- (NSAttributedString *)detailAttr {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 2;
    _detailAttr = [[NSAttributedString alloc]initWithString:self.detailStr attributes:[self detailAttributes]];
    return _detailAttr;
}

- (NSDictionary *)detailAttributes {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 2;
    return @{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(11)]};
}

- (CGFloat)cellHight {
    CGFloat detailH = [self.detailStr boundingRectWithSize:CGSizeMake(FitPTScreen(205), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self detailAttributes] context:nil].size.height;
    return detailH + FitPTScreen(102);
}

- (NSString *)title {
    return @"开卡送";
}

- (NSString *)gainName {
    NSString * min = @"10";
    NSString * max = @"";
    for (HLProfitOrderInfo *orderInfo in self.disOut) {
        if (orderInfo.discount.floatValue > max.floatValue) {
            max = orderInfo.discount;
        }
        if (orderInfo.discount.floatValue < min.floatValue) {
            min = orderInfo.discount;
        }
    }
    NSString *name = [NSString stringWithFormat:@"外卖%@-%@折",min,max];
    return name;
}
@end

@implementation HLProfitServiceInfo

- (BOOL)open {
    return self.gainType == 27;
}

- (NSAttributedString *)discountAttr {
    NSString *text = [NSString stringWithFormat:@"%ld次",self.gainNum];
    NSRange disRange = [text rangeOfString:[NSString stringWithFormat:@"%ld",self.gainNum]];
    NSRange tipRange = NSMakeRange(disRange.length, 1);
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:disRange];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    return [mutarr copy];
}

- (NSString *)detailStr {
    if (!self.open) {
        return [NSString stringWithFormat:@"%@-%@",_startDate,_endDate];
    }
    return nil;
}

- (NSString *)title {
    NSString *monthStr = [NSString stringWithFormat:@"月月送-%ld张",_gainNum];
    NSString *cardStr = [NSString stringWithFormat:@"开卡送-%ld张",_gainNum];
    if (!_gainNum) {
        monthStr = @"月月送";
        cardStr = @"开卡送";
    }
    NSString *title = self.open?monthStr:cardStr;
    return title;
}
@end

@implementation HLProfitVoucherInfo

- (BOOL)open {
    return self.gainType == 26;
}

- (NSAttributedString *)discountAttr {
    NSString *text = [NSString stringWithFormat:@"¥%@",self.gainPrice];
    NSRange tipRange = NSMakeRange(0, 1);
    NSRange priceRange = NSMakeRange(tipRange.length, text.length - tipRange.length);
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:priceRange];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    return [mutarr copy];
}

- (NSString *)detailStr {
    if (!self.open) {
        return [NSString stringWithFormat:@"%@-%@",_startDate,_endDate];
    }
    return nil;
}

- (NSString *)title {
    NSString *monthStr = [NSString stringWithFormat:@"月月送-%ld张",_gainNum];
    NSString *cardStr = [NSString stringWithFormat:@"开卡送-%ld张",_gainNum];
    if (!_gainNum) {
        monthStr = @"月月送";
        cardStr = @"开卡送";
    }
    NSString *title =  self.open?monthStr:cardStr;
    return title;
}

- (NSString *)gainName {
    NSString *priceStr = [NSString stringWithFormat:@"满%@元使用",_limitPrice];
    if (!_limitPrice.floatValue) {
        priceStr = @"无限制使用";
    }
    return priceStr;
}

@end

@implementation HLProfitDiscountInfo

- (BOOL)open {
    return self.gainType == 25;
}

- (NSAttributedString *)discountAttr {
    NSString *text = [NSString stringWithFormat:@"%@折",_gainPrice];
    NSRange disRange = [text rangeOfString:_gainPrice];
    NSRange tipRange = NSMakeRange(disRange.length, 1);
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:disRange];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    return [mutarr copy];
}

- (NSString *)detailStr {
    if (!self.open) {
        return [NSString stringWithFormat:@"%@-%@",_startDate,_endDate];
    }
    return nil;
}

- (NSString *)title {
    NSString *monthStr = [NSString stringWithFormat:@"月月送-%ld张",_gainNum];
    NSString *cardStr = [NSString stringWithFormat:@"开卡送-%ld张",_gainNum];
    if (!_gainNum) {
        monthStr = @"月月送";
        cardStr = @"开卡送";
    }
    NSString *title = self.open?monthStr:cardStr;
    return title;
}

- (NSString *)gainName {
    NSString *priceStr = [NSString stringWithFormat:@"满%@元使用",_limitPrice];
    if (!_limitPrice.floatValue) {
        priceStr = @"无限制使用";
    }
    return priceStr;
}
@end

@implementation HLProfitGiftInfo

- (BOOL)open {
    return self.gainType == 22;
}

- (NSString *)title {
    NSString *monthStr = [NSString stringWithFormat:@"月月送-%ld个",_gainNum];
    NSString *cardStr = [NSString stringWithFormat:@"开卡送-%ld个",_gainNum];
    if (!_gainNum) {
        monthStr = @"月月送";
        cardStr = @"开卡送";
    }
    NSString *title = self.gainType == 22 ? monthStr : cardStr;
    return title;
}

- (NSString *)detailStr {
    return self.gainDesc;
}

- (NSString *)dateStr {
    if (!self.open) {
        return [NSString stringWithFormat:@"%@-%@",_startDate,_endDate];
    }
    return nil;
}

- (CGFloat)cellHight {
    if (self.open) {
        return FitPTScreen(160);
    }
    return FitPTScreen(175);
}
@end

//话费卷
@implementation HLPhoneFeeInfo

- (NSAttributedString *)discountAttr {
    NSString *text = [NSString stringWithFormat:@"¥%@",self.gainPrice];
    NSRange tipRange = NSMakeRange(0, 1);
    NSRange priceRange = NSMakeRange(tipRange.length, text.length - tipRange.length);
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(18)]} range:priceRange];
    [mutarr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(12)]} range:tipRange];
    return [mutarr copy];
}

- (CGFloat)cellHight {
    return FitPTScreen(170);
}
@end


@implementation HLProfitOrderInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _discountPlace = @"";
        _minPlace = @"0";
        _maxPlace = @"0";
    }
    return self;
}

- (BOOL)check {
    if (_discount.floatValue > 9.5) {
        [HLTools showWithText:@"折扣不能超出9.5折"];
        return NO;
    }
    if (_discount.floatValue < 0.1) {
        [HLTools showWithText:@"折扣不能低于1折"];
        return NO;
    }
    
    if (!_priceStart.integerValue || !_priceEnd.integerValue) {
        [HLTools showWithText:@"请输入订单价格"];
        return NO;
    }
    
    if (_priceStart.length > 4 || _priceEnd.length > 4) {
        [HLTools showWithText:@"订单价格最高为4位数"];
        return NO;
    }
    
    if (_priceStart.integerValue > _priceEnd.integerValue) {
        [HLTools showWithText:@"订单价格下限不能高于上限"];
        return NO;
    }
    
    return YES;
}
@end
