//
//  HLHowFindPassController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/17.
//

#import "HLHowFindPassController.h"

@interface HLHowFindPassController ()

@end

@implementation HLHowFindPassController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setBackgroundColor:UIColorFromRGB(0xFF8D26)];
    [self hl_setTitle:@"如何找回密码" andTitleColor:[UIColor whiteColor]];
    [self hl_hideBack:false];
    [self hl_interactivePopGestureRecognizerUseable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

-(void)createUI{
    NSArray * titles=@[@"员工如何找回密码？",@"店长如何找回密码？",@"管理员如何找回密码？"];
    NSArray * subtitles = @[@"员工忘记工号或密码时，与所在门店的店长或总账号管理员联系，可在设置中心-员工管理中找回密码；",@"店长忘记工号或密码时，与总账号管理员联系，可在设置中心-员工管理中找回密码；",@"登录时，点击“找回管理员账号”，按页面提示输入正确信息并提交，重置的密码生效；"];
    for (int i = 0; i<titles.count; i++) {
        UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"oriangeDot"]];
        [self.view addSubview:img];
        [img makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(FitPTScreen(20));
            make.top.equalTo(self.view).offset(FitPTScreenH(106 + i*(110+8)));
        }];
        UILabel * titleLable = [[UILabel alloc]init];
        titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
        titleLable.text = titles[i];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.textColor = UIColorFromRGB(0xFF8D26);
        [self.view addSubview:titleLable];
        [titleLable makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img);
            make.left.equalTo(img.mas_right).offset(FitPTScreen(10));
        }];
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = FitPTScreenH(20);
        NSDictionary *dic=@{NSParagraphStyleAttributeName:paraStyle};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:subtitles[i] attributes:dic];
        UILabel * subTitleLb = [[UILabel alloc]init];
        subTitleLb.numberOfLines = 0;
        subTitleLb.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
        subTitleLb.textAlignment = NSTextAlignmentLeft;
        subTitleLb.textColor = UIColorFromRGB(0x656565);
        subTitleLb.attributedText = attributeStr;
        [self.view addSubview:subTitleLb];
        [subTitleLb makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img);
            make.width.equalTo(FitPTScreen(332));
            make.top.equalTo(titleLable.mas_bottom).offset(FitPTScreenH(20));
        }];
    }
    
}

@end
