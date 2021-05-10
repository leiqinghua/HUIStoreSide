//
//  HLPushHistorySectionHeader.m
//  HuiLife
//
//  Created by 王策 on 2021/4/28.
//

#import "HLPushHistorySectionHeader.h"

@interface HLPushHistorySectionHeader ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation HLPushHistorySectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    UIView *leftView = [[UIView alloc] init];
    [self.contentView addSubview:leftView];
    leftView.backgroundColor = UIColorFromRGB(0xFF9900);
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(3));
        make.height.equalTo(FitPTScreen(14.5));
    }];
    
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    self.label.font = [UIFont systemFontOfSize:FitPTScreen(14) weight:UIFontWeightMedium];
    self.label.textColor = UIColorFromRGB(0x333333);
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.right).offset(FitPTScreen(8));
        make.centerY.equalTo(leftView);
    }];
}

- (void)setNumber:(NSInteger)number{
    _number = number;
    NSString *numberStr = [NSString stringWithFormat:@"%ld次",number];
    NSString *allStr = [NSString stringWithFormat:@"本次活动已成功推送%@",numberStr];
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [mAttr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF9900)} range:[allStr rangeOfString:numberStr]];
    self.label.attributedText = mAttr;
}

@end
