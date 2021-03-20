//
//  HLExpertTipController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/21.
//

#import "HLExpertTipController.h"
#import "HLHotDetailMainModel.h"

@interface HLExpertTipController ()

@property(nonatomic ,strong) UIView *alertView;

@property(nonatomic, strong) UIImageView *headView;

@property(nonatomic, strong) UILabel *nameLb;

@property(nonatomic, strong) UIImageView *tipBgView;

@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) UIImageView *ewmView;

@property(nonatomic, strong) UILabel *wxNumLb;

@property(nonatomic, strong) HLHotAlertInfo *alertInfo;

@end

@implementation HLExpertTipController

- (void)viewWillAppear:(BOOL)animated {
    [self showAnimate];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

//复制微信号 打开微信
- (void)copyWXNumClick {
//    先复制微信号
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _alertInfo.wechatNumber;
    NSURL *url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen) {
    [[UIApplication sharedApplication] openURL:url];
    }else{
        HLShowHint(@"您还没有安装微信客户端", nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _alertInfo = _mainModel.zhuanJiaInfo;
    [self initSubView];
}


- (void)initSubView {
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, FitPTScreen(480))];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_alertView];
    
    _headView = [[UIImageView alloc]init];
    [_headView sd_setImageWithURL:[NSURL URLWithString:_alertInfo.authorPic] placeholderImage:[UIImage imageNamed:@"logo_default"]];;
    [_alertView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(26));
        make.top.equalTo(FitPTScreen(13));
        make.size.equalTo(CGSizeMake(FitPTScreen(40), FitPTScreen(40)));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    _nameLb.text = _alertInfo.author;
    [self.alertView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(12));
        make.centerY.equalTo(self.headView);
    }];
    
    CGFloat hight = [self hightForTip:_alertInfo.content];
    _tipBgView = [[UIImageView alloc]init];
    _tipBgView.image = [UIImage imageNamed:@"hot_alert_bg"];
    [self.alertView addSubview:_tipBgView];
    [_tipBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(self.headView.bottom);
        make.width.equalTo(FitPTScreen(353));
        make.height.equalTo(hight + FitPTScreen(40));
    }];
    
    _tipLb = [UILabel hl_lableWithColor:@"#333333" font:12 bold:NO numbers:0];
    _tipLb.attributedText = [self tipAttrWithTip:_alertInfo.content];
    [self.tipBgView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.tipBgView).insets(UIEdgeInsetsMake(FitPTScreen(20), FitPTScreen(12), FitPTScreen(15), FitPTScreen(12)));
        make.centerX.centerY.equalTo(self.tipBgView);
        make.width.lessThanOrEqualTo(FitPTScreen(328));
    }];
    
    
    UILabel *wxTipLb = [UILabel hl_regularWithColor:@"#222222" font:12];
    wxTipLb.text = _alertInfo.wechatNotice;
    [self.alertView addSubview:wxTipLb];
    [wxTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.tipBgView.bottom).offset(FitPTScreen(19));
    }];
    
    _ewmView = [[UIImageView alloc]init];
    [_ewmView sd_setImageWithURL:[NSURL URLWithString:_alertInfo.wechatPic]];
    [self.alertView addSubview:_ewmView];
    [_ewmView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(wxTipLb.bottom).offset(FitPTScreen(12));
        make.size.equalTo(CGSizeMake(FitPTScreen(104), FitPTScreen(104)));
    }];
    
    _wxNumLb = [UILabel hl_regularWithColor:@"#333333" font:12];
    _wxNumLb.text = _alertInfo.wechatNumber;;
    [self.alertView addSubview:_wxNumLb];
    [_wxNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.ewmView.bottom).offset(FitPTScreen(9));
    }];
    
    UIButton *button = [UIButton hl_regularWithTitle:_alertInfo.but titleColor:@"#FFFFFF" font:16 backgroundImg:@"voucher_bottom_btn"];
    [_alertView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.bottom.equalTo(FitPTScreen(-15));
    }];
    [button addTarget:self action:@selector(copyWXNumClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, FitPTScreen(-35), ScreenW, FitPTScreen(35))];
    topView.backgroundColor = [HLTools hl_toColorByColorStr:@"#FEA029" alpha:0.8];
    [self.alertView addSubview:topView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(FitPTScreen(10),FitPTScreen(10))];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    topView.layer.mask = maskLayer;
    
    UIImageView *picView = [[UIImageView alloc]init];
    picView.layer.cornerRadius = FitPTScreen(22.5) / 2;
    picView.layer.masksToBounds = YES;
    [picView sd_setImageWithURL:[NSURL URLWithString:_alertInfo.pic]];
    [topView addSubview:picView];
    [picView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.centerY.equalTo(topView);
        make.size.equalTo(CGSizeMake(FitPTScreen(22.5), FitPTScreen(22.5)));
    }];
    
    UILabel *topTipLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:12];
    topTipLb.text = _alertInfo.subTitle;
    [topView addSubview:topTipLb];
    [topTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picView.right).offset(FitPTScreen(9));
        make.centerY.equalTo(topView);
    }];
    
}

- (void)showAnimate {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH - FitPTScreen(480);
        self.alertView.frame = frame;
    }];
}

- (void)hideAnimate {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (NSAttributedString *)tipAttrWithTip:(NSString *)tip {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:tip attributes:@{NSParagraphStyleAttributeName:style}];
    return attr;
}

- (CGFloat)hightForTip:(NSString *)tip {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    NSDictionary *attrs = @{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(12)]};
    CGSize labelsize  = [tip
                        boundingRectWithSize:CGSizeMake(FitPTScreen(328), CGFLOAT_MAX)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:attrs
                        context:nil].size;
    return labelsize.height;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideAnimate];
}
@end
