//
//  HLReviewFailAlert.m
//  HuiLife
//
//  Created by 雷清华 on 2020/12/23.
//

#import "HLReviewFailAlert.h"
#import "HLReviewModel.h"

@interface HLReviewFailAlert ()
@property(nonatomic, strong) UIView *alertView;
@property(nonatomic, strong) UILabel *contentLb;
@end

@implementation HLReviewFailAlert

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showAnimate];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Event
- (void)closeClick {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.reCommitBlock) {
        self.reCommitBlock();
    }
}

- (void)showAnimate {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH -(FitPTScreen(300) + Height_Bottom_Margn);
        self.alertView.frame = frame;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - UIView
- (void)initSubView {
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
     CGFloat AelertViewHeight = FitPTScreen(300) + Height_Bottom_Margn;
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, AelertViewHeight)];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_alertView];
    
    UILabel *titleLb = [UILabel hl_regularWithColor:@"#333333" font:16];
    titleLb.text = @"状态说明";
    [_alertView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(17));
        make.centerX.equalTo(self.alertView);
    }];
    
    UIButton *cancelBtn = [UIButton hl_regularWithImage:@"close_x_grey" select:NO];
    [self.view addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(titleLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(36), FitPTScreen(30)));
    }];
    [cancelBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [_alertView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alertView);
        make.top.equalTo(FitPTScreen(50));
        make.height.equalTo(0.5);
    }];
    
    UILabel *leftLb = [UILabel hl_regularWithColor:@"#888888" font:14];
    leftLb.text = @"商家状态：";
    [self.alertView addSubview:leftLb];
    [leftLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(line.bottom).offset(FitPTScreen(20));
    }];
    
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#FF0000" font:14];
    tipLb.text = @"审核失败";
    [self.alertView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(leftLb);
    }];
    
    UIImageView *tipImV = [[UIImageView alloc]init];
    tipImV.image = [UIImage imageNamed:@"waring_grey"];
    [self.alertView addSubview:tipImV];
    [tipImV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLb);
        make.left.equalTo(tipLb.left).offset(FitPTScreen(-15));
    }];
    
    UILabel *timeLb = [UILabel hl_regularWithColor:@"#888888" font:12];
    timeLb.text = _info.create_time;
    [self.alertView addSubview:timeLb];
    [timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(15));
    }];
    
    UILabel *reasonTipLb = [UILabel hl_singleLineWithColor:@"#333333" font:14 bold:YES];
    reasonTipLb.text = @"不通过原因:";
    [self.alertView addSubview:reasonTipLb];
    [reasonTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(timeLb);
    }];
    
    _contentLb = [UILabel hl_lableWithColor:@"#333333" font:14 bold:NO numbers:0];
    [self.alertView addSubview:_contentLb];
    [_contentLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(22));
        make.top.equalTo(reasonTipLb.bottom).offset(FitPTScreen(10));
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    NSAttributedString *attri = [[NSAttributedString alloc]initWithString:_info.audit_content attributes:@{NSParagraphStyleAttributeName : style}];
    _contentLb.attributedText = attri;
    
    UIButton *knowBtn = [[UIButton alloc]init];
    [knowBtn setTitle:@"问题已修正，重新提交" forState:UIControlStateNormal];
    [knowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [knowBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [self.alertView addSubview:knowBtn];
    [knowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.bottom.equalTo(FitPTScreen(-15));
    }];
    [knowBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
