//
//  HLSortView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
//

#import "HLSortView.h"

@interface HLSortView ()

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *itemViews;

@property(nonatomic, strong) UIView *selectView;

@end

@implementation HLSortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildConfigs];
        [self initSubViews];
    }
    return self;
}

- (void)buildConfigs {
    _type = HLSortViewTypeNormal;
    _normalTitleColor = UIColorFromRGB(0x666666);
    _selectTitleColor = UIColorFromRGB(0xFD9E2F);
    _normalBorderColor = UIColor.clearColor;
    _selectBorderColor = UIColorFromRGB(0xFD9E2F);
    _itemBackgroundColor = UIColor.whiteColor;
    _normalFont = FitPTScreen(12);
    _selectFont = FitPTScreen(12);
    _itemGap = FitPTScreen(10);
    _width = FitPTScreen(78);
    _height = FitPTScreen(30);
    _inspacing = FitPTScreen(13);
}

- (void)initSubViews {
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (UIView *)createNormalViewWithTitle:(NSString *)title {
    UIView *itemView = [[UIView alloc]init];
    itemView.backgroundColor = _itemBackgroundColor;
    itemView.layer.borderColor = _normalBorderColor.CGColor;
    itemView.layer.cornerRadius = FitPTScreen(3);
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.tag = 10000;
    titleLb.text = title;
    titleLb.font = [UIFont systemFontOfSize:_normalFont];
    titleLb.textColor = _normalTitleColor;
    [itemView addSubview:titleLb];
    
    if (_autoWidth) {
        [titleLb makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inspacing);
            make.right.equalTo(-(self.inspacing));
            make.centerY.equalTo(itemView);
        }];
        
    } else {
        [titleLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(itemView);
        }];
    }
    
    return itemView;
}

#pragma mark - Method
- (void)layoutFrame {
    CGFloat contentWidth = _itemGap;
    for (UIView *itemView in self.itemViews) {
        NSInteger index = [self.itemViews indexOfObject:itemView];
        NSString *title = self.datasource[index];
        BOOL select = [itemView isEqual:_selectView];
        CGFloat width = _width;
        if (_autoWidth) {
            width = [HLTools estmateWidthString:title Font:[UIFont systemFontOfSize:select?_selectFont:_normalFont]] + _inspacing*2;
        }
        itemView.frame = CGRectMake(contentWidth, 0, width, _height);
        itemView.center = CGPointMake(CGRectGetMidX(itemView.frame), CGRectGetMidY(self.scrollView.bounds));
        contentWidth += width + _itemGap;
    }
    [self.scrollView setContentSize:CGSizeMake(contentWidth, 0)];
}


- (void)clickView:(UIView *)view select:(BOOL)select {
    if (select) {
        view.layer.borderColor = _selectBorderColor.CGColor;
        view.layer.borderWidth = 0.5;
        UILabel *titleLb = (UILabel *)[view viewWithTag:10000];
        titleLb.textColor = _selectTitleColor;
        titleLb.font = [UIFont systemFontOfSize:_selectFont];
    } else {
        view.layer.borderColor = _normalBorderColor.CGColor;
        view.layer.borderWidth = _normalBorderWidth;
        UILabel *titleLb = (UILabel *)[view viewWithTag:10000];
        titleLb.textColor = _normalTitleColor;
        titleLb.font = [UIFont systemFontOfSize:_normalFont];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    UIView *tapView = sender.view;
    [self itemViewClick:tapView];
}

- (void)sortViewSelectIndex:(NSInteger)index {
    UIView *itemView = [self.itemViews objectAtIndex:index];
    [self itemViewClick:itemView];
}

- (void)itemViewClick:(UIView *)itemView {
    if (![itemView isEqual:_selectView]) {
        [self clickView:_selectView select:NO];
        [self clickView:itemView select:YES];
    }
    NSInteger index = itemView.tag - 1000;
    if ([self.delegate respondsToSelector:@selector(sortView:selectAtIndex:)]) {
        [self.delegate sortView:self selectAtIndex:index];
    }
    _selectView = itemView;
    CGPoint point = [HLTools hl_horizontalWithScroll:_scrollView scrollWidth:CGRectGetWidth(self.bounds) selectItem:itemView];
    [self.scrollView setContentOffset:point animated:YES];
}

#pragma mark - setter
- (void)setDatasource:(NSArray *)datasource {
    _datasource = datasource;
    [self.itemViews removeAllObjects];
    for (NSInteger index = 0; index < datasource.count; index ++) {
        NSString *title = datasource[index];
        UIView *itemView;
        if (_type == HLSortViewTypeNormal) {
            itemView = [self createNormalViewWithTitle:title];
        }
        [self.scrollView addSubview:itemView];
        [self.itemViews addObject:itemView];
        itemView.tag = 1000+index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [itemView addGestureRecognizer:tap];
    }
    
    [self layoutFrame];
}


#pragma mark - getter
- (NSMutableArray *)itemViews {
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

@end
