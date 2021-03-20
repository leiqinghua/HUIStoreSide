//
//  HLRuleDescTableCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLRuleDescTableCell.h"

@interface HLRuleDescTableCell ()

@property(strong,nonatomic)UILabel *textLb;

@property(strong,nonatomic)UIImageView * selectV;

@end

@implementation HLRuleDescTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _textLb = [[UILabel alloc]init];
    _textLb.textColor = [UIColor hl_StringToColor:@"#333333"];
    _textLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textLb.numberOfLines = 0;
    [self.contentView addSubview:_textLb];
    [_textLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(self.contentView);
    }];
    
    _selectV = [[UIImageView alloc]init];
    [self.contentView addSubview:_selectV];
    [_selectV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.textLb);
    }];
    
    
    
}

-(void)setModel:(HLRuleModel *)model{
    _model = model;
    _textLb.text = model.content;
    _selectV.image = model.selected?[UIImage imageNamed:@"success_oriange"]:[UIImage imageNamed:@"select_md_normal"];
}
@end
