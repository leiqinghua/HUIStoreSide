//
//  HLTicketTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import "HLTicketTableViewCell.h"


@interface HLTicketTableViewCell ()

@property(strong,nonatomic)UILabel * priceLb;

@property(strong,nonatomic)UILabel * usepriceLb;
//售价
@property(strong,nonatomic)UILabel * seilpriceLb;

@property(strong,nonatomic)UILabel * giftLb;
//推广
@property(strong,nonatomic)UILabel * tgLb;

@property(strong,nonatomic)UIView * tgBgView;

@property(strong,nonatomic)UILabel * useNumLb;
//领取
@property(strong,nonatomic)UILabel * acceptNumLb;
//浏览
@property(strong,nonatomic)UILabel * reviewLb;

@property(strong,nonatomic)UIButton * shareBtn;

@property(strong,nonatomic)UIImageView * statuImv;

@property(strong,nonatomic)UILabel * statuLb;



@end

@implementation HLTicketTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIImageView * bgImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ticket_bg"]];
    [self.contentView addSubview:bgImV];
    [bgImV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.clearColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:0.17].CGColor;;
    _bagView.layer.shadowOffset = CGSizeMake(0,0);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(14);
    _bagView.layer.cornerRadius = FitPTScreen(5.5);
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(10), FitPTScreen(5), FitPTScreen(10)));
    }];
    
    
    UIView * priceBgView = [[UIView alloc]init];
    [_bagView addSubview:priceBgView];
    [priceBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.bagView);
        make.width.equalTo(FitPTScreen(87));
    }];
    
    _priceLb = [[UILabel alloc]init];
    _priceLb.textColor =UIColorFromRGB(0xA2631A);
    _priceLb.font = [UIFont systemFontOfSize:FitPTScreen(26)];
    _priceLb.adjustsFontSizeToFitWidth = YES;
    _priceLb.minimumScaleFactor = 0.1;
    [priceBgView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(priceBgView);
        make.top.equalTo(FitPTScreen(18));
        make.width.lessThanOrEqualTo(FitPTScreen(83));
    }];
    
    _usepriceLb = [[UILabel alloc]init];
    _usepriceLb.textColor =UIColorFromRGB(0x924F00);
    _usepriceLb.adjustsFontSizeToFitWidth = YES;
    _usepriceLb.minimumScaleFactor = 0.1;
    _usepriceLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [priceBgView addSubview:_usepriceLb];
    [_usepriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.priceLb);
        make.top.equalTo(self.priceLb.bottom).offset(FitPTScreen(7));
        make.width.lessThanOrEqualTo(FitPTScreen(83));
    }];
    
    _seilpriceLb = [[UILabel alloc]init];
    _seilpriceLb.textColor =UIColorFromRGB(0x333333);
    _seilpriceLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _seilpriceLb.text = @"售价：免费领取";
    [self.bagView addSubview:_seilpriceLb];
    [_seilpriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(117));
        make.top.equalTo(FitPTScreen(11));
    }];
    
    _giftLb = [[UILabel alloc]init];
    _giftLb.textColor =UIColorFromRGB(0xFF4040);
    _giftLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _giftLb.text = @"满10元赠送代金券";
    [self.bagView addSubview:_giftLb];
    [_giftLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seilpriceLb);
        make.top.equalTo(self.seilpriceLb.bottom).offset(FitPTScreen(6));
    }];
    
    _tgBgView = [[UIView alloc]init];
    _tgBgView.layer.cornerRadius = 3;
    _tgBgView.layer.masksToBounds = YES;
    _tgBgView.layer.borderColor = UIColorFromRGB(0x90D15C).CGColor;
    _tgBgView.layer.borderWidth = FitPTScreen(1);
    [self.bagView addSubview:_tgBgView];
    [_tgBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seilpriceLb);
        make.top.equalTo(self.giftLb.bottom).offset(FitPTScreen(6));
    }];
    
    _tgLb = [[UILabel alloc]init];
    _tgLb.textColor =UIColorFromRGB(0x90D15C);
    _tgLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _tgLb.text = @"推广效果：一般";
    _tgLb.textAlignment = NSTextAlignmentCenter;
    [self.tgBgView addSubview:_tgLb];

    [_tgLb makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tgBgView).insets(UIEdgeInsetsMake(3, 6, 3, 6));
    }];
    
    _useNumLb = [[UILabel alloc]init];
    _useNumLb.textColor =UIColorFromRGB(0x999999);
    _useNumLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _useNumLb.text = @"使用：20次";
    [self.bagView addSubview:_useNumLb];
    [_useNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seilpriceLb);
        make.top.equalTo(self.tgLb.bottom).offset(FitPTScreen(8));
    }];
    
    _acceptNumLb = [[UILabel alloc]init];
    _acceptNumLb.textColor =UIColorFromRGB(0x999999);
    _acceptNumLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _acceptNumLb.text = @"领取：30次";
    [self.bagView addSubview:_acceptNumLb];
    [_acceptNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useNumLb.right).offset(FitPTScreen(34));
        make.centerY.equalTo(self.useNumLb);
    }];
    
    _reviewLb = [[UILabel alloc]init];
    _reviewLb.textColor =UIColorFromRGB(0x999999);
    _reviewLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _reviewLb.text = @"浏览：20次";
    [self.bagView addSubview:_reviewLb];
    [_reviewLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acceptNumLb.right).offset(FitPTScreen(34));
        make.centerY.equalTo(self.useNumLb);
    }];
    
//
    _shareBtn = [[UIButton alloc]init];
    [_shareBtn setImage:[UIImage imageNamed:@"share_h_yellow_dot"] forState:UIControlStateNormal];
    [self.bagView addSubview:_shareBtn];
    [_shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-5));
        make.top.equalTo(FitPTScreen(5));
        make.width.height.equalTo(FitPTScreen(40));
    }];
    
    [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
//     ticket_statu
    _statuImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ticket_statu"]];
    [self.bagView addSubview:_statuImv];
    [_statuImv makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bagView);
    }];
    
    _statuLb = [[UILabel alloc]init];
    _statuLb.textColor =UIColorFromRGB(0x666666);
    _statuLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _statuLb.text = @"已过期";
    _statuLb.textAlignment = NSTextAlignmentCenter;
    [self.statuImv addSubview:_statuLb];
    [_statuLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.statuImv);
    }];
}


-(void)shareClick{
    if ([self.mainDelegate respondsToSelector:@selector(ticketCell:shareWithModel:)]) {
        [self.mainDelegate ticketCell:self shareWithModel:_model];
    }
}

-(void)setModel:(HLTicketModel *)model{
    _model = model;
    _priceLb.attributedText = model.priceAttr;
    _statuLb.hidden = model.couponStatus == 0;
    _statuImv.image = [UIImage imageNamed:model.couponStatus == 0?@"tag_saling":@"ticket_statu"];
    _statuLb.text = model.statusDesc;
    _tgLb.text = model.marketEffect;
    _tgLb.textColor = model.tgColor;
    _tgBgView.layer.borderColor = model.tgColor.CGColor;
    _usepriceLb.text = model.couponDesc;
    _giftLb.text = _ticketPromote?@"":model.giftDesc;
    _useNumLb.text = model.useDesc;
    _acceptNumLb.text = model.receiveDesc;
    _reviewLb.text = model.browseDesc;
    _seilpriceLb.text = model.salePrice;
    
    if (!model.giftDesc.length) {
        [_useNumLb remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.seilpriceLb);
            make.top.equalTo(self.tgBgView.bottom).offset(FitPTScreen(10));
        }];
    }else{
        [_useNumLb remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.seilpriceLb);
            make.top.equalTo(self.tgBgView.bottom).offset(FitPTScreen(6));
        }];
    }
}


-(void)setTicketPromote:(BOOL)ticketPromote{
    _ticketPromote = ticketPromote;
    _reviewLb.hidden = ticketPromote;
    _statuImv.hidden = ticketPromote;
    if (ticketPromote) {
        _giftLb.text = @"";
    }
    _giftLb.hidden = ticketPromote;
    if (ticketPromote) {
        [_tgBgView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.seilpriceLb.bottom).offset(FitPTScreen(8));
        }];
    }
}

-(void)configureSelectCell{
    self.shareBtn.hidden = YES;
    _reviewLb.hidden = YES;
    _statuImv.hidden = YES;
    _giftLb.hidden = YES;
    
    [_tgBgView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seilpriceLb.bottom).offset(FitPTScreen(8));
    }];
}

@end
