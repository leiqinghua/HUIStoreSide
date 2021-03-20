//
//  HLOrderCarTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/11/18.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderCarTableCell.h"
#import "HLOrderGoodModel.h"

@interface HLOrderCarTableCell ()

@property (strong,nonatomic)UIImageView * headView;

@property (strong,nonatomic)UILabel * nameLb;

@property (strong,nonatomic)UILabel * descLb;

@property (strong,nonatomic)UILabel * timeLb;

@end

@implementation HLOrderCarTableCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:false];
    
    _headView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headView];
    [_headView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(10));
        make.width.height.equalTo(FitPTScreen(50));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColorFromRGB(0x222222);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _nameLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLb];
    [_nameLb remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(11));
        make.top.equalTo(FitPTScreen(10));
        make.width.equalTo(FitPTScreen(150));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x999999);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _descLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_descLb];
    [_descLb remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(6));
    }];
    
    _timeLb = [[UILabel alloc]init];
    _timeLb.textColor = UIColorFromRGB(0x999999);
    _timeLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _timeLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_timeLb];
    [_timeLb remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.descLb.bottom).offset(FitPTScreen(6));
    }];
}

- (void)setCarModel:(HLOrderCarModel *)carModel {
    _carModel = carModel;
    [_headView sd_setImageWithURL:[NSURL URLWithString:carModel.pic] placeholderImage:[UIImage imageNamed:@""]];
    _nameLb.text = carModel.title;
    _descLb.text = carModel.descText;
    _timeLb.text = carModel.timetext;
}
@end
