//
//  HLMessageDetailViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import "HLMessageDetailViewCell.h"

@interface HLMessageDetailViewCell()

@end

@implementation HLMessageDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = UIColorFromRGB(0x666666);
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    _subLable = [[UILabel alloc]init];
    _subLable.textColor = UIColorFromRGB(0x222222);
    _subLable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _subLable.numberOfLines = 0;
    _subLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_subLable];
    [_subLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(223));
    }];
}
@end
