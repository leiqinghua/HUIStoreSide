//
//  HLScanViewController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/31.
//

#import "HLScanViewController.h"
#import "HLScanGoodViewCell.h"

@interface HLScanViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation HLScanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"商品订单"];
}

- (void)confirmClick {
    [self confirmOrder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
//    [self initBottomBtn];
    [self loadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = FitPTScreen(173);
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColorFromRGB(0xf6f7f6);
        AdjustsScrollViewInsetNever(self, _tableView);
        
        [_tableView registerClass:[HLScanGoodViewCell class] forCellReuseIdentifier:@"HLScanGoodViewCell"];
    }
    return _tableView;
}

- (void)initBottomBtn {
    UIButton *confirmBtn = [[UIButton alloc]init];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认核销" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:confirmBtn];
    [confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-76) - Height_Bottom_Margn);
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLScanGoodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLScanGoodViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodModel = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - request

- (void)loadData {
     HLLoading(self.view);
       [XMCenter sendRequest:^(XMRequest *request) {
           request.api = @"/MerchantSideA/BusinessHxOrder.php";
           request.serverType = HLServerTypeNormal;
           request.parameters = @{@"order_id":self.order_id?:@""};
       }onSuccess:^(id responseObject) {
            HLHideLoading(self.view);
           // 处理数据
           XMResult *result = (XMResult *)responseObject;
           if (result.code == 200) {
               self.dataSource = [NSMutableArray array];
               HLScanGoodModel *model = [HLScanGoodModel mj_objectWithKeyValues:result.data];
               [self.dataSource addObject:model];
               [self.tableView reloadData];
               if (model.is_hx == 0) {
                   [self initBottomBtn];
               }
           }
       }onFailure:^(NSError *error) {
           HLHideLoading(self.view);
       }];
}

- (void)confirmOrder {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessHxOrderAC.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":self.order_id};
    }onSuccess:^(id responseObject) {
         HLHideLoading(self.view);
        // 处理数据
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

@end
