//
//  HLReviewStatuAlert.m
//  HuiLife
//
//  Created by 雷清华 on 2020/12/22.
//

#import "HLReviewStatuAlert.h"
#import "HLReviewModel.h"

@interface HLReviewStatuAlert ()

@property(nonatomic, strong) UIView *alertView;

@end

@implementation HLReviewStatuAlert

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
    [self hide];
}


#pragma mark - Method
- (UIView *)createViewWithTitle:(NSString *)title pic:(NSString *)pic tip:(NSString *)tip tipColor:(NSString *)tipColor {
    UIView *statuView = [[UIView alloc]init];
    UILabel *titleLb = [UILabel hl_regularWithColor:@"#888888" font:14];
    titleLb.text = title;
    [statuView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(statuView);
    }];
    
    UIImageView *tipImV = [[UIImageView alloc]init];
    tipImV.image = [UIImage imageNamed:pic];
    [statuView addSubview:tipImV];
    [tipImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-71));
        make.centerY.equalTo(titleLb);
    }];
    
    UILabel *tipLb = [UILabel hl_regularWithColor:tipColor font:14];
    tipLb.text = tip;
    [statuView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipImV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tipImV);
    }];
    return statuView;
}

- (NSString *)statuPicWithInfo:(HLStatuInfo *)info {
    NSInteger index = [self.statuInfos indexOfObject:info];
    if (index == 0) {
        if (_state == 0) return @"waring_oriange";
        if (_state == 5 || _state == 8) return @"tip_red";
        if (_state == 10) return @"time_yellow";
        return @"check_yes_green";
    }
    
    return info.state == 0?@"check_not":@"check_yes";
}

- (NSString *)tipColorWithInfo:(HLStatuInfo *)info {
    NSInteger index = [self.statuInfos indexOfObject:info];
    if (index == 0) {
        if (_state == 0 || _state == 10) return @"#FF9900";
        if (_state == 5 || _state == 8) return @"#FF0000";
        return @"#23A820";
    }
    
    return @"#333333";
}

- (void)showAnimate {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH -(FitPTScreen(292) + Height_Bottom_Margn);
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
    
     CGFloat AelertViewHeight = FitPTScreen(292) + Height_Bottom_Margn;
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
    
    UIButton *knowBtn = [[UIButton alloc]init];
    [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [knowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [knowBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [self.alertView addSubview:knowBtn];
    [knowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.bottom.equalTo(FitPTScreen(-15));
    }];
    [knowBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSInteger index = 0; index < _statuInfos.count; index ++) {
        HLStatuInfo *info = _statuInfos[index];
        NSString *pic = [self statuPicWithInfo:info];
        NSString *tipColor = [self tipColorWithInfo:info];
        UIView *statuView = [self createViewWithTitle:[NSString stringWithFormat:@"%@：",info.key] pic:pic tip:info.value tipColor:tipColor];
        [_alertView addSubview:statuView];
        [statuView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.alertView);
            make.height.equalTo(FitPTScreen(34));
            make.top.equalTo(line.bottom).offset(FitPTScreen(10) + index *FitPTScreen(34));
        }];
    }
}


@end
