//
//  HLWithDrawDealController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/9/10.
//

#import "HLWithDrawDealController.h"
#import "HLEntryViewController.h"

@interface HLWithDrawDealController ()


@end

@implementation HLWithDrawDealController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_hideBack:YES];
    [self hl_setTitle:@"结果详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_success) {
       [self initSuccessView];
    }else{
        [self initFailedView];
    }
    
}

-(void)initSuccessView{
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(159))];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    
    UIImageView * tipImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
    [topView addSubview:tipImgV];
    [tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(FitPTScreen(30));
    }];
    
    UILabel * botTipLb = [[UILabel alloc]init];
    botTipLb.text = @"提现已成功";
    botTipLb.textColor = UIColorFromRGB(0x222222);
    botTipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [topView addSubview:botTipLb];
    [botTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipImgV.bottom).offset(FitPTScreen(16));
        make.centerX.equalTo(tipImgV);
    }];
    
    UIView * midView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + FitPTScreen(10), ScreenW, FitPTScreen(85))];
    midView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:midView];
    
    UILabel *priceTip = [[UILabel alloc]init];
    priceTip.text = @"提现金额";
    priceTip.textColor = UIColorFromRGB(0x555555);
    priceTip.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [midView addSubview:priceTip];
    [priceTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(18));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    
    NSString * money = [NSString stringWithFormat:@"¥%@",_money];
    if (![money containsString:@"."]) {
        money = [money stringByAppendingString:@".00"];
    }
    NSMutableAttributedString * moneyAttr = [[NSMutableAttributedString alloc]initWithString:money attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(18)],NSForegroundColorAttributeName:UIColorFromRGB(0xFF8D26)}];
    [moneyAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]} range:NSMakeRange(0, 1)];

    UILabel *priceLb = [[UILabel alloc]init];
    priceLb.attributedText = moneyAttr;
    
    [midView addSubview:priceLb];
    [priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-18));
        make.centerY.equalTo(priceTip);
    }];
    
    UILabel *wayTipLb = [[UILabel alloc]init];
    wayTipLb.text = @"提现方式";
    wayTipLb.textColor = UIColorFromRGB(0x555555);
    wayTipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [midView addSubview:wayTipLb];
    [wayTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceTip);
        make.top.equalTo(priceTip.bottom).offset(FitPTScreen(15));
    }];
    
    UILabel *txWayLb = [[UILabel alloc]init];
    txWayLb.text = @"微信";
    txWayLb.textColor = UIColorFromRGB(0x222222);
    txWayLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [midView addSubview:txWayLb];
    [txWayLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLb);
        make.centerY.equalTo(wayTipLb);
    }];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(midView.frame) + FitPTScreen(10), ScreenW, FitPTScreen(340) + Height_Bottom_Margn)];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottomView];
    
    UILabel *searchTip = [[UILabel alloc]init];
    searchTip.text = @"到账查询";
    searchTip.textColor = UIColorFromRGB(0x555555);
    searchTip.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [bottomView addSubview:searchTip];
    [searchTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(18));
        make.top.equalTo(FitPTScreen(29));
    }];
    
    
    UILabel *functionLb = [[UILabel alloc]init];
    functionLb.text = @"1.微信-我的零钱-零钱明细";
    functionLb.textColor = UIColorFromRGB(0x999999);
    functionLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [bottomView addSubview:functionLb];
    [functionLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchTip);
        make.top.equalTo(searchTip.bottom).offset(FitPTScreen(16));
    }];
    
    
    UIButton *recordBtn = [[UIButton alloc] init];
    [bottomView addSubview:recordBtn];
    [recordBtn setTitle:@"查询提现记录" forState:UIControlStateNormal];
    recordBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [recordBtn setTitleColor:UIColorFromRGB(0xFF8517) forState:UIControlStateNormal];
    recordBtn.layer.cornerRadius = FitPTScreen(9);
    recordBtn.layer.borderColor =UIColorFromRGB(0xFF8517).CGColor;
    recordBtn.layer.borderWidth = FitPTScreen(0.8);
    [recordBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.bottom.equalTo(-FitPTScreen(28)-Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(281));
        make.height.equalTo(FitPTScreen(45));
    }];
    
    
    UIButton *knowBtn = [[UIButton alloc] init];
    [bottomView addSubview:knowBtn];
    [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [knowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [knowBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [knowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.bottom.equalTo(recordBtn.top).offset(FitPTScreen(-7));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [knowBtn addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
}

//提现失败
-(void)initFailedView{
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIImageView * tipImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error_oriange"]];
    [self.view addSubview:tipImgV];
    [tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(80) + Height_NavBar);
    }];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.text = @"提现失败，请稍后再试";
    tipLb.textColor = UIColorFromRGB(0x222222);
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tipImgV.bottom).offset(FitPTScreen(19));
    }];
    
    UILabel *subLb = [[UILabel alloc]init];
    subLb.text = @"如继续失败，请联系客服";
    subLb.textColor = UIColorFromRGB(0x999999);
    subLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self.view addSubview:subLb];
    [subLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(7));
    }];
    
    
    UIButton *goBackBtn = [[UIButton alloc] init];
    [self.view addSubview:goBackBtn];
    [goBackBtn setTitle:@"返回上一级" forState:UIControlStateNormal];
    goBackBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [goBackBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [goBackBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [goBackBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-7)-Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}


-(void)goBack{
    [self hl_goback];
}

-(void)knowClick{
     [self hl_goback];
}

//查询提现记录
-(void)recordClick{
    HLEntryViewController * entryVC = [[HLEntryViewController alloc]init];
    [self hl_pushToController:entryVC];
}

@end
