//
//  HLScanYMOrderController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/6/18.
//

#import "HLScanYMOrderController.h"
#import "HLLLTableViewCell.h"
#import "HLScanYMGoodTableCell.h"
#import "HLScanYMMainInfo.h"

#define KBttomButtonMargn (FitPTScreen(76) + Height_Bottom_Margn)

@interface HLScanYMOrderController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HLScanYMMainInfo *mainInfo;
@end

@implementation HLScanYMOrderController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"商品订单"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestMainData];
}

#pragma mark - request
- (void)requestMainData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHxOrder.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":self.order_id?:@"2628713"};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            self.mainInfo = [HLScanYMMainInfo mj_objectWithKeyValues:result.data];
            if (!self.mainInfo.is_hx) {
                [self initBottomButton];
            }
            [self.tableView reloadData];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark-Event
- (void)confirmClick {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHxOrderAC.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":self.order_id?:@"2628713"};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowHint(@"订单核销成功", nil);
            [HLNotifyCenter postNotificationName:HLNewOrderClickedFunctionNotifi object:@[@"0",@"1",@"2",@"3",@"4"]];
            [self hl_goback];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HLLLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLLLTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell titleColor:UIColorFromRGB(0x999999) titleFont:[UIFont systemFontOfSize:FitPTScreen(12)]];
            [cell conColor:UIColorFromRGB(0xFD912E) conFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
            cell.title = [NSString stringWithFormat:@"订单号：%@",_mainInfo.order_id];
            cell.content = _mainInfo.is_hx?@"已自提":@"待取货";
        } else {
            [cell titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
            [cell conColor:UIColorFromRGB(0x222222) conFont:[UIFont boldSystemFontOfSize:FitPTScreen(14)]];
            if (indexPath.row == 1) {
                cell.title = @"自提信息：";
                cell.content = _mainInfo.ziti_info;
            } else {
                cell.title = @"自提时间：";
                cell.content = _mainInfo.closing_date;
            }
            
        }
        return cell;
    }
    HLScanYMGoodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLScanYMGoodTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goods = _mainInfo.pro_info;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return FitPTScreen(51);
    }
    return _mainInfo.orderInfoHight;
}

#pragma mark - UIView
- (void)initSubView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - KBttomButtonMargn - FitPTScreen(72)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.backgroundColor = UIColorFromRGB(0xf6f7f6);
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0,KBttomButtonMargn + FitPTScreen(72), 0);
    AdjustsScrollViewInsetNever(self, _tableView);
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[HLLLTableViewCell class] forCellReuseIdentifier:@"HLLLTableViewCell"];
    [_tableView registerClass:[HLScanYMGoodTableCell class] forCellReuseIdentifier:@"HLScanYMGoodTableCell"];
    
}

- (void)initBottomButton {
    UIButton *confirmBtn = [[UIButton alloc]init];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认核销" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:confirmBtn];
    [confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(-KBttomButtonMargn);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"waring_red"]];
    [self.view addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(114));
        make.top.equalTo(confirmBtn.bottom);
    }];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.textColor = UIColorFromRGB(0xFF9920);
    tipLb.text = @"商品核销成功后不可修改";
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.view addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView.right).offset(FitPTScreen(5));
        make.centerY.equalTo(tipView);
    }];
    
}
@end
