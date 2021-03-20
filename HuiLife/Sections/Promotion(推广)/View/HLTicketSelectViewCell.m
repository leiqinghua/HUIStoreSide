//
//  HLTicketSelectViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/11.
//

#import "HLTicketSelectViewCell.h"

@interface HLTicketSelectViewCell ()

@property(nonatomic,strong)UIButton * selectBtn;

@end

@implementation HLTicketSelectViewCell

-(void)initView{
    [super initView];
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [_selectBtn setTitle:@"已选择" forState:UIControlStateSelected];
    [_selectBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateSelected];
    [_selectBtn setTitleColor:UIColorFromRGB(0xFF8A00) forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _selectBtn.layer.cornerRadius = FitPTScreen(13);
    _selectBtn.layer.borderColor =UIColorFromRGB(0xFFB016).CGColor;
    _selectBtn.layer.borderWidth = FitPTScreen(1);
    _selectBtn.userInteractionEnabled = false;
    [self.bagView addSubview:_selectBtn];
    [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.bottom.equalTo(FitPTScreen(-19));
        make.width.equalTo(FitPTScreen(72));
        make.height.equalTo(FitPTScreen(26));
    }];
    [self configureSelectCell];
}


-(void)setModel:(HLTicketPromoteAble *)model{
    [super setModel:model];
    
    _selectBtn.selected = model.isExtConupon;
    _selectBtn.layer.borderColor = _selectBtn.selected?UIColorFromRGB(0xD8D8D8).CGColor:UIColorFromRGB(0xFFB016).CGColor;
    self.bagView.layer.borderColor = model.select?UIColorFromRGB(0xFF9F23).CGColor:UIColor.clearColor.CGColor;
    self.bagView.layer.borderWidth = model.select?FitPTScreen(0.7):0;
    self.bagView.layer.shadowColor = model.select?UIColorFromRGB(0xBABABA).CGColor:UIColorFromRGB(0xFF9F23).CGColor;
    self.bagView.layer.shadowOpacity = model.select?1:0.3;
}

@end
