//
//  SettlementAlertView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/13.
//

#import "SettlementAlertView.h"

@interface SettlementAlertView()
@property(strong,nonatomic)UIImageView * warnImgView;
@property(copy,nonatomic)NSString * title;
@property(copy,nonatomic)NSString * subTitle;
@property(assign,nonatomic)SettlementType type;
@end

@implementation SettlementAlertView

static SettlementAlertView * _alertView;
+(instancetype)share{
    if (!_alertView) {
        _alertView = [[super allocWithZone:nil]init];
        _alertView.frame = [UIScreen mainScreen].bounds;
    }
    return _alertView;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self share];
}

-(void)showWihtType:(SettlementType)type title:(NSString *)title subTitle:(NSString *)subTitle{
    _type = type;
    _title = title;
    _subTitle = subTitle;
    [self createUIWithType];
}

-(void)createUIWithType{
    switch (_type) {
        case SettlementTypeDefault:
            [self createUIWithImage:@"" isSubTitle:false];
            break;
        case SettlementTypeCheck:
            [self createUIWithImage:@"alert_check" isSubTitle:false];
            break;
        case SettlementTypeSuccess:
            [self createUIWithImage:@"alert_success" isSubTitle:YES];
            break;
        case SettlementTypeFailed:
            [self createUIWithImage:@"alert_failed" isSubTitle:YES];
            break;
            
        default:
            break;
    }
}

-(void)createUIWithImage:(NSString *)image isSubTitle:(BOOL)isShow{
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
        make.height.equalTo(isShow?FitPTScreen(216):FitPTScreen(199));
    }];
    
    _warnImgView = [[UIImageView alloc]init];
    _warnImgView.image = [UIImage imageNamed:image];
    _warnImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_warnImgView];
    [_warnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(showView.mas_top).offset(FitPTScreen(29));
    }];
    
    UILabel * titleLable = [[UILabel alloc]init];
    titleLable.text = _title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = UIColorFromRGB(0x555555);
    titleLable.font = MicrosoftYaHeiFont(18);
    [self addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(FitPTScreen(18));
        make.top.equalTo(self.warnImgView.mas_bottom).offset(FitPTScreen(isShow?20:28));
    }];
    if (isShow) {
        UILabel * subLable = [[UILabel alloc]init];
        subLable.text = _subTitle;
        subLable.textAlignment = NSTextAlignmentCenter;
        subLable.textColor = UIColorFromRGB(0xAAAAAA);
        subLable.font = MicrosoftYaHeiFont(14);
        [self addSubview:subLable];
        [subLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(FitPTScreen(14));
            make.top.equalTo(titleLable.mas_bottom).offset(FitPTScreen(15));
        }];
    }
    
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
    [concernBtn setTitle:_type == SettlementTypeFailed?@"重试":@"确定" forState:UIControlStateNormal];
    concernBtn.titleLabel.font = MicrosoftYaHeiFont(17);
//    concernBtn.titleLabel.textColor = UIColorFromRGB(0x009FF5);
    [concernBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    concernBtn.backgroundColor = [UIColor whiteColor];
    [showView addSubview:concernBtn];
    [concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(showView);
        make.height.equalTo(FitPTScreen(47));
        make.width.equalTo(self.type == SettlementTypeFailed ?150:300);
    }];
    [concernBtn addTarget:self action:@selector(concernClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_type == SettlementTypeFailed) {
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
        
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
    [KEY_WINDOW addSubview:self];
}

//取消操作
-(void)cancelClick:(UIButton *)sender{
    [self removeFromSuperview];
    _alertView = nil;
}

-(void)concernClick:(UIButton *)sender{
    //重新进行请求
    if (_type == SettlementTypeFailed) {
        
    }else{
        [self removeFromSuperview];
        _alertView = nil;
    }
}

-(void)dealloc{
    HLLog(@"单利弹框销毁...");
}
@end
