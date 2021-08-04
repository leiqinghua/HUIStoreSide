//
//  HLMessageTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import "HLMessageTableViewCell.h"

@interface HLMessageTableViewCell()

@property(strong,nonatomic)UIView * bagView;

@property(strong,nonatomic)UILabel * timeLable;

@property(strong,nonatomic)UILabel * storeNameLable;

@property(strong,nonatomic)UILabel * msgLable;

@property(strong,nonatomic)UIImageView * goView;
@end

@implementation HLMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = [UIColor whiteColor];
    _bagView.layer.cornerRadius = 7;
//    _bagView.layer.borderWidth = 0.8;
//    _bagView.layer.borderColor = UIColorFromRGB(0xE1E1E1).CGColor;
    _bagView.layer.shadowColor = UIColorFromRGB(0xD5D5D5).CGColor;;
    _bagView.layer.shadowRadius = FitPTScreen(27);
    _bagView.layer.shadowOpacity = 0.25;
    _bagView.layer.masksToBounds = false;
    _bagView.clipsToBounds = false;
    _bagView.layer.shadowOffset = CGSizeMake(0, 1);
    [self.contentView addSubview:_bagView];
    
    //名称过长要截取
    _storeNameLable = [[UILabel alloc]init];
    _storeNameLable.textColor = UIColorFromRGB(0x222222);
    _storeNameLable.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _storeNameLable.text = @"满记甜品北京区总店店";
    _storeNameLable.lineBreakMode = NSLineBreakByTruncatingTail;
    [_bagView addSubview:_storeNameLable];
    
    _timeLable = [[UILabel alloc]init];
    _timeLable.textColor = UIColorFromRGB(0x999999);
    _timeLable.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _timeLable.text = @"2018-09-04  11:30";
    [_bagView addSubview:_timeLable];
    
    _msgLable = [[UILabel alloc]init];
    _msgLable.textColor = UIColorFromRGB(0x555555);
    _msgLable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _msgLable.text = @"通过秒杀订单，成功收款 ￥215.6";
    _msgLable.numberOfLines = 0;
    [_bagView addSubview:_msgLable];
    
    _goView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [_bagView addSubview:_goView];
    
    [self layout];
    
}

-(void)layout{
    [_bagView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(FitPTScreen(20));
//        make.top.equalTo(FitPTScreen(8));
//        make.bottom.equalTo(self.contentView).offset(-8);
//        make.width.equalTo(FitPTScreen(335));
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(8), FitPTScreen(13), FitPTScreen(8), FitPTScreen(13)));
    }];
    
    [_storeNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bagView).offset(FitPTScreen(20));
        make.top.equalTo(self.bagView).offset(FitPTScreen(25));
        make.width.equalTo(FitPTScreen(250));
    }];
    
    [_timeLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeNameLable);
        make.top.equalTo(self.storeNameLable.mas_bottom).offset(FitPTScreen(15));
    }];
    
    [_msgLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeNameLable);
        make.top.equalTo(self.timeLable.mas_bottom).offset(FitPTScreen(30));
        make.bottom.equalTo(self.bagView).offset(FitPTScreen(-35));
        make.width.equalTo(FitPTScreen(250));
    }];
    
    [_goView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.right.equalTo(self.bagView).offset(FitPTScreen(-16));
    }];
}

-(void)setListModel:(HLMessageListModel *)listModel{
    _listModel = listModel;
    _storeNameLable.text = listModel.store_name;
    _timeLable.text = listModel.input_time;
    NSString *type = listModel.sodm == 1 ? @"收款" : @"退款";
    _msgLable.text = [NSString stringWithFormat:@"通过【%@】，成功%@ ￥%.2lf元",listModel.source,type,listModel.money];
}

@end
