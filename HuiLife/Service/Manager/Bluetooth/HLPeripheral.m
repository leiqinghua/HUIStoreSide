//
//  HLPeripheral.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/10.
//

#import "HLPeripheral.h"
#import "HLBLEManager.h"

@interface HLPeripheral()
//当前点击要连接的蓝牙外设
@property (strong,nonatomic)CBPeripheral * curPeripheral;

@property (assign,nonatomic)BOOL isConnectResult;

@property (copy,nonatomic)CallBack callBack;
@end

@implementation HLPeripheral

+ (void)conncetPeripheral:(CBPeripheral *)peripheral callBack:(CallBack)callBack{
    if (![[HLBLEManager shared] blueToothUseable]) {
        [HLTools showWithText:@"请打开手机蓝牙"];
        callBack();
        return;
    }
    
    HLBLEManager * manager = [HLBLEManager shared];
    //断开之前的监听
    [manager removeObserveForPerpheal:manager.curPeripheral];
    
    HLPeripheral * per = [[HLPeripheral alloc]init];
    per.curPeripheral = peripheral;
    per.callBack = callBack;
    per.isConnectResult = NO;
    //连接
    [manager connectPeripheral:peripheral stopScanAfterConnected:NO result:^(CBPeripheral *peripheral, NSError *error, CBService *service) {
        per.callBack();
        per.isConnectResult = YES;
        if (error) {//失败了
            [manager addObserverWith:manager.curPeripheral];
        }
    }];
    //倒计时(设置超时时间15秒)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!per.isConnectResult) {
            [HLTools showWithText:@"连接超时，试试重启打印机哦"];
           //给之前的添加监听
            [manager addObserverWith:manager.curPeripheral];
            //断开
            [manager cancelConnectPeripheral:per.curPeripheral callBack:^(CBPeripheral *peripheral, NSError *error, CBService *service) {

            }];
            per.callBack();
        }
    });
}


@end
