//
//  HLRightEditNumViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import "HLRightEditNumViewCell.h"

@interface HLRightEditNumViewCell ()
@property(nonatomic, strong) UIButton *intBtn;
@property(nonatomic, strong) UIButton *dotBtn;
@property(nonatomic, strong) UILabel *rightLb;
@end

@implementation HLRightEditNumViewCell

//减
- (void)delClick {
    HLRightEditNumInfo *info = (HLRightEditNumInfo *)self.baseInfo;
    NSInteger dot = [_dotBtn.titleLabel.text integerValue];
    NSInteger num = [_intBtn.titleLabel.text integerValue];
    if (dot > 0) {
        if (num == info.intMin && dot == info.dotMin) return;
        dot --;
        [_dotBtn setTitle:[NSString stringWithFormat:@"%ld",dot] forState:UIControlStateNormal];
        info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
    } else {
        if (num > info.intMin) {
            num --;
            [_dotBtn setTitle:@"9" forState:UIControlStateNormal];
            [_intBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
            info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
        }
    }
}

//加
- (void)addClick {
    HLRightEditNumInfo *info = (HLRightEditNumInfo *)self.baseInfo;
    NSInteger dot = [_dotBtn.titleLabel.text integerValue];
    NSInteger num = [_intBtn.titleLabel.text integerValue];
    if (dot < 9) {
        dot ++;
        [_dotBtn setTitle:[NSString stringWithFormat:@"%ld",dot] forState:UIControlStateNormal];
        info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
    } else {
        if (num < 9) {
            num ++;
            [_dotBtn setTitle:@"0" forState:UIControlStateNormal];
            [_intBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
            info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
        }
    }
}


- (void)configDiscount:(NSString *)discountStr {
//    整数部分
    NSString *intStr = [discountStr substringWithRange:NSMakeRange(0, 1)];
    NSString *dotStr = @"0";
    if ([discountStr containsString:@"."]) {
        NSRange dotRange = [discountStr rangeOfString:@"."];
        dotStr = [discountStr substringFromIndex:(dotRange.location + 1)];
    }
    [_intBtn setTitle:intStr forState:UIControlStateNormal];
    [_dotBtn setTitle:dotStr forState:UIControlStateNormal];
}

- (void)setBaseInfo:(HLRightEditNumInfo *)baseInfo {
    [super setBaseInfo:baseInfo];
    _rightLb.text = baseInfo.rightTip;
    [self configDiscount:baseInfo.text];
}

- (void)initSubUI {
    [super initSubUI];
    _rightLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    [self.contentView addSubview:_rightLb];
    [_rightLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.contentView);
    }];
    
    UIButton *addBtn = [UIButton hl_regularWithTitle:@"+" titleColor:@"#343434" font:15 image:@""];
    [addBtn hl_addCornerRadius:FitPTScreen(4) bounds:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(35))  byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight];
    addBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self.contentView addSubview:addBtn];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLb.left).offset(FitPTScreen(-6));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(40), FitPTScreen(35)));
    }];
    
    _dotBtn = [UIButton hl_regularWithTitle:@"1" titleColor:@"#343434" font:15 image:@""];
    _dotBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self.contentView addSubview:_dotBtn];
    [_dotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.left).offset(FitPTScreen(-1.5));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    
    UILabel *dotLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    dotLb.text = @".";
    [self.contentView addSubview:dotLb];
    [dotLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dotBtn.left).offset(FitPTScreen(-3.5));
        make.top.equalTo(self.dotBtn).offset(FitPTScreen(23));
    }];
    
    _intBtn = [UIButton hl_regularWithTitle:@"0" titleColor:@"#343434" font:15 image:@""];
    _intBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self.contentView addSubview:_intBtn];
    [_intBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dotLb.left).offset(FitPTScreen(-3.5));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    
    UIButton *delBtn = [UIButton hl_regularWithTitle:@"-" titleColor:@"#343434" font:15 image:@""];;
    [delBtn hl_addCornerRadius:FitPTScreen(4) bounds:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(35))  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    delBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self.contentView addSubview:delBtn];
    [delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.intBtn.left).offset(FitPTScreen(-1.5));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(40), FitPTScreen(35)));
    }];
    
    [delBtn addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
}



@end



@implementation HLRightEditNumInfo

- (BOOL)checkParamsIsOk{
    if (!self.needCheckParams) {
        return YES;
    }
    
    if (self.text.length == 0 && self.mParams.count == 0) {
        return NO;
    }
    
    return YES;
}


@end
