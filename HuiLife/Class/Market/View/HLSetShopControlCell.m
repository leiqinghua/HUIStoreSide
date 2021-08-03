//
//  HLSetShopControlCell.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLSetShopControlCell.h"

@interface HLSetShopControlCell ()

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIImageView *locateImgV;

@end

@implementation HLSetShopControlCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    CGFloat buttonW = FitPTScreen(28);
    
    self.delBtn = [[UIButton alloc] init];
    self.delBtn.layer.cornerRadius = buttonW/2;
    self.delBtn.layer.masksToBounds = YES;
    [self.delBtn setBackgroundImage:[UIImage imageNamed:@"store_manager_del"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.delBtn];
    [self.delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(buttonW);
        make.right.equalTo(FitPTScreen(-15));
    }];
    [self.delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.editBtn = [[UIButton alloc] init];
    self.editBtn.layer.cornerRadius = buttonW/2;
    self.editBtn.layer.masksToBounds = YES;
    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"store_manager_edit"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.editBtn];
    [self.editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(buttonW);
        make.right.equalTo(self.delBtn.left).offset(FitPTScreen(-10));
    }];
    [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLab];
    self.nameLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    self.nameLab.textColor = UIColorFromRGB(0x333333);
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(18));
        make.left.equalTo(FitPTScreen(15));
        make.right.lessThanOrEqualTo(self.editBtn.left).offset(FitPTScreen(-5));
    }];
    
    self.locateImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_manager_location"]];
    [self.contentView addSubview:self.locateImgV];
    [self.locateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(FitPTScreen(-18));
        make.left.equalTo(self.nameLab);
        make.width.equalTo(FitPTScreen(9.5));
        make.height.equalTo(FitPTScreen(11.5));
    }];
    
    self.addressLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.addressLab];
    self.addressLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.addressLab.textColor = UIColorFromRGB(0x888888);
    [self.addressLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locateImgV);
        make.left.equalTo(self.locateImgV.right).offset(FitPTScreen(5));
        make.right.lessThanOrEqualTo(self.editBtn.left).offset(FitPTScreen(-5));
    }];
    
    self.tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipLab];
    self.tipLab.text = @"请设置门店信息";
    self.tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    self.tipLab.textColor = UIColorFromRGB(0xE02020);
    [self.tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.locateImgV);
    }];
}

- (void)delBtnClick{
    if (self.delegate) {
        [self.delegate controlCell:self delWithStoreModel:self.storeModel];
    }
}

- (void)editBtnClick{
    if (self.delegate) {
        [self.delegate controlCell:self editWithStoreModel:self.storeModel];
    }
}

- (void)setStoreModel:(HLSetStoreModel *)storeModel{
    _storeModel = storeModel;
    self.nameLab.text = storeModel.storeName;
    self.addressLab.text = storeModel.storeAddress;
    self.nameLab.hidden = storeModel.storeName.length == 0;
    self.locateImgV.hidden = storeModel.storeName.length == 0;
    self.addressLab.hidden = storeModel.storeName.length == 0;
    self.tipLab.hidden = storeModel.storeName.length > 0;
}

@end
