//
//  HLWithDrawalMainController.m
//  HuiLife
//
//  Created by 王策 on 2019/9/10.
//

#import "HLWithDrawalMainController.h"
#import "HLWXAuthoView.h"
#import "HLWithDrawDealController.h"
#import "HLWithDrawalHead.h"
#import "HLWithDrawalInputView.h"
#import "HLWithDrawalPageInfo.h"

@interface HLWithDrawalMainController () <HLWithDrawalInputViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HLWithDrawalPageInfo *pageInfo;

@property (nonatomic, strong) UILabel *noteLab;
@property (nonatomic, strong) HLWithDrawalHead *headView;
@property (nonatomic, strong) HLWithDrawalInputView *inputView;

@end

@implementation HLWithDrawalMainController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setBackImage:@"back_white"];
    [self hl_setTitle:@"我要提现" andTitleColor:UIColor.whiteColor];
    [self hl_setBackgroundColor:UIColor.clearColor showLine:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
    [self creatFootViewWithButtonTitle:@"立即提现"];
    
    [self loadPageData];
}



-(void)loadWXInfoWithCode:(NSString *)code{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/ShopPlus/essentialInfo.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"code":code?:@""};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            [self handleWXInfoWithData:[(XMResult *)responseObject data] code:code];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}


-(void)handleWXInfoWithData:(NSDictionary *)data code:(NSString *)code{
    
//    是否授权
    BOOL authed = data.count > 0;
    NSString * pic = data[@"weinxin_pic"];
    
    NSString * key = data[@"weixin_number"];
    NSString * defalutKey = [HLTools valueForKey:hl_wxAuth_key];
    if (!defalutKey) {
        [HLTools storeValue:key?:@"" forKey:hl_wxAuth_key];
    }else{
        if ([key isEqualToString:defalutKey] && code.length) {
            [HLTools showWithText:@"你要更换的账号一样，请检查后再试"];
        }else{
            [HLTools storeValue:key?:@"" forKey:hl_wxAuth_key];
        }
    }
    
    [HLWXAuthoView showWXAuthWithAuthed:authed headPic:pic Completion:^(NSInteger index) {
        if (index == 0 || index == 1) {
            [[HLPayManage shareManage].wxManage sendAuthRequestWithScope:@"snsapi_userinfo" state:@"123" finishBlock:^(NSString *code, NSString * _Nonnull msg, NSString *state) {
                HLLog(@"code = %@,mag = %@,state = %@",code,msg,state);
                if (code.length) {
                    [self loadWXInfoWithCode:code];
                }
            }];
            return ;
        }
        if (index == 2) { //去提现
            [self withdrawWithMoney:[self.inputView inputWithdrawalMoney]];
        }
    }];
}


#pragma mark - 提现
-(void)withdrawWithMoney:(NSString *)money{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/ShopPlus/agentWithdraw.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"money":money};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        HLWithDrawDealController * dealVC = [[HLWithDrawDealController alloc]init];
        dealVC.success = [responseObject code] == 200;
        dealVC.money = money;
        [self hl_pushToController:dealVC];
        
//        刷新当前页面
        [self loadPageData];
        
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}


#pragma mark -

/// 加载数据
- (void)loadPageData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/ShopPlus/withdrawHome.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@1};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            self.pageInfo = [HLWithDrawalPageInfo mj_objectWithKeyValues:responseObject.data];
            // 配置头部可提现金额
            [_headView configCanWithdrawMoney:self.pageInfo.money];
            _noteLab.text = self.pageInfo.matters_info;
            [_inputView configWithdrawalMoney:0];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 点击保存按钮
- (void)saveButtonClick {
    
    NSString *moneyStr = [_inputView inputWithdrawalMoney];
    
    if (!_pageInfo) {
        HLShowHint(@"接口请求失败，退出重试", self.view);
        return;
    }
    
    if (moneyStr.length == 0) {
        HLShowHint(@"请输入提现金额", self.view);
        return;
    }
    
    if (moneyStr.doubleValue < _pageInfo.min_price) {
        NSString *tip = [NSString stringWithFormat:@"提现金额最低%@元",[NSString hl_stringWithNoZeroMoney:_pageInfo.min_price]];
        HLShowHint(tip, self.view);
        return;
    }
    
    if (moneyStr.doubleValue > _pageInfo.money) {
        HLShowHint(@"提现账户,超出限额", self.view);
        return;
    }
    
    if (moneyStr.doubleValue > _pageInfo.max_price) {
        NSString *tip = [NSString stringWithFormat:@"提现金额最高%@元",[NSString hl_stringWithNoZeroMoney:_pageInfo.max_price]];
        HLShowHint(tip, self.view);
        return;
    }
    
    if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
        HLShowHint(@"请安装微信客户端", self.view);
        return;
    }
    [self loadWXInfoWithCode:nil];
}

#pragma mark - HLWithDrawalInputViewDelegate
/// 点击全部提现
- (void)clickAllMoneyBtnWithInputView:(HLWithDrawalInputView *)inputView{
    [inputView configWithdrawalMoney:self.pageInfo.money];
    [inputView configAcceptMoney:self.pageInfo.money];
}

/// 输入框价格改变，计算手续费
- (void)inputMoneyChanged:(NSString *)inputMoney inputView:(HLWithDrawalInputView *)inputView{
    // 改变手续费
    [inputView configAcceptMoney:inputMoney.doubleValue];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self.view addSubview:footView];
    
    self.scrollView.frame = CGRectMake(0, 0, ScreenW, ScreenH - FitPTScreen(100));
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)creatSubViews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    _scrollView.bounces = NO;
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    AdjustsScrollViewInsetNever(self, _scrollView);
    
    UIView *contentView = [[UIView alloc] init];
    [_scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
    }];
    
    // 头部显示钱
    _headView = [[HLWithDrawalHead alloc] init];
    [contentView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView);
        make.height.equalTo(FitPTScreen(114) + Height_NavBar);
    }];
    
    // 输入钱选择提现方式
    _inputView = [[HLWithDrawalInputView alloc] init];
    [contentView addSubview:_inputView];
    _inputView.delegate = self;
    _inputView.backgroundColor = UIColor.whiteColor;
    _inputView.layer.cornerRadius = FitPTScreen(9);
    _inputView.layer.masksToBounds = YES;
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(_headView.bottom).offset(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(218));
    }];
    
    UIView *noteLine = [[UIView alloc] init];
    [contentView addSubview:noteLine];
    noteLine.backgroundColor = UIColorFromRGB(0xFF9616);
    noteLine.layer.cornerRadius = FitPTScreen(1.5);
    noteLine.layer.masksToBounds = YES;
    [noteLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(27));
        make.top.equalTo(_inputView.bottom).offset(FitPTScreen(15));
        make.width.equalTo(FitPTScreen(3));
        make.height.equalTo(FitPTScreen(14));
    }];
    
    UILabel *noteTipLab = [[UILabel alloc] init];
    [contentView addSubview:noteTipLab];
    noteTipLab.text = @"注意事项";
    noteTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    noteTipLab.textColor = UIColorFromRGB(0x777777);
    [noteTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noteLine);
        make.left.equalTo(noteLine.right).offset(FitPTScreen(5));
    }];
    
    UILabel *noteLab = [[UILabel alloc] init];
    [contentView addSubview:noteLab];
    noteLab.numberOfLines = 0;
    noteLab.text = @"";
    noteLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    noteLab.textColor = UIColorFromRGB(0x999999);
    _noteLab = noteLab;
    [noteLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(33));
        make.right.equalTo(FitPTScreen(-31));
        make.top.equalTo(noteTipLab.bottom).offset(FitPTScreen(15)).with.priorityHigh();
    }];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(noteLab.bottom).offset(FitPTScreen(15));
    }];
    
    if (isPad) {
        noteLine.hidden = YES;
        noteTipLab.hidden = YES;
        noteLab.hidden = YES;
    }
}

@end
