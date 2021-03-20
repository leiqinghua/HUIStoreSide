//
//  HLBaseInputViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLBaseInputViewCell.h"

@interface HLBaseInputViewCell ()

@end

@implementation HLBaseInputViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initSubUI{
    _leftTipLab = [[UILabel alloc] init];
    [self.contentView addSubview:_leftTipLab];
    [_leftTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(15));
    }];
    
    _bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:_bottomLine];
    _bottomLine.hidden = YES;
    _bottomLine.backgroundColor = SeparatorColor;
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(0);
        make.height.equalTo(0.7);
        make.bottom.equalTo(0);
    }];
}

-(void)setBaseInfo:(HLBaseTypeInfo *)baseInfo{
    _baseInfo = baseInfo;
    _leftTipLab.attributedText = baseInfo.leftTipAttr;
    self.separatorInset = baseInfo.separatorInset;
    if (baseInfo.leftTipColor) {
        _leftTipLab.textColor = baseInfo.leftTipColor;
    }
}

-(void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    self.bottomLine.hidden = !showBottomLine;
}

@end


@implementation HLBaseTypeInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
        _separatorInset = UIEdgeInsetsMake(0, FitPTScreen(26), 0, FitPTScreen(12));
    }
    return self;
}


-(NSAttributedString *)leftTipAttr{
    
    if (!_leftTip || _leftTip.length == 0) {
        return nil;
    }
    
    if (!_leftTipAttr) {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:_leftTip attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
        if ([_leftTip containsString:@"*"]) {
            NSRange range = [_leftTip rangeOfString:@"*"];
            [mAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF4040) range:range];
            [mAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FitPTScreen(14)] range:range];
        }
        _leftTipAttr = mAttr;
    }
    return _leftTipAttr;
}

@end
