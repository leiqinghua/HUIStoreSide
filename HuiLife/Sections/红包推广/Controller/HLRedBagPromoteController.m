//
//  HLRedBagPromoteController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/19.
//

#import "HLRedBagPromoteController.h"
#import "HLRedBagRecordController.h"

@interface HLRedBagPromoteController ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIView *scroll;
@property(nonatomic, strong) NSMutableArray *titleBtns;
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) NSMutableArray *subControllers;
@end

@implementation HLRedBagPromoteController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"推广统计"];
    [self hl_setBackImage:@"back_black"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Event
- (void)buttonClick:(UIButton *)sender {
    if ([sender isEqual:_selectBtn]) return;
    _selectBtn.selected = NO;
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    _selectBtn = sender;
    NSInteger index = [self.titleBtns indexOfObject:sender];
    [self.mainScrollView setContentOffset:CGPointMake(ScreenW *index, 0)];
    
    HLRedBagRecordController *recordVC = self.subControllers[sender.tag -1000];
    [recordVC startLoadListWithId:_redBagId];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = 3;
    CGPoint center =  CGPointMake(ScreenW/6, CGRectGetMidY(_scroll.frame));;
    center.x += scrollView.contentOffset.x / scale;
    _scroll.center = center;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    UIButton *button = self.titleBtns[index];
    [self buttonClick:button];
}

#pragma mark - UIView
- (void)initSubView {
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(55));
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    _titleBtns = [NSMutableArray array];
    NSArray *titles = @[@"领取记录",@"充值记录",@"退款记录"];
    for (NSInteger index = 0; index < titles.count; index ++) {
        NSString *title = titles[index];
        UIButton *button = [UIButton hl_regularWithTitle:title titleColor:@"#555555" font:14 image:@""];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        [topView addSubview:button];
        button.frame = CGRectMake((ScreenW/3)*index, 0,ScreenW/3 , CGRectGetMaxY(topView.bounds));
        button.tag = 1000 + index;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtns addObject:button];
    }
    _scroll = [[UIView alloc]init];
    [topView addSubview:_scroll];
    _scroll.backgroundColor = UIColorFromRGB(0xFF9900);
    _scroll.layer.cornerRadius = FitPTScreen(1);
    _scroll.frame = CGRectMake(0, FitPTScreen(42), FitPTScreen(25), FitPTScreen(2));
    _scroll.center = CGPointMake(ScreenW/6, CGRectGetMidY(_scroll.frame));
    
    _mainScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenW, CGRectGetMaxY(self.view.bounds)-CGRectGetMaxY(topView.frame));
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    [_mainScrollView setContentSize:CGSizeMake(ScreenW * 3, 0)];
    AdjustsScrollViewInsetNever(self, _mainScrollView);
    
    for (NSInteger index = 0; index < 3; index ++) {
        HLRedBagRecordController *recordVC = [[HLRedBagRecordController alloc]init];
        recordVC.type = index;
        recordVC.hideUser = index != 0;
        recordVC.view.frame = CGRectMake(index *ScreenW, 0, ScreenW, CGRectGetMaxY(_mainScrollView.bounds));
        [_mainScrollView addSubview:recordVC.view];
        [self addChildViewController:recordVC];
        [self.subControllers addObject:recordVC];
    }
//    默认选择第一个
    UIButton *firstBtn = self.titleBtns.firstObject;
    [self buttonClick:firstBtn];
}

#pragma mark - getter
- (NSMutableArray *)subControllers {
    if (!_subControllers) {
        _subControllers = [NSMutableArray array];
    }
    return _subControllers;
}
@end
