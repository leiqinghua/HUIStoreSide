//
//  HLYGManagerCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/20.
//

#import "HLYGManagerCell.h"

@interface HLYGManagerCell(){
    UIImageView * go_imgView;
}
@property(strong,nonatomic)UILabel * gongHao;

@property(strong,nonatomic)UILabel * name;

@property(strong,nonatomic)UILabel * dianzhang;

@property(strong,nonatomic)UILabel * phoneNum;

@property(strong,nonatomic)UILabel * mendianName;

@property (nonatomic, strong)UIView *separatorLine;
//所属门店/门店地址
@property (nonatomic, strong)UILabel *storeDes;
/**
//用于门店列表
 */
//门店名称
@property(strong,nonatomic)UILabel * storeName;
//类别
@property(strong,nonatomic)UILabel * leavlLable;

@property(strong,nonatomic)UIImageView * showView;

@property(strong,nonatomic)NSDictionary * storeDict;

@end

@implementation HLYGManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = backGroundView;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _gongHao = [[UILabel alloc]init];
    _gongHao.textAlignment = NSTextAlignmentCenter;
    _gongHao.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    _gongHao.text = @"0222";
    _gongHao.textColor = UIColorFromRGB(0x656565);
    _gongHao.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_gongHao];
    
    _name = [[UILabel alloc]init];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.font = [UIFont fontWithName:@"Helvetica-Bold" size:FitPTScreenH(14)];
    _name.text = @"张三";
    _name.textColor = UIColorFromRGB(0x282828);
    [self.contentView addSubview:_name];

    _dianzhang = [[UILabel alloc]init];
    _dianzhang.textAlignment = NSTextAlignmentCenter;
    _dianzhang.font = [UIFont systemFontOfSize:FitPTScreenH(10)];
    _dianzhang.text = @"店长";
    _dianzhang.textColor = UIColorFromRGB(0xFF8D26);
    _dianzhang.layer.borderColor =UIColorFromRGB(0xFF8D26).CGColor;
    _dianzhang.layer.borderWidth = 1;
    _dianzhang.layer.cornerRadius = 2;
    [self.contentView addSubview:_dianzhang];
    _dianzhang.hidden = YES;
    
    _phoneNum = [[UILabel alloc]init];
    _phoneNum.textAlignment = NSTextAlignmentCenter;
    _phoneNum.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    _phoneNum.text = @"联系电话：13100000000";
    _phoneNum.textColor = UIColorFromRGB(0x656565);
    [self.contentView addSubview:_phoneNum];

    _storeDes = [[UILabel alloc]init];
    _storeDes.textAlignment = NSTextAlignmentLeft;
    _storeDes.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    _storeDes.text = @"所属门店：";
    _storeDes.textColor = UIColorFromRGB(0x656565);
    [self.contentView addSubview:_storeDes];
    _storeDes.hidden = ![HLAccount shared].admin;
    
    _mendianName = [[UILabel alloc]init];
    _mendianName.textAlignment = NSTextAlignmentLeft;
    _mendianName.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    _mendianName.text = @"四川火锅店";
    _mendianName.textColor = UIColorFromRGB(0x656565);
    _mendianName.numberOfLines = 0;
    [self.contentView addSubview:_mendianName];
    _mendianName.hidden = ![HLAccount shared].admin;
    
    go_imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self.contentView addSubview:go_imgView];

    _separatorLine = [[UIView alloc]init];
    _separatorLine.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self.contentView addSubview:_separatorLine];

    _selectImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success_grey"]];
    [self.contentView addSubview:_selectImg];
    _selectImg.hidden = YES;

    
    //门店列表
    _storeName = [[UILabel alloc]init];
    _storeName.textAlignment = NSTextAlignmentCenter;
    if (@available(iOS 8.2, *)) {
        _storeName.font = [UIFont systemFontOfSize:FitPTScreenH(14) weight:UIFontWeightBold];
    } else {
        
    }
    _storeName.text = @"四川火锅店";
    _storeName.textColor = UIColorFromRGB(0x282828);
    _storeName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_storeName];
    _storeName.hidden = YES;

    _leavlLable = [[UILabel alloc]init];
    _leavlLable.textAlignment = NSTextAlignmentCenter;
    _leavlLable.font = [UIFont systemFontOfSize:FitPTScreenH(10)];
    _leavlLable.text = @"";
    _leavlLable.textColor = UIColorFromRGB(0xFF8D26);
    _leavlLable.layer.borderColor =UIColorFromRGB(0xFF8D26).CGColor;
    _leavlLable.layer.borderWidth = 1;
    _leavlLable.layer.cornerRadius = 2;
    [self.contentView addSubview:_leavlLable];
     _leavlLable.hidden = YES;
    
    _showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"store_hide"]];
    [self.contentView addSubview:_showView];
    _showView.hidden = YES;
    
    [self layout];
}

- (void)layout{
    [_gongHao mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FitPTScreen(21));
        make.top.equalTo(self.contentView).offset(FitPTScreenH(20));
    }];
    
    [_name mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gongHao.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.gongHao);
    }];
    
    [_dianzhang mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(FitPTScreen(20));
        make.centerY.equalTo(self.gongHao);
        make.width.equalTo(40);
        make.height.equalTo(FitPTScreenH(20));
    }];
    
    [_phoneNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gongHao);
        make.top.equalTo(self.gongHao.mas_bottom).offset(FitPTScreenH(19));
    }];
    
    [_storeDes mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gongHao);
        make.top.equalTo(self.phoneNum.mas_bottom).offset([self->_mendianName.text hl_isAvailable] ?FitPTScreenH(19):0);
    }];
    
    [_mendianName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeDes.mas_right);
        make.width.equalTo(FitPTScreen(230));
        make.top.equalTo(self.storeDes);
        make.bottom.equalTo(self.contentView).offset(FitPTScreenH([HLAccount shared].admin?-20:0));
        if (![HLAccount shared].admin) {
            make.height.equalTo(0);
        }
    }];
    
    [go_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(FitPTScreen(-23));
    }];
    
    [_separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-1);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(1);
    }];
    
    [_selectImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(FitPTScreen(-20));
    }];
    
    [_storeName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([self.storeModel.is_show integerValue]==0?FitPTScreen(49):FitPTScreen(21));
        make.top.equalTo(FitPTScreenH(23));
    }];
    
    [_leavlLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeName.mas_right).offset(FitPTScreen(17));
        make.centerY.equalTo(self.storeName);
        make.height.equalTo(20);
        if (self.storeModel) {
            make.width.equalTo(FitPTScreen(20) + self.storeModel.classnameTextW);
        }
    }];
    
    [_showView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FitPTScreen(20));
        make.centerY.equalTo(self.storeName);
    }];
}


-(void)setphoneNumber:(NSString *)number{
    _phoneNum.text = [NSString stringWithFormat:@"联系电话：%@",number];
}

-(void)setMenDian:(NSString *)name{
    _mendianName.text = [NSString stringWithFormat:@"%@",name];
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _selectImg.hidden = !_isSelect;
}

-(void)setCellSelected:(BOOL)select{
    if (select) {
        _selectImg.image = [UIImage imageNamed:@"success_oriange"];
    }else{
        _selectImg.image = [UIImage imageNamed:@"success_grey"];
    }
}


-(void)setStaffModel:(HLStaffModel *)staffModel{
    _staffModel = staffModel;
    _name.text = staffModel.nameText;
    _gongHao.text = staffModel.user_name;
    _phoneNum.text = [NSString stringWithFormat:@"联系电话：%@",staffModel.mobile];
    _mendianName.text = staffModel.store;
    _dianzhang.hidden = [staffModel.is_dianzhang integerValue] != 1;
    
    _storeDes.hidden = ![staffModel.store hl_isAvailable];
    
    [self layout];
}


- (void)setStoreModel:(HLStoreModel *)storeModel{
    _storeName.hidden = NO;
    _leavlLable.hidden = NO;
    _gongHao.hidden = YES;
    _name.hidden = YES;
    
    
    _storeModel = storeModel;
    _storeName.text = _storeModel.nameText;
    _leavlLable.text = _storeModel.classnameText;
    _phoneNum.text = [NSString stringWithFormat:@"门店电话：%@",_storeModel.tel];
    _storeDes.text = @"门店地址：";
     _mendianName.text = _storeModel.address;
    _leavlLable.hidden = (![_storeModel.classname hl_isAvailable] ||[_storeModel.classname isEqualToString:@"请选择类别"]);
    _storeDes.hidden = ![_storeModel.address hl_isAvailable];
    
    _showView.hidden = [_storeModel.is_show integerValue]==1;
    [self layout];
}

//-(void)setIsMDList:(BOOL)isMDList{
//
//}

-(void)layoutSubviews{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor =[UIColor clearColor];
    self.gongHao.backgroundColor = [UIColor clearColor];
    self.name.backgroundColor = [UIColor clearColor];
    self.phoneNum.backgroundColor = [UIColor clearColor];
    self.mendianName.backgroundColor = [UIColor clearColor];
    self.dianzhang.backgroundColor = [UIColor clearColor];
    self.storeName.backgroundColor = [UIColor clearColor];
    self.leavlLable.backgroundColor = [UIColor clearColor];
    self.storeDes.backgroundColor = [UIColor clearColor];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"success_oriange"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"success_grey"];
                    }
                }
            }
        }
    }

    [super layoutSubviews];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    go_imgView.hidden = editing;
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (!self.selected) {
                        image.image=[UIImage imageNamed:@"success_grey"];
                    }else
                    {
                        image.image=[UIImage imageNamed:@"success_oriange"];
                    }
                }
            }
        }
    }
    
}

-(void)setHighlighted:(BOOL)highlighted{
//    [super setHighlighted:highlighted];
    return;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.separatorLine.backgroundColor =UIColorFromRGB(0xDDDDDD);
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.separatorLine.backgroundColor =UIColorFromRGB(0xDDDDDD);
}

@end
