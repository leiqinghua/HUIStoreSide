//
//  HLRedBagAddController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import "HLRedBagAddController.h"
#import "HLRedBagAddFooter.h"
#import "HLDayDealGoodController.h"
#import "HLRedBagInfo.h"
#import "HLPaySuccessController.h"

@interface HLRedBagAddController ()<UITableViewDelegate,UITableViewDataSource,HLRedBagSetViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *saveButton;
@property(nonatomic, strong) HLRedBagInfo *redBagInfo;
@property(nonatomic, strong) NSString *selectName;
@property(nonatomic, strong) NSString *selectId;
@end

@implementation HLRedBagAddController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"红包推广"];
    [self hl_setBackImage:@"back_black"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Request
- (void)saveRequest {
    HLLoading(self.view);
    NSMutableDictionary *pargram = [NSMutableDictionary dictionaryWithDictionary:[self.redBagInfo mj_JSONObject]];
    [pargram setObject:_selectId forKey:@"proId"];
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/SeckillAdd.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handlePay:result.data];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handlePay:(NSDictionary *)payData {
    if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
        [HLTools showWithText:@"请下载微信客户端"];
        return;
    }
    [[HLPayManage shareManage].wxManage prepareWXPayWithPayParams:payData finishBlock:^(BOOL success, NSString * _Nonnull msg) {
        if (success) { //跳转成功页面
            HLPaySuccessController *successVC = [[HLPaySuccessController alloc]init];
            successVC.price = [NSString stringWithFormat:@"%.2f",ceil(self.redBagInfo.total.doubleValue *1.01 * 100)/100.0];
            [self hl_pushToController:successVC];
            return;
        }
        dispatch_main_async_safe(^{
            [HLTools showWithText:msg];
        });
    }];
}

#pragma mark - Event
- (void)saveClick {
    if (!_selectName.length) {
        [HLTools showWithText:@"请选择秒杀商品"];
        return;
    }
    [self saveRequest];
}

#pragma mark - HLRedBagSetViewDelegate
- (void)textFieldDidEdit:(UITextField *)textField price:(BOOL)price {
    if ((!price && self.redBagInfo.total.doubleValue && textField.text.integerValue) || (price && self.redBagInfo.num && textField.text.doubleValue)) {
        [_saveButton setTitle:[NSString stringWithFormat:@"保存并支付¥%.2f",ceil(self.redBagInfo.total.doubleValue *1.01 * 100)/100.0] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateHighlighted];
        _saveButton.userInteractionEnabled = YES;
        return;
    }
    [_saveButton setTitle:@"保存并支付" forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"bag_btn_unable"] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"bag_btn_unable"] forState:UIControlStateHighlighted];
    _saveButton.userInteractionEnabled = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    cell.textLabel.textColor = UIColorFromRGB(0x222222);
    cell.textLabel.text = @"推广商品";
    UILabel *subLb = [cell.contentView viewWithTag:1000];
    if (!subLb) {
        subLb = [UILabel hl_regularWithColor:@"#333333" font:14];
        subLb.tag = 1000;
        subLb.text = @"请选择秒杀推广";
        [cell.contentView addSubview:subLb];
        [subLb makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-30));
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLDayDealGoodController *dayDealVC = [[HLDayDealGoodController alloc]init];
    dayDealVC.goodId = _selectId;
    weakify(self);
    dayDealVC.dayDealBlock = ^(NSString * _Nonnull name, NSString * _Nonnull Id) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *lable = [cell.contentView viewWithTag:1000];
        lable.text = name;
        weak_self.selectName = name;
        weak_self.selectId = Id;
        [tableView reloadData];
    };
    [self hl_pushToController:dayDealVC];
}

#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    
    CGFloat bottomHeight = FitPTScreen(100);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - bottomHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = FitPTScreen(52);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = FitPTScreen(10);
    _tableView.sectionHeaderHeight = FitPTScreen(10);
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    AdjustsScrollViewInsetNever(self, _tableView);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    HLRedBagAddFooter *tableFooter = [[HLRedBagAddFooter alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(428))];
    tableFooter.delegate = self;
    tableFooter.redBagInfo = self.redBagInfo;
    _tableView.tableFooterView = tableFooter;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds) - bottomHeight, ScreenW,bottomHeight)];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    _saveButton = [[UIButton alloc] init];
    [footView addSubview:_saveButton];
    _saveButton.userInteractionEnabled = NO;
    [_saveButton setTitle:@"保存并支付" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"bag_btn_unable"] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"bag_btn_unable"] forState:UIControlStateHighlighted];
    [_saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(footView);
    }];
    [_saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (HLRedBagInfo *)redBagInfo {
    if (!_redBagInfo) {
        _redBagInfo = [[HLRedBagInfo alloc]init];
    }
    return _redBagInfo;
}

@end
