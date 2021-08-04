//
//  HLStoreSelectViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/13.
//

#import "HLStoreSelectViewCell.h"


@interface HLStoreSelectViewCell ()

@property(nonatomic,strong)UILabel * nameLb;

@property(nonatomic,strong)UILabel * descLb;

@property(nonatomic,strong)UIView * descBgV;

@property(nonatomic,strong)UILabel * phoneLb;

@property(nonatomic,strong)UILabel * addressLb;

@property(nonatomic,strong)UIImageView * showView;

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UIImageView * phoneImgV;

@property(nonatomic,strong)UIImageView * addressImgV;

@property(nonatomic,strong)UIButton * selectBtn;

@end

@implementation HLStoreSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.42].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,1);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(26);
    _bagView.layer.cornerRadius = FitPTScreen(5.5);
    _bagView.layer.masksToBounds = false;
    
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(6), FitPTScreen(10), FitPTScreen(6), FitPTScreen(10)));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor =UIColorFromRGB(0x222222);
    _nameLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    [self.bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.top.equalTo(FitPTScreen(25));
    }];
    
    _descBgV = [[UIView alloc]init];
    _descBgV.layer.cornerRadius = FitPTScreen(2);
    _descBgV.layer.borderColor = UIColorFromRGB(0xFF8604).CGColor;
    _descBgV.layer.borderWidth = FitPTScreen(1);
    [_bagView addSubview:_descBgV];
    [_descBgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.nameLb);
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor =UIColorFromRGB(0xFF8604);
    _descLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(10)];
    [_descBgV addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.descBgV).insets(UIEdgeInsetsMake(FitPTScreen(4), FitPTScreen(7), FitPTScreen(4), FitPTScreen(7)));
    }];
    
    _phoneImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_green_hollow"]];
    [_bagView addSubview:_phoneImgV];
    [_phoneImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(43));
    }];
    
    _phoneLb = [[UILabel alloc]init];
    _phoneLb.textColor =UIColorFromRGB(0x666666);
    _phoneLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(13)];
    [_bagView addSubview:_phoneLb];
    [_phoneLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImgV.right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.phoneImgV);
    }];
    
    _addressImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address"]];
    [_bagView addSubview:_addressImgV];
    [_addressImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImgV);
        make.top.equalTo(self.phoneImgV.bottom).offset(FitPTScreen(30));
    }];
    
    _addressLb = [[UILabel alloc]init];
    _addressLb.numberOfLines = 0;
    _addressLb.textColor =UIColorFromRGB(0x666666);
    _addressLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(13)];
    [_bagView addSubview:_addressLb];
    [_addressLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImgV.right).offset(FitPTScreen(2));
        make.top.equalTo(self.phoneLb.bottom).offset(FitPTScreen(29));
        make.width.lessThanOrEqualTo(FitPTScreen(300));
        make.bottom.equalTo(FitPTScreen(-26));
    }];
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"single_ring_normal"] forState:UIControlStateSelected];
    [self.bagView addSubview:_selectBtn];
    [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-16));
        make.centerY.equalTo(self.bagView);
    }];
    
    _showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"store_hide"]];
    [self.bagView addSubview:_showView];
    [_showView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.top.equalTo(FitPTScreen(25));
    }];
}


-(void)setModel:(HLStoreModel *)model{
    
    _model = model;
    _nameLb.text = model.nameText;
    _descLb.text = model.classnameText;
    _phoneLb.text = [NSString stringWithFormat:@"门店电话：%@",model.tel];
    _addressLb.text = [NSString stringWithFormat:@"门店地址：%@",model.address];
    BOOL show = [model.is_show integerValue]==0;
    _showView.hidden = !show;
    if (show) {
        [_nameLb updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.showView.right).offset(FitPTScreen(10));
        }];
    }else{
        [_nameLb updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bagView).offset(FitPTScreen(16));
        }];
    }
    
    if (model.address.length) {
        [_addressLb updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.phoneLb.bottom).offset(FitPTScreen(29));
        }];
    }else{
        [_addressLb updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneLb.bottom);
        }];
    }
    
    _addressImgV.hidden = !model.address.length;
    _addressLb.hidden = !model.address.length;
}

-(void)setSelect:(BOOL)select{
    _select = select;
    _selectBtn.selected = select;
}
@end
