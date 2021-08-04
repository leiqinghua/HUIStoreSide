//
//  HLSpecialTableHead.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import "HLSpecialTableHead.h"
#import "HLSwitch.h"

@interface HLSpecialTableHead ()
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *descLb;
@property(nonatomic, strong) HLSwitch *switchView;
@property(nonatomic, strong)UIView *botLine;
@end

@implementation HLSpecialTableHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark - Event
- (void)switchClick:(UITapGestureRecognizer *)tap {
    _switchView.select = !_switchView.select;
    if ([self.delegate respondsToSelector:@selector(tableHead:open:)]) {
        [self.delegate tableHead:self open:_switchView.select];
    }
}

#pragma mark - UIView
- (void)initSubView {
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x999999);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(8));
    }];
    
    _switchView = [[HLSwitch alloc]init];
    [self addSubview:_switchView];
    [_switchView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(9));
        make.top.equalTo(FitPTScreen(23));
        make.size.equalTo(CGSizeMake(FitPTScreen(43), FitPTScreen(22)));
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchClick:)];
    [_switchView addGestureRecognizer:tap];
    
    _botLine = [[UIView alloc]init];
    _botLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self addSubview:_botLine];
    [_botLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.equalTo(FitPTScreen(0.5));
        make.left.equalTo(FitPTScreen(12));
    }];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _titleLb.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _descLb.text = subTitle;
}

- (void)setOn:(BOOL)on {
    _on = on;
    _switchView.select = on;
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    _botLine.hidden = hideLine;
}
@end
