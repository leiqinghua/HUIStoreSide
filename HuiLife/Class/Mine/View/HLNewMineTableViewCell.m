//
//  HLNewMineTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import "HLNewMineTableViewCell.h"

@interface HLNewMineTableViewCell()

@property (strong,nonatomic)UIImageView * tipImgV;

@property (strong,nonatomic)UILabel * titleLb;

@property (strong,nonatomic)UILabel * descLb;

@property(nonatomic,strong)UIView * bagView;

@end

@implementation HLNewMineTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.29].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,2);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(14);
    _bagView.layer.cornerRadius = FitPTScreen(6);
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(6), FitPTScreen(10), FitPTScreen(6), FitPTScreen(10)));
    }];
    
    _tipImgV = [[UIImageView alloc]init];
    [_bagView addSubview:_tipImgV];
    [_tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(19));
        make.left.equalTo(FitPTScreen(15));
        make.width.equalTo(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(13));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _titleLb.textColor = UIColorFromRGB(0x222222);
    [_bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipImgV);
        make.left.equalTo(self.tipImgV.right).offset(FitPTScreen(5));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _descLb.textColor = UIColorFromRGB(0x999999);
    [_bagView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(11));
        make.left.equalTo(self.titleLb);
    }];
  
    
    UIImageView * arrowImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [_bagView addSubview:arrowImgV];
    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.right.equalTo(FitPTScreen(-26));
    }];
}

-(void)setMineModel:(HLMineModel *)mineModel{
    _mineModel = mineModel;
    if ([mineModel.title isEqualToString:@"关于我们"]) {
        mineModel.describe = [NSString stringWithFormat:@"当前版本v%@",[HLTools currentVersion]];
    }
    [_tipImgV sd_setImageWithURL:[NSURL URLWithString:mineModel.icon] placeholderImage:[UIImage imageNamed:@""]];
    _titleLb.text = mineModel.title;
    _descLb.text = mineModel.describe;
    
}

@end
