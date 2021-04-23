//
//  HLVideoProductSelectController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import "HLVideoProductSelectController.h"
#import "HLVideoProductListController.h"

@interface HLVideoProductSelectController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleBtns;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *controlLine;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation HLVideoProductSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.navigationItem.title = @"选择推广商品";
    [self creatSubViews];
    // 默认显示
    [self controlTitleButtonStyle];
}

#pragma mark - Method

- (void)titleButtonClick:(UIButton *)sender{
    self.selectIndex = sender.tag;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * self.selectIndex, 0) animated:YES];
    [self controlTitleButtonStyle];
}

- (void)controlTitleButtonStyle{
    [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.selectIndex != idx) {
            obj.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        }else{
            obj.titleLabel.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
            CGRect frame = self.controlLine.frame;
            self.controlLine.frame = CGRectMake(CGRectGetMidX(obj.frame) - frame.size.width/2, FitPTScreen(38), frame.size.width, frame.size.height);
        }
    }];
}

#pragma mark - View

- (void)creatSubViews{
    
    NSArray *titles = @[@"外卖活动",@"秒杀活动"];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(50))];
    [self.view addSubview:self.titleView];
    self.titleView.backgroundColor = UIColor.whiteColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame) + FitPTScreen(10), ScreenW, ScreenH - (CGRectGetMaxY(self.titleView.frame) + FitPTScreen(10)))];
    [self.view addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * titles.count , self.scrollView.bounds.size.height);
    
    CGFloat buttonW = ScreenW / titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        button.tag = i;
        [self.titleBtns addObject:button];
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i * buttonW, 0, buttonW, self.titleView.bounds.size.height);
        [self.titleView addSubview:button];
        
        HLVideoProductListController *productList = [[HLVideoProductListController alloc] init];
        productList.type = i;
        [self addChildViewController:productList];
        [self.scrollView addSubview:productList.view];
        productList.view.frame = CGRectMake(i * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    }
    
    self.controlLine = [[UIView alloc] init];
    self.controlLine.backgroundColor = UIColorFromRGB(0xFD9927);
    [self.titleView addSubview:self.controlLine];
    self.controlLine.frame = CGRectMake(0, 0, FitPTScreen(25), FitPTScreen(3));
    self.controlLine.layer.cornerRadius = FitPTScreen(1.5);
    self.controlLine.layer.masksToBounds = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.selectIndex = offsetX / scrollView.bounds.size.width;
    [self controlTitleButtonStyle];
}

#pragma mark - Getter

- (NSMutableArray *)titleBtns{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

@end
