//
//  HLMineFooterView.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/11.
//

#import "HLMineFooterView.h"

@interface HLMineFooterView ()

@end

@implementation HLMineFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = UIColor.clearColor;
    
    UIButton * exitBtn = [[UIButton alloc]init];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setTitleColor:UIColorFromRGB(0xFF8301) forState:UIControlStateNormal];
    exitBtn.layer.borderColor = UIColorFromRGB(0xFFAC56).CGColor;
    exitBtn.layer.borderWidth = FitPTScreen(0.7);
    exitBtn.layer.cornerRadius = FitPTScreen(6);
    [self addSubview:exitBtn];
    [exitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.equalTo(FitPTScreen(351));
        make.height.equalTo(FitPTScreen(48));
    }];
    [exitBtn addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)exitClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(exitLoginWithButtonClick:)]) {
        [self.delegate exitLoginWithButtonClick:sender];
    }
}
@end
