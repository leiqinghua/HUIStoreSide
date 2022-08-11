//
//  HLReviewCheckController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/12/22.
//

#import "HLReviewCheckController.h"
#import "HLReviewModel.h"

@interface HLReviewCheckController ()
@property(nonatomic, strong) UIView *alertView;
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *bottomLb;
@property(nonatomic, strong) UIButton *bottomBtn;
@property(nonatomic, strong) NSMutableArray *statuViews;
@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, assign) BOOL checkAccess;
@end

@implementation HLReviewCheckController

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

#pragma mark - Request
- (void)commitRequest {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/ClientSide/UnionCard/AuditBusiness.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"store_id":[HLAccount shared].store_id?:@""};
    }onSuccess:^(id responseObject) {
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLTools showWithText:@"提交审核成功"];
            [self hide];
        }
    }onFailure:^(NSError *error) {
    }];
}

#pragma mark - Event
- (void)closeClick {
    [self hide];
}

//提交审核
- (void)commitClick {
    [self commitRequest];
}

#pragma mark - Method
- (UIView *)createViewWithTitle:(NSString *)title pic:(NSString *)pic tip:(NSString *)tip {
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
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#333333" font:14];
    tipLb.text = tip;
    [statuView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipImV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tipImV);
    }];
    return statuView;
}

- (NSString *)statuPicWithInfo:(HLStatuInfo *)info {
    return info.state == 0?@"check_not_red":@"check_yes_green";
}

- (void)showAnimate {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH - FitPTScreen(442);
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        //启动计时器
        [self showStatuViewAnimate];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        dispatch_source_cancel(self.timer);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//计时器
- (void)showStatuViewAnimate {
    
    __block NSInteger count = 1;
    // 全局队列
   dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
   // 创建一个 timer 类型定时器 （ DISPATCH_SOURCE_TYPE_TIMER）
   dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
   // 指定定时器开始的时间和间隔的时间
   dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
   // 任务回调
   dispatch_source_set_event_handler(timer, ^{
       if (count <= self.statuViews.count) {
           dispatch_main_async_safe(^{
               UIView *statuView = [self.statuViews objectAtIndex:(count - 1)];
               statuView.hidden = NO;
               count ++;
           });
           
       } else {
           dispatch_source_cancel(timer);
           dispatch_main_async_safe(^{
               self.bottomLb.hidden = self.checkAccess;
               self.bottomBtn.hidden = !self.checkAccess;
               self.titleLb.text = @"检测完成";
           });
       }
   });
   // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
   dispatch_resume(timer);
   _timer = timer;
}


#pragma mark - UIView
- (void)initSubView {
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
     CGFloat AelertViewHeight = FitPTScreen(442);
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, AelertViewHeight)];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_alertView];
    
    _titleLb = [UILabel hl_regularWithColor:@"#333333" font:16];
    _titleLb.text = @"正在检测中...";
    [_alertView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(17));
        make.centerX.equalTo(self.alertView);
    }];
    
    UIButton *cancelBtn = [UIButton hl_regularWithImage:@"close_x_grey" select:NO];
    [self.view addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.titleLb);
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
    
    _statuViews = [NSMutableArray array];
    _checkAccess = YES; //初始化假设都通过
    for (NSInteger index = 0; index < _statuInfos.count; index ++) {
        HLStatuInfo *info = _statuInfos[index];
        NSString *pic = [self statuPicWithInfo:info];
        UIView *statuView = [self createViewWithTitle:[NSString stringWithFormat:@"%@：",info.key] pic:pic tip:info.value];
        [_alertView addSubview:statuView];
        [statuView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView).offset(FitPTScreen(19));
            make.right.equalTo(self.alertView).offset(FitPTScreen(-19));
            make.height.equalTo(FitPTScreen(38));
            make.top.equalTo(line.bottom).offset(FitPTScreen(10) + index *FitPTScreen(38));
        }];
        
        NSInteger num = index % 2;
        statuView.backgroundColor = num == 0?UIColor.whiteColor:UIColorFromRGB(0xFFFAF7);
        [_statuViews addObject:statuView];
        statuView.hidden = YES;
        if (!info.state) _checkAccess = NO;
    }
    
    _bottomLb = [UILabel hl_regularWithColor:@"#FF9900" font:14];
    _bottomLb.text = @"请完善信息后，进行提交";
    [_alertView addSubview:_bottomLb];
    [_bottomLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.bottom.equalTo(FitPTScreen(-40));
    }];
    _bottomLb.hidden = YES;
    
    _bottomBtn = [[UIButton alloc]init];
    [_bottomBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [self.alertView addSubview:_bottomBtn];
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.bottom.equalTo(FitPTScreen(-30));
    }];
    [_bottomBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomBtn.hidden = YES;
}

@end
