//
//  HLAboutUsHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/27.
//

#import "HLAboutUsHeaderView.h"

@interface HLAboutUsHeaderView()

@end

@implementation HLAboutUsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    UIImageView* logoview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
    [self addSubview:logoview];
    [logoview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(39));
        make.left.equalTo(FitPTScreen(124));
        make.height.equalTo(FitPTScreen(78));
        make.width.equalTo(FitPTScreen(158));
    }];
    
    UILabel * appName = [[UILabel alloc]init];
    appName.text = @"商+号";
    appName.textColor = UIColorFromRGB(0x282828);
    appName.font = [UIFont systemFontOfSize:FitPTScreen(18)];
    [self addSubview:appName];
    [appName makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(logoview.mas_bottom).offset(FitPTScreen(20));
    }];
    
    UILabel* version = [[UILabel alloc]init];
    version.text = [NSString stringWithFormat:@"当前版本 v%@",[HLTools currentVersion]];
    version.textColor = UIColorFromRGB(0x989898);
    version.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    [self addSubview:version];
    [version makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(appName.mas_bottom).offset(FitPTScreen(10));
    }];
}
@end
