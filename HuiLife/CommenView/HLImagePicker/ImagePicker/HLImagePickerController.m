//
//  HLImagePickerController.m
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import "HLImagePickerController.h"
#import "HLImageAlbumController.h"

@interface HLImagePickerController ()

@property (nonatomic, strong) UIView *authorizationView; // 提示权限设置View


@end

@implementation HLImagePickerController

- (instancetype)initWithNeedResize:(BOOL)needResize maxSelectNum:(NSInteger)maxSelectNum singleSelect:(BOOL)singleSelect mustResize:(BOOL)mustResize selectOrinal:(BOOL)selectOrinal resizeWHScale:(CGFloat)resizeWHScale pickerBlock:(HLImagePickerBlock)pickerBlock
{
    self = [super initWithRootViewController:[HLImageAlbumController new]];
    
    if (self) {
        HLImagePickerConfig *config = [[HLImagePickerConfig alloc] init];
        config.selectOrinal = selectOrinal;
        config.singleSelect = singleSelect;
        config.maxSelectNum = maxSelectNum == 0 ? 9 : maxSelectNum;
        config.needResize = needResize;
        config.resizeWHScale = resizeWHScale;
        config.mustResize = mustResize;
        
        // 如果比例为0，则不是强制裁减
        if (config.resizeWHScale == 0) {
            config.mustResize = NO;
            config.resizeWHScale = 1;
        }
        // 如果必须强制裁减，肯定显示裁减按钮
        if (config.mustResize) {
            config.needResize = YES;
        }
        
        [[HLImagePickerManager shared] setUpConfig:config];
        [HLImagePickerManager shared].pickerBlock = pickerBlock;

        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPhotoAuthorization) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //
    [self checkPhotoAuthorization];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[HLImagePickerManager shared] clearCacheImageDict];
    [[HLImagePickerManager shared] clearSelectAsset];
}

#pragma mark - 认证提示

// 加载所有图片
- (void)checkPhotoAuthorization{
    // 判断权限
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{

                // 允许访问
                if (status == PHAuthorizationStatusAuthorized) {
                    [self hideAuthorizationView];
                    // 根视图加载数据
                    HLImageAlbumController *album = self.childViewControllers.firstObject;
                    [album loadAllAlbums];
                }

                // 不允许访问
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    [self showAuthorizationView];
                }
            });
        }];
        return;
        
    }else if(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
        [self showAuthorizationView];
        return;
    }
    
    // 说明是已经授权了
    [self hideAuthorizationView];
}

// 展示认证提示页面
- (void)showAuthorizationView{
    [self.view addSubview:self.authorizationView];
}

// 隐藏认证提示页面
- (void)hideAuthorizationView{
    [self.authorizationView removeFromSuperview];
    self.authorizationView = nil;
}

// 打开设置页面
- (void)settingBtnClick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (UIView *)authorizationView{
    if (!_authorizationView) {
        _authorizationView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _authorizationView.backgroundColor = UIColorFromRGB(0xF6F6F6);
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [settingBtn setTitle:@"打开设置" forState:UIControlStateNormal];
        settingBtn.frame = CGRectMake(0, 0, 150, 44);
        settingBtn.center = self.view.center;
        settingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_authorizationView addSubview:settingBtn];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, self.view.bounds.size.width - 40, 60);
        label.center = CGPointMake(settingBtn.center.x, settingBtn.center.y - 60);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [_authorizationView addSubview:label];

        NSString *tipText = @"请在\"设置 -> 隐私 -> 照片\"中，开启商+号图片的访问权限";
        label.text = tipText;
    }
    return _authorizationView;
}

@end
