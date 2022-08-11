//
//  HLJudgmentInternetView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/25.
//

#import "HLJudgmentInternetView.h"

@interface HLJudgmentInternetView()

@end

@implementation HLJudgmentInternetView
//judgement_yuan
//judgement_dian

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    UIView * bagView = [[UIView alloc]init];
    bagView.backgroundColor = [UIColor blackColor];
    bagView.alpha = 0.5;
    [self addSubview:bagView];
    [bagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView * showView = [[UIView alloc]init];
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.cornerRadius = 5;
    showView.clipsToBounds = YES;
    [self addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(300));
        make.height.equalTo(FitPTScreen(216));
    }];
    
    UIImageView * first = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_circle_oriange"]];
    [showView addSubview:first];
    [first makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView).offset(FitPTScreen(46));
        make.top.equalTo(showView).offset(FitPTScreen(43));
    }];
    
    UIImageView * second = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_circle_oriange"]];
    [showView addSubview:second];
    [second makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(first.mas_right).offset(FitPTScreen(45));
        make.centerY.equalTo(first);
    }];
    
    UIImageView * third = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_circle_oriange"]];
    [showView addSubview:third];
    [third makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showView).offset(FitPTScreen(-44));
        make.centerY.equalTo(first);
    }];
    
    UIImageView * firstD = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_h_oriange_dot"]];
    [showView addSubview:firstD];
    [firstD makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(first.mas_right).offset(FitPTScreen(-10));
        make.centerY.equalTo(first);
    }];
    
    UIImageView * secondD = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_h_oriange_dot"]];
    [showView addSubview:secondD];
    [secondD makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(first.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(first);
    }];
    
    UILabel * zhenduan = [[UILabel alloc]init];
    zhenduan.text = @"正在诊断网络";
    zhenduan.textColor = UIColorFromRGB(0x555555);
    zhenduan.font = [UIFont systemFontOfSize:17];
    [showView addSubview:zhenduan];
    [zhenduan makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(showView);
        make.top.equalTo(showView).offset(FitPTScreen(103));
    }];
    
    UILabel * description = [[UILabel alloc]init];
    description.text = @"诊断需要一分钟，请耐心等待";
    description.textColor = UIColorFromRGB(0xAAAAAA);
    description.font = [UIFont systemFontOfSize:14];
    [showView addSubview:description];
    [description makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(showView);
        make.top.equalTo(showView).offset(FitPTScreen(135));
    }];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.width.equalTo(showView);
        make.left.equalTo(showView);
        make.bottom.equalTo(showView.mas_bottom).offset(FitPTScreen(-47));
    }];
    
    UIButton * concernBtn = [[UIButton alloc]init];
    [concernBtn setTitle:@"确定" forState:UIControlStateNormal];
    concernBtn.titleLabel.font = MicrosoftYaHeiFont(17);
    //    concernBtn.titleLabel.textColor = UIColorFromRGB(0x009FF5);
    [concernBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    concernBtn.backgroundColor = [UIColor whiteColor];
    [showView addSubview:concernBtn];
    [concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(showView);
        make.height.equalTo(FitPTScreen(47));
        make.width.equalTo(FitPTScreen(150));
    }];
    [concernBtn addTarget:self action:@selector(concernClick) forControlEvents:UIControlEventTouchUpInside];
        UIButton * cancelBtn = [[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = MicrosoftYaHeiFont(17);
        [cancelBtn setTitleColor:UIColorFromRGB(0x009FF5) forState:UIControlStateNormal];
        [showView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(showView);
            make.height.equalTo(FitPTScreen(40));
            make.width.equalTo(150);
        }];
        
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *failLineView= [[UIView alloc]init];
        failLineView.backgroundColor =UIColorFromRGB(0xCCCCCC);
        [showView addSubview:failLineView];
        [failLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancelBtn.mas_right);
            make.top.equalTo(lineView.mas_bottom);
            make.width.equalTo(1);
            make.height.equalTo(FitPTScreen(47));
        }];
}

-(void)concernClick{
    [self removeFromSuperview];
}

-(void)cancelClick{
    [self removeFromSuperview];
}
@end
