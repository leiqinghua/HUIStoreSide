//
//  HLRightEditNumViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import "HLRightEditNumViewCell.h"

@interface HLRightEditNumViewCell ()
@property(nonatomic, strong) UITextField *intInput;
@property(nonatomic, strong) UITextField *dotInput;
@property(nonatomic, strong) UILabel *rightLb;
@end

@implementation HLRightEditNumViewCell

//减
- (void)delClick {
    [_dotInput endEditing:YES];
    [_intInput endEditing:YES];
    HLRightEditNumInfo *info = (HLRightEditNumInfo *)self.baseInfo;
    NSInteger dot = [_dotInput.text integerValue];
    NSInteger num = [_intInput.text integerValue];
    
    if (info.text.doubleValue <= info.minNum) {
        HLShowText(@"折扣不能低于1折");
        return;
    }
    
    if (dot > 0) {
        dot--;
        _dotInput.text = [NSString stringWithFormat:@"%ld",dot];
        info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
    } else {
        if (num > 0) {
            num--;
            _dotInput.text = @"9";
            _intInput.text = [NSString stringWithFormat:@"%ld",num];
            info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
        }
    }
}

//加
- (void)addClick {
    
    [_dotInput endEditing:YES];
    [_intInput endEditing:YES];
    
    HLRightEditNumInfo *info = (HLRightEditNumInfo *)self.baseInfo;
    NSInteger dot = [_dotInput.text integerValue];
    NSInteger num = [_intInput.text integerValue];
    
    if (info.text.doubleValue >= info.maxNum) {
        HLShowText(@"折扣不能超出9.5折");
        return;
    }
    
    if (dot < 9) {
        dot++;
        _dotInput.text = [NSString stringWithFormat:@"%ld",dot];
        info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
    } else {
        if (num < 9) {
            num++;
            _dotInput.text = @"0";
            _intInput.text = [NSString stringWithFormat:@"%ld",num];
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
    _dotInput.text = dotStr;
    _intInput.text = intStr;
}

- (void)setBaseInfo:(HLRightEditNumInfo *)baseInfo {
    [super setBaseInfo:baseInfo];
    _rightLb.text = baseInfo.rightTip;
    [self configDiscount:baseInfo.text];
}

- (void)inputChanged:(UITextField *)sender{
    if (sender.text.length > 1) {
        sender.text = [sender.text substringToIndex:1];
    }
    HLRightEditNumInfo *info = (HLRightEditNumInfo *)self.baseInfo;
    NSInteger dot = [_dotInput.text integerValue];
    NSInteger num = [_intInput.text integerValue];
    info.text = [NSString stringWithFormat:@"%ld.%ld",num,dot];
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
    
    _dotInput = [[UITextField alloc] init];
    [self.contentView addSubview:_dotInput];
    _dotInput.textAlignment = NSTextAlignmentCenter;
    _dotInput.textColor = UIColorFromRGB(0x343434);
    _dotInput.font = [UIFont systemFontOfSize:15];
    _dotInput.keyboardType = UIKeyboardTypeNumberPad;
    _dotInput.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [_dotInput makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.left).offset(FitPTScreen(-1.5));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    [_dotInput addTarget:self action:@selector(inputChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *dotLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    dotLb.text = @".";
    [self.contentView addSubview:dotLb];
    [dotLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dotInput.left).offset(FitPTScreen(-3.5));
        make.top.equalTo(self.dotInput).offset(FitPTScreen(23));
    }];
    
    _intInput = [[UITextField alloc] init];
    [self.contentView addSubview:_intInput];
    _intInput.textAlignment = NSTextAlignmentCenter;
    _intInput.textColor = UIColorFromRGB(0x343434);
    _intInput.font = [UIFont systemFontOfSize:15];
    _intInput.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [_intInput makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dotLb.left).offset(FitPTScreen(-3.5));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    _intInput.keyboardType = UIKeyboardTypeNumberPad;
    [_intInput addTarget:self action:@selector(inputChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *delBtn = [UIButton hl_regularWithTitle:@"-" titleColor:@"#343434" font:15 image:@""];;
    [delBtn hl_addCornerRadius:FitPTScreen(4) bounds:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(35))  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    delBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self.contentView addSubview:delBtn];
    [delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.intInput.left).offset(FitPTScreen(-1.5));
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
