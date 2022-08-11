//
//  HLListViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/17.
//

#import "HLListViewCell.h"

@implementation HLListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = UIColorFromRGB(0xFFF9F9F9);
        self.frame = CGRectMake(0, 0, 200, 37);
        //self.bounds.size.width-30
        _imageV  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 20, 20)];
        [_imageV setImage:[UIImage imageNamed:@"0"]];
        [self addSubview:_imageV];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
