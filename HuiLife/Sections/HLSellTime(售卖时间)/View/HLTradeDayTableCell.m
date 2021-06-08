//
//  HLTradeDayTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLTradeDayTableCell.h"

@interface HLTradeDayTableCell ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) NSMutableArray *buttons;

@property(nonatomic, strong) NSMutableArray *selectBtns;

@end

@implementation HLTradeDayTableCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:NO];
    self.showLine = YES;
    
    _titleLb = [UILabel hl_regularWithColor:@"#333333" font:14];
    [self.bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(19));
    }];
    
    _buttons = [NSMutableArray array];
    NSArray *days = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    CGFloat width = ScreenW / 5;
    CGFloat hight = FitPTScreen(40);
    for (int i = 0; i < days.count; i ++) {
        NSInteger row = i / 5;
        NSInteger col = i % 5;
        UIView *bottomView = [[UIView alloc]init];
        [self.bagView addSubview:bottomView];
        [bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(width * col);
            make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(14) + hight * row);
            make.size.equalTo(CGSizeMake(width, hight));
        }];
        NSString *title = [NSString stringWithFormat:@"  %@",days[i]];
        UIButton *button = [UIButton hl_regularWithTitle:title titleColor:@"#222222" font:14 image:@"rect_normal"];
        [button setImage:[UIImage imageNamed:@"success_square_oriange"] forState:UIControlStateSelected];
        [bottomView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(bottomView);
            make.width.height.equalTo(bottomView);
        }];
        button.tag = i;
        [_buttons addObject:button];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected && ![self.selectBtns containsObject:sender]) {
        [self.selectBtns addObject:sender];
    } else if (!sender.selected && [self.selectBtns containsObject:sender]) {
        [self.selectBtns removeObject:sender];
    }
    
    NSMutableArray *values = [NSMutableArray array];
    for (UIButton *button in self.selectBtns) {
        [values addObject:@(button.tag)];
    }
    _model.values = [values copy];
    if ([self.delegate respondsToSelector:@selector(tradeDayWithMode:cancelAll:)]) {
        [self.delegate tradeDayWithMode:_model cancelAll:!_model.values.count];
    }
}

- (void)setModel:(HLSellModel *)model {
    _model = model;
   
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:model.title];
    if ([model.title containsString:@"*"]) {
        [attr addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xFF3A3A)} range:NSMakeRange(0, 1)];
    }
    _titleLb.attributedText = attr;
   
    [self.selectBtns removeAllObjects];
    for (int i = 0; i< model.values.count; i ++) {
        NSInteger index = [model.values[i] integerValue];
        UIButton *button = self.buttons[index];
        button.selected = YES;
        [self.selectBtns addObject:button];
    }
    
    NSMutableArray *buttons = [NSMutableArray arrayWithArray:_buttons];
    [buttons removeObjectsInArray:self.selectBtns];
    for (UIButton *button in buttons) {
        button.selected = NO;
    }
}

- (NSMutableArray *)selectBtns {
    if (!_selectBtns) {
        _selectBtns = [NSMutableArray array];
    }
    return _selectBtns;
}
@end
