//
//  HLVideoMarketListCell.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketListCell.h"

@interface HLVideoMarketListCell ()

@property (nonatomic, strong) UIImageView *videoImgV;
@property (nonatomic, strong) UIView *stateV;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *reasonBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *controlBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) UILabel *goodNameLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *lookImgV;
@property (nonatomic, strong) UILabel *lookLab;
@property (nonatomic, strong) UIImageView *payImgV;
@property (nonatomic, strong) UILabel *payLab;

@end

@implementation HLVideoMarketListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _videoImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_videoImgV];
    _videoImgV.contentMode = UIViewContentModeScaleAspectFill;
    _videoImgV.clipsToBounds = YES;
    _videoImgV.userInteractionEnabled = YES;
    [_videoImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(12));
        make.width.equalTo(FitPTScreen(116));
        make.height.equalTo(FitPTScreen(154));
    }];
    
    UIImageView *playImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_play"]];
    [self.videoImgV addSubview:playImgV];
    [playImgV makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImgV);
        make.width.height.equalTo(FitPTScreen(30));
    }];
    [playImgV hl_addTarget:self action:@selector(playBtnClick)];
    
    self.editBtn = [[UIButton alloc] init];
    self.editBtn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.videoImgV addSubview:self.editBtn];
    [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.videoImgV);
        make.height.equalTo(FitPTScreen(25.5));
        make.width.equalTo(FitPTScreen(57));
    }];
    
    self.controlBtn = [[UIButton alloc] init];
    self.controlBtn.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    self.controlBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.controlBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.controlBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.videoImgV addSubview:self.controlBtn];
    [self.controlBtn addTarget:self action:@selector(controlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.videoImgV);
        make.height.equalTo(FitPTScreen(25.5));
        make.width.equalTo(FitPTScreen(57));
    }];
    
    _stateV = [[UIView alloc] init];
    [self.videoImgV addSubview:self.stateV];
    self.stateV.backgroundColor = UIColorFromRGB(0xFF9900);
    self.stateV.layer.cornerRadius = FitPTScreen(1);
    self.stateV.layer.masksToBounds = YES;
    [self.stateV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(FitPTScreen(5));
    }];

    _stateLab = [[UILabel alloc] init];
    [self.stateV addSubview:_stateLab];
    _stateLab.textColor = UIColorFromRGB(0xFFFFFF);
    _stateLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(FitPTScreen(2), FitPTScreen(4), FitPTScreen(2), FitPTScreen(4)));
    }];
    
    self.reasonBtn = [[UIButton alloc] init];
    [self.reasonBtn setBackgroundImage:[UIImage imageNamed:@"video_wenhao"] forState:UIControlStateNormal];
    [self.videoImgV addSubview:self.reasonBtn];
    [self.reasonBtn addTarget:self action:@selector(reasonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.reasonBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateV.right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.stateV);
        make.width.height.equalTo(FitPTScreen(16));
    }];
    
    self.titleLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    self.titleLab.textColor = UIColorFromRGB(0x333333);
    self.titleLab.numberOfLines = 2;
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoImgV.right).offset(FitPTScreen(11));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(self.videoImgV.top).offset(FitPTScreen(2));
    }];
    
    self.goodsView = [[UIView alloc] init];
    [self.contentView addSubview:self.goodsView];
    self.goodsView.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.goodsView.layer.cornerRadius = FitPTScreen(12.5);
    self.goodsView.layer.masksToBounds = YES;
    [self.goodsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.bottom).offset(FitPTScreen(12));
        make.height.equalTo(FitPTScreen(25));
        make.right.lessThanOrEqualTo(self.titleLab.right).priorityHigh();
    }];
    
    UIImageView *goodsImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_good_tip"]];
    [self.goodsView addSubview:goodsImgV];
    [goodsImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsView);
        make.left.equalTo(FitPTScreen(10.5));
        make.width.equalTo(FitPTScreen(13));
        make.height.equalTo(FitPTScreen(14));
    }];
    
    self.goodNameLab = [[UILabel alloc] init];
    [self.goodsView addSubview:self.goodNameLab];
    self.goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.goodNameLab.textColor = UIColorFromRGB(0x666666);
    [self.goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImgV.right).offset(FitPTScreen(4.5));
        make.right.equalTo(FitPTScreen(-11.5));
        make.centerY.equalTo(self.goodsView);
    }];
    
    self.descLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.descLab];
    self.descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.descLab.textColor = UIColorFromRGB(0x999999);
    self.descLab.numberOfLines = 2;
    [self.descLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.right.equalTo(self.titleLab);
        make.top.equalTo(self.goodsView.bottom).offset(FitPTScreen(14));
    }];
    
    self.lookImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_look_tip"]];
    [self.contentView addSubview:self.lookImgV];
    [self.lookImgV makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoImgV.bottom).offset(FitPTScreen(-2));
        make.left.equalTo(self.titleLab);
        make.width.equalTo(FitPTScreen(14));
        make.height.equalTo(FitPTScreen(9.5));
    }];
    
    self.lookLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.lookLab];
    self.lookLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.lookLab.textColor = UIColorFromRGB(0x333333);
    [self.lookLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookImgV.right).offset(FitPTScreen(3));
        make.centerY.equalTo(self.lookImgV);
    }];
    
    self.payImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_pay_tip"]];
    [self.contentView addSubview:self.payImgV];
    [self.payImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lookImgV);
        make.left.equalTo(self.lookLab.right).offset(FitPTScreen(16));
        make.width.equalTo(FitPTScreen(11));
        make.height.equalTo(FitPTScreen(10.5));
    }];
    
    self.payLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.payLab];
    self.payLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.payLab.textColor = UIColorFromRGB(0x333333);
    [self.payLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payImgV.right).offset(FitPTScreen(3));
        make.centerY.equalTo(self.lookLab);
    }];
}

- (void)reasonBtnClick{
    if (self.delegate) {
        [self.delegate marketListCell:self reasonClickWithModel:self.listModel];
    }
}

- (void)editBtnClick{
    if (self.delegate) {
        [self.delegate marketListCell:self editClickWithModel:self.listModel];
    }
}

- (void)controlBtnClick{
    if (self.delegate) {
        [self.delegate marketListCell:self controlClickWithModel:self.listModel];
    }
}

- (void)playBtnClick{
    if (self.delegate) {
        [self.delegate marketListCell:self playClickWithModel:self.listModel];
    }
}

- (void)setListModel:(HLVideoMarketModel *)listModel{
    _listModel = listModel;
    [_videoImgV sd_setImageWithURL:[NSURL URLWithString:listModel.pic]];
    _stateLab.text = listModel.stateStr;
    self.titleLab.text = listModel.title;
    self.goodNameLab.text = listModel.name;
    self.descLab.text = listModel.content;
    self.lookLab.text = [NSString stringWithFormat:@"%ld浏览",listModel.looks];
    self.payLab.text = [NSString stringWithFormat:@"%ld下单",listModel.pays];
    // 被驳回显示问号按钮
    self.reasonBtn.hidden = listModel.state != 15;
    // 审核中&被驳回不显示上下架
    self.controlBtn.hidden = listModel.state == 10 || listModel.state == 15;
    // 审核中不显示编辑
    self.editBtn.hidden = listModel.state == 10;
    
//    0下架 1上架
    NSString *controlTitle = @"";
    if (listModel.state == 0) {
        controlTitle = @"上架";
    }else if(listModel.state == 1){
        controlTitle = @"下架";
    }
    [self.controlBtn setTitle:controlTitle forState:UIControlStateNormal];
}

@end
