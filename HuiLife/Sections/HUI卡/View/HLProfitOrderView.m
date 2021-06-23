//
//  HLProfitOrderView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import "HLProfitFooterView.h"
#import "HLFeeInputView.h"
#import "HLHUIProfitInfo.h"
#import "HLProfitGoodInfo.h"

@interface HLProfitOrderView ()<UITableViewDelegate, UITableViewDataSource, HLProfitOrderCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *datasource;
@end

@implementation HLProfitOrderView

- (void)initSubView {
    [super initSubView];
    _tableView = [[UITableView alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = FitPTScreen(50);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.top.equalTo(self.detailLb.bottom).offset(FitPTScreen(15));
    }];
    [_tableView registerClass:[HLProfitOrderCell class] forCellReuseIdentifier:@"HLProfitOrderCell"];
}

#pragma mark - HLProfitOrderCellDelegate
- (void)orderCell:(HLProfitOrderCell *)cell add:(BOOL)add {
    
    if (self.datasource.count >= 10 && add) {
        [HLTools showWithText:@"最多添加10个"];
        return;
    }
    
    HLProfitOrderInfo *info = nil;
    
    if (add) {
        
        if (self.datasource.count >= 2) {
            //获取最后两个,判断区间是否包含
            HLProfitOrderInfo *upInfo = self.datasource[self.datasource.count-2];
            HLProfitOrderInfo *downInfo = self.datasource.lastObject;
            if (downInfo.priceStart.doubleValue <= upInfo.priceEnd.doubleValue) {
                [HLTools showWithText:@"价格区间填写有误"];
                return;
            }
        }
        
        HLProfitOrderInfo *lastInfo = self.datasource.lastObject;
        if ([lastInfo check]) {
            info = [[HLProfitOrderInfo alloc]init];
            info.discount = @"1";
            [self.datasource addObject:info];
            [self.tableView reloadData];
        }
        
    } else {
        info = cell.info;
        NSInteger index = [self.datasource indexOfObject:info];
        [self.datasource removeObject:info];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    if ([self.delegate respondsToSelector:@selector(orderViewAdd:allSource:info:)]) {
        [self.delegate orderViewAdd:add allSource:self.datasource info:info];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLProfitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLProfitOrderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.add = indexPath.row == 0;
    cell.delegate = self;
    cell.info = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - getter & setter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        HLProfitOrderInfo *addInfo = [[HLProfitOrderInfo alloc]init];
        [_datasource addObject:addInfo];
    }
    return _datasource;
}

- (void)setOrderDiscounts:(NSArray *)orderDiscounts {
    _orderDiscounts = orderDiscounts;
    [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:orderDiscounts];
    [self.tableView reloadData];
}
@end


#pragma mark - HLProfitOrderCell
@interface HLProfitOrderCell () <HLFeeInputViewDelegate>
@property(nonatomic, strong) HLFeeInputView *leftInputV;
@property(nonatomic, strong) HLFeeInputView *midInputV;
@property(nonatomic, strong) HLFeeInputView *rightInputV;
@property(nonatomic, strong) UIButton *optionBtn;
@end

@implementation HLProfitOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _optionBtn = [[UIButton alloc]init];
    [self.contentView addSubview:_optionBtn];
    [_optionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-7));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(32), FitPTScreen(32)));
    }];
    [_optionBtn addTarget:self action:@selector(optionClick) forControlEvents:UIControlEventTouchUpInside];
    
    _rightInputV = [[HLFeeInputView alloc]init];
    _rightInputV.title = @"则享受";
    _rightInputV.tip = @"折";
    _rightInputV.text = @"";
    _rightInputV.inputWidth = FitPTScreen(55);
    _rightInputV.delegate = self;
    
    [self.contentView addSubview:_rightInputV];
    [_rightInputV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.optionBtn.left).offset(FitPTScreen(-6));
        make.centerY.height.equalTo(self.contentView);
    }];
    
    _midInputV = [[HLFeeInputView alloc]init];
    _midInputV.title = @"～";
    _midInputV.tip = @"";
    _midInputV.inputWidth = FitPTScreen(55);
    _midInputV.delegate = self;
    _midInputV.keyBoardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_midInputV];
    [_midInputV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightInputV.left);
        make.centerY.height.equalTo(self.contentView);
    }];
    
    _leftInputV = [[HLFeeInputView alloc]init];
    _leftInputV.title = @"订单价格 ¥";
    _leftInputV.tip = @"";
    _leftInputV.inputWidth = FitPTScreen(55);
    _leftInputV.delegate = self;
    _leftInputV.keyBoardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_leftInputV];
    [_leftInputV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.midInputV.left);
        make.centerY.height.equalTo(self.contentView);
    }];
}

- (void)setAdd:(BOOL)add {
    _add = add;
    UIImage *optionImg = [UIImage imageNamed:_add?@"add_light_white":@"delete_circle_grey"];
    [_optionBtn setImage:optionImg forState:UIControlStateNormal];
}

- (void)setInfo:(HLProfitOrderInfo *)info {
    _info = info;
    _leftInputV.placeHolder = info.minPlace;
    _midInputV.placeHolder = info.maxPlace;
    _rightInputV.placeHolder = info.discountPlace;
        _leftInputV.text = info.priceStart ?: @"";
    
    _midInputV.text = info.priceEnd ?: @"";
    _rightInputV.text = info.discount ?: @"";
}

- (void)optionClick {
    if ([self.delegate respondsToSelector:@selector(orderCell:add:)]) {
        [self.delegate orderCell:self add:_add];
    }
}

#pragma mark - HLFeeInputViewDelegate
- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text {
    if ([inputView isEqual:_leftInputV]) {
        if (text.length > 4) {
            _leftInputV.text = [text substringToIndex:4];
            text = _leftInputV.text;
        }
        _info.priceStart = text;
        return;
    }
    if ([inputView isEqual:_midInputV]) {
        if (text.length > 4) {
            _midInputV.text = [text substringToIndex:4];
            text = _midInputV.text;
        }
        _info.priceEnd = text;
        return;
    }
    
    if (text.floatValue > 9.5){
        text = @"9.5";
        [HLTools showWithText:@"折扣不能超出9.5折"];
        _rightInputV.text = text;
    }
    
    if (text.floatValue < 1 && text.length > 0){
        text = @"1";
        [HLTools showWithText:@"折扣不能小于1折"];
        _rightInputV.text = text;
    }
    
    _info.discount = text;
}

- (void)inputView:(HLFeeInputView *)inputView didEndText:(UITextField *)textField {
    
}


- (BOOL)inputView:(HLFeeInputView *)inputView textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.keyboardType != UIKeyboardTypeDecimalPad) {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //限制.后面最多有1位，且不能再输入.
    if ([textField.text rangeOfString:@"."].location != NSNotFound) {
        //有.了 且.后面输入了1位  停止输入
        if (toBeString.length > [toBeString rangeOfString:@"."].location+2) {
            return NO;
        }
        //有.了，不允许再输入.
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    // 限制首位0，后面只能输入.
    if ([textField.text isEqualToString:@"0"]) {
        if (![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    // 如果第一个输入的是点，那么直接变成 0.
    if (textField.text.length == 0 && [string isEqualToString:@"."]) {
        textField.text = @"0";
    }
    
    //限制只能输入：1234567890.
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

@end
