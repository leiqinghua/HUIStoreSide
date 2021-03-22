//
//  HLBuyCardPackageViewCell.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardPackageViewCell.h"

@implementation HLBuyCardPackageViewModel

- (CGFloat)cellHeight{
    if (_cellHeight == 0) {
        _cellHeight = FitPTScreen(33) + FitPTScreen(70) * (self.items.count + 2) / 3 + FitPTScreen(15);
    }
    return _cellHeight;
}

@end

@interface HLBuyCardPackageViewCell ()

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) NSMutableArray *itemViews;

@end

@implementation HLBuyCardPackageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)creatSubViews{
    
    UIView *topPlaceV = [[UIView alloc] init];
    [self.contentView addSubview:topPlaceV];
    topPlaceV.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
    [topPlaceV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(5));
    }];
    
    self.tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipLab];
    self.tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.tipLab.textColor = [UIColor hl_StringToColor:@"#666666"];
    [self.tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topPlaceV.bottom).offset(FitPTScreen(14));
        make.left.equalTo(FitPTScreen(12));
        make.right.lessThanOrEqualTo(FitPTScreen(-12));
    }];
    
    
}

- (void)setModel:(HLBuyCardPackageViewModel *)model{
    _model = model;
    self.tipLab.text = model.tip;
    // 如果有了，就不用初始化了
    if (self.itemViews.count) {
        return;
    }
    
    CGFloat rowMargin = FitPTScreen(12);
    CGFloat colMargin = FitPTScreen(10);
    NSInteger rowCount = 3;
    CGFloat itemWidth = (ScreenW - (rowCount + 1) * rowMargin) / rowCount;
    CGFloat itemHeight = FitPTScreen(60);
    
    for (NSInteger i = 0; i < model.items.count; i++) {
        NSInteger row = i / rowCount;
        NSInteger col = i % rowCount;
        HLBuyCardPackageItemView *itemView = [[HLBuyCardPackageItemView alloc] init];
        itemView.item = model.items[i];
        itemView.tag = i;
        [self.contentView addSubview:itemView];
        [self.itemViews addObject:itemView];
        [itemView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rowMargin + col * (itemWidth + rowMargin));
            make.top.equalTo(self.tipLab.bottom).offset(FitPTScreen(18.5) + row * (itemHeight + colMargin));
            make.width.equalTo(itemWidth);
            make.height.equalTo(itemHeight);
        }];
        [itemView hl_addTarget:self action:@selector(itemViewClick:)];
        
        if(i == 0){
            itemView.item.select = YES;
            [itemView resetViewsState];
            if (self.delegate && model.items.count > 0) {
                [self.delegate packageViewCell:self selectItem:model.items[i]];
            }
        }
    }
}

- (void)itemViewClick:(UITapGestureRecognizer *)tap{
    HLBuyCardPackageItemView *itemView = (HLBuyCardPackageItemView *)tap.view;
    if (itemView.tag == self.model.selectIndex) {
        return;
    }
    
    HLBuyCardPackageItemView *lastItemView = self.itemViews[self.model.selectIndex];
    lastItemView.item.select = NO;
    [lastItemView resetViewsState];
    
    itemView.item.select = YES;
    [itemView resetViewsState];
    
    self.model.selectIndex = itemView.tag;
    
    if (self.delegate && self.model.items.count > 0) {
        [self.delegate packageViewCell:self selectItem:self.model.items[self.model.selectIndex]];
    }
}

- (NSMutableArray *)itemViews{
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

@end
