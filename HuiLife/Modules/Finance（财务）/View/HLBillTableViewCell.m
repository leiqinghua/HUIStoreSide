//
//  HLBillTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import "HLBillTableViewCell.h"
@interface HLBillTableViewCell()

@property(strong,nonatomic)UIImageView *pic;

@property(strong,nonatomic)UILabel *title;

@property(strong,nonatomic)UILabel *name;

@property(strong,nonatomic)UILabel *orderId;

@property(strong,nonatomic)UILabel *money;

@property(strong,nonatomic)UILabel *time;

@property (nonatomic, strong) UILabel *descLab;

@property(strong,nonatomic)UIView* bagView;

@property(strong,nonatomic)UIView *line;

@end

@implementation HLBillTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, FitPTScreen(13), 0, FitPTScreen(13)));
    }];
    
    _pic = [[UIImageView alloc]init];
    _pic.layer.cornerRadius = FitPTScreen(37)/2;
    [_bagView addSubview:_pic];
    [_pic makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(6));
        make.top.equalTo(FitPTScreen(19));
        make.width.height.equalTo(FitPTScreen(37));
    }];
    
    _name = [[UILabel alloc]init];
    _name.text= @"秒杀团购";
    _name.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _name.textColor = UIColorFromRGB(0x333333);
    [_bagView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pic.right).offset(FitPTScreen(6));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _money = [[UILabel alloc]init];
    _money.textColor = UIColorFromRGB(0x333333);
    _money.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _money.text =@"+38.32";
    [_bagView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.name);
    }];
    
    _orderId = [[UILabel alloc]init];
    _orderId.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _orderId.textColor = UIColorFromRGB(0x888888);
    [_bagView addSubview:_orderId];
    [_orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.bottom).offset(FitPTScreen(11));
    }];
    
    _time = [[UILabel alloc]init];
    _time.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _time.textColor = UIColorFromRGB(0x999999);
    _time.text = @"20:45";
    [_bagView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.right).offset(FitPTScreen(8));
        make.bottom.equalTo(self.name);
    }];
    
    _descLab = [[UILabel alloc]init];
    _descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _descLab.textColor = UIColorFromRGB(0x777777);
    _descLab.text = @"20:45";
    [_bagView addSubview:_descLab];
    [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_money.right);
        make.centerY.equalTo(self.orderId);
    }];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = UIColorFromRGB(0xD9D9D9);
    [_bagView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.bottom.equalTo(self.bagView);
        make.height.equalTo(0.8);
    }];
}



-(void)setBillModel:(HLBillModel *)billModel{
    _billModel = billModel;
    [_pic sd_setImageWithURL:[NSURL URLWithString:billModel.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _name.text = billModel.leixing;
    _time.text = billModel.cj_time;
    _orderId.text = [NSString stringWithFormat:@"%@",billModel.Id];
    _money.attributedText = billModel.priceAttr;
    _line.hidden = billModel.hideLine;
    _descLab.text = billModel.desc;
    
    if (!billModel.topCorner && !billModel.bottomCorner) {
        return;
    }
    
    if (billModel.topCorner && billModel.bottomCorner) {
        _bagView.layer.cornerRadius = FitPTScreen(8);
        return;
    }
    
    
}
@end
