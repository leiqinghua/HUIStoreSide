//
//  HLCollegeFindViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/28.
//

#import "HLCollegeFindViewCell.h"

@interface HLCollegeFindViewCell ()

@property(nonatomic,strong)UIImageView * leftImgV;

@property(nonatomic,strong)UILabel * leftLb;

@property(nonatomic,strong)UILabel * tipLb;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIView * bagView;

@end

@implementation HLCollegeFindViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = UIColor.clearColor;
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, FitPTScreen(13), 0, FitPTScreen(13)));
    }];
    
    _leftImgV = [[UIImageView alloc]init];
    [_bagView addSubview:_leftImgV];
    [_leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.bottom.equalTo(FitPTScreen(-13));
    }];
    
    _leftLb = [[UILabel alloc]init];
    _leftLb.textColor = UIColorFromRGB(0x222222);
    _leftLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_bagView addSubview:_leftLb];
    [_leftLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgV.right).offset(FitPTScreen(12));
        make.centerY.equalTo(self.leftImgV);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.textColor = UIColorFromRGB(0x333333);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [_bagView addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-25));
        make.centerY.equalTo(self.leftLb);
        make.width.equalTo(FitPTScreen(150));
        make.height.equalTo(FitPTScreen(40));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xE0E0E0);
    [_bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.bottom.equalTo(FitPTScreen(-1));
        make.right.equalTo(FitPTScreen(-19));
        make.height.equalTo(0.7);
    }];
    
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldEditing:(UITextField *)sender{
    self.infoModel.text = sender.text;
}

-(void)setInfoModel:(HLInfoModel *)infoModel{
    _infoModel = infoModel;
    _leftImgV.image = [UIImage imageNamed:infoModel.leftPic];
    _leftLb.text = infoModel.leftText;
    _textField.placeholder = infoModel.placeHolder;
    _textField.text = infoModel.text;
    _textField.enabled = infoModel.canInput;
    _textField.keyboardType = infoModel.keyboardType;
}


@end
