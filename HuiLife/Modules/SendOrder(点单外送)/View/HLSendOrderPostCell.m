//
//  HLSendOrderPostCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import "HLSendOrderPostCell.h"

@interface HLSendOrderPostCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIButton *postBtn;

@end

@implementation HLSendOrderPostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _titleLab = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLab];
    _titleLab.textColor = UIColorFromRGB(0x333333);
    _titleLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(18));
        make.left.equalTo(FitPTScreen(15));
    }];
    
    _subTitleLab = [[UILabel alloc] init];
    [self.contentView addSubview:_subTitleLab];
    _subTitleLab.textColor = UIColorFromRGB(0x666666);
    _subTitleLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_subTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.bottom).offset(FitPTScreen(7));
        make.left.equalTo(_titleLab);
    }];
    
    UIImageView *orderActionImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_action"]];
    [self.contentView addSubview:orderActionImgV];
    [orderActionImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_subTitleLab);
        make.left.equalTo(_subTitleLab.right).offset(FitPTScreen(8));
        make.width.height.equalTo(FitPTScreen(14));
    }];
    
    _postBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_postBtn];
    [_postBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _postBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_postBtn setBackgroundImage:[UIImage imageNamed:@"sendOrder_post_bg"] forState:UIControlStateNormal];
    [_postBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(104));
        make.height.equalTo(FitPTScreen(58));
    }];
    [_postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)postBtnClick{
    if (self.delegate) {
        [self.delegate postCell:self clickMainInfo:self.mainInfo];
    }
}

-(void)setMainInfo:(HLSendOrderMainInfo *)mainInfo{
    _mainInfo = mainInfo;
    _titleLab.text = mainInfo.title;
    _subTitleLab.text = mainInfo.subTitle;
    [_postBtn setTitle:mainInfo.butName forState:UIControlStateNormal];
}

@end
