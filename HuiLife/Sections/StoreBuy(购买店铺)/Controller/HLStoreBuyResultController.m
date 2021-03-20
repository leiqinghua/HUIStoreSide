//
//  HLStoreBuyResultController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import "HLStoreBuyResultController.h"

@interface HLStoreBuyResultController ()

@end

@implementation HLStoreBuyResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hl_setTitle:@"支付订单"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self creatSubUI];
}

- (void)creatSubUI{
    
    UIImageView *stateImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    [self.view addSubview:stateImgV];
    [stateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(30) + Height_NavBar);
        make.width.height.equalTo(FitPTScreen(60));
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [self.view addSubview:tipLab];
    tipLab.text = @"支付成功!";
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    tipLab.textColor = UIColorFromRGB(0x222222);
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(stateImgV.bottom).offset(FitPTScreen(15));
    }];
    
    UILabel *yearTipLab = [[UILabel alloc] init];
    [self.view addSubview:yearTipLab];
    yearTipLab.text = @"店铺年限";
    yearTipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    yearTipLab.textColor = UIColorFromRGB(0x555555);
    [yearTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(60));
    }];
    
    UILabel *yearLab = [[UILabel alloc] init];
    [self.view addSubview:yearLab];
    yearLab.text = self.yearText;
    yearLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    yearLab.textColor = UIColorFromRGB(0x222222);
    [yearLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(yearTipLab);
    }];
    
    UILabel *typeTipLab = [[UILabel alloc] init];
    [self.view addSubview:typeTipLab];
    typeTipLab.text = @"支付方式";
    typeTipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    typeTipLab.textColor = UIColorFromRGB(0x555555);
    [typeTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(yearTipLab.bottom).offset(FitPTScreen(15));
    }];
    
    UILabel *typeLab = [[UILabel alloc] init];
    [self.view addSubview:typeLab];
    typeLab.text = self.payType;
    typeLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    typeLab.textColor = UIColorFromRGB(0x222222);
    [typeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(typeTipLab);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [self.view addSubview:backBtn];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"buy_store_btn"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [backBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLab.bottom).offset(FitPTScreen(80));
        make.width.equalTo(FitPTScreen(115));
        make.height.equalTo(FitPTScreen(37));
        make.centerX.equalTo(self.view);
    }];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnClick{
    // 这里是向前跳转两个页面，不应该是跳转到根页面
    NSArray *controllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:controllers[controllers.count - 3] animated:YES];
}

@end
