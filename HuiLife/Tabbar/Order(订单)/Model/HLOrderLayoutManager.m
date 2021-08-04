//
//  HLOrderLayoutManager.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/25.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderLayoutManager.h"


@implementation HLOrderLayoutManager

+ (HLBaseOrderLayout *)orderLayoutWithDict:(NSDictionary *)dataDict tableView:(UITableView *)tableView{
    
    NSInteger type = [dataDict[@"type"] integerValue];
    switch (type) {
        case 13://汽车服务
        {
            HLCarServiceModel *carModel = [HLCarServiceModel mj_objectWithKeyValues:dataDict];
            carModel.identifier = @"HLCarServiceTableCell";//对应cell的名称
            HLCarServiceLayout *carLayout = [[HLCarServiceLayout alloc]initWithOrderModel:carModel];
            return carLayout;
            
        }break;
        case 4://优惠买单
        {
            HLPreferentialModel *preferentialModel = [HLPreferentialModel mj_objectWithKeyValues:dataDict];
            preferentialModel.identifier = @"HLPreferentialTableCell";//对应cell的名称
            HLPreferentialLayout *preferentialLayout = [[HLPreferentialLayout alloc]initWithOrderModel:preferentialModel];
            return preferentialLayout;
            
        }break;
        case 5://HUI卡
        {
            HLHUICardModel *huiCardModel = [HLHUICardModel mj_objectWithKeyValues:dataDict];
            huiCardModel.identifier = @"HLHUICardTableCell";//对应cell的名称
            HLHUICardLayout *cardLayout = [[HLHUICardLayout alloc]initWithOrderModel:huiCardModel];
            return cardLayout;
            
        }break;
        case 1:
        case 16://秒杀
        {
            HLSpikeBuyModel *spikeBuyModel = [HLSpikeBuyModel mj_objectWithKeyValues:dataDict];
            spikeBuyModel.identifier = @"HLSpikeBuyTableCell";//对应cell的名称
            HLSpikeBuyLayout *spikeBuyLayout = [[HLSpikeBuyLayout alloc]initWithOrderModel:spikeBuyModel];
            return spikeBuyLayout;
            
        }break;
        case 29://便利商超
        {
            HLConShopModel *shopModel = [HLConShopModel mj_objectWithKeyValues:dataDict];
            shopModel.identifier = @"HLOrderScanTableCell";//对应cell的名称
            HLConShopLayout *shopLayout = [[HLConShopLayout alloc]initWithOrderModel:shopModel];
            return shopLayout;
            
        }break;
        case 30://快捷买单
        {
            HLFastBuyModel *fastBuyModel = [HLFastBuyModel mj_objectWithKeyValues:dataDict];
            fastBuyModel.identifier = @"HLFastBuyTableCell";//对应cell的名称
            HLFastBuyLayout *fastBuyLayout = [[HLFastBuyLayout alloc]initWithOrderModel:fastBuyModel];
            return fastBuyLayout;
            
        }break;
        case 37://计次卡(HUI小程序售卡)
        {
            HLNumberCardModel *numberCardModel = [HLNumberCardModel mj_objectWithKeyValues:dataDict];
            numberCardModel.identifier = @"HLNumberCardTableCell";//对应cell的名称
            HLNumberCardLayout *numberCardLayout = [[HLNumberCardLayout alloc]initWithOrderModel:numberCardModel];
            return numberCardLayout;
            
        }break;
        case 38:// 代金券(HUI小程序代金卷)
        {
            HLVoucherBuyModel *voucherBuyModel = [HLVoucherBuyModel mj_objectWithKeyValues:dataDict];
            voucherBuyModel.identifier = @"HLVoucherBuyTableCell";//对应cell的名称
            HLVoucherBuyLayout *voucherBuyLayout = [[HLVoucherBuyLayout alloc]initWithOrderModel:voucherBuyModel];
            return voucherBuyLayout;
            
        }break;
        case 39:// 折扣买单
        {
            HLDiscountBuyModel *discountBuyModel = [HLDiscountBuyModel mj_objectWithKeyValues:dataDict];
            discountBuyModel.identifier = @"HLDiscountBuyTableCell";//对应cell的名称
            HLDiscountBuyLayout *discountBuyLayout = [[HLDiscountBuyLayout alloc]initWithOrderModel:discountBuyModel];
            return discountBuyLayout;
            
        }break;
        case 44:// 爆款
        {
            HLHotShopModel *hotShopModel = [HLHotShopModel mj_objectWithKeyValues:dataDict];
            hotShopModel.identifier = @"HLOrderScanTableCell";//对应cell的名称
            HLHotShopLayout *hotShopLayout = [[HLHotShopLayout alloc]initWithOrderModel:hotShopModel];
            return hotShopLayout;
            
        }break;
        case 43:// 拼团(延用HLOrderScanTableCell，有问题再改)
        {
            HLSpikeGroupModel *groupShopModel = [HLSpikeGroupModel mj_objectWithKeyValues:dataDict];
            groupShopModel.identifier = @"HLOrderScanTableCell";//对应cell的名称
            HLSpikeGroupLayout *hotShopLayout = [[HLSpikeGroupLayout alloc]initWithOrderModel:groupShopModel];
            return hotShopLayout;
            
        }break;
            
        default:
        {//扫码点餐
            HLScanOrderModel *scanOrderModel = [HLScanOrderModel mj_objectWithKeyValues:dataDict];
            scanOrderModel.identifier = @"HLOrderScanTableCell";//对应cell的名称
            HLScanOrderLayout *scanOrderLayout = [[HLScanOrderLayout alloc]initWithOrderModel:scanOrderModel];
            return scanOrderLayout;
        }break;
    }
    
    
    return nil;
}

@end
