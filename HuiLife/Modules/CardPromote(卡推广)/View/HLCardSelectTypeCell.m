//
//  HLCardSelectTypeCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/12.
//

#import "HLCardSelectTypeCell.h"

@interface HLCardSelectTypeCell ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, copy) UILabel *descLb;

@property(nonatomic, copy) UIImageView *arrowImV;

@end

@implementation HLCardSelectTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont boldSystemFontOfSize:FitPTScreen(15)];
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.centerY.equalTo(self.contentView);
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.textColor = UIColorFromRGB(0x666666);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-30));
        make.centerY.equalTo(self.contentView);
    }];
    
    _arrowImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self.contentView addSubview:_arrowImV];
    [_arrowImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-17));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setModel:(HLCardPromoteType *)model {
    _model = model;
    _titleLb.text = model.title;
    _descLb.text = model.desc;
    
    if (model.canEdit) {
        self.arrowImV.hidden = NO;
        [_descLb updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-30));
        }];
    }else{
        self.arrowImV.hidden = YES;
        [_descLb updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-17));
        }];
    }
}
@end
