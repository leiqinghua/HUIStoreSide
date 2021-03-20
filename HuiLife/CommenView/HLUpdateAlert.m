//
//  HLUpdateAlert.m
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/10/11.
//  Copyright © 2018年 wce. All rights reserved.
//

#import "HLUpdateAlert.h"

@interface HLUpdateAlert ()

@property (strong, nonatomic) UIView *mainView;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *content;

@property (assign, nonatomic) BOOL mustUpdate;

@property (copy, nonatomic) HLUpdateCallBack callBack;

@end

@implementation HLUpdateAlert

+ (void)showUpdateAlertVersion:(NSString *)version content:(NSString *)content mustUpdate:(BOOL)mustUpdate callBack:(HLUpdateCallBack)callBack{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    __block BOOL isShow = NO;
    [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[HLUpdateAlert class]]) {
            isShow = YES;
            *stop = YES;
        }
    }];
    if (isShow) {
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"V%@",version];
    HLUpdateAlert *alert = [[HLUpdateAlert alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) title:title content:content mustUpdate:mustUpdate];
    alert.callBack = callBack;
    [alert show];
}

/**
 返回实例
 @param frame frame
 @param title title
 @param content 内容哦
 @param mustUpdate 是否强制更新
 @return 返回的哦
 */

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content mustUpdate:(BOOL)mustUpdate
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _content = content;
        _mustUpdate = mustUpdate;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    // 构建主视图
    CGFloat leftMargin = FitPTScreen(60);
    CGFloat mainViewWidth = ScreenW - 2 * leftMargin;
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, ScreenW - 2 * leftMargin, 0)];
    [self addSubview:_mainView];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = FitPTScreen(5);
    _mainView.layer.masksToBounds = YES;
    
    // 顶部背景图
    UIImageView *headImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update_alert_head"]];
    [_mainView addSubview:headImgV];
    [headImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.mainView);
    }];
    
    // 提示label
    UILabel *versionTipLab = [[UILabel alloc] init];
    [headImgV addSubview:versionTipLab];
    versionTipLab.text = @"版本更新啦！";
    versionTipLab.textColor = UIColorFromRGB(0xFFFFFF);
    versionTipLab.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    [versionTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(25));
        make.top.equalTo(FitPTScreen(31));
    }];
    
    // 最上面的label
    UILabel *versionLab = [[UILabel alloc] init];
    [headImgV addSubview:versionLab];
    versionLab.text = _title;
    versionLab.textColor = UIColorFromRGB(0xFFFFFF);
    versionLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [versionLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(versionTipLab);
        make.top.equalTo(versionTipLab.bottom).offset(FitPTScreen(9));
    }];
    
    // 升级内容提示
    UILabel *noteTipLab = [[UILabel alloc] init];
    [headImgV addSubview:noteTipLab];
    noteTipLab.text = @"更新内容:";
    noteTipLab.textColor = UIColorFromRGB(0x333333);
    noteTipLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    [noteTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(26));
        make.top.equalTo(headImgV.bottom).offset(FitPTScreen(10));
    }];
    
    // 内容label
    UILabel *contentLab = [[UILabel alloc] init];
    [_mainView addSubview:contentLab];
    contentLab.textColor = UIColorFromRGB(0x333333);
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    contentLab.preferredMaxLayoutWidth = mainViewWidth - FitPTScreen(28);
    NSMutableAttributedString *contentAttr = [HLTools attrStringWithString:_content lineSpace:FitPTScreen(4) kern:0];
    contentLab.attributedText = contentAttr;
    [contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(25));
        make.top.equalTo(noteTipLab.bottom).offset(FitPTScreen(10));
    }];
    
    // 按钮
    UIImageView *updateImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update_alert_btn"]];
    [_mainView addSubview:updateImgV];
    [updateImgV hl_addTarget:self action:@selector(buttonClick)];
    [updateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(24));
        make.right.equalTo(FitPTScreen(-24));
        make.height.equalTo(FitPTScreen(56));
        make.top.equalTo(contentLab.bottom).offset(FitPTScreen(15));
    }];
    
    // 中间提示label
    UILabel *noteLab = [[UILabel alloc] init];
    [_mainView addSubview:noteLab];
    NSString *note = @"注: 如遇到问题，请保证网络良好，前往App Store右下角更新入口尝试。";
    noteLab.textColor = UIColorFromRGB(0x555555);
    noteLab.numberOfLines = 2;
    NSMutableAttributedString *noteAttr = [HLTools attrStringWithString:note lineSpace:FitPTScreen(4) kern:0];
    NSRange tipRange = [note rangeOfString:@"保证网络良好，前往App Store右下角更新入口"];
    [noteAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF5858) range:tipRange];
    noteLab.attributedText = noteAttr;
    noteLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    noteLab.preferredMaxLayoutWidth = mainViewWidth - FitPTScreen(28);
    [noteLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(25));
        make.top.equalTo(updateImgV.bottom).offset(FitPTScreen(0));
        make.bottom.equalTo(FitPTScreen(-15));
    }];

    CGFloat height = [_mainView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _mainView.frame;
    frame.size.height = height;
    _mainView.frame = frame;
    _mainView.center = CGPointMake(ScreenW/2, ScreenH/2 - FitPTScreen(50));
    
    // 如果不是强制更新，那么有关闭按钮
    if(!_mustUpdate){
        UIButton *closeBtn = [[UIButton alloc] init];
        [self addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"close_x_shadow"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(FitPTScreen(56));
            make.height.equalTo(FitPTScreen(55));
            make.top.equalTo(self.mainView.bottom).offset(FitPTScreen(13));
        }];
    }

}

- (void)buttonClick{
    if (!_mustUpdate) {
        [self hide];
    }
    if (self.callBack) {
        self.callBack();
    }
}

#pragma mark - Public Method

- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    // 添加弹出动画
    [self.mainView hl_addPopAnimation];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }];
}

- (void)hide{
    [self endEditing:YES];
    //    [UIView animateWithDuration:0.1 animations:^{
    //        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    //    } completion:^(BOOL finished) {
    [self removeFromSuperview];
    //    }];
}

@end
