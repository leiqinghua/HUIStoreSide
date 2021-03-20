//
//  HLHotTitleScrollView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/17.
//

#import "HLHotTitleScrollView.h"

@interface HLHotTitleScrollView () <UIScrollViewDelegate>

{
    CGFloat _width;
    BOOL _reload; //是否刷新过布局
}

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray<UIButton *> *titleBtns;

@property(nonatomic, strong) UIButton *lastBtn;

@property(nonatomic, strong) UIView *bottomScroll;

@end

@implementation HLHotTitleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.whiteColor;
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = false;
    [self addSubview:_scrollView];
}

- (void)setTitles:(NSArray *)titles {
    if (_titles.count) return;
    _titles = titles;
    _titleBtns = [NSMutableArray array];
    
    __block CGFloat width = FitPTScreen(13);
    [_titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [self.scrollView addSubview:button];
        
        [self.titleBtns addObject:button];
    
        width += [button hl_estmateSizeWithTitle:title Font:button.titleLabel.font maxSize:CGSizeMake(ScreenW, FitPTScreen(40))].width;
        width += FitPTScreen(20);
        
        button.tag = idx;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *lastBtn ;
        if (idx > 0) lastBtn = self.titleBtns[idx - 1];
        if (idx == 0) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(FitPTScreen(13));
            }];
        } else {
           [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.right).offset(FitPTScreen(20));
            }];
        }
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView);
        }];
        
    }];
    _width = width;
    [_scrollView setContentSize:CGSizeMake(width, 0)];
    
    [self buttonClick:self.titleBtns.firstObject];
}


- (void)buttonClick:(UIButton *)sender {
    if ([sender isEqual:_lastBtn]) {
        return;
    }
    _lastBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:FitPTScreen(17)];
    _lastBtn = sender;

    if (!_reload) {
        //    两句一起使用会在当前runloop中立即刷新布局
        [self.scrollView setNeedsLayout];
        [self.scrollView layoutIfNeeded];
        _reload = YES;
    }
    
    if (_width > ScreenW) {
        CGPoint point = [HLTools hl_horizontalWithScroll:_scrollView scrollWidth:ScreenW selectItem:sender];
        [self.scrollView setContentOffset:point animated:YES];
    }
    
    [self setBottomScroll];
    
    if ([self.delegate respondsToSelector:@selector(hl_hotTitleView:selectAtIndex:)]) {
        [self.delegate hl_hotTitleView:self selectAtIndex:_lastBtn.tag];
    }
}

//下面的滚动条
- (void)setBottomScroll{
    if (!_bottomScroll) {
        _bottomScroll = [[UIView alloc]init];
        _bottomScroll.backgroundColor = UIColorFromRGB(0xFF7F2B);
        _bottomScroll.layer.cornerRadius = FitPTScreen(1.25);
        _bottomScroll.frame = CGRectMake(0, CGRectGetMaxY(self.bounds)-FitPTScreen(3), 30, FitPTScreen(3));
        _bottomScroll.center = CGPointMake(self.lastBtn.center.x, _bottomScroll.center.y);
        [self.scrollView addSubview:_bottomScroll];
        return;
    }
   
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = self.bottomScroll.center;
        center.x = self.lastBtn.center.x - 4;
        self.bottomScroll.center = center;
    }];
}


#pragma mark - UIScrollViewDelegate

@end
