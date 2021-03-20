//
//  HLCardSelectViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/10.
//

#import "HLCardSelectViewCell.h"

@interface HLCardSelectViewCell ()

@property(nonatomic,strong)UIButton * selectBtn;

@end

@implementation HLCardSelectViewCell

-(void)initView{
    [super initView];
    [self configSelectCell];
    
    _selectBtn = [[UIButton alloc]init];
    _selectBtn.layer.cornerRadius = FitPTScreen(13);
    _selectBtn.backgroundColor = UIColorFromRGB(0xFFAB19);
    [_selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [_selectBtn setTitle:@"已选择" forState:UIControlStateSelected];
    [_selectBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_selectBtn setTitleColor:UIColorFromRGB(0x797979) forState:UIControlStateSelected];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _selectBtn.userInteractionEnabled = false;
    [self.bgView addSubview:_selectBtn];
    [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-22));
        make.right.equalTo(FitPTScreen(-12));
        make.width.equalTo(FitPTScreen(72));
        make.height.equalTo(FitPTScreen(26));
    }];
    
}

-(void)setBaseModel:(HLCardSelectModel *)baseModel{
    [super setBaseModel:baseModel];
    _selectBtn.selected = baseModel.isExtConupon;;
    _selectBtn.backgroundColor =baseModel.isExtConupon?UIColorFromRGB(0xF5F5F5):UIColorFromRGB(0xFFAB19);
    self.bgView.layer.borderColor = baseModel.select?UIColorFromRGB(0xFF9F23).CGColor:UIColor.clearColor.CGColor;
    self.bgView.layer.borderWidth = baseModel.select?FitPTScreen(1):0;
}

@end

