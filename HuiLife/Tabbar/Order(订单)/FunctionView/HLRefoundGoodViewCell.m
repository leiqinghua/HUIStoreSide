//
//  HLRefoundGoodViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/25.
//

#import "HLRefoundGoodViewCell.h"

@interface HLRefoundGoodViewCell(){
    UIButton * _delete;
}

@property(strong,nonatomic)UILabel *titleLable;

@property(strong,nonatomic)UILabel *priceLable;

@property(strong,nonatomic)UILabel *numLable;

@property(strong,nonatomic)UILabel *changeNum;

@end
@implementation HLRefoundGoodViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self iniSubView];
    }
    return self;
}

-(void)iniSubView{
    self.contentView.backgroundColor = [UIColor hl_StringToColor:@"#FCFCFC"];
    _titleLable = [[UILabel alloc]init];
    _titleLable.text = @"红烧排骨";
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _titleLable.textColor = [UIColor hl_StringToColor:@"#656565"];
    _titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(20));
        make.width.equalTo(FitPTScreen(200));
    }];
    
    _priceLable = [[UILabel alloc]init];
    _priceLable.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _priceLable.textColor = [UIColor hl_StringToColor:@"#AAAAAA"];
    [self.contentView addSubview:_priceLable];
    [_priceLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(self.titleLable.mas_bottom).offset(FitPTScreen(10));
    }];
    
    UIView * midLine = [[UIView alloc]init];
    midLine.backgroundColor = [UIColor hl_StringToColor:@"AAAAAA"];
    [self.contentView addSubview:midLine];
    [midLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLable.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.priceLable);
        make.width.equalTo(FitPTScreen(1));
        make.height.equalTo(FitPTScreen(11));
    }];
    
    _numLable = [[UILabel alloc]init];
    _numLable.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _numLable.textColor = [UIColor hl_StringToColor:@"#AAAAAA"];
    [self.contentView addSubview:_numLable];
    [_numLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midLine.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(midLine);
    }];
    
//
    UIButton * increase = [[UIButton alloc]init];
    [increase setImage:[UIImage imageNamed:@"add_oriange"] forState:UIControlStateNormal];
    [self.contentView addSubview:increase];
    [increase makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-5));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [increase addTarget:self action:@selector(increaseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeNum = [[UILabel alloc]init];
    _changeNum.text = @"0";
    _changeNum.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _changeNum.textColor = [UIColor hl_StringToColor:@"#656565"];
    [self.contentView addSubview:_changeNum];
    [_changeNum makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(increase);
        make.right.equalTo(increase.mas_left).offset(FitPTScreen(-11));
        
    }];
    
    UIButton * delete = [[UIButton alloc]init];
    [delete setImage:[UIImage imageNamed:@"delete_solid_grey"] forState:UIControlStateNormal];
    [self.contentView addSubview:delete];
    [delete makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.changeNum.mas_left).offset(FitPTScreen(-11));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    _delete = delete;
    [delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setGoodModel:(HLRefundGoodModel *)goodModel{
    _goodModel = goodModel;
    _titleLable.text = goodModel.pro_name;
    _priceLable.text = goodModel.priceText;
    _numLable.text = goodModel.numText;
}


-(void)increaseClick:(UIButton *)sender{
    NSInteger count =_changeNum.text.intValue + 1;
    if (count > _goodModel.pro_num.integerValue) {
        [HLTools showWithText:@"已到最大数量"];
        return;
    }
    _changeNum.text = [NSString stringWithFormat:@"%ld",count];
    _goodModel.selectNum = _changeNum.text.intValue;
    if ([self.delegate respondsToSelector:@selector(cell:changeNumWithModel:)]) {
        [self.delegate cell:self changeNumWithModel:_goodModel];
    }
}

-(void)deleteClick:(UIButton *)sender{
    int count = _changeNum.text.intValue - 1;
    if (count < 0) {
        return;
    }
    _changeNum.text = [NSString stringWithFormat:@"%d",count];
    _goodModel.selectNum = _changeNum.text.intValue;
    if ([self.delegate respondsToSelector:@selector(cell:changeNumWithModel:)]) {
        [self.delegate cell:self changeNumWithModel:_goodModel];
    }
}

-(void)setSelectAll:(BOOL)selectAll{
    _selectAll = selectAll;
    _changeNum.text = _selectAll?_goodModel.pro_num:@"0";
    _goodModel.selectNum = _changeNum.text.intValue;
    if ([self.delegate respondsToSelector:@selector(cell:changeNumWithModel:)]) {
        [self.delegate cell:self changeNumWithModel:_goodModel];
    }
    
}
@end
