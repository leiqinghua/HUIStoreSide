//
//  HLFeeSectionFooter.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLFeeSectionFooter.h"
#import "HLFeeInputView.h"
#import "HLFeeMainInfo.h"

@interface HLFeeSectionFooter () <HLFeeInputViewDelegate>

@property(nonatomic, strong) HLFeeInputView *inputView;

@end

@implementation HLFeeSectionFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {

    self.contentView.backgroundColor = UIColor.whiteColor;
    _inputView = [[HLFeeInputView alloc]init];
    _inputView.inputWidth = FitPTScreen(75);
    _inputView.delegate = self;
    [self.contentView addSubview:_inputView];
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.centerY.height.equalTo(self.contentView);
    }];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self);
        make.size.equalTo(CGSizeMake(FitPTScreen(362), FitPTScreen(0.7)));
    }];
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    _inputView.enableEdit = canEdit;
}

- (void)setBaseInfo:(HLFeeBaseInfo *)baseInfo {
    _baseInfo = baseInfo;
    NSString *text = [NSString stringWithFormat:@"%@%@",_baseInfo.title,_baseInfo.label];
    _inputView.titleAttr =  [text modifyDigitalColor:UIColorFromRGB(0xFD9E2F) normalColor:UIColorFromRGB(0x333333) font:[UIFont boldSystemFontOfSize:FitPTScreen(15)] normalFont:[UIFont systemFontOfSize:FitPTScreen(12)]];
    _inputView.text = baseInfo.distance_amount;
}

#pragma mark - HLFeeInputViewDelegate
- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text {
    _baseInfo.distance_amount = text;
    _baseInfo.value = text;
}
@end
