//
//  HLHelpCenterController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/16.
//

#import "HLHelpCenterController.h"
#import "HLOPtionDescController.h"
#import "HLCustomerController.h"
#import "HLOfftenQuestionController.h"

@interface HLHelpCenterController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *controlView;

@property (nonatomic, strong) NSMutableArray *buttonArr;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation HLHelpCenterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"college_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self hl_setBackImage:@"back_white"];
}


- (void)controlItemClick:(UIButton *)sender {
    [self configSelectIndex:sender.tag];
    [self.scrollView setContentOffset:CGPointMake(sender.tag * CGRectGetWidth(_scrollView.frame), 0) animated:YES];
    [self changeBottomLineWithScrollContentOffsetX:sender.tag * CGRectGetWidth(_scrollView.frame)];
    [self loadDataWithPage:sender.tag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.statusBarStyle = UIStatusBarStyleLightContent;

    [self initScrollView];
    [self initTopView];
    // 默认加载第一页
    [self controlItemClick:self.buttonArr.firstObject];
}

- (void)initTopView {
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FitPTScreen(290), 44)];
    self.navigationItem.titleView = _controlView;
    NSArray *titles = @[@"操作说明", @"常见问题", @"联系客服"];
    self.buttonArr = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:UIColorFromRGB(0xFFECDB) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [_controlView addSubview:button];
        button.tag = i;
        button.frame = CGRectMake(CGRectGetWidth(_controlView.frame) / 3 * i, 0, CGRectGetWidth(_controlView.frame) / 3, CGRectGetHeight(_controlView.frame));
        [button addTarget:self action:@selector(controlItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:button];
    }
    _bottomLine = [[UIView alloc] init];
    [_controlView addSubview:_bottomLine];
    _bottomLine.backgroundColor = UIColorFromRGB(0xFFE4AF);
    _bottomLine.layer.cornerRadius = FitPTScreen(1.5);
    _bottomLine.layer.masksToBounds = YES;
    _bottomLine.frame = CGRectMake(0, 0, FitPTScreen(18), FitPTScreen(3));
}


- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * self.controllers.count, CGRectGetHeight(_scrollView.frame));
    
    for (int i = 0; i < self.controllers.count; i ++ ) {
        HLBaseViewController * baseVC = self.controllers[i];
        baseVC.view.frame = CGRectMake(ScreenW * i, 0, ScreenW, CGRectGetMaxY(self.scrollView.bounds));
        [_scrollView addSubview:baseVC.view];
        [self addChildViewController:baseVC];
        if ([baseVC respondsToSelector:@selector(resetFrame)]) {
            [baseVC performSelector:@selector(resetFrame)];
        }
    }
}

#pragma mark - Private Method
/// 控制按钮选中
- (void)configSelectIndex:(NSInteger)index {
    [self.buttonArr enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx == index) {
            obj.selected = YES;
            obj.titleLabel.font = [UIFont boldSystemFontOfSize:FitPTScreen(17)];
        } else {
            obj.selected = NO;
            obj.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        }
    }];
}

/// 改变bottomLine的位置
- (void)changeBottomLineWithScrollContentOffsetX:(CGFloat)offsetX {
    CGFloat scrollViewWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat controlViewWidth = CGRectGetWidth(_controlView.frame);
    _bottomLine.center = CGPointMake(controlViewWidth / 6 + (offsetX / scrollViewWidth) * controlViewWidth / 3, 39);
}

- (void)loadDataWithPage:(NSInteger)page {
    switch (page) {
        case 0:
        {
            HLOPtionDescController *optionVC = self.controllers[page];
            [optionVC loadOptionDesList];
        }
            break;
        case 1:
        {
            HLOfftenQuestionController *offenVC = self.controllers[page];
            offenVC.loadUrl = _questionUrl?:@"";
        }
            break;
        default:
        {
            HLCustomerController *customVC = self.controllers[page];
            [customVC loadCustomData];
        }
            break;
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeBottomLineWithScrollContentOffsetX:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self controlItemClick:self.buttonArr[index]];
}

#pragma mark - Getter

- (NSArray *)controllers {
    if (!_controllers) {
        HLOPtionDescController * optionVC = [[HLOPtionDescController alloc]init];
        HLOfftenQuestionController * webVC = [[HLOfftenQuestionController alloc]init];
        HLCustomerController * customerVC = [[HLCustomerController alloc]init];
        _controllers = @[optionVC, webVC, customerVC];
    }
    return _controllers;
}

@end
