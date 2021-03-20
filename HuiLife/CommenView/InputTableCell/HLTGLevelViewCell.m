//
//  HLTGLevelViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "HLTGLevelViewCell.h"

@interface HLTGLevelViewCell ()

@property(nonatomic,strong)UIButton * lowBtn;

@property(nonatomic,strong)UIButton * midBtn;

@property(nonatomic,strong)UIButton * highBtn;

@property(nonatomic,strong)UIButton * selectBtn;

@end

@implementation HLTGLevelViewCell

-(void)initSubUI{
    [super initSubUI];
    
    _lowBtn = [[UIButton alloc]init];
    [_lowBtn setTitle:@"较弱" forState:UIControlStateNormal];
    [_lowBtn setTitleColor:UIColorFromRGB(0xA3A3A3) forState:UIControlStateNormal];
    [_lowBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
    _lowBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _lowBtn.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self.contentView addSubview:_lowBtn];

    _midBtn = [[UIButton alloc]init];
    [_midBtn setTitle:@"中等" forState:UIControlStateNormal];
    [_midBtn setTitleColor:UIColorFromRGB(0xA3A3A3) forState:UIControlStateNormal];
    [_midBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
    _midBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _midBtn.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self.contentView addSubview:_midBtn];

    _highBtn = [[UIButton alloc]init];
    [_highBtn setTitle:@"非常好" forState:UIControlStateNormal];
    [_highBtn setTitleColor:UIColorFromRGB(0xA3A3A3) forState:UIControlStateNormal];
    [_highBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
    _highBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _highBtn.backgroundColor = UIColorFromRGB(0xF6F6F6);
    [self.contentView addSubview:_highBtn];
    
    [_highBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(75));
        make.height.equalTo(FitPTScreen(24));
    }];
    
    [_midBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.highBtn.left);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(75));
        make.height.equalTo(FitPTScreen(24));
    }];
    
    [_lowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.midBtn.left);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(75));
        make.height.equalTo(FitPTScreen(24));
    }];
    
    _lowBtn.userInteractionEnabled = false;
    _midBtn.userInteractionEnabled = false;
    _highBtn.userInteractionEnabled = false;
}

-(void)levelBtnClick:(UIButton *)sender{
    
    if ([_selectBtn isEqual:sender] && _selectBtn) {
        return;
    }
    _selectBtn.selected = false;
    _selectBtn.backgroundColor = UIColorFromRGB(0xF6F6F6);
    
    sender.selected = YES;
//    sender.backgroundColor = UIColorFromRGB(0xFF7916);
    
    _selectBtn = sender;
    
}


-(void)setBaseInfo:(HLTGLevelInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    switch (baseInfo.levle) {
        case 0:
            [self levelBtnClick:_lowBtn];
            _lowBtn.backgroundColor = [HLTools hl_toColorByColorStr:@"ffc740"];
            break;
        case 1:
            [self levelBtnClick:_midBtn];
            _midBtn.backgroundColor = [HLTools hl_toColorByColorStr:@"ff881f"];
            break;
        case 2:
            [self levelBtnClick:_highBtn];
            _highBtn.backgroundColor = [HLTools hl_toColorByColorStr:@"ff7916"];
            break;
        default:
            break;
    }
}



@end


@implementation HLTGLevelInfo

@end
