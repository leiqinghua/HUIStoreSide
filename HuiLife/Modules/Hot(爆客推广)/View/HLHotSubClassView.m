//
//  HLHotSubClassView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/18.
//

#import "HLHotSubClassView.h"

@interface HLHotSubClassView () <UIScrollViewDelegate>
{
    CGFloat _width;
    BOOL _reload; //是否刷新过布局
}
@property(nonatomic, strong) UIButton *lastBtn;

@property(nonatomic, strong) NSMutableArray<UIButton *> *titleBtns;

@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HLHotSubClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = false;
    [self addSubview:_scrollView];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    
    [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [self.titleBtns removeAllObjects];
    
    __block CGFloat width = FitPTScreen(13);
    [_titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton hl_regularWithTitle:title titleColor:@"#222222" font:14 image:@""];
        button.layer.cornerRadius = FitPTScreen(14);
        button.backgroundColor = UIColor.whiteColor;
        [button setTitleColor:UIColorFromRGB(0xFF812A) forState:UIControlStateSelected];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
        
        [self.titleBtns addObject:button];
        
        CGFloat btnWidth = [button hl_estmateSizeWithTitle:title Font:button.titleLabel.font maxSize:CGSizeMake(ScreenW, FitPTScreen(40))].width + FitPTScreen(26);
        width += btnWidth + FitPTScreen(10);
        
        button.tag = idx;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (idx == 0) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(FitPTScreen(13));
            }];
        } else {
            UIButton *lastBtn = self.titleBtns[idx - 1];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.right).offset(FitPTScreen(10));
            }];
        }
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView);
            make.width.equalTo(btnWidth);
            make.height.equalTo(FitPTScreen(28));
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
    sender.selected = YES;
    sender.backgroundColor = UIColorFromRGB(0xFFF7F2);
    sender.layer.borderColor = UIColorFromRGB(0xFF812A).CGColor;
    sender.layer.borderWidth = 0.8;
    
    _lastBtn.selected = NO;
    _lastBtn.backgroundColor = UIColor.whiteColor;
    _lastBtn.layer.borderColor = UIColor.clearColor.CGColor;
    _lastBtn.layer.borderWidth = 0;
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
    
    if ([self.delegate respondsToSelector:@selector(hl_hotSubView:selectAtIndex:)]) {
        [self.delegate hl_hotSubView:self selectAtIndex:_lastBtn.tag];
    }
}

- (void)hotSubClassViewClickAtIndex:(NSInteger)index {
    UIButton *button = self.titleBtns[index];
    [self buttonClick:button];
}

@end

