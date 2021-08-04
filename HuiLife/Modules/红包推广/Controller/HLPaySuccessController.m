//
//  HLPaySuccessController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/20.
//

#import "HLPaySuccessController.h"

@interface HLPaySuccessController ()
@property(nonatomic, strong) UILabel *priceLb;
@end

@implementation HLPaySuccessController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"结果详情"];
    [self hl_hideBack:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    UIImageView *tipImV = [[UIImageView alloc]init];
    tipImV.image = [UIImage imageNamed:@"success_pay"];
    [self.view addSubview:tipImV];
    [tipImV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Height_NavBar+FitPTScreen(34));
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(FitPTScreen(86), FitPTScreen(86)));
    }];
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#222222" font:17];
    tipLb.text = @"支付成功！";
    [self.view addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipImV.bottom).offset(FitPTScreen(5));
        make.centerX.equalTo(self.view);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(44));
        make.height.equalTo(FitPTScreen(9));
    }];
    
    UILabel *priceTip = [UILabel hl_regularWithColor:@"#888888" font:14];
    priceTip.text = @"支付金额";
    [self.view addSubview:priceTip];
    [priceTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(22));
        make.top.equalTo(line.bottom).offset(FitPTScreen(18));
    }];
    
    _priceLb = [UILabel hl_regularWithColor:@"#FD942E" font:14];
    _priceLb.text = [NSString stringWithFormat:@"¥%@",_price];
    [self.view addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(priceTip);
    }];
    
    UIView *thinLine = [[UIView alloc]init];
    [self.view addSubview:thinLine];
    [thinLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(priceTip.bottom).offset(FitPTScreen(18));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    UILabel *wayTip = [UILabel hl_regularWithColor:@"#888888" font:14];
    wayTip.text = @"支付方式";
    [self.view addSubview:wayTip];
    [wayTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(22));
        make.top.equalTo(thinLine.bottom).offset(FitPTScreen(18));
    }];
    
    UILabel *wayLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    wayLb.text = @"微信";
    [self.view addSubview:wayLb];
    [wayLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLb);
        make.centerY.equalTo(wayTip);
    }];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(30))];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:UIColorFromRGB(0xFD9E2F) forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doneClick {
    for (HLBaseViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"HLRedBagListController")]) {
            [HLNotifyCenter postNotificationName:HLReloadRedBagDataNotifi object:nil];
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

@end
