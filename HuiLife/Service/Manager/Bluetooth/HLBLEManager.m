//
//  HLBLEManager.m
//  打印机
//
//  Created by 闻喜惠生活 on 2018/11/17.
//  Copyright © 2018年 闻喜惠生活. All rights reserved.
//

#import "HLBLEManager.h"
#import "HLPrinterSetModel.h"
#import "HLPeripheral.h"

//打印机的服务id
#define kiOSServiceId1 @"18F0"
#define kiOSServiceId2 @"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"

typedef void(^PrinterCallBack)(void);
//表示每次发送的数据长度
#define MAX_CHARACTERISTIC_VALUE_SIZE  120
//f
@interface HLBLEManager()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    PrinterCallBack _success;
}

// 中心设备，创建一个CBCentralManager实例来进行蓝牙管理
@property (strong,nonatomic)CBCentralManager * manager;

// 写入特征
@property (strong,nonatomic)CBCharacteristic *characteristicInfo;

@property (assign,nonatomic)BOOL stopScanAfterConnected;

/**
 * 每次发送的最大数据长度，因为部分型号的蓝牙打印机一次写入数据过长，会导致打印乱码。
 * iOS 9之后，会调用系统的API来获取特性能写入的最大数据长度。
 * 但是iOS 9之前需要自己测试然后设置一个合适的值。默认值是120
 * 所以，如果你打印乱码，你考虑将该值设置小一点再试试。
 */
@property (assign, nonatomic)NSInteger limitLength;

@property (strong,nonatomic)NSArray *goodsArray;

@property (copy,nonatomic)HLConnectResult connectResult;

@property (copy,nonatomic)HLConnectResult disConnectCallBack;

// 是否自动连
@property (assign,nonatomic)BOOL autoConnect;

@end

@implementation HLBLEManager

static HLBLEManager * _instance;

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[HLBLEManager alloc]init];
            _instance.manager = [[CBCentralManager alloc]initWithDelegate:_instance queue:nil];
            _instance.limitLength = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
    });
    return _instance;
}

#pragma mark - CBCentralManagerDelegate

// 确定蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (@available(iOS 10.0, *)) {
        if (central.state == CBManagerStatePoweredOn) {//正在工作
            
        }
        if (central.state == CBManagerStatePoweredOff) {
            // 当页面处于打印机设置页
            [self updateState];
            // 断开连接(页面不在打印机设置页)
            [self cancelCurrentPeripheral:^{
                
            } loading:NO];
        }
    } else {
        if (central.state == CBCentralManagerStatePoweredOn) {
        }
        if (central.state == CBCentralManagerStatePoweredOff) {
            // 蓝牙断开
            [self updateState];
            // 断开连接
            [self cancelCurrentPeripheral:^{
                
            } loading:NO];
        }
    }
    
    if (self.stateUpdateBlock) {
        self.stateUpdateBlock(central);
    }
}

#pragma mark - CBCentralManagerDelegate

/*
 扫描，发现设备后会调用
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if (!peripheral.name) {
        return;
    }
    
    HLLog(@"advertisementData = %@",advertisementData);
    
    // 扫描到后 就去连接
    if (!_autoConnect) {
        _autoConnect = YES;
        [HLPeripheral conncetPeripheral:peripheral callBack:^{
            
        }];
    }
    if (_discoverPeripheralBlock) {
        _discoverPeripheralBlock(central,peripheral,self.models);
    }
    
}

// 失去链接后
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    
    if (_disConnectCallBack) {
        _disConnectCallBack(peripheral,error,nil);
    }
}

/*
 连接失败后回调
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _connectResult(peripheral,error,nil);
}

/*
 连接成功后回调
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    _connectResult(peripheral,nil,nil);
    // 重置
    self.curPeripheral = peripheral;
    self.characteristicInfo = nil;
    // 添加监听
    [self addObserverWith:self.curPeripheral];
    // 设置代理
    peripheral.delegate = self;
    // 寻找外设内所包含的服务
    [peripheral discoverServices:nil];
    
    if (!self.stopAfterScan) {
        [self scanPrinterDevices];
    }
    [self postNotification];
}

#pragma mark - CBPeripheralDelegate

/*
 扫描到服务后回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        HLLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService* service in  peripheral.services) {
        HLLog(@"扫描到的serviceUUID:%@，service = %@",service.UUID,service);
        //扫描特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

/*
 扫描到特性后回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        HLLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    HLLog(@"扫描到特征 = %@,service = %@",service.UUID,service);
    
    for (CBCharacteristic * cha in service.characteristics)
    {
        CBCharacteristicProperties p = cha.properties;//特征的权限
        if (p & CBCharacteristicPropertyWrite) {//有反馈写入特征
            self.characteristicInfo = cha;
            //回调
            _connectResult(peripheral,nil,service);
        }
    }
}

#pragma mark - method

- (BOOL)blueToothUseable{
    if (@available(iOS 10.0, *)) {
        if (self.manager.state != CBManagerStatePoweredOn) {
            return NO;
        }
    } else {
        if (self.manager.state != CBCentralManagerStatePoweredOn) {
            return NO;
        }
    }
    return YES;
}

// 启动扫描打印机
- (void)scanPrinterDevices {
    CBUUID *uuid1 = [CBUUID UUIDWithString:kiOSServiceId1];
    CBUUID *uuid2 = [CBUUID UUIDWithString:kiOSServiceId2];
    [self.manager scanForPeripheralsWithServices:@[uuid1,uuid2] options:nil];
}

// 定时自动连接打印机
- (void)autoConnectPrinter {
// 监听5s
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), ^(void) {
        if (![HLBLEManager shared].blueToothUseable) return;
        [[HLBLEManager shared] scanPrinterDevices];
//        延迟30秒 扫描
        double delay = 30.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(delay * NSEC_PER_SEC));
        dispatch_after(popTime,dispatch_get_main_queue(), ^(void) {
            [[HLBLEManager shared] stopScan];
        });
    });

}

//停止扫描
- (void)stopScan{
    [self.manager stopScan];
}

// 连接蓝牙设备
- (void)connectPeripheral:(CBPeripheral *)peripheral stopScanAfterConnected:(BOOL)stop result:(nonnull HLConnectResult)resultCallBack {
    _connectResult = resultCallBack;
    if (![self blueToothUseable]) {
        _connectResult(peripheral,[NSError new],nil);
        return;
    }
    [self.manager connectPeripheral:peripheral options:nil];
}

//取消连接蓝牙设备
- (void)cancelConnectPeripheral:(CBPeripheral *)peripheral callBack:(nonnull HLConnectResult)callBack{
    if (!peripheral) {
        return;
    }
    _disConnectCallBack = callBack;
    [self.manager cancelPeripheralConnection:peripheral];
}

//取消连接当前的蓝牙设备（做假的loading）
- (void)cancelCurrentPeripheral:(void(^)(void))callBack loading:(BOOL)loading{
    //先移除监听
    [self removeObserveForPerpheal:self.curPeripheral];
    if (loading) [HLTools startLoadingAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((loading?2.0:0.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HLTools endLoadingAnimation];
        //断开连接
        [self disConnectBoolth];
        callBack();
    });
    //断开连接
    [self cancelConnectPeripheral:self.curPeripheral callBack:^(CBPeripheral *peripheral, NSError *error,CBService *service) {
        
    }];
}

//写入数据
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type completionBlock:(HLWriteToCharacteristicBlock)completionBlock{
    _characteristicBlock = completionBlock;
    [self writeValue:data forCharacteristic:characteristic type:type];
}

//写入数据
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (_characteristicBlock) {
        _characteristicBlock(characteristic,error);
    }
}

//打印数据
- (void)printeDataWithOrderId:(NSString *)orderid blueTooth:(BOOL)bluetooth wifiSn:(NSString *)wifiSn type:(NSInteger)type success:(void(^)(void))success{
    _success = success;
    
    [HLTools printDataWithOrderId:orderid type:type success:^(NSData * _Nonnull data) {
            [self handleDataWithData:data type:type];
    } fail:^{
        
    }];
    
    // 这个wifiPrintWithOrderId 安卓没有调用
//    if (type != 1) { //自动。两个接口都调用
//
//        //    WiFi
////        [HLTools wifiPrintWithOrderId:orderid wifiSn:wifiSn];
//        return;
//    }
//    if (bluetooth) {
//        [HLTools printDataWithOrderId:orderid type:type success:^(NSData * _Nonnull data) {
////            [self handleDataWithData:data type:type];
//        } fail:^{
//
//        }];
//        return;
//    }
}

- (void)handleDataWithData:(NSData *)data type:(NSInteger)type{
    return;
    HLAccount *account = [HLAccount shared];
    //打印连数
    NSInteger count = account.print_count;
    if (type == 1) {//手动
        [self startPrintWithCount:count data:data];
        _success();
        return;
    }
    //判断当前打印机是否存在。是否自动
    if (account.print_mode == 1 || account.print_mode == 3) {
        if (!self.curPeripheral) {//还没有搜索到
            _success();
            return;
        }
        if (self.curPeripheral.state == CBPeripheralStateConnected) {
            [self startPrintWithCount:count data:data];
            _success();
        }else{//如果没有连接 要先连接
            [self connectWithCount:count data:data];
        }
    }
}

- (void)startPrintWithCount:(NSInteger)count data:(NSData *)data{
    for (int i = 0; i<count; i++) {
        [self writeValue:data forCharacteristic:self.characteristicInfo type:CBCharacteristicWriteWithResponse completionBlock:^(CBCharacteristic *characteristic, NSError *error) {
            if (error) {
                
            }
        }];
    }
}

- (void)connectWithCount:(NSInteger)count data:(NSData *)data{
    [self connectPeripheral:self.curPeripheral stopScanAfterConnected:YES result:^(CBPeripheral *peripheral, NSError *error, CBService *service) {
        if (service) {
            [self startPrintWithCount:count data:data];
            self->_success();
        }
    }];
}


- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type{
    NSUInteger cellMin;
    NSUInteger cellLen;
    //数据长度
    NSUInteger strLength = [data length];
    if (strLength < 1) {
        return;
    }
    //MAX_CHARACTERISTIC_VALUE_SIZE = 120
    NSUInteger cellCount = (strLength % MAX_CHARACTERISTIC_VALUE_SIZE) ? (strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (int i = 0; i < cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        NSRange rang = NSMakeRange(cellMin, cellLen);
        //截取打印数据
        NSData *subData = [data subdataWithRange:rang];
        //循环写入数据
        [self.curPeripheral writeValue:subData forCharacteristic:characteristic type:type];
    }
}

#pragma mark - KVO--
- (void)addObserverWith:(CBPeripheral *)peripheral{
    [peripheral addObserver:self
                 forKeyPath:@"state"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
}

//移除状态监听
- (void)removeObserveForPerpheal:(CBPeripheral *)peral{
    if (self.curPeripheral) {
        [peral removeObserver:self forKeyPath:@"state"];
    }
}

#pragma mark 监听代理

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"])
    {   //更新状态
        [self updateState];
    }
}

#pragma mark - NOTIFICATION
- (void)postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:HLConnectedBoolthNotifi object:nil];
}

- (void)updateState{
    [[NSNotificationCenter defaultCenter]postNotificationName:HLUpdateBlueToothStateNotifi object:nil];
}

- (void)disConnectBoolth{
    [[NSNotificationCenter defaultCenter]postNotificationName:HLDisConnectedBoolthNotifi object:nil];
}
#pragma mark -SET & GET
-(NSMutableArray *)peripherals{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

-(NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end

