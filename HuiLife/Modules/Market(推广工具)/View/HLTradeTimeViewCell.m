//
//  HLTradeTimeViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/11.
//

#import "HLTradeTimeViewCell.h"

@interface HLTradeTimeViewCell ()

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UIView * bottomLine;

@property(nonatomic,strong)UILabel * weekLb;

@property(nonatomic,strong)UILabel * hourLb;

@end

@implementation HLTradeTimeViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _titleLb.text = @"营业时间";
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.centerY.equalTo(self.contentView);
    }];
    
    _weekLb = [[UILabel alloc]init];
    _weekLb.textColor =UIColorFromRGB(0x666666);
    _weekLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self.contentView addSubview:_weekLb];
    [_weekLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(9));
        make.right.equalTo(FitPTScreen(-13));
    }];
    
    _hourLb = [[UILabel alloc]init];
    _hourLb.textColor =UIColorFromRGB(0x666666);
    _hourLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.contentView addSubview:_hourLb];
    [_hourLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekLb.bottom).offset(FitPTScreen(3));
        make.right.equalTo(FitPTScreen(-13));
    }];
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.contentView addSubview:_bottomLine];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-1));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(FitPTScreenH(1));
    }];
}


-(void)setInputModel:(HLBaseInputModel *)inputModel{
    _inputModel = inputModel;
    HLTraidTimeInput * model = (HLTraidTimeInput *)inputModel;
    _weekLb.text = model.weekStr;
    _hourLb.text = model.hourStr;
    _bottomLine.hidden = model.hideLine;
}

@end


@implementation HLTraidTimeInput


@end
