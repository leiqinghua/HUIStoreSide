//
//  HLCompeteMainController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/10.
//

#import "HLCompeteMainController.h"
#import "HLCompeteUpController.h"
#import "HLCompeteDownController.h"

@interface HLCompeteMainController () <UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIButton *upBtn;
@property(nonatomic, strong) UIButton *downBtn;
@property(nonatomic, strong) UIView *scroll;

@property(nonatomic, strong) HLCompeteUpController *upcontroller;
@property(nonatomic, strong) HLCompeteDownController *downcontroller;

@end

@implementation HLCompeteMainController

- (void)viewWillAppear:(BOOL)animated {
    [self hl_setTitle:@"竞业管理"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Event
- (void)switchClick:(UIButton *)sender {
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:FitPTScreen(13)];
    NSInteger index = sender.tag - 1000;
    if (index == 0) {
        _downBtn.selected = NO;
        _downBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        if (!_upcontroller) {
            _upcontroller = [[HLCompeteUpController alloc]init];
            _upcontroller.view.frame = CGRectMake(0, 0, ScreenW, CGRectGetMaxY(self.mainScrollView.bounds));
            [_mainScrollView addSubview:_upcontroller.view];
            [self addChildViewController:_upcontroller];
        }
    } else {
        _upBtn.selected = NO;
        _upBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        if (!_downcontroller) {
            _downcontroller = [[HLCompeteDownController alloc]init];
            _downcontroller.view.frame = CGRectMake(ScreenW, 0, ScreenW, CGRectGetMaxY(self.mainScrollView.bounds));
            [_mainScrollView addSubview:_downcontroller.view];
            [self addChildViewController:_downcontroller];
        }
    }
    [self.mainScrollView setContentOffset:CGPointMake(ScreenW *index, 0) animated:YES];
    
}

- (void)searchBtnClick:(UIButton *)sender {
    [HLTools pushAppPageLink:@"HLCompeteSearchController" params:@{} needBack:NO];
}

#pragma mark - UIView
- (void)initSubView {
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(42))];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    
    _upBtn = [UIButton hl_regularWithTitle:@"营业中" titleColor:@"#666666" font:13 image:@""];
    _upBtn.frame = CGRectMake(0, 0, ScreenW/2, FitPTScreen(42));
    [_upBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
    _upBtn.tag = 1000;
    [topView addSubview:_upBtn];
    
    _downBtn = [UIButton hl_regularWithTitle:@"已下架" titleColor:@"#666666" font:13 image:@""];
    [_downBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
    _downBtn.frame = CGRectMake(CGRectGetMaxX(_upBtn.frame), 0, ScreenW/2, FitPTScreen(42));
    _downBtn.tag = 1001;
    [topView addSubview:_downBtn];
    
    _scroll = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(37), FitPTScreen(2.5))];
    _scroll.backgroundColor = UIColorFromRGB(0xFD9E2F);
    _scroll.center = CGPointMake(CGRectGetMidX(_upBtn.frame), FitPTScreen(36));
    [topView addSubview:_scroll];
    
    [_upBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_downBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.delegate = self;
    _mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenW, CGRectGetMaxY(self.view.bounds) - CGRectGetMaxY(topView.frame));
    [self.view addSubview:_mainScrollView];
    [_mainScrollView setContentSize:CGSizeMake(ScreenW * 2, CGRectGetMaxY(_mainScrollView.bounds))];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    AdjustsScrollViewInsetNever(self, _mainScrollView);
    
    [self switchClick:_upBtn];
    
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(17), FitPTScreen(17))];
    [searchBtn setImage:[UIImage imageNamed:@"search_oriange"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search_oriange"] forState:UIControlStateHighlighted];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = 2;
    CGPoint center =  CGPointMake(CGRectGetMidX(_upBtn.frame), FitPTScreen(36));;
    center.x += scrollView.contentOffset.x / scale;
    _scroll.center = center;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    if (index == 0) [self switchClick:_upBtn];
    else [self switchClick:_downBtn];
}

@end
