//
//  HLHomeShareController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/9/4.
//

#import "HLHomeShareController.h"

#define kDefaultShareH (FitPTScreen(269) + Height_Bottom_Margn)
#define kImageContentH FitScreenH(385)
#define kSaveImgShareH (FitScreenH(154) + Height_Bottom_Margn)


@interface HLHomeShareController ()

@property (nonatomic, strong) UIImageView *imageContentView;
@property (nonatomic, strong) UIView *saveImgShareView;
@property (nonatomic, strong) UIImage *saveImgae;

@end

@implementation HLHomeShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     [self creatViewImage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 刚开始肯定是展现默认的分享页面
    [UIView animateWithDuration:0.35 animations:^{
        [self creatViewImage];
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
}

/// 小程序分享给好友
- (void)saveImgShareToFriend{
    [HLTools shareWithId:_Id type:4 controller:self completion:^(NSDictionary * dict) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"pic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            dispatch_main_async_safe(^{
                [HLWXManage shareToWXWithMiniProgramUserName:WX_MINIPAGRAM_USERNAME title:dict[@"title"] description:@"" image:image webpageUrl:dict[@"link"] path:dict[@"path"]];
            });
        }];
    }];
    
    
}

/// 图片分享给朋友圈
- (void)saveImgShareToCycle{
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:_data[@"imgUrl"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        dispatch_main_async_safe(^{
            [HLWXManage shareToWXWithImage:image scene:HLSceneTimeline];
        });
    }];
}

/// 保存图片
- (void)saveImgToLocal{
    
    if ([_data[@"imgUrl"] isEqualToString:@""] ||!_data[@"imgUrl"]) {
        HLLog(@"稍后再试");
        return;
    }
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:_data[@"imgUrl"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        dispatch_main_async_safe(^{
            // 保存图片
            _saveImgae = image;
            [HLTools saveImageToLocal:_saveImgae];
            [self saveImgClose];
        });
    }];
    
}

/// 默认分享页面时，关闭
- (void)defaultShareClose{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

/// 带有保存图片的关闭
- (void)saveImgClose{
    [UIView animateWithDuration:0.25 animations:^{
        _saveImgShareView.frame = CGRectMake(0, ScreenH, ScreenW, kSaveImgShareH);
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _imageContentView.alpha = 0;
    } completion:^(BOOL finished) {
        [_imageContentView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

/// 根据传来的数据创建图片
- (void)creatViewImage{
    // 展示内容view
    [self showImageContentView];

    // 展示保存图片的shareView
    [self showSaveImgShareView];
}

/// 展示带有保存图片的view
- (void)showSaveImgShareView{
    if (!_saveImgShareView) {
        
        _saveImgShareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, kSaveImgShareH)];
        [self.view addSubview:_saveImgShareView];
        _saveImgShareView.backgroundColor = UIColor.whiteColor;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_saveImgShareView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(9,9)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _saveImgShareView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _saveImgShareView.layer.mask = maskLayer;
        
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_saveImgShareView addSubview:tipLab];
        tipLab.text = @"分享海报给好友";
        tipLab.textColor = UIColorFromRGB(0x333333);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(25));
            make.centerX.equalTo(_saveImgShareView);
        }];
        
        UIView *wxCycleV = [[UIView alloc] init];
        [_saveImgShareView addSubview:wxCycleV];
        [wxCycleV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_saveImgShareView);
            make.top.equalTo(tipLab.bottom).offset(FitPTScreen(16));
            make.height.equalTo(FitPTScreen(70));
            make.width.equalTo(FitPTScreen(60));
        }];

        [self creatCenterSubViewsWithSuperView:wxCycleV imageName:@"hui_pengyouquan" title:@"微信朋友圈"];
        [wxCycleV hl_addTarget:self action:@selector(saveImgShareToCycle)];
        
        UIView *creatImageV = [[UIView alloc] init];
        [_saveImgShareView addSubview:creatImageV];
        [creatImageV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wxCycleV.right).offset(FitPTScreen(26));
            make.top.height.width.equalTo(wxCycleV);
        }];
        [self creatCenterSubViewsWithSuperView:creatImageV imageName:@"hui_baocuntupian" title:@"保存图片"];
        [creatImageV hl_addTarget:self action:@selector(saveImgToLocal)];
        
        UIView *wxFriendV = [[UIView alloc] init];
        [_saveImgShareView addSubview:wxFriendV];
        [wxFriendV makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wxCycleV.left).offset(FitPTScreen(-26));
            make.top.height.width.equalTo(wxCycleV);
        }];
        [self creatCenterSubViewsWithSuperView:wxFriendV imageName:@"hui_haoyou" title:@"微信好友"];
        [wxFriendV hl_addTarget:self action:@selector(saveImgShareToFriend)];
        
        // 取消按钮
        UIButton *closeBtn = [[UIButton alloc] init];
        [_saveImgShareView addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"close_x_grey"] forState:UIControlStateNormal];
        [closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.width.height.equalTo(FitPTScreen(42));
            make.top.equalTo(FitPTScreen(12));
        }];
        [closeBtn addTarget:self action:@selector(saveImgClose) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 刚开始肯定是展现默认的分享页面
    [UIView animateWithDuration:0.35 animations:^{
        _saveImgShareView.frame = CGRectMake(0, ScreenH - kSaveImgShareH, ScreenW, kSaveImgShareH);
    }];
}

/// 展示内容view
- (void)showImageContentView{
    _imageContentView = [[UIImageView alloc] init];
    [self.view addSubview:_imageContentView];
    [_imageContentView sd_setImageWithURL:[NSURL URLWithString:_data[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
  
    _imageContentView.layer.cornerRadius = FitPTScreen(10);
    _imageContentView.layer.masksToBounds = YES;
    
    [_imageContentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HIGHT_NavBar_MARGIN + FitPTScreen(90));
        make.left.equalTo(FitPTScreen(37));
        make.right.equalTo(FitPTScreen(-37));
        make.height.equalTo(kImageContentH);
    }];
    _imageContentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _imageContentView.alpha = 1;
    }];
}


- (void)creatCenterSubViewsWithSuperView:(UIView *)superView imageName:(NSString *)imageName title:(NSString *)title{
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    imageView.image = [UIImage imageNamed:imageName];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(superView.width);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    [superView addSubview:titleLab];
    titleLab.text = title;
    titleLab.textColor = UIColorFromRGB(0x222222);
    titleLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.bottom.equalTo(FitPTScreen(0));
    }];
}

@end
