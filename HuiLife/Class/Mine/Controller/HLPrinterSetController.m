//
//  HLPrinterSetController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import "HLPrinterSetController.h"
#import "HLPrinterSetViewCell.h"
#import "HLRightInputViewCell.h"
#import "HLPrinterModelViewCell.h"
#import "HLPrinteHeader.h"
#import "HLRightSwitchViewCell.h"
#import "HLBLEManager.h"
#import "HLPrinterSettingAlertView.h"
#import "HLAddPrinterViewController.h"
#import "HLPeripheral.h"
#import "HLBlueToothSetingController.h"
#import "HLWIFISettingController.h"
#import "HLSelectMDViewController.h"

@interface HLPrinterSetController ()
<
UITableViewDelegate,
UITableViewDataSource,
HLPrinteHeaderDelegate,
HLPrinterModelDelegate,
HLRightSwitchViewCellDelegate
>

@property (strong,nonatomic)UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *datasource;

@property (strong,nonatomic)NSMutableArray *placeDatasource;

//WiFi设备
@property (strong,nonatomic)NSMutableArray *mydevices;
//蓝牙设备
@property (strong,nonatomic)NSMutableArray *blueToothdevices;

//打印门店
@property (strong,nonatomic)HLRightInputTypeInfo * storeInfo;
//蓝牙打印开关
@property (strong,nonatomic)HLRightSwitchInfo * switchInfo;
//打印连数
@property (strong,nonatomic)NSArray *printNums;

@property (strong,nonatomic)NSArray *printOrderTypes;

//连接的蓝牙设备
@property(strong,nonatomic)HLPrinterInfo * connectInfo;

//当前选择的门店id
@property(nonatomic,copy)NSString * selectStoreId;

@end

@implementation HLPrinterSetController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"打印机设置"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[HLBLEManager shared] blueToothUseable] && self.switchInfo.switchOn) {
        //先停止扫描
        [[HLBLEManager shared]stopScan];
        [[HLBLEManager shared] scanPrinterDevices];
    } else if (![[HLBLEManager shared] blueToothUseable] && self.switchInfo.switchOn){
        [HLTools showWithText:@"请检查手机蓝牙是否可用"];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    //停止扫描
    [[HLBLEManager shared] stopScan];
}


#pragma mark - public
- (void)scanDevices {
    //扫描蓝牙
    weakify(self);
    [HLBLEManager shared].discoverPeripheralBlock = ^(CBCentralManager *central, CBPeripheral *peripheral, NSArray *datas) {
        if (!self.switchInfo.switchOn) {
            return ;
        }
        __block BOOL content = false;
        [weak_self.blueToothdevices enumerateObjectsUsingBlock:^(HLPrinterInfo*  _Nonnull device, NSUInteger idx, BOOL * _Nonnull stop) {
            CBPeripheral * per = (CBPeripheral *)device.otherKey;
            if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                content = YES;
                *stop = YES;
            }
        }];
        if (!content) {
            HLPrinterInfo * device = [[HLPrinterInfo alloc]init];
            device.type = HLInputCellPrinterType;
            device.leftTip = peripheral.name;
            device.rightImg = [UIImage imageNamed:@"bluetooth_black"];
            device.cellHeight = FitPTScreen(50);
            device.otherKey = peripheral;
            [weak_self.blueToothdevices addObject:device];
        }
        [weak_self.tableView reloadData];
    };
}

//监听蓝牙状态
- (void)observeBluetoothState {
    [HLBLEManager shared].stateUpdateBlock = ^(CBCentralManager *state) {
        if ([[HLBLEManager shared] blueToothUseable] && self.switchInfo.switchOn && !self.blueToothdevices.count) {
            [[HLBLEManager shared] scanPrinterDevices];
        }
    };
}

- (void)addNotifications{
    //蓝牙连接成功后 接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didConnectSuccess:) name:HLConnectedBoolthNotifi object:nil];
    //手动断开连接后 接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDisConnectSuccess:) name:HLDisConnectedBoolthNotifi object:nil];
    //添加或修改打印机后
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPrinterNotification:) name:HLAddPrinterSuccessNotifi object:nil];
    //更新连接的蓝牙设备的状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateStateForPrinter:) name:HLUpdateBlueToothStateNotifi object:nil];
}

//断开连接
- (void)cancelPerpheal{
    //断开连接
    if (![HLBLEManager shared].curPeripheral) return;
    [[HLBLEManager shared] cancelCurrentPeripheral:^{
        
    } loading:NO];
    [[HLBLEManager shared] scanPrinterDevices];
}


- (void)didConnectSuccess:(NSNotification *)sender{
    if (!self.switchInfo.switchOn) return;
    //我的设备
    NSMutableArray * myDevices = self.datasource[2];
    HLPrinterInfo * info = [self modelWithPeripheral:[HLBLEManager shared].curPeripheral];
    if (_connectInfo && myDevices.count) {
        [myDevices replaceObjectAtIndex:myDevices.count - 1 withObject:info];
        _connectInfo = info;
    }else{
        [myDevices addObject:info];
        _connectInfo = info;
        NSIndexPath * index = [NSIndexPath indexPathForRow:myDevices.count-1 inSection:2];
        [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [[HLBLEManager shared] scanPrinterDevices];
    }
}

- (void)didDisConnectSuccess:(NSNotification *)sender{
    if (self.datasource.count < 3) return;
    NSMutableArray * myDevices = self.datasource[2];
    if (_connectInfo) {
        [myDevices removeObjectAtIndex:myDevices.count - 1];
        [self.tableView reloadData];
        _connectInfo = nil;
    }
}

- (void)addPrinterNotification:(NSNotification *)sender{
    [self loadDataWithType:1 printModel:0 orderType:0 printNum:0];
}


- (void)updateStateForPrinter:(NSNotification *)sender{
    if (_connectInfo) {
        NSMutableArray * devices = self.datasource[2];
        HLPrinterInfo * info = devices.lastObject;
        info.text = [HLBLEManager shared].curPeripheral.state == CBPeripheralStateConnected?@"已连接":@"未连接";
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:devices.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self scanDevices];
    [self observeBluetoothState];
    [self addNotifications];
    
    _selectStoreId = [HLAccount shared].store_id;
    [self loadDataWithType:1 printModel:0 orderType:0 printNum:0];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableFooterView = [UIView new];
        AdjustsScrollViewInsetNever(self, _tableView);
        
        [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
        [_tableView registerClass:[HLPrinterSetViewCell class] forCellReuseIdentifier:@"HLPrinterSetViewCell"];
        [_tableView registerClass:[HLPrinterModelViewCell class] forCellReuseIdentifier:@"HLPrinterModelViewCell"];
        [_tableView registerClass:[HLPrinteHeader class] forHeaderFooterViewReuseIdentifier:@"HLPrinteHeader"];
        [_tableView registerClass:[HLRightSwitchViewCell class] forCellReuseIdentifier:@"HLRightSwitchViewCell"];;
        
    }
    return _tableView;
}


#pragma mark - HLPrinteHeaderDelegate
//添加打印机
- (void)hlAddPrinteDevice {
    HLAddPrinterViewController * add = [[HLAddPrinterViewController alloc]init];
    add.isAdd = YES;
    add.storeID = _selectStoreId?:[HLAccount shared].store_id;
    [self hl_pushToController:add];
}

#pragma mark - HLPrinterModelDelegate
//打印模式
- (void)printeModelCell:(HLPrinterModelViewCell *)cell autoClick:(BOOL)autoClick model:(HLprinterModelInfo *)model{
    [HLAccount shared].print_mode = model.modelType;
    if (model.modelType == 4) {
        [self.placeDatasource removeAllObjects];
        [self.placeDatasource addObjectsFromArray:self.datasource];
        [self.datasource removeAllObjects];
        [self.datasource addObject:self.placeDatasource.firstObject];
    } else {
        if (self.placeDatasource.count) {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:self.placeDatasource];
        }
    }
    [self.tableView reloadData];
    [self loadDataWithType:2 printModel:model.modelType orderType:0 printNum:0];
}

#pragma mark - HLRightSwitchCellDelegate
- (void)switchViewCell:(HLRightSwitchViewCell *)cell switchChanged:(HLRightSwitchInfo *)switchInfo{
    
    if (!switchInfo.switchOn) {
           [self cancelPerpheal];
           if ([self.datasource containsObject:self.blueToothdevices]) {
               [self.datasource removeObject:self.blueToothdevices];
           }
       }else{
           
           if (![[HLBLEManager shared]blueToothUseable]) {
               [HLTools showWithText:@"请打开手机蓝牙"];
               return;
           }
           
           [[HLBLEManager shared] scanPrinterDevices];
           if (![self.datasource containsObject:self.blueToothdevices]) {
               [self.datasource addObject:self.blueToothdevices];
           }
       }
       [self.tableView reloadData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * infos = self.datasource[section];
    return infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * infos = self.datasource[indexPath.section];
    HLBaseTypeInfo *info = infos[indexPath.row];
    switch (info.type) {
        case HLInputCellTypeDefault:
        {
            HLRightInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellPrinterType:
        {
            HLPrinterSetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLPrinterSetViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case HLInputCellPrinterModel:
        {
            HLPrinterModelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLPrinterModelViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            return cell;
        }
            break;
        case HLInputCellTypeRightSwitch:
        {
            HLRightSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightSwitchViewCell" forIndexPath:indexPath];
            cell.baseInfo = info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSArray * infos = self.datasource[indexPath.section];
     HLBaseTypeInfo *info = infos[indexPath.row];
    return info.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * infos = self.datasource[section];
    if (section == 2 || [infos isEqual:self.blueToothdevices]) {
        HLPrinteHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLPrinteHeader"];
        header.name = section==2?@"我的设备":@"可配对设备";
        header.delegate = self;
        return header;
    }
   return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray * infos = self.datasource[section];
    if (section == 2 || [infos isEqual:self.blueToothdevices]) {
        return FitPTScreen(53);
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * infos = self.datasource[indexPath.section];
    HLBaseTypeInfo *info = infos[indexPath.row];
    if ([info.leftTip isEqualToString:@"打印门店"]) {
        HLSelectMDViewController *selectVC = [[HLSelectMDViewController alloc]init];
        selectVC.storeId = self.selectStoreId?:[HLAccount shared].store_id;
        weakify(self);
        selectVC.selectMD = ^(HLStoreModel *storeModel) {
            self.storeInfo.text = storeModel.nameText;
            weak_self.selectStoreId = storeModel.storeID;
            [weak_self loadDataWithType:1 printModel:0 orderType:0 printNum:0];
        };
        [self hl_pushToController:selectVC];
        return;
    }
    
    if ([info.leftTip isEqualToString:@"打印订单类型"] || [info.leftTip isEqualToString:@"打印联数"]) {
        [self alertViewWithModel:info];
    }
    
    if (indexPath.section == 2) {
//        蓝牙设置
        if (indexPath.row == infos.count-1 && self.connectInfo) {
            HLBlueToothSetingController * blueTooth = [[HLBlueToothSetingController alloc]init];
            [self hl_pushToController:blueTooth];
            return;
        }
//       WiFi设置
        HLWIFISettingController * wifi = [[HLWIFISettingController alloc]init];
        HLPrinterInfo * wifiInfo = (HLPrinterInfo *)info;
        wifi.printerInfo = wifiInfo.otherKey;
        wifi.storeID = _selectStoreId?:[HLAccount shared].store_id;
        [self hl_pushToController:wifi];
    }
    
//    点击蓝牙
    if ([infos isEqual:self.blueToothdevices]) {
        HLPrinterInfo * blueTooth = infos[indexPath.row];
        CBPeripheral * peripheral = (CBPeripheral *)blueTooth.otherKey;
        blueTooth.loading = YES;
        [HLPeripheral conncetPeripheral:peripheral callBack:^{
            blueTooth.loading = false;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - CellSelect
- (void)alertViewWithModel:(HLBaseTypeInfo *)info{
    HLPrinterInfo * printInfo = (HLPrinterInfo * )info;
    NSString * title = printInfo.leftTip;
    NSString * otherKey = (NSString *)printInfo.otherKey;
    BOOL isOrder = [title isEqualToString:@"打印订单类型"];
    weakify(self);
    [HLPrinterSettingAlertView showWithTitle:title type:isOrder?HLPrinterViewStyleDefault:HLPrinterViewStyleScroll dataSource:isOrder?self.printOrderTypes:self.printNums defaultIndex:otherKey.integerValue callBack:^(NSInteger clickIndex, NSInteger selectIndex) {
        
        if (clickIndex == 1) {
            if (isOrder) {
                HLPrinterItemModel * model = weak_self.printOrderTypes[selectIndex];
                printInfo.otherKey = [NSString stringWithFormat:@"%ld",selectIndex];
                printInfo.text = model.title;
                [HLAccount shared].order_mode = selectIndex + 1;
            }else{
                NSString * title = self.printNums[selectIndex];
                printInfo.text = [NSString stringWithFormat:@"%@联",title];
                printInfo.otherKey = [NSString stringWithFormat:@"%ld",selectIndex];
                [HLAccount shared].print_count = selectIndex +1;
            }
        }
        [weak_self loadDataWithType:2 printModel:0 orderType:isOrder?selectIndex+1:0 printNum:isOrder?0:selectIndex+1];
    }];
}

#pragma mark - Request

/// 获取数据
/// @param type type
/// @param printModel 打印模式
/// @param orderType 订单类型
/// @param printNum 打印连数
- (void)loadDataWithType:(NSInteger)type printModel:(NSInteger)printModel orderType:(NSInteger)orderType printNum:(NSInteger)printNum{
    if (type == 1)HLLoading(self.view);
    HLAccount * account = [HLAccount shared];
    NSDictionary * pargram = @{
                               @"store_id":account.store_id?:@"",
                               @"type":@(type),
                               @"print_mode":@(printModel),
                               @"order_mode":@(orderType),
                               @"print_count":@(printNum),
                               };
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/PrinterSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray * datas = result.data;
            if (type == 1) {
                [self.view addSubview:self.tableView];
                [self handleDataWithDict:datas.firstObject];
            }
            [self.tableView reloadData];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithDict:(NSDictionary *)dataDict{
    if (!dataDict)return;
    
    [self.datasource removeAllObjects];
    HLAccount * account = [HLAccount shared];
    //我的设备
    NSArray * wifiDevices = dataDict[@"list_info"];
    NSMutableArray * printers = [NSMutableArray array];
    for (NSDictionary * dict in wifiDevices) {
        HLPrinterInfo * device1 = [[HLPrinterInfo alloc]init];
        device1.type = HLInputCellPrinterType;
        device1.leftTip = dict[@"printer_name"]?:@"";
        device1.text = [dict[@"is_print"] integerValue] == 1?@"已连接":@"未连接";
        device1.rightImg = [UIImage imageNamed:@"set_oriange"];
        device1.leftImg = [UIImage imageNamed:@"wifi_black"];
        device1.otherKey = dict;
        device1.cellHeight = FitPTScreen(50);
        [printers addObject:device1];
    }

    NSDictionary * orderDict = ((NSArray *)dataDict[@"set_info"]).lastObject;
//    打印模式
    NSInteger printModel = [orderDict[@"print_mode"] integerValue];
//    订单类型
    NSInteger orderModel = [orderDict[@"order_mode"] integerValue];
//    打印连数
    NSInteger  printNum = [orderDict[@"print_count"] integerValue];

////    打印模式
    HLprinterModelInfo * modelInfo = [[HLprinterModelInfo alloc]init];
    modelInfo.type = HLInputCellPrinterModel;
    modelInfo.leftTip = @"打印模式";
    modelInfo.modelType = printModel;
    modelInfo.cellHeight = FitPTScreen(93);
//

////    打印订单类型
    HLPrinterItemModel * model = self.printOrderTypes[(orderModel > 0)?orderModel-1:0];

    HLPrinterInfo * orderType = [[HLPrinterInfo alloc]init];
    orderType.type = HLInputCellPrinterType;
    orderType.leftTip = @"打印订单类型";
    orderType.text = model.title;
    orderType.rightImg = [UIImage imageNamed:@"arrow_down_grey_light"];
    orderType.cellHeight = FitPTScreen(50);
    orderType.otherKey = [NSString stringWithFormat:@"%ld",(orderModel > 0)?orderModel-1:0];
//
////    打印连数
    NSString * title = self.printNums[(printNum > 0)?printNum-1:0];
    HLPrinterInfo * printerNum = [[HLPrinterInfo alloc]init];
    printerNum.type = HLInputCellPrinterType;
    printerNum.leftTip = @"打印联数";
    printerNum.text = [NSString stringWithFormat:@"%@联",title];
    printerNum.rightImg = [UIImage imageNamed:@"arrow_down_grey_light"];
    printerNum.cellHeight = FitPTScreen(50);
    printerNum.otherKey = [NSString stringWithFormat:@"%ld",(printNum > 0)?printNum-1:0];

////    第一个分组(打印门店，打印模式)
    NSMutableArray * first = [NSMutableArray arrayWithArray:@[self.storeInfo,modelInfo]];
    [self.datasource addObject:first];
//
    //    第二个分组（订单类型，打印联数）
    [self.datasource addObject:@[orderType,printerNum]];
//
////    第三个分组 （WiFi打印机 和连接的蓝牙）
    if ([HLBLEManager shared].curPeripheral) {
        _connectInfo = [self modelWithPeripheral:[HLBLEManager shared].curPeripheral];
        [printers addObject:_connectInfo];
    }
    [self.datasource addObject:printers];
////    第四个分组（蓝牙控制开关）
    [self.datasource addObject:@[self.switchInfo]];
////    第5️⃣个分组（扫描的蓝牙设备）
    [self.datasource addObject:self.blueToothdevices];
//
    if (printModel == 4 || !orderDict.count) {//一个都不选
        [self.placeDatasource addObjectsFromArray:self.datasource];
        [self.datasource removeAllObjects];
        [self.datasource addObject:first];
    }
//    //保存打印信息
    account.print_mode = printModel;
    account.print_count = printNum;
    account.order_mode = orderModel;
    account.printSet = YES;
    
    [self.tableView reloadData];
}


#pragma mark - SET&GET

- (HLPrinterInfo *)modelWithPeripheral:(CBPeripheral *)peripheral{
    HLPrinterInfo  * info = [[HLPrinterInfo alloc]init];
    info.type = HLInputCellPrinterType;
    info.leftTip = peripheral.name?:@"";
    info.text = peripheral.state == CBPeripheralStateConnected? @"已连接":@"未连接";;
    info.rightImg = [UIImage imageNamed:@"set_oriange"];
    info.leftImg = [UIImage imageNamed:@"bluetooth_black"];
    info.cellHeight = FitPTScreen(50);
    info.otherKey = peripheral;
    
    return info;
}


- (HLRightInputTypeInfo *)storeInfo{
    if (!_storeInfo) {
        _storeInfo = [[HLRightInputTypeInfo alloc]init];
        _storeInfo.leftTip = @"打印门店";
        _storeInfo.enabled = false;
        _storeInfo.text = [HLAccount shared].store_name;
        _storeInfo.cellHeight = FitPTScreen(50);
        _storeInfo.showRightArrow = YES;
    }
    return _storeInfo;
}

//蓝牙打印开关
- (HLRightSwitchInfo *)switchInfo{
    if (!_switchInfo) {
        _switchInfo = [[HLRightSwitchInfo alloc]init];
        _switchInfo.leftTip = @"蓝牙打印";
        _switchInfo.type = HLInputCellTypeRightSwitch;
        _switchInfo.switchOn = YES;
        _switchInfo.cellHeight = FitPTScreen(50);
    }
    return _switchInfo;
}

- (NSArray *)printOrderTypes{
    if (!_printOrderTypes) {
        HLPrinterItemModel * model1 = [[HLPrinterItemModel alloc]init];
        model1.title = @"所有订单";
        
        HLPrinterItemModel * model2 = [[HLPrinterItemModel alloc]init];
        model2.title = @"已支付订单";
        
        _printOrderTypes = @[model1,model2];
    }
    return _printOrderTypes;
}

- (NSArray *)printNums{
    if (!_printNums) {
        _printNums = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    }
    return _printNums;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)blueToothdevices{
    if (!_blueToothdevices) {
        _blueToothdevices = [NSMutableArray array];
    }
    return _blueToothdevices;
}

- (NSMutableArray *)placeDatasource{
    if (!_placeDatasource) {
        _placeDatasource = [NSMutableArray array];
    }
    return _placeDatasource;
}
@end
