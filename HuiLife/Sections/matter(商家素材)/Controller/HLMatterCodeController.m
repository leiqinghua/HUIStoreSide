//
//  HLMatterCodeController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterCodeController.h"

@interface HLMatterCodeController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HLMatterCodeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hl_setBackImage:@"back_white"];
    [self hl_setBackgroundColor:UIColorFromRGB(0x000000) showLine:NO];
    [self hl_setTitle:self.navTitle andTitleColor:UIColor.whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x999999);
    self.statusBarStyle = UIStatusBarStyleLightContent;
    
    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(isPad ? 375 : ScreenW);
    }];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.codeImgUrl] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            _imageView.backgroundColor = UIColorFromRGB(0xDBDBDB);
        }
    }];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [self.view addSubview:saveButton];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = FitPTScreen(7);
    saveButton.backgroundColor = UIColorFromRGB(0x000000);
    [saveButton setTitle:@"快速保存到相册" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_imageView.bottom).offset(FitPTScreen(45));
        make.width.equalTo(FitPTScreen(132));
        make.height.equalTo(FitPTScreen(37));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UserAction

/// 保存图片
- (void)saveButtonClick {
    HLLoading(self.view);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.codeImgUrl]
                                                          options:SDWebImageDownloaderHighPriority
                                                         progress:nil
                                                        completed:^(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error, BOOL finished) {
                                                            HLHideLoading(self.view);
                                                            if (image) {
                                                                [HLTools saveImageToLocal:image];
                                                            } else {
                                                                HLShowHint(@"下载图片失败，请重试", self.view);
                                                            }
                                                        }];
}

@end
