//
//  HLDistanceInputTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLDistanceInputTableCell.h"
#import "HLFeeInputView.h"
#import "HLFeeMainInfo.h"

@interface HLDistanceInputTableCell () <HLFeeInputViewDelegate>

@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) HLFeeInputView *inputView;

@end

@implementation HLDistanceInputTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
//    _titleLb.text = @"2公里内";
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(self.contentView);
    }];
    
    _inputView = [[HLFeeInputView alloc]init];
    _inputView.inputWidth = FitPTScreen(75);
    _inputView.delegate = self;
    [self.contentView addSubview:_inputView];
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.centerY.height.equalTo(self.contentView);
    }];
}

- (void)setBaseInfo:(HLFeeBaseInfo *)baseInfo {
    _baseInfo = baseInfo;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:baseInfo.title];
    [attr addAttributes:@{NSForegroundColorAttributeName :UIColorFromRGB(0xFD9F30),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(15)]} range:NSMakeRange(0, 1)];
    _titleLb.attributedText = attr;
    _inputView.title = baseInfo.label;
    _inputView.text = baseInfo.distance_amount;
}

- (void)setCanEdit:(BOOL)canEdit {
    _inputView.enableEdit = canEdit;
}

#pragma mark - HLFeeInputViewDelegate
- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text {
    _baseInfo.distance_amount = text;
    _baseInfo.value = text;
}
@end
