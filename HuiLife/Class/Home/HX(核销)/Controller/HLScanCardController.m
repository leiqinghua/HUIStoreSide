//
//  HLScanCardController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/8/27.
//

#import "HLScanCardController.h"
#import "HLScanCardBaseView.h"
#import "HLScanCardMainInfo.h"

@interface HLScanCardController ()
@property(nonatomic, strong) UILabel *orderLb;
@property(nonatomic, strong) UILabel *phoneLb;
@property(nonatomic, strong) UIImageView *cardImV;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UILabel *dateLb;//开卡日期
@property(nonatomic, strong) UILabel *expirLb;//过期时间
@property(nonatomic, strong) UILabel *vipCardLb;
@property(nonatomic, strong) UILabel *numLb;//剩余核销次数
@property(nonatomic, strong) UIButton *concernBtn;//确认核销按钮
@property(nonatomic, strong) HLScanCardMainInfo *mainInfo;
@property(nonatomic, strong) HLScanCardBaseView *scanView;
@property(nonatomic, strong) UIView *scanBottomView;
@property(nonatomic, strong) UIView *coverView;
@end

@implementation HLScanCardController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hl_setTitle:@"开卡有礼" andTitleColor:UIColorFromRGB(0x222222)];
    [self hl_setBackImage:@"back_oriange"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultData];
}

#pragma mark - request
//加载默认数据
- (void)loadDefaultData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/GainUseBuss.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"userGainId":_userGainId?:@""};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            self.mainInfo = [HLScanCardMainInfo mj_objectWithKeyValues:result.data];
            [self configData];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
//确认核销
- (void)concernHX {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/GainUseBuss.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"userGainId":_userGainId?:@"",@"storeId":[HLAccount shared].store_id?:@""};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200 || result.code == 92209) {
            _mainInfo.gains.firstObject.gainState = 1;
            [self configData];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
#pragma mark - Event
- (void)concernClick {
    [self concernHX];
}

#pragma mark - Method
- (void)configData {
    //    0 卡，1 礼品，2代金券
    NSInteger type = _mainInfo.gains.firstObject.gainType;
    if (!_scanView) {
        switch (type) {
            case 0:
                _scanView = [[HLScanCardView alloc]initWithFrame:self.scanBottomView.bounds];
                break;
            case 1:
                _scanView = [[HLScanGiftView alloc]initWithFrame:self.scanBottomView.bounds];
                break;
            case 2:
                _scanView = [[HLScanVolumeView alloc]initWithFrame:self.scanBottomView.bounds];
            break;
            default:
                break;
        }
        [self.scanBottomView addSubview:_scanView];
    }
    _scanView.goodInfo = _mainInfo.gains.firstObject;
    _phoneLb.text = [HLTools getMiddleHideTextWithPhoneNum:_mainInfo.phone];
    [_cardImV sd_setImageWithURL:[NSURL URLWithString:_mainInfo.cardIcon] placeholderImage:[UIImage imageNamed:@""]];
    _nameLb.text = _mainInfo.cardName;
    _dateLb.text = [NSString stringWithFormat:@"开卡日期：%@",_mainInfo.cardStart];
    _expirLb.text = [NSString stringWithFormat:@"截止日期：%@",_mainInfo.cardEnd];
    _orderLb.text = _mainInfo.orderNo;
    _vipCardLb.text = _mainInfo.flag;
    _numLb.text = _mainInfo.verify;
    [self showConcernCover:(_mainInfo.gains.firstObject.gainState == 1)];
}

#pragma mark - UIView
- (void)initSubView {
    if (_scanBottomView) return;
    self.view.backgroundColor = UIColorFromRGB(0xf5f6f9);
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = UIColor.whiteColor;
    topView.frame = CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(80));
    [self.view addSubview:topView];
    
    UILabel *orderTipLb = [[UILabel alloc]init];
    orderTipLb.textColor = UIColorFromRGB(0x333333);
    orderTipLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    orderTipLb.text = @"订单号";
    [topView addSubview:orderTipLb];
    [orderTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(14));
    }];
    
    _orderLb = [[UILabel alloc]init];
    _orderLb.textColor = UIColorFromRGB(0x888888);
    _orderLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [topView addSubview:_orderLb];
    [_orderLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(orderTipLb);
    }];
    
    _vipCardLb = [[UILabel alloc]init];
    _vipCardLb.backgroundColor = UIColorFromRGB(0xFD9E2F);
    _vipCardLb.layer.cornerRadius = FitPTScreen(1);
    _vipCardLb.layer.masksToBounds = YES;
    _vipCardLb.text = @"会员卡";
    _vipCardLb.textAlignment = NSTextAlignmentCenter;
    _vipCardLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _vipCardLb.textColor = UIColor.whiteColor;
    [topView addSubview:_vipCardLb];
    [_vipCardLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderLb.left).offset(FitPTScreen(-4));
        make.centerY.equalTo(self.orderLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(41), FitPTScreen(15)));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [topView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(-0.5);
        make.top.equalTo(FitPTScreen(40));
        make.height.equalTo(0.5);
    }];
    
    UILabel *phoneTipLb = [[UILabel alloc]init];
    phoneTipLb.textColor = UIColorFromRGB(0x333333);
    phoneTipLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    phoneTipLb.text = @"会员手机号";
    [topView addSubview:phoneTipLb];
    [phoneTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.bottom.equalTo(FitPTScreen(-15));
    }];
    
    _phoneLb = [[UILabel alloc]init];
    _phoneLb.textColor = UIColorFromRGB(0x888888);
    _phoneLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [topView addSubview:_phoneLb];
    [_phoneLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(phoneTipLb);
    }];
    
    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = UIColor.whiteColor;
    cardView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame) + FitPTScreen(10), ScreenW, FitPTScreen(80));
    [self.view addSubview:cardView];
    
    _cardImV = [[UIImageView alloc]init];
    _cardImV.image = [UIImage imageNamed:@""];
    [cardView addSubview:_cardImV];
    [_cardImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(cardView);
        make.size.equalTo(CGSizeMake(FitPTScreen(60), FitPTScreen(60)));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColorFromRGB(0x333333);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [cardView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImV.right).offset(FitPTScreen(20));
        make.top.equalTo(FitPTScreen(13));
    }];
    
    _dateLb = [[UILabel alloc]init];
    _dateLb.textColor = UIColorFromRGB(0x888888);
    _dateLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [cardView addSubview:_dateLb];
    [_dateLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(13));
    }];
    
    _expirLb = [[UILabel alloc]init];
    _expirLb.textColor = UIColorFromRGB(0x888888);
    _expirLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [cardView addSubview:_expirLb];
    [_expirLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateLb);
        make.right.equalTo(FitPTScreen(-12));
    }];
        
    _scanBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cardView.frame) + FitPTScreen(9), ScreenW, FitPTScreen(112))];
    [self.view addSubview:_scanBottomView];
    
    _numLb = [UILabel hl_singleLineWithColor:@"#FF5555" font:17 bold:YES];
    [self.view addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanBottomView.bottom).offset(FitPTScreen(23));
        make.centerX.equalTo(self.view);
    }];
    _numLb.text = @"本次核销1次";
    
    _concernBtn = [UIButton hl_regularWithTitle:@"确认核销" titleColor:@"#FFFFFF" font:13 image:@""];
    _concernBtn.backgroundColor = UIColorFromRGB(0xFD9E30);
    _concernBtn.layer.cornerRadius = FitPTScreen(20);
    [self.view addSubview:_concernBtn];
    [_concernBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLb.bottom).offset(FitPTScreen(30));
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(FitPTScreen(351), FitPTScreen(40)));
    }];
    
    UIButton *tipBtn = [UIButton hl_regularWithTitle:@" 商品核销成功后不可修改" titleColor:@"#9A9A9A" font:12 image:@"waring"];
    [self.view addSubview:tipBtn];
    [tipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.concernBtn.bottom).offset(FitPTScreen(25));
        make.centerX.equalTo(self.view);
    }];
    [_concernBtn addTarget:self action:@selector(concernClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showConcernCover:(BOOL)show {
    if (show && !_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _coverView.layer.cornerRadius = FitPTScreen(20);
        [self.concernBtn addSubview:_coverView];
        [_coverView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.concernBtn);
        }];
    }
    _coverView.hidden = !show;
}
@end
