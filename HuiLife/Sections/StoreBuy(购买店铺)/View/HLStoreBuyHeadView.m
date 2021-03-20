//
//  HLStoreBuyHeadView.m
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import "HLStoreBuyHeadView.h"

@interface HLStoreBuyHeadView ()

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) NSMutableArray *itemArr;

@property (nonatomic, strong) HLStoreBuyMainInfo *mainInfo;

@end

@implementation HLStoreBuyHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    UIView *lineV = [[UIView alloc] init];
    [self addSubview:lineV];
    lineV.backgroundColor = UIColorFromRGB(0xFF8E14);
    lineV.layer.cornerRadius = FitPTScreen(2);
    lineV.layer.masksToBounds = YES;
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.height.equalTo(FitPTScreen(15));
        make.width.equalTo(FitPTScreen(4));
        make.top.equalTo(FitPTScreen(50));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [self addSubview:tipLab];
    tipLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(17)];
    tipLab.textColor = UIColorFromRGB(0x000000);
    tipLab.text = @"购买商 + 号时效";
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.right).offset(FitPTScreen(11));
        make.centerY.equalTo(lineV);
    }];
    _tipLab = tipLab;
    
    UILabel *descLab = [[UILabel alloc] init];
    [self addSubview:descLab];
    descLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    descLab.textColor = UIColorFromRGB(0x999999);
    descLab.text = @"全场功能免费用 功能迭代不收费";
    [descLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLab);
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(15));
    }];
    _descLab = descLab;
    
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.shadowColor = UIColorFromRGB(0xD8D8D8).CGColor;
    bgView.layer.shadowOpacity = 0.5;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowRadius = FitPTScreen(8);
    bgView.layer.cornerRadius = FitPTScreen(8);
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV);
        make.right.equalTo(FitPTScreen(-13));
        make.top.equalTo(descLab.bottom).offset(FitPTScreen(32));
        make.height.equalTo(FitPTScreen(145));
    }];
    
    self.itemArr = [NSMutableArray array];
    
    CGFloat itemWidth = FitPTScreen(73);
    CGFloat itemHight = FitPTScreen(68);
    CGFloat leftMargin = FitPTScreen(15);
    CGFloat itemMargin = (FitPTScreen(350) - leftMargin * 2 - itemWidth * 4) / 3;
    
    for (NSInteger i = 0; i < 4; i++) {
        UIView *itemView = [self subItemView];
        [bgView addSubview:itemView];
        [self.itemArr addObject:itemView];
        itemView.layer.cornerRadius = FitPTScreen(9);
        itemView.layer.shadowRadius = FitPTScreen(9);
        itemView.tag = i;
        [itemView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(42));
            make.left.equalTo(leftMargin + (itemWidth + itemMargin) * i);
            make.height.equalTo(itemHight);
            make.width.equalTo(itemWidth);
        }];
        [itemView hl_addTarget:self action:@selector(itemViewClick:)];
    }
    
    UIView *bottomLine = [[UIView alloc] init];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(FitPTScreen(5));
    }];
}

- (UIView *)subItemView {
    
    UIView *itemView = [[UIView alloc] init];
    
    UILabel *itemLab = [[UILabel alloc] init];
    [itemView addSubview:itemLab];
    itemLab.textAlignment = NSTextAlignmentCenter;
    itemLab.tag = 999;
    itemLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(18)];
    [itemLab makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    return itemView;
}

- (void)itemViewClick:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    [self.mainInfo.ruleData enumerateObjectsUsingBlock:^(HLStoreBuyYearInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = idx == index;
    }];
    for (NSInteger i = 0; i < self.itemArr.count; i++) {
        HLStoreBuyYearInfo *info = _mainInfo.ruleData[i];
        UIView *itemView = self.itemArr[i];
        [self configWithItemViewSelect:itemView select:info.select];
    }
    
    if (self.delegate) {
        [self.delegate selectYearInfoChanged:self];
    }
}

- (void)configMainInfo:(HLStoreBuyMainInfo *)mainInfo {
    _mainInfo = mainInfo;
    
    _tipLab.text = mainInfo.title;
    _descLab.text = mainInfo.titleDesc;
    
    for (NSInteger i = 0; i < self.itemArr.count; i++) {
        HLStoreBuyYearInfo *info = mainInfo.ruleData[i];
        UIView *itemView = self.itemArr[i];
        UILabel *label = [itemView viewWithTag:999];
        label.text = info.name;
        [self configWithItemViewSelect:itemView select:info.select];
        
        if (info.discount.length) {
            UIButton *discountBtn = [[UIButton alloc] init];
            [itemView.superview addSubview:discountBtn];
            discountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, FitPTScreen(2), 0);
            [discountBtn setTitle:info.discount forState:UIControlStateNormal];
            [discountBtn setBackgroundImage:[UIImage imageNamed:@"buy_store_discount"] forState:UIControlStateNormal];
            [discountBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            discountBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
            [discountBtn makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(itemView.top).offset(FitPTScreen(2));
                make.centerX.equalTo(itemView);
                make.width.equalTo(FitPTScreen(35));
                make.height.equalTo(FitPTScreen(18));
            }];
        }
    }
}

- (void)configWithItemViewSelect:(UIView *)itemView select:(BOOL)select {
    UILabel *label = [itemView viewWithTag:999];
    if (select) {
        itemView.layer.borderWidth = 1;
        itemView.layer.shadowOpacity = 0.5;
        label.textColor = UIColorFromRGB(0xFF8400);
        itemView.layer.shadowOffset = CGSizeMake(0, 0);
        itemView.backgroundColor = UIColorFromRGB(0xFFF5DF);
        itemView.layer.borderColor = UIColorFromRGB(0xFF9B30).CGColor;
        itemView.layer.shadowColor = UIColorFromRGB(0xFF9702).CGColor;
    } else {
        itemView.layer.borderWidth = 0;
        itemView.layer.shadowOpacity = 0.5;
        label.textColor = UIColorFromRGB(0x333333);
        itemView.layer.shadowOffset = CGSizeMake(0, 0);
        itemView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        itemView.layer.shadowColor = UIColorFromRGB(0XC9C9C9).CGColor;
    }
}

@end
