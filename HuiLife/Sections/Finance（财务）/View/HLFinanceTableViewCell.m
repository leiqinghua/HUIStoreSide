//
//  HLFinanceTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLFinanceTableViewCell.h"

@interface HLFinanceTableViewCell()

@property (strong,nonatomic)UILabel *left;

@property (strong,nonatomic)UILabel *sub;

@property (strong,nonatomic)UILabel *money;

@property (strong,nonatomic)UILabel *statu;

@end

@implementation HLFinanceTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _left = [[UILabel alloc]init];
    _left.textColor = [UIColor hl_StringToColor:@"#656565"];
    _left.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.contentView addSubview:_left];
    [_left makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _sub = [[UILabel alloc]init];
    _sub.textColor = [UIColor hl_StringToColor:@"#989898"];
    _sub.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.contentView addSubview:_sub];
    [_sub makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(self.left.bottom).offset(FitPTScreen(11));
    }];
    
    _money = [[UILabel alloc]init];
    _money.textColor = [UIColor hl_StringToColor:@"#282828"];
    _money.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.contentView addSubview:_money];
    [_money makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.left);
        make.right.equalTo(FitPTScreen(-13));
    }];
    
    _statu = [[UILabel alloc]init];
    _statu.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.contentView addSubview:_statu];
    [_statu makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sub);
        make.right.equalTo(FitPTScreen(-13));
    }];
    
}

-(void)setModel:(HLFinanceModel *)model{
    _model = model;
    _left.text = model.month;
    _money.text = model.money;
    _sub.text = model.compomentStr;
    _statu.text = model.name;
    _statu.textColor = model.isEntried?[UIColor hl_StringToColor:@"#989898"]:[UIColor hl_StringToColor:@"#FF8D26"];
}

-(void)setEntriedModel:(HLEntriedModel *)entriedModel{
    _entriedModel = entriedModel;
    _left.text = entriedModel.status;
    _sub.text = entriedModel.input_time;
    _money.text = entriedModel.moneyText;
    
    UIColor * failColor = [UIColor hl_StringToColor:@"#BBBBBB"];
    if (!entriedModel.isSuccess) {
        _left.textColor = failColor;
        _sub.textColor = failColor;
        _money.textColor = failColor;
    }else{
        _left.textColor = [UIColor hl_StringToColor:@"#656565"];
         _money.textColor = [UIColor hl_StringToColor:@"#282828"];
    }
}
@end
