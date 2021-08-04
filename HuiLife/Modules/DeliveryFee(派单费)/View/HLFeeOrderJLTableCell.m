//
//  HLFeeOrderJLTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLFeeOrderJLTableCell.h"
#import "HLFeeInputView.h"
#import "HLFeeMainInfo.h"

@interface HLFeeOrderJLTableCell () <HLFeeInputViewDelegate>

@property(nonatomic, strong) HLFeeInputView *leftInputV;
@property(nonatomic, strong) HLFeeInputView *rightInputV;

@end

@implementation HLFeeOrderJLTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _rightInputV = [[HLFeeInputView alloc]init];
    _rightInputV.title = @"，则加派单费 ¥";
    _rightInputV.inputWidth = FitPTScreen(55);
    _rightInputV.delegate = self;
    [self.contentView addSubview:_rightInputV];
    [_rightInputV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.centerY.height.equalTo(self.contentView);
    }];
    
    _leftInputV = [[HLFeeInputView alloc]init];
    _leftInputV.title = @"订单金额超 ¥";
    _leftInputV.inputWidth = FitPTScreen(55);
    _leftInputV.delegate = self;
    [self.contentView addSubview:_leftInputV];
    [_leftInputV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightInputV.left);
        make.centerY.height.equalTo(self.contentView);
    }];
}

- (void)setOrderInfo:(HLFeeOrderInfo *)orderInfo {
    _orderInfo = orderInfo;
    _leftInputV.title = orderInfo.title;
    _leftInputV.text = orderInfo.order_amount;
    _rightInputV.title = orderInfo.label;
    _rightInputV.text = orderInfo.distance_amount;
}

- (BOOL)checkOrdersIsEqual {
    HLFeeOrderInfo *orderInfo = (HLFeeOrderInfo *)self.orderInfo;
    for (HLFeeOrderInfo *info in self.orders) {
        if (![info isEqual:orderInfo] && ([info.order_amount floatValue] == [orderInfo.order_amount floatValue]) && info.order_amount.length && orderInfo.order_amount.length) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - HLFeeInputViewDelegate
- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text {
    HLFeeOrderInfo *orderInfo = (HLFeeOrderInfo *)self.orderInfo;
    if ([inputView isEqual:_leftInputV]) {
        orderInfo.order_amount = text;
        [orderInfo.pargrams setObject:orderInfo.order_amount forKey:orderInfo.orderKey];
        return;
    }
    orderInfo.distance_amount = text;
    [orderInfo.pargrams setObject:orderInfo.distance_amount forKey:orderInfo.distanceKey];
}

- (void)inputView:(HLFeeInputView *)inputView didEndText:(UITextField *)textField {
    if ([self checkOrdersIsEqual]) {
        textField.text = @"";
        HLFeeOrderInfo *orderInfo = (HLFeeOrderInfo *)self.orderInfo;
        orderInfo.order_amount = @"";
        [HLTools showWithText:@"不能输入相同的订单金额"];
    }
}


@end
