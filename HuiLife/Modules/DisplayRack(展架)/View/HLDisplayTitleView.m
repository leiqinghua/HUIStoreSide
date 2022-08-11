//
//  HLDisplayTitleView.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import "HLDisplayTitleView.h"

@interface HLDisplayTitleView () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *bottomView;

@property(nonatomic, strong) NSMutableArray *titleBtns;

@property(nonatomic, strong) UIButton *selectBtn;


@end

@implementation HLDisplayTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _bottomView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _bottomView.showsHorizontalScrollIndicator = false;
    _bottomView.delegate = self;
    [self addSubview:_bottomView];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;

    CGFloat width = FitPTScreen(88);
    CGFloat hight = FitPTScreen(27);
    CGFloat gaping = FitPTScreen(10);
    CGFloat leftPading = FitPTScreen(12);
    _titleBtns = [NSMutableArray array];
    
    [_bottomView setContentSize:CGSizeMake(leftPading + (width + gaping) *titles.count , 0)];
    
    for (int i = 0; i< titles.count; i++) {
        NSString *title = titles[i];
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF8517) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        button.layer.cornerRadius = FitPTScreen(13.5);
        button.layer.borderColor = UIColorFromRGB(0xC0C0C0).CGColor;
        button.layer.borderWidth = 0.5;
        [self.bottomView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftPading + (width + gaping) * i);
            make.top.equalTo(FitPTScreen(10));
            make.width.equalTo(width);
            make.height.equalTo(hight);
        }];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtns addObject:button];
    }
}

- (void)buttonClick:(UIButton *)sender {
    if (![sender isEqual:_selectBtn]) {
        _selectBtn.selected = false;
        _selectBtn.layer.borderColor = UIColorFromRGB(0xC0C0C0).CGColor;
    }
    
    sender.selected = YES;
    sender.layer.borderColor = UIColorFromRGB(0xFF8517).CGColor;
    
    _selectBtn = sender;
    
    [self.bottomView layoutIfNeeded];
    CGPoint point = [HLTools hl_horizontalWithScroll:self.bottomView scrollWidth:ScreenW selectItem:sender];
    [self.bottomView setContentOffset:point animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(displayView:selectAtIndex:)]) {
        [self.delegate displayView:self selectAtIndex:sender.tag];
    }
}

- (void)clickWithIndex:(NSInteger)index {
    UIButton *button = self.titleBtns[index];
    [self buttonClick:button];
}
@end
