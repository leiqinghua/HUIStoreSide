//
//  HLMatterPreviewController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterPreviewController.h"

@interface HLMatterPreviewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HLMatterPreviewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hl_setBackImage:@"back_white"];
    [self hl_setBackgroundColor:UIColorFromRGB(0x000000) showLine:NO];
    [self hl_setTitle:@"店内宣传展架" andTitleColor:UIColor.whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x000000);
    self.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self creatSubUI];
}

/// 复制文字
- (void)copyUrl {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.downloadUrl;
    HLShowHint(@"复制成功", self.view);
}

/// 创建视图
- (void)creatSubUI {
    
    CGFloat controlHeight = FitPTScreen(67) + Height_Bottom_Margn;
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - controlHeight, ScreenW, controlHeight)];
    [self.view addSubview:controlView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - controlHeight - Height_NavBar)];
    [self.view addSubview:scrollView];
    
    _imageView = [[UIImageView alloc] init];
    [scrollView addSubview:self.imageView];
    
    HLLoading(self.view);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.bigImgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        HLHideLoading(self.view);
        scrollView.contentSize = CGSizeMake(ScreenW, image.size.height / (image.size.width / ScreenW));
        _imageView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    }];
    
    UILabel *leftTipLab = [[UILabel alloc] init];
    [controlView addSubview:leftTipLab];
    leftTipLab.numberOfLines = 2;
    leftTipLab.text = @"复制短链接\n快速下载源文件";
    leftTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    leftTipLab.textColor = UIColorFromRGB(0xFFFFFF);
    [leftTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    UIButton *copyBtn = [[UIButton alloc] init];
    [controlView addSubview:copyBtn];
    [copyBtn setImage:[UIImage imageNamed:@"mater_preview_fuzhi"] forState:UIControlStateNormal];
    [copyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(FitPTScreen(40));
        make.centerY.equalTo(leftTipLab);
        make.right.equalTo(FitPTScreen(-10));
    }];
    [copyBtn addTarget:self action:@selector(copyUrl) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *urlView = [[UIView alloc] init];
    [controlView addSubview:urlView];
    urlView.backgroundColor = UIColorFromRGB(0x999999);
    urlView.layer.cornerRadius = FitPTScreen(3);
    [urlView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyBtn);
        make.right.equalTo(copyBtn.left).offset(FitPTScreen(-10));
        make.height.equalTo(FitPTScreen(25));
        make.width.equalTo(FitPTScreen(168));
    }];
    
    UILabel *urlLab = [[UILabel alloc] init];
    [urlView addSubview:urlLab];
    urlLab.text = self.downloadUrl;
    urlLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    urlLab.textColor = UIColorFromRGB(0xFFFFFF);
    [urlLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(urlView);
        make.width.lessThanOrEqualTo(FitPTScreen(158));
    }];
}

#pragma mark - UserAction

@end
