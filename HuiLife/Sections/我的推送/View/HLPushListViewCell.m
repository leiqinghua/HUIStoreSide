//
//  HLPushListViewCell.m
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLPushListViewCell.h"

@interface HLPushListViewCell ()

@property (nonatomic, strong) UIView *grayBgView;
@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIButton *stateBtn;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIImageView *goodImgV;
@property (nonatomic, strong) UILabel *goodNameLab;
@property (nonatomic, strong) UILabel *salePriceLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *pushNumLab;
@property (nonatomic, strong) UILabel *openNumLab;
@property (nonatomic, strong) UILabel *payNumLab;

@end

@implementation HLPushListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.grayBgView = [[UIView alloc] init];
    [self.contentView addSubview:self.grayBgView];
    self.grayBgView.backgroundColor = UIColorFromRGB(0xEDEDED);
    self.grayBgView.layer.cornerRadius = FitPTScreen(10);
    [self.grayBgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(12), FitPTScreen(0), FitPTScreen(12)));
    }];
    
    self.whiteBgView = [[UIView alloc] init];
    [self.grayBgView addSubview:self.whiteBgView];
    self.whiteBgView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.whiteBgView.layer.cornerRadius = FitPTScreen(10);
    [self.whiteBgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(FitPTScreen(0), FitPTScreen(0), FitPTScreen(51), FitPTScreen(0)));
    }];
    
    UIImageView *dataTipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_list_time"]];
    [self.whiteBgView addSubview:dataTipImgV];
    [dataTipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(FitPTScreen(11));
        make.left.equalTo(FitPTScreen(12.5));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    self.stateBtn = [[UIButton alloc] init];
    [self.whiteBgView addSubview:self.stateBtn];
    self.stateBtn.layer.cornerRadius = FitPTScreen(3);
    self.stateBtn.layer.borderWidth = FitPTScreen(0.5);
    self.stateBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.stateBtn.layer.masksToBounds = YES;
    [self.stateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dataTipImgV);
        make.right.equalTo(FitPTScreen(-12));
        make.width.equalTo(FitPTScreen(59));
        make.height.equalTo(FitPTScreen(17.5));
    }];
    [self.stateBtn addTarget:self action:@selector(stateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.dateLab = [[UILabel alloc] init];
    [self.whiteBgView addSubview:self.dateLab];
    self.dateLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.dateLab.textColor = UIColorFromRGB(0x999999);
    [self.dateLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dataTipImgV.right).offset(FitPTScreen(7));
        make.centerY.equalTo(dataTipImgV);
    }];
    
    UIView *goodView = [[UIView alloc] init];
    [self.whiteBgView addSubview:goodView];
    goodView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    goodView.layer.cornerRadius = FitPTScreen(6);
    goodView.layer.masksToBounds = YES;
    [goodView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(FitPTScreen(331));
        make.height.equalTo(FitPTScreen(82));
        make.top.equalTo(dataTipImgV.bottom).offset(FitPTScreen(14));
        make.centerX.equalTo(self.whiteBgView);
    }];
    
    self.goodImgV = [[UIImageView alloc] init];
    [goodView addSubview:self.goodImgV];
    self.goodImgV.layer.cornerRadius = FitPTScreen(6);
    self.goodImgV.layer.masksToBounds = YES;
    [self.goodImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodView);
        make.width.height.equalTo(FitPTScreen(60));
        make.left.equalTo(FitPTScreen(11.5));
    }];
    
    self.goodNameLab = [[UILabel alloc] init];
    [goodView addSubview:self.goodNameLab];
    self.goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.goodNameLab.textColor = UIColorFromRGB(0x555555);
    self.goodNameLab.numberOfLines = 2;
    [self.goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImgV.right).offset(FitPTScreen(7));
        make.top.equalTo(self.goodImgV);
    }];
    
    self.priceLab = [[UILabel alloc] init];
    [goodView addSubview:self.priceLab];
    self.priceLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.priceLab.textColor = UIColorFromRGB(0x333333);
    [self.priceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodNameLab);
        make.bottom.equalTo(self.goodImgV);
    }];
    
    self.salePriceLab = [[UILabel alloc] init];
    [goodView addSubview:self.salePriceLab];
    self.salePriceLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.salePriceLab.textColor = UIColorFromRGB(0x999999);
    [self.salePriceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLab.right).offset(FitPTScreen(12));
        make.centerY.equalTo(self.priceLab);
    }];
    
    UIView *salePriceLine = [[UIView alloc] init];
    [self.salePriceLab addSubview:salePriceLine];
    salePriceLine.backgroundColor = UIColorFromRGB(0x999999);
    [salePriceLine makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(FitPTScreen(1));
        make.left.right.centerY.equalTo(self.salePriceLab);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    [self.whiteBgView addSubview:self.titleLab];
    self.titleLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    self.titleLab.textColor = UIColorFromRGB(0x000000);
    self.titleLab.numberOfLines = 2;
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(goodView);
        make.top.equalTo(goodView.bottom).offset(FitPTScreen(13.5));
    }];
    
    self.descLab = [[UILabel alloc] init];
    [self.whiteBgView addSubview:self.descLab];
    self.descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.descLab.textColor = UIColorFromRGB(0x999999);
    self.descLab.numberOfLines = 3;
    [self.descLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(goodView);
        make.top.equalTo(self.titleLab.bottom).offset(FitPTScreen(7.5));
        make.bottom.equalTo(FitPTScreen(-14));
    }];
    
    UIImageView *pushTipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_list_tip"]];
    [self.grayBgView addSubview:pushTipImgV];
    [pushTipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.whiteBgView.bottom).offset(FitPTScreen(11));
        make.width.height.equalTo(FitPTScreen(13));
    }];
    
    UILabel *pushTipLab = [[UILabel alloc] init];
    [self.grayBgView addSubview:pushTipLab];
    pushTipLab.text = @"成功推送给";
    pushTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    pushTipLab.textColor = UIColorFromRGB(0x999999);
    [pushTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pushTipImgV.right).offset(FitPTScreen(5));
        make.centerY.equalTo(pushTipImgV);
    }];
    
    self.pushNumLab = [[UILabel alloc] init];
    [self.grayBgView addSubview:self.pushNumLab];
    self.pushNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.pushNumLab.textColor = UIColorFromRGB(0x222222);
    [self.pushNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pushTipLab);
        make.top.equalTo(pushTipLab.bottom).offset(FitPTScreen(4));
    }];
    
    UIImageView *openTipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_list_open"]];
    [self.grayBgView addSubview:openTipImgV];
    [openTipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pushTipLab.right).offset(FitPTScreen(36));
        make.centerY.equalTo(pushTipImgV);
        make.width.height.equalTo(FitPTScreen(13));
    }];
    
    
    UILabel *openTipLab = [[UILabel alloc] init];
    [self.grayBgView addSubview:openTipLab];
    openTipLab.text = @"累计打开推送";
    openTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    openTipLab.textColor = UIColorFromRGB(0x999999);
    [openTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openTipImgV.right).offset(FitPTScreen(5));
        make.centerY.equalTo(openTipImgV);
    }];
    
    self.openNumLab = [[UILabel alloc] init];
    [self.grayBgView addSubview:self.openNumLab];
    self.openNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.openNumLab.textColor = UIColorFromRGB(0x222222);
    [self.openNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openTipLab);
        make.top.equalTo(openTipLab.bottom).offset(FitPTScreen(4));
    }];
    
    
    
    UIImageView *payTipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_list_pay"]];
    [self.grayBgView addSubview:payTipImgV];
    [payTipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openTipLab.right).offset(FitPTScreen(38));
        make.centerY.equalTo(openTipImgV);
        make.width.height.equalTo(FitPTScreen(13));
    }];
    
    UILabel *payTipLab = [[UILabel alloc] init];
    [self.grayBgView addSubview:payTipLab];
    payTipLab.text = @"转化下单";
    payTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    payTipLab.textColor = UIColorFromRGB(0x999999);
    [payTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payTipImgV.right).offset(FitPTScreen(5));
        make.centerY.equalTo(payTipImgV);
    }];
    
    self.payNumLab = [[UILabel alloc] init];
    [self.grayBgView addSubview:self.payNumLab];
    self.payNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.payNumLab.textColor = UIColorFromRGB(0x222222);
    [self.payNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payTipLab);
        make.top.equalTo(payTipLab.bottom).offset(FitPTScreen(4));
    }];
}

- (void)stateBtnClick{
    if (self.delegate) {
        [self.delegate listViewCell:self stateBtnClick:self.listModel];
    }
}

- (void)setListModel:(HLPushListModel *)listModel{
    _listModel = listModel;
    self.dateLab.text = listModel.date;
    [self.goodImgV sd_setImageWithURL:[NSURL URLWithString:listModel.image] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    self.goodNameLab.text = listModel.name;
    self.titleLab.text = listModel.title;
    self.descLab.text = listModel.describe;
    self.pushNumLab.text = [NSString stringWithFormat:@"%ld位",listModel.total];
    self.openNumLab.text = [NSString stringWithFormat:@"%ld位",listModel.open];
    self.payNumLab.text = [NSString stringWithFormat:@"%ld位",listModel.buy];
    if (listModel.price == 0) {
        self.priceLab.text = [NSString stringWithFormat:@"售价: ¥%.2lf",listModel.sale];
        self.salePriceLab.hidden = YES;
        self.salePriceLab.text = @"";
    }else{
        self.priceLab.text = [NSString stringWithFormat:@"售价: ¥%.2lf",listModel.price];
        self.salePriceLab.hidden = NO;
        self.salePriceLab.text = [NSString stringWithFormat:@"原价: ¥%.2lf",listModel.sale];
    }
    
    
    if(listModel.state == 15){
        // 审核失败
        [self.stateBtn setTitle:@"审核失败" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:UIColorFromRGB(0xEF1D1D) forState:UIControlStateNormal];
        self.stateBtn.layer.borderColor = UIColorFromRGB(0xEF1D1D).CGColor;
    }else if(listModel.state == 10){
        // 审核中
        [self.stateBtn setTitle:@"审核中" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:UIColorFromRGB(0x23A820) forState:UIControlStateNormal];
        self.stateBtn.layer.borderColor = UIColorFromRGB(0x23A820).CGColor;
    }else{
        [self.stateBtn setTitle:@"活动推送" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:UIColorFromRGB(0x23A820) forState:UIControlStateNormal];
        self.stateBtn.layer.borderColor = UIColorFromRGB(0x23A820).CGColor;
    }
}

@end
