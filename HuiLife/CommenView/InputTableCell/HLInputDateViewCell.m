//
//  HLInputDateViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import "HLInputDateViewCell.h"
#import "HLSwitch.h"

@interface HLInputDateViewCell ()

@property(nonatomic,strong)UILabel * dateLb;

@property (nonatomic, strong) UIImageView *arrowImgV;

@property(nonatomic,strong)HLSwitch * switchV;

@end

@implementation HLInputDateViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(18));
    }];
    
    _dateLb = [[UILabel alloc]init];
    _dateLb.textColor =UIColorFromRGB(0x999999);
    _dateLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self.contentView addSubview:_dateLb];
    [_dateLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTipLab);
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(9));
    }];
    
    _arrowImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_arrowImgV];
    _arrowImgV.image = [UIImage imageNamed:@"arrow_right_grey"];
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(6));
        make.height.equalTo(FitPTScreen(12));
    }];
    
    _switchV = [[HLSwitch alloc]init];
    [self.contentView addSubview:_switchV];
    [_switchV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(43));
        make.height.equalTo(FitPTScreen(22));
    }];
    _switchV.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_switchV addGestureRecognizer:tap];
  
}

- (void)tapClick:(UITapGestureRecognizer *)sender{
    HLSwitch * switchV = (HLSwitch *)sender.view;
    switchV.select = !switchV.select;
    HLInputDateInfo *info = (HLInputDateInfo *)self.baseInfo;
    
    info.text = [NSString stringWithFormat:@"%d",switchV.select];
    info.swithOn = switchV.select;
    
    if ([self.delegate respondsToSelector:@selector(dateCell:switchON:)]) {
        [self.delegate dateCell:self switchON:switchV.select];
    }
}


- (void)setBaseInfo:(HLInputDateInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    if (baseInfo.dateType == 0) {
        if (!baseInfo.text.length) {
            self.dateLb.text = baseInfo.placeHoder;
            self.dateLb.textColor = UIColorFromRGB(0x999999);
        }else{
            self.dateLb.text = baseInfo.text;
            self.dateLb.textColor = UIColorFromRGB(0x666666);
        }
    }else{
        self.dateLb.text = baseInfo.placeHoder;
        self.dateLb.textColor = UIColorFromRGB(0x999999);
        self.baseInfo.text = [NSString stringWithFormat:@"%d",baseInfo.swithOn];
    }
    _arrowImgV.hidden = baseInfo.dateType == 1;
    _switchV.hidden = baseInfo.dateType == 0;
    _switchV.select = baseInfo.swithOn;
}


@end


@implementation HLInputDateInfo

-(BOOL)checkParamsIsOk{
    if (self.dateType == 1) {
        return self.text.length;
    }
    return self.mParams.count > 0;
}

@end
