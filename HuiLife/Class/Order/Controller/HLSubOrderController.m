//
//  HLSubOrderController.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/27.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLSubOrderController.h"
#import "HLBaseOrderModel.h"
#import "HLOrderBaseTableCell.h"
#import "HLOrderLayoutManager.h"
#import "HLOrderOpetionHelper.h"
#import "HLRefundViewController.h"
#import "HLNavigateViewController.h"
#import "HLOrderQrcodeView.h"

@interface HLSubOrderController () <UITableViewDelegate, UITableViewDataSource, HLOrderOpetionDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *datasource;
@property (strong, nonatomic) NSArray *dates;
@property (assign, nonatomic) NSInteger date_tag;
@property (assign, nonatomic) BOOL loaded;//是否加载过
@property (assign, nonatomic) NSInteger page;
@end

@implementation HLSubOrderController

- (void)updateFrame:(CGRect)frame {
    self.view.frame = frame;
}
#pragma mark - request
- (void)loadDataWithDate:(NSString *)date loading:(BOOL)loading {
    if (_date_tag == 0 && ![self.dates hl_isAvailable]) {
        _date_tag = 2;
    }
    
    NSDictionary *pargram = @{
        @"type": @(_type),
        @"page": @(_page),
        @"date": date ?: @"",
        @"start_date": self.dates.firstObject ?: @"",
        @"end_date": self.dates.lastObject ?: @"",
        @"date_tag": @(_date_tag)
    };
    if (loading) HLLoading(self.view);
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/OrderListNew.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        self.loaded = YES;
        [self.tableView endRefresh];
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray *datas = result.data;
            [self handleDataWithDict:datas.firstObject];
            return;
        }
        if (self.page > 1) self.page--;
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (self.page > 1) self.page--;
    }];
}

- (void)handleDataWithDict:(NSDictionary *)dict {
    if (_page == 1) [self.datasource removeAllObjects];
    NSArray *orders = dict[@"info"];
    if (!orders.count) {
        [_tableView endNomorData];
    }
    for (NSDictionary *data in orders) {
        HLBaseOrderLayout *orderLayout = [HLOrderLayoutManager orderLayoutWithDict:data tableView:_tableView];
        [self.datasource addObject:orderLayout];
    }
    if (self.datasource.count) {
        [_tableView hideFooter:false];
        [_tableView removeEmptyView];
    } else {
        if (![_tableView emptyViewIsShow]){
            CGRect noDataFrame = CGRectMake(0, FitPTScreen(10), ScreenW, CGRectGetMaxY(self.tableView.bounds) - FitPTScreen(10));
            [HLEmptyDataView emptyViewWithFrame:noDataFrame
                                      superView:self.tableView
                                           type:@"0"
                                         balock:nil];
        };
    }
    [self.tableView reloadData];
    
    NSDictionary *titleNum = dict[@"titleNum"];
    //数量
    NSArray *nums = [self numbersWithDict:titleNum];
    
    [HLNotifyCenter postNotificationName:HLNewOrderTitleNumsNotifi object:nums];
}

#pragma mark - Event
- (void)bottomButtonClick:(NSNotification *)sender {
    NSArray *types = sender.object;
    for (NSString *type in types) {
        if (_type == type.integerValue) {
            [self updateFirstPageDatas];
        }
    }
}

#pragma mark - Method
- (void)reloadDataWithDates:(NSArray *)dates tag:(NSInteger)tag {
    _dates = dates;
    _date_tag = tag;
    if (_loaded) {
        _page = 1;
        [self.datasource removeAllObjects];
        [self loadDataWithDate:_currentDate loading:YES];
    }
}

- (void)loadList {
    if (!_loaded) {
        _page = 1;
        [self loadDataWithDate:_currentDate loading:YES];
    }
}

- (NSString *)printerSnWithSelects:(NSArray *)selects{
    NSMutableArray * arr = [NSMutableArray array];
    for (HLPrinterItemModel *model in selects) {
        if (!model.isBluetooth) {
            [arr addObject:model.Id];
        }
    }
    return [arr mj_JSONString];
}

- (NSArray *)numbersWithDict:(NSDictionary *)dict {
    NSMutableArray *numbers = [NSMutableArray array];
    
    NSInteger wait = [dict[@"waitNum"] integerValue];
    NSInteger ingNum = [dict[@"ingNum"] integerValue];
    NSInteger okNum = [dict[@"okNum"] integerValue];
    NSInteger refundNum = [dict[@"refundNum"] integerValue];
    NSInteger usedNum = [dict[@"usedNum"] integerValue];
    
    [numbers addObject:@(wait)];
    [numbers addObject:@(ingNum)];
    [numbers addObject:@(okNum)];
    [numbers addObject:@(refundNum)];
    [numbers addObject:@(usedNum)];
    return numbers;
}

#pragma mark - Notification
- (void)updateFirstPageDatas {
    _page = 1;
    [self loadDataWithDate:_currentDate loading:YES];
}

- (void)registerNotification {
    [HLNotifyCenter addObserver:self selector:@selector(bottomButtonClick:) name:HLNewOrderClickedFunctionNotifi object:nil];
    [HLNotifyCenter addObserver:self selector:@selector(updateFirstPageDatas) name:HLNewOrderReloadDataNotifi object:nil];
}

#pragma mark - HLOrderOpetionDelegate
- (void)hl_reloadOrderViewCellHightWithLayout:(HLBaseOrderLayout *)layout {
    [self.tableView reloadData];
    
}

- (void)hl_goToNavigatePageWithLayout:(HLBaseOrderLayout *)layout {
    HLNavigateViewController *navigate = [[HLNavigateViewController alloc] init];
    HLScanOrderModel *model = (HLScanOrderModel *)layout.orderModel;
    navigate.address = model.address;
    UIViewController *vc = [self fatherController];
    if (vc) {
        [vc hl_pushToController:navigate];
    }
}

//处理服务器返回的按钮 的事件
- (void)hl_functionWithName:(NSString *)name orderLayout:(HLBaseOrderLayout *)layout {
    HLBaseOrderModel *orderModel = layout.orderModel;
    if ([orderModel isKindOfClass:[HLScanOrderModel class]]) {
        HLScanOrderModel *scanModel = (HLScanOrderModel *)orderModel;
        if (scanModel.dispatchType == 0 && scanModel.dispatch_mobile.length) {
            [HLTools callPhone:scanModel.dispatch_mobile];
            return;
        }
        // 展示二维码
        if (scanModel.dispatchType == 1 && scanModel.qr_code.length) {
            [HLOrderQrcodeView showWithQrcode:scanModel.qr_code];
        }
    }
}


- (void)hl_functionWithTypeIndex:(NSInteger)index orderLayout:(HLBaseOrderLayout *)layout {
    HLLog(@"index = %ld",index);
    switch (index) {
        case 1://配送
        {
            [HLOrderOpetionHelper hl_deliverdWithModel:layout.orderModel completion:^{
                [HLTools showWithText:@"配送成功"];
                self.page = 1;
                [self loadDataWithDate:self.currentDate loading:YES];
            }];
            
        }
            break;
        case 2://打印
        {
            [HLOrderOpetionHelper hl_wifiListWithModel:layout.orderModel completion:^(NSArray * _Nonnull printers) {
                [HLPrinterSettingAlertView showWithTitle:@"打印机" type:HLPrinterViewStyleDefault dataSource:printers selects:^(BOOL blueTooth, NSArray * _Nonnull selects) {
                    [[HLBLEManager shared]printeDataWithOrderId:layout.orderModel.order_id blueTooth:blueTooth wifiSn:[self printerSnWithSelects:selects] type:1 success:^{
                                            
                    }];
                }];
            }];
            
        }
            break;
        case 3://退款
        {
            HLScanOrderModel *model = (HLScanOrderModel *)layout.orderModel;
            if (model.refund == 1) {
                [HLTools showWithText:model.refund_txt];
                return;
            }
            HLRefundViewController *refundVC = [[HLRefundViewController alloc] init];
            refundVC.orderid = model.order_id;
            UIViewController *vc = [self fatherController];
            if (vc) [vc hl_pushToController:refundVC];
        }
            break;
        case 4://自提
        {
            [HLOrderOpetionHelper hl_MentionWithModel:layout.orderModel completion:^{
                [HLTools showWithText:@"自提成功"];
                [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0",@"1",@"2"]];
            }];
            
        }break;
        case 5://送达
        {
            [HLOrderOpetionHelper hl_arrivedWithModel:layout.orderModel completion:^{
                [HLTools showWithText:@"送达成功"];
                [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0", @"1", @"2"]];
            }];
            
        }
            break;
        case 6: // 立即接单
        {
            [HLCustomAlert showNormalStyleTitle:@"" message:@"确定要接单吗？" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x333333),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
                if (index == 1) {
                    [HLOrderOpetionHelper hl_wifiListWithModel:layout.orderModel completion:^(NSArray * _Nonnull printers) {
                        [HLOrderOpetionHelper hl_acceptOrderWithModel:layout.orderModel completion:^{
                            // 调用打印接口
                            HLShowHint(@"接单成功", nil);
                            [HLPrinterSettingAlertView showWithTitle:@"打印机" type:HLPrinterViewStyleDefault dataSource:printers selects:^(BOOL blueTooth, NSArray * _Nonnull selects) {
                                [[HLBLEManager shared]printeDataWithOrderId:layout.orderModel.order_id blueTooth:blueTooth wifiSn:[self printerSnWithSelects:selects] type:1 success:^{
                                                        
                                }];
                            }];
                            [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0", @"1", @"2"]];
                        }];
                    }];
                }
            }];
        }
            break;
        case 7: // 拒绝接单
        {
            [HLCustomAlert showNormalStyleTitle:@"" message:@"要拒绝接单吗？" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x333333),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
                if (index == 1) {
                    [HLOrderOpetionHelper hl_refuseOrderWithModel:layout.orderModel completion:^{
                        HLShowHint(@"退单成功", nil);
                        [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0", @"3"]];
                    }];
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseOrderLayout *layout = self.datasource[indexPath.row];
    HLOrderBaseTableCell *cell = (HLOrderBaseTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:layout.orderModel.identifier indexPath:indexPath];
    cell.orderLayout = layout;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLBaseOrderLayout *layout = self.datasource[indexPath.row];
    return layout.totalHight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self registerNotification];
}

#pragma mark - UIView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        /** 以下三行，防止刷新时 cell 抖动*/
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColorFromRGB(0xf6f7f6);
        _tableView.scrollsToTop = YES;
        AdjustsScrollViewInsetNever(self, _tableView);
        
        CGRect noDataFrame = CGRectMake(0, FitPTScreen(10), ScreenW, CGRectGetMaxY(self.view.bounds) - FitPTScreen(10));
        [HLEmptyDataView emptyViewWithFrame:noDataFrame
                                  superView:_tableView
                                       type:@"0"
                                     balock:nil];
        //        防止tabbar 遮挡
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_tableView footerWithEndText:@"没有更多数据"
                      refreshingBlock:^{
            self.page++;
            [self loadDataWithDate:self.currentDate loading:false];
        }];
        
        [_tableView headerNormalRefreshingBlock:^{
            self.page = 1;
            [self loadDataWithDate:self.currentDate loading:false];
        }];
        [_tableView hideFooter:YES];
    }
    return _tableView;
}


#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
@end
