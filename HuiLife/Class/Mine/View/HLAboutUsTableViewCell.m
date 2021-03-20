//
//  HLAboutUsTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/27.
//

#import "HLAboutUsTableViewCell.h"

@interface HLAboutUsTableViewCell(){
    UIView * _line;
}

@property(strong,nonatomic)UILabel * title;

@property(strong,nonatomic)UILabel * subLable;

@end

@implementation HLAboutUsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _title = [[UILabel alloc]init];
    _title.text = @"";
    _title.textColor = UIColorFromRGB(0x656565);
    _title.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    [self addSubview:_title];
    [_title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    _subLable = [[UILabel alloc]init];
    _subLable.text = @"";
    _subLable.textColor = UIColorFromRGB(0xFF8D26);
    _subLable.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    [self addSubview:_subLable];
    [_subLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-41));
        make.centerY.equalTo(self.contentView);
    }];
    
    UIImageView* tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_darkGrey"]];
    [self addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
    }];
    
//    _line = [[UIView alloc]init];
//    _line.backgroundColor = UIColorFromRGB(0xDDDDDD);
//    [self addSubview:_line];
//    [_line makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(FitPTScreen(10));
//        make.right.equalTo(FitPTScreen(-10));
//        make.top.equalTo(self.contentView);
//        make.height.equalTo(FitPTScreen(1));
//    }];
    
}

-(void)setInfo:(NSDictionary *)info{
    _info = info;
    _title.text = _info[@"title"];
    _subLable.text = _info[@"value"];
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    [self setContentWithIndex:indexPath.row];
}

-(void)setContentWithIndex:(NSInteger)index{
    
//    if (index == 0) {
//        _line.hidden = YES;
////        UIView * line = [[UIView alloc]init];
////        line.backgroundColor = UIColorFromRGB(0xDDDDDD);
////        [self addSubview:line];
////        [line makeConstraints:^(MASConstraintMaker *make) {
////            make.left.right.top.equalTo(self.contentView);
////            make.height.equalTo(FitPTScreen(1));
////        }];
//    }
    
    if (index == 2) {
//        UIView * line = [[UIView alloc]init];
//        line.backgroundColor = UIColorFromRGB(0xDDDDDD);
//        [self addSubview:line];
//        [line makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.contentView);
//            make.height.equalTo(FitPTScreen(1));
//        }];
        
        _subLable.textColor = [HLAccount shared].isUpdate?[UIColor hl_StringToColor:@"#FF8D26"]:[UIColor hl_StringToColor:@"#989898"];
    }
}

@end
