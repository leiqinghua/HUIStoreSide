//
//  HLOrderFunctionView.m
//  HuiLife
//
//  Created by 雷清华 on 2019/12/15.
//

#import "HLOrderFunctionView.h"
#import "HLCustomAlert.h"

@interface HLOrderFunctionView ()

@property(nonatomic, strong) NSMutableArray *functionBtns;

@end

@implementation HLOrderFunctionView

- (void)setFunctions:(NSArray *)functions {
    _functions = functions;
    
    if (!functions.count) {
        [_functionBtns enumerateObjectsUsingBlock:^(UIButton*  _Nonnull funBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            [funBtn removeFromSuperview];
        }];
        [_functionBtns removeAllObjects];
        return;
    };
    
    if (functions.count == _functionBtns.count) {
        [functions enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *funbtn = self.functionBtns[idx];
            [funbtn setTitle:[NSString stringWithFormat:@" %@",dict[@"funTitle"]] forState:UIControlStateNormal];
            [funbtn setImage:[UIImage imageNamed:dict[@"tipImg"]] forState:UIControlStateNormal];
        }];
        return;
    }
    
    [_functionBtns enumerateObjectsUsingBlock:^(UIButton*  _Nonnull funBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        [funBtn removeFromSuperview];
    }];
    [_functionBtns removeAllObjects];
    
    CGFloat width = CGRectGetMaxX(self.bounds) / functions.count;
    for (int i =0; i<functions.count; i++) {
        NSDictionary *dict = functions[i];
        UIButton *funBtn = [UIButton hl_regularWithTitle:[NSString stringWithFormat:@" %@",dict[@"funTitle"]] titleColor:@"#666666" font:14 image:dict[@"tipImg"]];
        [self addSubview:funBtn];
        [funBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(width * i);
            make.top.bottom.equalTo(self);
            make.width.equalTo(width);
        }];
        [self.functionBtns addObject:funBtn];
        if (i > 0) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = UIColorFromRGB(0xECECEC);
            [funBtn addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(funBtn.left);
                make.centerY.equalTo(funBtn);
                make.width.equalTo(0.8);
                make.height.equalTo(FitPTScreen(15));
            }];
        }
        
        [funBtn addTarget:self action:@selector(funBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = UIColorFromRGB(0xECECEC);
    [self addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.top.equalTo(self);
        make.height.equalTo(FitPTScreen(0.8));
    }];
}


- (void)funBtnClick:(UIButton *)sender {
    NSInteger index = [self typeIndexWithTitle:sender.titleLabel.text];
    if (index == 0) {
        if ([self.delegate respondsToSelector:@selector(functionView:funName:)]) {
            [self.delegate functionView:self funName:sender.titleLabel.text];
        }
        return;
    }

    if (index == 1) {
        [HLCustomAlert showNormalStyleTitle:@"配送" message:@"确定配送？" buttonTitles:@[@"取消",@"确定"] buttonColors:@[UIColorFromRGB(0x868686),UIColorFromRGB(0xFF8604)] callBack:^(NSInteger index) {
            if (index == 1) {
                if ([self.delegate respondsToSelector:@selector(functionView:typeIndex:)]) {
                    [self.delegate functionView:self typeIndex:index];
                }
            }
        }];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(functionView:typeIndex:)]) {
        [self.delegate functionView:self typeIndex:index];
    }
}


- (NSInteger)typeIndexWithTitle:(NSString *)title {
//    要加空格
    if ([title isEqualToString:@" 配送"]) {
        return 1;
    }
    
    if ([title isEqualToString:@" 打印"]) {
        return 2;
    }
    
    if ([title isEqualToString:@" 退款"]) {
        return 3;
    }
    
    if ([title isEqualToString:@" 已自提"]) {
        return 4;
    }
    
    if ([title isEqualToString:@" 送达"]) {
        return 5;
    }
    
    if ([title isEqualToString:@" 立即接单"]) {
        return 6;
    }
    
    if ([title isEqualToString:@" 拒绝接单"]) {
        return 7;
    }
    
    return 0;
}



- (NSMutableArray *)functionBtns {
    if (!_functionBtns) {
        _functionBtns = [NSMutableArray array];
    }
    return _functionBtns;
}



@end
