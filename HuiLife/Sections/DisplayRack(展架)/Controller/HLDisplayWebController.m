//
//  HLDisplayWebController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import "HLDisplayWebController.h"

@interface HLDisplayWebController ()

@property(nonatomic, strong)UILabel *urlLb;

@end

@implementation HLDisplayWebController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"展架详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetWebViewFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(67) - Height_Bottom_Margn)];
    [self setProgressFrame:CGRectMake(0, Height_NavBar, ScreenW, 0)];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(FitPTScreen(67) + Height_Bottom_Margn);
    }];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.numberOfLines = 2;
    tipLb.textColor = UIColor.whiteColor;
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [bottomView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(bottomView);
    }];
    
    NSString *text = @"复制短链接 \n发送给印刷店";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 6;
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:text attributes:@{NSParagraphStyleAttributeName : style}];
    tipLb.attributedText = attr;
    
    UILabel *copyLb = [[UILabel alloc]init];
    copyLb.backgroundColor = UIColorFromRGB(0x999999);
    copyLb.layer.cornerRadius = 2.5;
    copyLb.layer.masksToBounds = YES;
    copyLb.textColor = UIColor.whiteColor;
    copyLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    copyLb.text = _dl_url;
    copyLb.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:copyLb];
    [copyLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-63));
        make.centerY.equalTo(bottomView);
        make.width.equalTo(FitPTScreen(167));
        make.height.equalTo(FitPTScreen(25));
    }];
    
    UIButton *copyBtn = [[UIButton alloc]init];
    [copyBtn setImage:[UIImage imageNamed:@"copy_white"] forState:UIControlStateNormal];
    [bottomView addSubview:copyBtn];
    [copyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(bottomView);
        make.width.height.equalTo(FitPTScreen(30));
    }];
    [copyBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)copyBtnClick:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dl_url;
    HLShowHint(@"复制成功", self.view);
}

@end
