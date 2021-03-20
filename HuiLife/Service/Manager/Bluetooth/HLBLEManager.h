//
//  HLBLEManager.h
//  打印机
//
//  Created by 闻喜惠生活 on 2018/11/17.
//  Copyright © 2018年 闻喜惠生活. All rights reserved.
//蓝牙打印机的管理类

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//监测到中心设备（手机）蓝牙的开启状态
typedef void(^HLStateUpdateBlock)(CBCentralManager *state);

//写入数据时 成功或失败回调
typedef void(^HLWriteToCharacteristicBlock)(CBCharacteristic *characteristic, NSError *error);

//扫描到设备后调用
typedef void(^HLDiscoverPeripheral)(CBCentralManager *central,CBPeripheral *peripheral,NSArray *datas);

//连接成功或失败回调
typedef void(^HLConnectResult)(CBPeripheral *peripheral,NSError * error,CBService *service);

//连接蓝牙设备 成功或失败后调用

NS_ASSUME_NONNULL_BEGIN

@interface HLBLEManager : NSObject

@property (copy,nonatomic)HLStateUpdateBlock stateUpdateBlock;

@property (copy,nonatomic)HLWriteToCharacteristicBlock characteristicBlock;

@property (copy,nonatomic)HLDiscoverPeripheral discoverPeripheralBlock;

@property (strong,nonatomic)NSMutableArray * models;

@property (strong,nonatomic)NSMutableArray *peripherals;

//当前连接的外设
@property (strong,nonatomic)CBPeripheral *curPeripheral;

@property (assign,nonatomic)BOOL stopAfterScan;//扫描到存储的设备后是否停止扫描

+ (instancetype)shared;

//当前蓝牙是否可用
- (BOOL)blueToothUseable;

//扫描打印机(根据指定的服务id)
- (void)scanPrinterDevices ;
//自动连接
- (void)autoConnectPrinter;
//停止扫描
- (void)stopScan;

//连接蓝牙设备
- (void)connectPeripheral:(CBPeripheral *)peripheral stopScanAfterConnected:(BOOL)stop result:(HLConnectResult)resultCallBack;

//取消连接蓝牙设备(成功或失败的回调)
- (void)cancelConnectPeripheral:(CBPeripheral *)peripheral callBack:(HLConnectResult)callBack;

//取消连接当前的蓝牙设备（做假的loading）
- (void)cancelCurrentPeripheral:(void(^)(void))callBack loading:(BOOL)loading;

//添加监听
- (void)addObserverWith:(CBPeripheral *)peripheral;

//移除状态监听
- (void)removeObserveForPerpheal:(CBPeripheral *)peral;

- (void)printeDataWithOrderId:(NSString *)orderid blueTooth:(BOOL)bluetooth wifiSn:(NSString *)wifiSn type:(NSInteger)type success:(void(^)(void))success;

@end

NS_ASSUME_NONNULL_END
