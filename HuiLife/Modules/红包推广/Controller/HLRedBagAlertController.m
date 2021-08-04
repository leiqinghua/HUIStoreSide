//
//  HLRedBagAlertController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/18.
//

#import "HLRedBagAlertController.h"
#import "HLRedBagSetView.h"
#import "HLRedBagInfo.h"

@interface HLRedBagAlertController ()<HLRedBagSetViewDelegate>
@property(nonatomic, strong) UIView *alertView;
@property(nonatomic, strong) HLRedBagSetView *redBagSetView;
@property(nonatomic, strong) HLRedBagInfo *redBagInfo;
@property(nonatomic, strong) UIButton *payBtn;
@end

@implementation HLRedBagAlertController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self show];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Request
- (void)saveRequest {
    HLLoading(self.view);
    NSMutableDictionary *pargram = [NSMutableDictionary dictionaryWithDictionary:[self.redBagInfo mj_JSONObject]];
    [pargram setObject:_proId forKey:@"proId"];
    [pargram setObject:_extendId forKey:@"extendId"];
    
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
            NSString *price = [NSString stringWithFormat:@"%.2f",ceil(self.redBagInfo.total.doubleValue *1.01 * 100)/100.0];
            if (self.successBlock) {
                self.successBlock(price);
            }
            [self hide];
            return;
        }
        dispatch_main_async_safe(^{
            [HLTools showWithText:msg];
        });
    }];
}

#pragma mark - Method
- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH - CGRectGetMaxY(self.alertView.bounds);
        self.alertView.frame = frame;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Event
- (void)cancleClick {
    [self hide];
}

- (void)payClick {
    if (!self.redBagInfo.total.doubleValue) {
        [HLTools showWithText:@"请输入追加金额"];
        return;
    }
    
    if (!self.redBagInfo.num) {
        [HLTools showWithText:@"请输入追加红包个数"];
        return;
    }
    
    [self saveRequest];
}

#pragma mark - HLRedBagSetViewDelegate
- (void)textFieldDidEdit:(UITextField *)textField price:(BOOL)price {
    if (price && textField.text.doubleValue) {
        [_payBtn setTitle:[NSString stringWithFormat:@"追加并支付¥%.2f",ceil(self.redBagInfo.total.doubleValue *1.01 * 100) / 100.0] forState:UIControlStateNormal];
    }
}

#pragma mark - UIView
- (void)initSubView {
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    CGFloat redBagSetHeight = self.hideTime?FitPTScreen(278):FitPTScreen(348);
    CGFloat alertViewHeight = self.hideTime?FitPTScreen(405):FitPTScreen(475);
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, alertViewHeight + Height_Bottom_Margn)];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_alertView];
    [_alertView hl_addCornerRadius:FitPTScreen(17.5) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    UILabel *titleLb = [UILabel hl_regularWithColor:@"#222222" font:16];
    titleLb.text = @"追加红包";
    [_alertView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(FitPTScreen(15));
    }];
    
    UIButton *cancleBtn = [UIButton hl_regularWithImage:@"close_x_grey" select:NO];
    [_alertView addSubview:cancleBtn];
    [cancleBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alertView);
        make.centerY.equalTo(titleLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(38), FitPTScreen(20)));
    }];
    [cancleBtn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [_alertView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alertView);
        make.top.equalTo(FitPTScreen(50));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    _redBagSetView = [[HLRedBagSetView alloc]init];
    [_alertView addSubview:_redBagSetView];
    [_redBagSetView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alertView);
        make.top.equalTo(line.bottom);
        make.height.equalTo(redBagSetHeight);
    }];
    _redBagSetView.backgroundColor = UIColor.whiteColor;
    _redBagSetView.delegate = self;
    _redBagSetView.title = @"追加推广红包";
    _redBagSetView.timeTitle = @"追加推广时间";
    _redBagSetView.rangeTitle = @"领取范围";
    _redBagSetView.priceTitle = @"追加金额";
    _redBagSetView.pricePlace = @"请输入追加金额";
    _redBagSetView.numTitle = @"追加红包个数";
    _redBagSetView.numPlace = @"请输入追加红包个数";
    _redBagSetView.times = _hideTime?@[]:@[@"+10天",@"+30天",@"领完为止"];
    _redBagSetView.redBagInfo = self.redBagInfo;
    self.redBagInfo.timeType = [self.redBagInfo.rangTimes objectAtIndex:_hideTime?2:0];
    [_redBagSetView seletTimeAtIndex:_hideTime?2:0];
    [_redBagSetView selectRangeAtIndex:0];
    
    _payBtn = [[UIButton alloc]init];
    [_payBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [_payBtn setTitle:@"追加并支付" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_alertView addSubview:_payBtn];
    [_payBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.redBagSetView.bottom);
    }];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
}

- (HLRedBagInfo *)redBagInfo {
    if (!_redBagInfo) {
        _redBagInfo = [[HLRedBagInfo alloc]init];
    }
    return _redBagInfo;
}

@end
