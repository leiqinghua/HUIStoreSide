//
//  HLPickImageViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import "HLPickImageViewCell.h"

@interface HLPickImageViewCell ()
@property(nonatomic, strong) UIImageView *picImV;
@property(nonatomic, strong) UIButton *delBtn;
@end

@implementation HLPickImageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _picImV = [[UIImageView alloc]init];
        _picImV.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:_picImV];
        [_picImV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(FitPTScreen(10));
            make.size.equalTo(CGSizeMake(FitPTScreen(80), FitPTScreen(80)));
        }];
        
        _delBtn = [UIButton hl_regularWithImage:@"delete_red" select:NO];
        [self.contentView addSubview:_delBtn];
        [_delBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.picImV.right).offset(FitPTScreen(-2));
            make.centerY.equalTo(self.picImV.top).offset(FitPTScreen(2));
            make.size.equalTo(CGSizeMake(FitPTScreen(12), FitPTScreen(12)));
        }];
        [_delBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setPic:(NSString *)pic {
    _pic = pic;
    [_picImV sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
}

- (void)deleteClick {
    if ([self.delegate respondsToSelector:@selector(deleteWithImage:)]) {
        [self.delegate deleteWithImage:self.pic];
    }
}

@end

//添加按钮
@interface HLImageAddViewCell ()

@end

@implementation HLImageAddViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *addBtn = [[UIButton alloc]init];
        addBtn.layer.cornerRadius = FitPTScreen(1);
        addBtn.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
        addBtn.layer.borderWidth = 0.5;
        addBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:addBtn];
        [addBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(FitPTScreen(10));
            make.size.equalTo(CGSizeMake(FitPTScreen(80), FitPTScreen(80)));
        }];
        
        UIImageView *addImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_grey"]];
        [addBtn addSubview:addImV];
        [addImV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(addBtn);
            make.top.equalTo(FitPTScreen(18));
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"上传图片";
        [addBtn addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(addBtn);
            make.top.equalTo(addImV.bottom).offset(FitPTScreen(6));
        }];
    }
    return self;
}

@end
