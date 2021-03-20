//
//  HLMineShareView.m
//  HuiLifeUserSide
//
//  Created by 王策 on 2018/9/10.
//  Copyright © 2018年 wce. All rights reserved.
//

#import "HLMineShareView.h"

#define kMainViewHeight (FitPTScreen(212) + Height_Bottom_Margn)

@interface HLMineShareView ()

@property (strong, nonatomic) UIView *mainView;

@property (copy, nonatomic) HLShareCallBack callBack;

@end

@implementation HLMineShareView

+ (void)showShareViewWithCallBack:(HLShareCallBack)callBack{
    HLMineShareView *shareView = [[HLMineShareView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    shareView.callBack = callBack;
    [shareView show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews{
    
    // mainVi
    _mainView = [[UIView alloc] init];
    [self addSubview:_mainView];
    _mainView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainViewHeight);
    
    // topLab
    UILabel *topLab = [[UILabel alloc] init];
    [_mainView addSubview:topLab];
    topLab.textAlignment = NSTextAlignmentCenter;
    topLab.text = @"选择分享平台";
    topLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    topLab.textColor = UIColorFromRGB(0x333333);
    topLab.frame = CGRectMake(0, 0, ScreenW, FitPTScreen(40));
    topLab.backgroundColor = UIColor.whiteColor;
    
    
    // 2个按钮
    CGFloat btnHeight = FitPTScreen(126);
    CGFloat margin = FitPTScreen(50);
    CGFloat btnWidth = (ScreenW - margin * 2)/2;
    NSArray *imageArr = @[@"share_weixin",@"share_pengyouquan"];
    NSArray *titleArr = @[@"微信好友",@"朋友圈"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [self.mainView addSubview:button];
        button.tag = i;
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnWidth * i + margin);
            make.top.equalTo(topLab.bottom);
            make.height.equalTo(btnHeight);
            make.width.equalTo(btnWidth);
        }];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgV = [[UIImageView alloc] init];
        [button addSubview:imgV];
        imgV.image = [UIImage imageNamed:imageArr[i]];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.top.equalTo(topLab.bottom).offset(FitPTScreen(24));
            make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(50)));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [button addSubview:label];
        label.text = titleArr[i];
        label.textColor = UIColorFromRGB(0x777777);
        label.font = [UIFont systemFontOfSize:FitPTScreen(11)];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgV.bottom).offset(FitPTScreen(11));
            make.centerX.equalTo(imgV);
        }];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
    [self.mainView addSubview:cancelBtn];
    cancelBtn.backgroundColor = UIColor.whiteColor;
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mainView);
        make.bottom.equalTo(self.mainView).offset(-Height_Bottom_Margn);
        make.height.equalTo(FitPTScreen(45));
    }];
}

- (void)buttonClick:(UIButton *)sender{
    if (self.callBack) {
        self.callBack(sender.tag);
        [self hide];
    }
}

#pragma mark - Public Method

- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    // 展示出来
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = CGRectMake(0, ScreenH - kMainViewHeight, ScreenW, kMainViewHeight);
    }];
}

- (void)hide{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
