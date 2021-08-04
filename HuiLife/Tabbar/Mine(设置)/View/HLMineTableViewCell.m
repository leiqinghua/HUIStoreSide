//
//  HLMineTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/24.
//

#import "HLMineTableViewCell.h"

@interface HLMineTableViewCell()

@end

@implementation HLMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _title = [[UILabel alloc]init];
    _title.textColor = UIColorFromRGB(0x656565);
    _title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_title];
    [_title makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(FitPTScreen(20));
    }];
    
    UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self.contentView addSubview:img];
    [img makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(FitPTScreen(-20));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FitPTScreen(10));
        make.width.equalTo(FitPTScreen(355));
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.height.equalTo(FitPTScreen(1));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
