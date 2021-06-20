//
//  HLOrderPrinterModel.m
//  HuiLife
//
//  Created by 王策 on 2021/6/19.
//

#import "HLOrderPrinterModel.h"
#import "HLPrinterHelper.h"

@implementation HLOrderPrinterModel

- (NSData *)printData{
    if (!_printData) {
        HLPrinterHelper *helper = [[HLPrinterHelper alloc] init];

        // 打印头部商家标题
        [helper appendText:self.items.title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle doubleHeight:NO];
        [helper appendNewLine]; // 添加距离

        // 打印订单号
        [helper appendText:self.items.small_title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle doubleHeight:YES];
        [helper appendNewLine]; // 添加距离

        [self.items.list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(![obj isKindOfClass:[NSDictionary class]]) {
                return;;
            }
            
            switch (idx) {
                case 0:
                case 1:
                {
                    [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        [helper appendTitle:[NSString stringWithFormat:@"%@:",key] value:obj doubleHeight:NO];
                    }];
                    [helper appendSeperatorLine];
                }
                    break;
                case 2:
                {
                    [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        [helper appendTitle:[NSString stringWithFormat:@"%@:",key] value:obj doubleHeight:YES];
                    }];
                    [helper appendSeperatorLine];
                }
                    break;
                case 3:
                {
                    [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:@"goods"]) {
                            [helper appendLeftText:@"商品名称" middleText:@"数量" rightText:@"金额"];

                            NSArray <HLOrderPrinterGoods *> *goods = [HLOrderPrinterGoods mj_objectArrayWithKeyValuesArray:obj];
                            [goods enumerateObjectsUsingBlock:^(HLOrderPrinterGoods * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [helper appendLeftText:obj.title middleText:obj.num rightText:obj.prices];
                            }];
                            [helper appendSeperatorLine];
                        }else if ([key isEqualToString:@"total_price"]){
                            [helper appendText:[NSString stringWithFormat:@"商品合计:%.2lf",[obj doubleValue]] alignment:HLTextAlignmentRight fontSize:HLFontSizeTitleSmalle doubleHeight:NO];
                        }
                    }];
                }
                    break;
                case 4:
                {
                    
                    // 保证实付金额在最下方
                    NSArray *allKeys = [obj allKeys];
                    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2){
                        if ([obj1 isEqualToString:@"实付金额"]) {
                            return NSOrderedDescending;
                        }
                        return NSOrderedAscending;
                    }];

                    
                    for (NSString *key in allKeys) {
                        NSString *value = obj[key];
                        BOOL doubleHeight = [key isEqualToString:@"实付金额"];
                        [helper appendTitle:[NSString stringWithFormat:@"%@:",key] value:value doubleHeight:doubleHeight];
                    }
                }
                    break;
                default:
                    break;
            }
        }];

        // 添加分割线
        [helper appendSeperatorLine];
        [helper appendNewLine];

        // 打印二维码
        if (self.items.qr_url.length > 0) {
            [helper appendQRCodeWithInfo:self.items.qr_url];

            [helper appendNewLine];
            
            if (self.items.button.length > 0) {
                [helper appendText:self.items.button alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle doubleHeight:NO];
                [helper appendNewLine];
            }
        }
        
        [helper appendNewLine];
        [helper appendNewLine];
        [helper printCutPaper];

        _printData = [helper getFinalData];
    }
    return _printData;
}

@end

@implementation HLOrderPrinterItem

@end

@implementation HLOrderPrinterGoods

@end
