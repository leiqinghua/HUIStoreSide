//
//  HLRightButtonsViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/9/19.
//

#import "HLRightButtonsViewCell.h"

@interface HLRightButtonsViewCell ()

@property(nonatomic,strong)UILabel * subLb;

@property(nonatomic,strong)NSMutableArray * buttons;

@property(nonatomic,strong)UIButton * selectBtn;

@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HLRightButtonsViewCell

- (void)initSubUI {
    [super initSubUI];
    
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(21));
        make.left.equalTo(FitPTScreen(12));
    }];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsHorizontalScrollIndicator = false;
    [self.contentView addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTipLab.right).offset(FitPTScreen(30));
        make.centerY.equalTo(self.leftTipLab);
        make.right.equalTo(self);
        make.height.equalTo(FitPTScreen(55));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xD9D9D9);
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.top.equalTo(FitPTScreen(55));
        make.right.equalTo(-13);
        make.height.equalTo(0.7);
    }];
    
    _subLb = [[UILabel alloc] init];
    _subLb.textColor = UIColorFromRGB(0x666666);
    _subLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self.contentView addSubview:_subLb];
    [_subLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(FitPTScreen(19));
        make.left.equalTo(FitPTScreen(19));
    }];
}


- (void)setBaseInfo:(HLRightButtonsInfo *)baseInfo {
    [super setBaseInfo:baseInfo];
    _subLb.text = baseInfo.tip;
    if (baseInfo.titles.count == self.buttons.count) {
        [self.buttons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setTitle:baseInfo.titles[idx] forState:UIControlStateNormal];
            if (idx == baseInfo.selectIndex) {
                button.selected = YES;
                button.layer.borderColor = UIColorFromRGB(0xFFB016).CGColor;
            }else{
                button.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
                button.selected = false;
            }
        }];
    }else{
        [self initButtons];
    }
    
    UIButton * selectBtn = [self.buttons objectAtIndex:baseInfo.selectIndex];
    [self buttonClick:selectBtn];
    
}


- (void)initButtons {
    HLRightButtonsInfo * info = (HLRightButtonsInfo *)self.baseInfo;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button removeFromSuperview];
    }];
    [self.buttons removeAllObjects];
    
    [_scrollView setContentSize:CGSizeMake(info.titles.count * FitPTScreen(83), 0)];
    
    for (int i = 0; i<info.titles.count; i++) {
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:info.titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFF8A00) forState:UIControlStateSelected];
        button.layer.cornerRadius = FitPTScreen(13);
        button.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
        button.layer.borderWidth = FitPTScreen(0.8);
        [self.scrollView addSubview:button];
        
        CGFloat width = FitPTScreen(73);
        CGFloat gap = FitPTScreen(10);
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(15));
            make.left.equalTo((width + gap) * i);
            make.width.equalTo(FitPTScreen(73));
            make.height.equalTo(FitPTScreen(26));
        }];
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)buttonClick:(UIButton *)sender {
    
    if (![sender isEqual:_selectBtn]) {
        
        sender.selected = YES;
        sender.layer.borderColor = UIColorFromRGB(0xFFB016).CGColor;
        
        _selectBtn.selected = false;
        _selectBtn.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
        _selectBtn = sender;
        
        HLRightButtonsInfo * info = (HLRightButtonsInfo *)self.baseInfo;
        info.selectIndex = [self.buttons indexOfObject:sender];
        if ([self.delegate respondsToSelector:@selector(hlButtonsCellWithSelectIndex:typeInfo:)]) {
            [self.delegate hlButtonsCellWithSelectIndex:info.selectIndex typeInfo:info];
        }
    }
    
    HLRightButtonsInfo * info = (HLRightButtonsInfo *)self.baseInfo;
    [self.scrollView layoutIfNeeded];
    if (info.titles.count >3) {
        CGPoint point = [HLTools hl_horizontalWithScroll:_scrollView scrollWidth:FitPTScreen(175) selectItem:sender];
        [self.scrollView setContentOffset:point animated:YES];
    }
}


- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
@end


@implementation HLRightButtonsInfo



@end
