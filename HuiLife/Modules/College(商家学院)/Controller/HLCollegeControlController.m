//
//  HLCollegeControlController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/28.
//

#import "HLCollegeControlController.h"
#import "HLCollegeCaseController.h"
#import "HLCollegeFindController.h"

@interface HLCollegeControlController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray *buttonArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *controllers;

@end

@implementation HLCollegeControlController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *backGroundImage = [UIImage imageNamed:@"college_nav_bg"];
    backGroundImage = [backGroundImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:backGroundImage forBarMetrics:UIBarMetricsDefault];
    [self hl_setBackImage:@"back_white"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusBarStyle = UIStatusBarStyleLightContent;
    
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FitPTScreen(168), 44)];
    self.navigationItem.titleView = _controlView;
    
    [self creatTopControlSubViews];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * self.controllers.count, CGRectGetHeight(_scrollView.frame));
    
    // 默认加载第一页
    [self configSelectIndex:0];
    [self loadPageDataWithIndex:0];
    [self changeBottomLineWithScrollContentOffsetX:0];
}

#pragma mark - User Action

- (void)controlItemClick:(UIButton *)sender {
    [self configSelectIndex:sender.tag];
    [self loadPageDataWithIndex:sender.tag];
    [self.scrollView setContentOffset:CGPointMake(sender.tag * CGRectGetWidth(_scrollView.frame), 0) animated:YES];
    
    [self changeBottomLineWithScrollContentOffsetX:sender.tag * CGRectGetWidth(_scrollView.frame)];
}

/// 改变bottomLine的位置
- (void)changeBottomLineWithScrollContentOffsetX:(CGFloat)offsetX {
    CGFloat scrollViewWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat controlViewWidth = CGRectGetWidth(_controlView.frame);
    _bottomLine.center = CGPointMake(controlViewWidth / 4 + (offsetX / scrollViewWidth) * controlViewWidth / 2, 39);
}

#pragma mark - Private Method

/// 加载指定页的数据
- (void)loadPageDataWithIndex:(NSInteger)index {
    HLBaseViewController *baseVC = self.controllers[index];
    if (![self.childViewControllers containsObject:baseVC]) {
        [self.scrollView addSubview:baseVC.view];
        baseVC.view.frame = CGRectMake(index * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        // 加载数据
        if ([baseVC respondsToSelector:@selector(loadData)]) {
            [baseVC performSelector:@selector(loadData)];
        }
        [self addChildViewController:baseVC];
    }
}

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

- (void)creatTopControlSubViews {
    NSArray *titles = @[@"案例", @"找专家"];
    self.buttonArr = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:UIColorFromRGB(0xFFECDB) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [_controlView addSubview:button];
        button.tag = i;
        button.frame = CGRectMake(CGRectGetWidth(_controlView.frame) / 2 * i, 0, CGRectGetWidth(_controlView.frame) / 2, CGRectGetHeight(_controlView.frame));
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeBottomLineWithScrollContentOffsetX:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [self configSelectIndex:index];
    [self loadPageDataWithIndex:index];
    [self changeBottomLineWithScrollContentOffsetX:index * CGRectGetWidth(_scrollView.frame)];
}

#pragma mark - Getter

- (NSArray *)controllers {
    if (!_controllers) {
        
        HLCollegeCaseController *caseVC = [[HLCollegeCaseController alloc] init];
        HLCollegeFindController *findVC = [[HLCollegeFindController alloc] init];
        
        _controllers = @[caseVC, findVC];
    }
    return _controllers;
}

@end
