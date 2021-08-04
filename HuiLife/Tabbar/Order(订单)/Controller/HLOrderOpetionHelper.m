//
//  HLOrderOpetionHelper.m
//  HuiLife
//
//  Created by 雷清华 on 2019/12/15.
//

#import "HLOrderOpetionHelper.h"
#import "HLBaseOrderModel.h"


@implementation HLOrderOpetionHelper

+ (void)hl_deliverdWithModel:(HLBaseOrderModel *)orderModel completion:(void (^)(void))completion {
    [self optionDataWithOrderId:orderModel.order_id type:5 completion:completion];
}


+ (void)hl_arrivedWithModel:(HLBaseOrderModel *)orderModel completion:(void (^)(void))completion {
    [self optionDataWithOrderId:orderModel.order_id type:6 completion:completion];
}


+ (void)hl_MentionWithModel:(HLBaseOrderModel *)orderModel completion:(void (^)(void))completion {
    [self mentionWithOrderId:orderModel.order_id completion:completion];
}

+ (void)hl_wifiListWithModel:(HLBaseOrderModel *)orderModel completion:(void (^)(NSArray *))completion {
    [self wifiListWithOrderId:orderModel.order_id completion:completion];
}

//接单处理，立即接单
+ (void)hl_acceptOrderWithModel:(HLBaseOrderModel *)orderModel completion:(void (^)(void))completion{
    [self handleOrderAccetpWithOrderId:orderModel.order_id type:1 completion:completion];
}

//接单处理，拒绝接单
+ (void)hl_refuseOrderWithModel:(HLBaseOrderModel *)orderModel completion:(void(^)(void))completion{
    [self handleOrderAccetpWithOrderId:orderModel.order_id type:2 completion:completion];
}

#pragma mark - 立即接单 or 拒绝接单

// type  1接单   2拒绝
+ (void)handleOrderAccetpWithOrderId:(NSString *)orderId type:(NSInteger)type completion:(void (^)(void))completion {
    UIViewController *fatherVC = [HLTools visiableController];
    HLLoading(fatherVC.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/takeOutOrderDeal.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":@(type), @"order_id":orderId};
    }onSuccess:^(id responseObject) {
        HLHideLoading(fatherVC.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) completion();
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(fatherVC.view);
    }];
}

#pragma mark - 配送，送达
//5:配送 ，6 送达
+ (void)optionDataWithOrderId:(NSString *)orderId type:(NSInteger)type completion:(void (^)(void))completion {
    UIViewController *fatherVC = [HLTools visiableController];
    HLLoading(fatherVC.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/OrderManagement.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":@(type), @"order_id":orderId};
    }onSuccess:^(id responseObject) {
        HLHideLoading(fatherVC.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) completion();
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(fatherVC.view);
    }];
}

#pragma mark - 自提
+ (void)mentionWithOrderId:(NSString *)orderId completion:(void (^)(void))completion{
    UIViewController *fatherVC = [HLTools visiableController];
    HLLoading(fatherVC.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/OrderStateManage.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":orderId};
    }onSuccess:^(id responseObject) {
        HLHideLoading(fatherVC.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) completion();
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(fatherVC.view);
    }];
}

#pragma mark - 打印

+ (void)wifiListWithOrderId:(NSString *)orderId completion:(void (^)(NSArray *))completion {
    UIViewController *fatherVC = [HLTools visiableController];
    HLLoading(fatherVC.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/PrinterDevice.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":orderId};
    } onSuccess:^(id responseObject) {
        HLHideLoading(fatherVC.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            NSArray *datas = result.data;
            [self handleDataWithDict:datas.firstObject orderId:orderId completion:completion];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(fatherVC.view);
    }];
}

+ (void)handleDataWithDict:(NSDictionary *)dict orderId:(NSString *)orderId completion:(void (^)(NSArray *))completion {
    
    NSMutableArray *printers = [NSMutableArray array];
    CBPeripheral * pheral = [HLBLEManager shared].curPeripheral;
    NSArray * list = dict[@"list"];
    if (list.count == 0  && pheral.state != CBPeripheralStateConnected) {
        [HLTools showWithText:@"请到打印机设置页面连接打印机"];
        return;
    }
    
    if (pheral && pheral.state == CBPeripheralStateConnected) {
        HLPrinterItemModel * item = [[HLPrinterItemModel alloc]init];
        item.leftPic = @"bluetooth_black";
        item.title = [HLBLEManager shared].curPeripheral.name;
        item.isBluetooth = YES;
        [printers addObject:item];
    }
    for (NSDictionary * dict in list) {
        HLPrinterItemModel * item = [[HLPrinterItemModel alloc]init];
        item.leftPic = @"wifi_black";
        item.title = dict[@"printer_title"];
        item.Id = dict[@"printer_sn"];
        [printers addObject:item];
    }
    if (completion) completion(printers);
}
@end
