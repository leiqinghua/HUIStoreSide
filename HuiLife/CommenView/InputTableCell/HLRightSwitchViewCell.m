//
//  HLRightSwitchViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLRightSwitchViewCell.h"
#import "HLSwitch.h"

@interface HLRightSwitchViewCell ()

@property (nonatomic, strong) HLSwitch *switchV;

@end

@implementation HLRightSwitchViewCell

- (void)initSubUI{
    
    [super initSubUI];
    
    _switchV = [[HLSwitch alloc]init];
    [self.contentView addSubview:_switchV];
    [_switchV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(43));
        make.height.equalTo(FitPTScreen(22));
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_switchV addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)sender{
    HLSwitch * switchV = (HLSwitch *)sender.view;
    switchV.select = !switchV.select;
    [(HLRightSwitchInfo *)self.baseInfo setSwitchOn:switchV.select];
    if ([self.delegate respondsToSelector:@selector(switchViewCell:switchChanged:)]) {
        [self.delegate switchViewCell:self switchChanged:(HLRightSwitchInfo *)self.baseInfo];
        return;
    }
    
}

- (void)setBaseInfo:(HLRightSwitchInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _switchV.select = baseInfo.switchOn;
}

@end

@implementation HLRightSwitchInfo


-(BOOL)checkParamsIsOk{
    return self.mParams.count;
}


@end
