//
//  HLTKReasonViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/9.
//

#import "HLTKReasonViewCell.h"

@interface HLTKReasonViewCell()

@property (strong,nonatomic)UIImageView * imgView;
@end

@implementation HLTKReasonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _imgView.image = selected?[UIImage imageNamed:@"success_oriange"]:[UIImage imageNamed:@"circle_grey_normal"];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = UIColorFromRGB(0xFF333333);
        self.textLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_grey_normal"]];
        
        [self.contentView addSubview:_imgView];
        [_imgView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-13));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
