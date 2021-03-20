//
//  HLCardProductController.m
//  HuiLife
//
//  Created by 王策 on 2019/10/11.
//

#import "HLCardProductController.h"
#import "HLProduceReviewController.h"
#import "HLSwitch.h"

@interface HLCardProductController ()

@property (nonatomic, strong) UIView *switchBgV;
@property (nonatomic, strong) HLSwitch *switchV;

@property (nonatomic, strong) UIView *invateNumBgV;
@property (nonatomic, strong) UITextField *invateNumTextField;

@property (nonatomic, strong) UIView *maxNumBgV;
@property (nonatomic, strong) UITextField *maxNumTextField;

@end

@implementation HLCardProductController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"发布设置"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatFootView];
    [self creatSwitchBgV];
    [self creatInvateNumV];
    [self creatMaxNumV];
    
    _invateNumBgV.hidden = YES;
    _maxNumBgV.hidden = YES;
}

- (void)switchTapClick:(UITapGestureRecognizer *)tap{
    _switchV.select = !_switchV.select;
    _invateNumBgV.hidden = !_switchV.select;
    _maxNumBgV.hidden = !_switchV.select;
}

//上传生成预览图
-(void)upReviewDatas{
    
    BOOL switchSelect = _switchV.select;
    [self.pargram setObject:switchSelect ? @1 : @0 forKey:@"isReward"];
    
    if (switchSelect) {
        NSString *invateNum = _invateNumTextField.text;
        NSString *maxNum = _maxNumTextField.text;
        
        if (invateNum.integerValue <= 0) {
            HLShowHint(@"邀请人数必须大于0", self.view);
            return;
        }
        
        if (maxNum.integerValue <= 0) {
            HLShowHint(@"最高次数必须大于0", self.view);
            return;
        }
        
        [self.pargram setObject:invateNum forKey:@"rewardNum"];
        [self.pargram setObject:maxNum forKey:@"rewardMax"];
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Cardmarket/getCardUrl";
        request.serverType = HLServerTypeStoreService;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            NSString * url = result.data[@"url"];
            HLProduceReviewController * productReview = [[HLProduceReviewController alloc]init];
            [productReview resetWebViewFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            productReview.loadUrl = url;
            productReview.isTicket = self.isTicket;
            [self hl_pushToController:productReview];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

// 创建最高可得次数
- (void)creatMaxNumV{
    
    _maxNumBgV = [[UIView alloc] init];
    [self.view addSubview:_maxNumBgV];
    [_maxNumBgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_invateNumBgV.bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(50));
    }];
    
    UILabel *maxNumTipLab = [[UILabel alloc] init];
    [_maxNumBgV addSubview:maxNumTipLab];
    maxNumTipLab.textColor = UIColorFromRGB(0x333333);
    maxNumTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    maxNumTipLab.text = @"最高可得次数";
    [maxNumTipLab makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(FitPTScreen(14));
       make.centerY.equalTo(_maxNumBgV);
    }];
    
    _maxNumTextField = [[UITextField alloc] init];
    [_maxNumBgV addSubview:_maxNumTextField];
    _maxNumTextField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _maxNumTextField.textAlignment = NSTextAlignmentRight;
    _maxNumTextField.textColor = UIColorFromRGB(0x333333);
    _maxNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"到达最高次数后不再增加次数" attributes:
    @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
                NSFontAttributeName:_maxNumTextField.font}];
    _maxNumTextField.attributedPlaceholder = attrString;

    [_maxNumTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_maxNumBgV);
        make.width.equalTo(FitPTScreen(200));
        make.height.equalTo(FitPTScreen(23));
        make.right.equalTo(FitPTScreen(-13));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [_maxNumBgV addSubview:bottomLine];
    bottomLine.backgroundColor = SeparatorColor;
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.bottom.right.equalTo(0);
        make.height.equalTo(0.7);
    }];
}

// 创建邀请人数
- (void)creatInvateNumV{
    
    _invateNumBgV = [[UIView alloc] init];
    [self.view addSubview:_invateNumBgV];
    [_invateNumBgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_switchBgV.bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(50));
    }];
    
    UILabel *invateTipLab = [[UILabel alloc] init];
    [_invateNumBgV addSubview:invateTipLab];
    invateTipLab.textColor = UIColorFromRGB(0x333333);
    invateTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    invateTipLab.text = @"邀请人数";
    [invateTipLab makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(FitPTScreen(14));
       make.centerY.equalTo(_invateNumBgV);
    }];
    
    UILabel *rightTipLab = [[UILabel alloc] init];
    [_invateNumBgV addSubview:rightTipLab];
    rightTipLab.textColor =  UIColorFromRGB(0x999999);
    rightTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    rightTipLab.text = @"位好友可增加1次";
    [rightTipLab makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(FitPTScreen(-13));
       make.centerY.equalTo(_invateNumBgV);
    }];
    
    _invateNumTextField = [[UITextField alloc] init];
    [_invateNumBgV addSubview:_invateNumTextField];
    _invateNumTextField.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _invateNumTextField.textAlignment = NSTextAlignmentCenter;
    _invateNumTextField.textColor = UIColorFromRGB(0x333333);
    _invateNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _invateNumTextField.layer.cornerRadius = FitPTScreen(2);
    _invateNumTextField.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
    _invateNumTextField.layer.borderWidth = 0.7;
    _invateNumTextField.layer.masksToBounds = YES;
    
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"如:2" attributes:
    @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C4C4),
                NSFontAttributeName:_invateNumTextField.font}];
    _invateNumTextField.attributedPlaceholder = attrString;

    [_invateNumTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_invateNumBgV);
        make.width.equalTo(FitPTScreen(47));
        make.height.equalTo(FitPTScreen(23));
        make.right.equalTo(rightTipLab.left).offset(FitPTScreen(-8));
    }];
    
    UILabel *leftTipLab = [[UILabel alloc] init];
    [_invateNumBgV addSubview:leftTipLab];
    leftTipLab.textColor =  UIColorFromRGB(0x999999);
    leftTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    leftTipLab.text = @"每邀请";
    [leftTipLab makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(_invateNumTextField.left).offset(FitPTScreen(-8));
       make.centerY.equalTo(_invateNumBgV);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [_invateNumBgV addSubview:bottomLine];
    bottomLine.backgroundColor = SeparatorColor;
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.bottom.right.equalTo(0);
        make.height.equalTo(0.7);
    }];
}

// 创建顶部swith所在的视图
- (void)creatSwitchBgV{
    _switchBgV = [[UIView alloc] init];
    [self.view addSubview:_switchBgV];
    [_switchBgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Height_NavBar);
        make.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(77));
    }];
    
    UILabel *switchTipLab = [[UILabel alloc] init];
    [_switchBgV addSubview:switchTipLab];
    switchTipLab.textColor =UIColorFromRGB(0x333333);
    switchTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    switchTipLab.text = @"分享领取后，用户可立得";
    [switchTipLab makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(FitPTScreen(14));
       make.top.equalTo(FitPTScreen(18));
    }];
    
    UILabel *switchDescLab = [[UILabel alloc] init];
    [_switchBgV addSubview:switchDescLab];
    switchDescLab.textColor = UIColorFromRGB(0x999999);
    switchDescLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    switchDescLab.text = @"分享好友领取成功后，用户卡增加次数";
    [switchDescLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchTipLab);
        make.top.equalTo(switchTipLab.bottom).offset(FitPTScreen(9));
    }];
    
    _switchV = [[HLSwitch alloc]init];
    [_switchBgV addSubview:_switchV];
    [_switchV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(_switchBgV);
        make.width.equalTo(FitPTScreen(43));
        make.height.equalTo(FitPTScreen(22));
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchTapClick:)];
    [_switchV addGestureRecognizer:tap];
    
    UIView *bottomLine = [[UIView alloc] init];
    [_switchBgV addSubview:bottomLine];
    bottomLine.backgroundColor = SeparatorColor;
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.bottom.right.equalTo(0);
        make.height.equalTo(0.7);
    }];
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"去发布" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(upReviewDatas) forControlEvents:UIControlEventTouchUpInside];
}


@end
