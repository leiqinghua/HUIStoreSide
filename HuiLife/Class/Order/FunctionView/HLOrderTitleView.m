//
//  HLOrderTitleView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/3.
//

#import "HLOrderTitleView.h"

#define kScrollWidth ScreenW

@interface HLOrderTitleView()

@property(strong,nonatomic)NSArray * titles;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *bottomScroll;

@property (strong, nonatomic) NSMutableArray *btnArr;

@property (strong, nonatomic) NSMutableArray *titleLables;

@property (strong, nonatomic) NSMutableArray *numLables;
//选中的按钮
@property (strong, nonatomic) UIButton *selectItem;

@end

@implementation HLOrderTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//    [self addSubview:_scrollView];
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.bounces = NO;
    
    CGFloat itemWidth = kScrollWidth / (_titles.count > 5 ? 5 : _titles.count);
    self.scrollView.contentSize = CGSizeMake(itemWidth * _titles.count, FitPTScreenH(55));
    if (!_btnArr) _btnArr = [NSMutableArray array];

    for (NSInteger i = 0; i < _titles.count; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, self.frame.size.height)];
        item.tag = i;
        [item addTarget:self action:@selector(tapItem:) forControlEvents:UIControlEventTouchDown];
        [_btnArr addObject:item];
        [self addSubview:item];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = _titles[i];
        title.tag = 1000;
        title.textColor = [UIColor hl_StringToColor:@"#222222"];
        title.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        title.textAlignment = NSTextAlignmentCenter;
        [item addSubview:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(item);
            make.top.equalTo(FitPTScreen(13));
        }];
        [self.titleLables addObject:title];

        UILabel *num = [[UILabel alloc]init];
        num.tag = 1001;
        num.textColor = [UIColor hl_StringToColor:@"#777777"];
        num.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        num.textAlignment = NSTextAlignmentCenter;
        num.text = [NSString stringWithFormat:@"(%d)",0];
        [item addSubview:num];
        [num makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(item);
            make.top.equalTo(title.bottom).offset(FitPTScreen(7));
        }];
        [self.numLables addObject:num];
        
    }
    
    _selectItem = self.btnArr.firstObject;
    
    //创建黄色的滚动条
    _bottomScroll = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - FitPTScreen(2) - FitPTScreen(13),FitPTScreen(40), FitPTScreen(2))];
    _bottomScroll.layer.cornerRadius = FitPTScreen(1);
    _bottomScroll.backgroundColor = UIColorFromRGB(0xFD9E2F);
    _bottomScroll.center = CGPointMake(CGRectGetMidX(_selectItem.frame), _bottomScroll.center.y);
    [self addSubview:_bottomScroll];
    
}

- (void)tapItem:(UIButton *)sender{
    
    if (![_selectItem isEqual:sender]) {
        UILabel * titleLb = [_selectItem viewWithTag:1000];
        titleLb.textColor = [UIColor hl_StringToColor:@"#222222"];
        titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        
        UILabel * numLb = [_selectItem viewWithTag:1001];
        numLb.textColor = [UIColor hl_StringToColor:@"#777777"];
    }
    
    UILabel * titleLb = [sender viewWithTag:1000];
    titleLb.textColor = [UIColor hl_StringToColor:@"#FF8604"];
    titleLb.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    
    UILabel * numLb = [sender viewWithTag:1001];
    numLb.textColor = [UIColor hl_StringToColor:@"#FF8604"];
    _selectItem = sender;
    
    
    CGPoint center = self.bottomScroll.center;
    center.x = _selectItem.center.x;
    self.bottomScroll.center = center;
    
    if ([self.delegate respondsToSelector:@selector(headView:selectItem:)]) {
        [self.delegate headView:self selectItem:_selectItem];
    }

}

- (void)setSelectIndex:(NSInteger)index{
    UIButton *item = self.btnArr[index];
    [self tapItem:item];
}

- (void)configerNumbers:(NSArray *)numbers{
    if (numbers.count == 0) {
        return;
    }
    for (int i = 0; i<self.numLables.count; i++) {
        UILabel * numberLable = self.numLables[i];
        numberLable.text = [NSString stringWithFormat:@"(%@)",numbers[i]];
    }
}

- (NSMutableArray *)titleLables{
    if (!_titleLables) {
        _titleLables = [NSMutableArray array];
    }
    return _titleLables;
}

- (NSMutableArray *)numLables{
    if (!_numLables) {
        _numLables = [NSMutableArray array];
    }
    return _numLables;
}

@end
