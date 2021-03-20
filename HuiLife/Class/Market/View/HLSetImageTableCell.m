//
//  HLSetImageTableCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLSetImageTableCell.h"

@interface HLSetImageTableCell ()

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UIImageView * imgV;

@property(nonatomic,strong)UILabel * numLb;

@property(nonatomic,strong)UIView * bagView;

@end

@implementation HLSetImageTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.42].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,3);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(22);
    _bagView.layer.cornerRadius = FitPTScreen(7);
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(13), FitPTScreen(5), FitPTScreen(13)));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _titleLb.text = @"店铺图册";
    [_bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(self.bagView);
    }];
    
    _imgV = [[UIImageView alloc]init];
    _imgV.layer.cornerRadius = 4;
    [_bagView addSubview:_imgV];
    [_imgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.right.equalTo(FitPTScreen(-31));
        make.width.height.equalTo(FitPTScreen(91));
    }];
    
    _numLb = [[UILabel alloc]init];
    _numLb.textColor = UIColorFromRGB(0xFFFFFF);
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _numLb.text = @"2";
    _numLb.layer.cornerRadius = 8;
    _numLb.layer.masksToBounds = YES;
    _numLb.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _numLb.textAlignment = NSTextAlignmentCenter;
    [_imgV addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-3));
        make.bottom.equalTo(FitPTScreen(-5));
        make.width.equalTo(26);
        make.height.equalTo(16);
    }];
    
    UIImageView * arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    arrow.layer.cornerRadius = 4;
    [_bagView addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.right.equalTo(FitPTScreen(-13));
    }];
}

-(void)setMainModel:(HLSetModel *)mainModel{
    _mainModel = mainModel;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:mainModel.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _numLb.text = [NSString stringWithFormat:@"%ld",mainModel.imageCnt];
}


@end
