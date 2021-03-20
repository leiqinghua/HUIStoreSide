//
//  HLNetWorkFailView.m
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/10/16.
//  Copyright © 2018年 wce. All rights reserved.
//

#import "HLNetWorkFailView.h"

@interface HLNetWorkFailView ()

@property (copy, nonatomic) HLNetClickCallBack callBack;

@end

@implementation HLNetWorkFailView

- (instancetype)initWithFrame:(CGRect)frame clickCallBack:(HLNetClickCallBack)callBack{
    self = [super initWithFrame:frame];
    if (self) {
        self.callBack = callBack;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    self.backgroundColor = UIColor.whiteColor;
    
    UIImageView *tipImgV = [[UIImageView alloc] init];
    [self addSubview:tipImgV];
    tipImgV.image = [UIImage imageNamed:@"hl_noNet_image"];
    [tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitScreenH(170));
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(FitPTScreen(131), FitPTScreen(139)));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [self addSubview:tipLab];
    tipLab.text = @"网络请求失败，请检查您的网络设置";
    tipLab.textColor = UIColorFromRGB(0x777777);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tipImgV.bottom).offset(FitPTScreen(40));
    }];
    
    UIButton *reloadBtn = [[UIButton alloc] init];
    [self addSubview:reloadBtn];
    reloadBtn.backgroundColor = UIColorFromRGB(0xFF9900);
    [reloadBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    reloadBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    reloadBtn.layer.cornerRadius = FitPTScreen(3);
    reloadBtn.layer.masksToBounds = YES;
    [reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [reloadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(30));
        make.size.equalTo(CGSizeMake(FitPTScreen(145), FitPTScreen(45)));
    }];
}

- (void)reloadBtnClick{
    [self removeFromSuperview];
    if (self.callBack) {
        self.callBack();
    }
}

@end
