//
//  HLImageAssetController.m
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import "HLImageAssetController.h"
#import "HLImagePickerService.h"
#import "HLAssetCollectionViewCell.h"
#import "HLImagePickerToolBar.h"
#import "HLImagePreviewController.h"
#import "HLImagePickerManager.h"

#define kTooBarHeight 50

@interface HLImageAssetController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,HLAssetCollectionViewCellDelegate,HLImagePickerToolBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) NSMutableArray<HLAsset *>* assets;

@property (nonatomic, strong) HLImagePickerToolBar *toolBar;

@end

@implementation HLImageAssetController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    NSMutableArray *selectAssets = [HLImagePickerManager shared].selectAssets;
    NSMutableArray *selectAssetIds = [HLImagePickerManager shared].selectAssetIds;
    
    // 判断如果此时有数据
    if (selectAssets.count > 0) {
        for (NSInteger i = 0; i < selectAssets.count; i++) {
            HLAsset *asset = selectAssets[i];
            if (!asset.select) {
                // 移除，并且id中也移除
                [selectAssets removeObjectAtIndex:i];
                [selectAssetIds removeObject:asset.asset.localIdentifier];
                // 裁减过的也移除缓存
                [[HLImagePickerManager shared] removeCacheImageWithAssetId:asset.asset.localIdentifier];
                i--;
            }
        }
        [self.collectionView reloadData];
    }
    // 更改底部的按钮
    [self.toolBar configSelectNum:selectAssets.count];
    // 配置底部原图是否选中
    [self.toolBar configOrinalSelect:[HLImagePickerManager shared].config.selectOrinal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.title = self.album.name;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolBar];
    AdjustsScrollViewInsetNever(self, self.collectionView);
    
    // 如果是单张选择
    if ([HLImagePickerManager shared].config.singleSelect) {
        self.toolBar.hidden = YES;
        self.collectionView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - Height_Bottom_Margn);
    }
    
    // 然后加载所有图片
    [self loadAllAssets];
}

- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PrivateMethod

// 加载图片
- (void)loadAllAssets{
    self.assets = [self.album.models mutableCopy];
    
    NSMutableArray *selectModels = [HLImagePickerManager shared].selectAssets;
    NSMutableSet *selectedAssets = [NSMutableSet setWithCapacity:selectModels.count];
    for (HLAsset *model in selectModels) {
        [selectedAssets addObject:model.asset];
    }
    for (HLAsset *model in self.assets) {
        model.select = NO;
        if ([selectedAssets containsObject:model.asset]) {
            model.select = YES;
        }
    }
    
    [self.collectionView reloadData];
}

// 打开设置页面
- (void)settingBtnClick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

// 拍照
- (void)takePhoto{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSString *message = @"请在\"设置 -> 隐私 -> 相机\"中，开启商+号相机的访问权限";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相机" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self settingBtnClick];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self openCamera];
                });
            }
        }];
    } else {
        [self openCamera];
    }
}

// 打开相机
- (void)openCamera{
    // 拍照获取图片
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePickerVc.sourceType = sourceType;
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - HLImagePickerToolBarDelegate

// 预览
- (void)leftButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar{
    
    NSMutableArray *selectModels = [HLImagePickerManager shared].selectAssets;
    
    if (selectModels.count == 0) {
        HLShowHint(@"请选取相片", self.view);
        return;
    }
    
    HLImagePreviewController *preview = [[HLImagePreviewController alloc] init];
    [self.navigationController pushViewController:preview animated:YES];
}

// 原图
- (void)toolBar:(HLImagePickerToolBar *)tooBar orinalSelect:(BOOL)orinalSelect{
    [HLImagePickerManager shared].config.selectOrinal = YES;
}

// 选中预览
- (void)selectButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar{
    
    NSMutableArray *selectModels = [HLImagePickerManager shared].selectAssets;

    if (selectModels.count == 0) {
        HLShowHint(@"请选择图片", self.view);
        return;
    }
    
    HLImagePreviewController *preview = [[HLImagePreviewController alloc] init];
    preview.currentIndex = 0;
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark - HLAssetCollectionViewCellDelegate

// 选中或者取消选中
-(void)assetCollectionViewCell:(HLAssetCollectionViewCell *)cell selected:(BOOL)selected{
    HLAsset *asset = cell.asset;
    asset.select = selected;
    
    NSMutableArray *selectModels = [HLImagePickerManager shared].selectAssets;
    
    if (selected) {
        
        // 判断是否大于最大选中数量
        NSInteger maxSelectNum = [HLImagePickerManager shared].config.maxSelectNum;
        if (selectModels.count >= maxSelectNum) {
            NSString *errorTip = [NSString stringWithFormat:@"最多选择%ld张",(long)maxSelectNum];
            HLShowHint(errorTip, self.view);
            asset.select = NO;
            return;
        }
        
        // 添加进选中的数组
        [[HLImagePickerManager shared] addSelectAsset:asset];
        
        // 单个的话，直接修改cell
        [cell configSelectStateIndex:selectModels.count - 1];
        
        // 设置强制裁减 && 选中了 && 没有裁减过 就显示裁减提示lab
        HLImagePickerManager *manager = [HLImagePickerManager shared];
        BOOL isResized = [[HLImagePickerManager shared] hasImageCacheWithAssetId:asset.asset.localIdentifier];
        BOOL showResizeTip = manager.config.mustResize && asset.select && !isResized && !manager.config.singleSelect;
        [cell configResizeTipLab:showResizeTip];
        
    }else{
        // 移除选中的数组
        [[HLImagePickerManager shared] removeAsset:asset];
        // 裁减过的也移除缓存
        [[HLImagePickerManager shared] removeCacheImageWithAssetId:asset.asset.localIdentifier];
        // 取消隐式动画
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadData];
        }];
    }
    
    // 更改底部的按钮
    [self.toolBar configSelectNum:selectModels.count];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        if (![cell.contentView viewWithTag:999]) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"takephoto"]];
            [cell.contentView addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = cell.bounds;
        }
        return cell;
    }else{
        HLAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLAssetCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        HLAsset *asset = self.assets[indexPath.row - 1];
        // 设置下标
        [cell configAsset:asset arrayIndex:[[HLImagePickerManager shared] indexWithAssetId:asset.asset.localIdentifier]];
        // 设置强制裁减 && 选中了 && 没有裁减过（根据缓存的裁减图片进行判断） 就显示裁减提示lab
        HLImagePickerManager *manager = [HLImagePickerManager shared];
        BOOL isResized = [manager hasImageCacheWithAssetId:asset.asset.localIdentifier];
        BOOL showResizeTip = manager.config.mustResize && asset.select && !isResized && !manager.config.singleSelect;
        [cell configResizeTipLab:showResizeTip];
        // 如果是单选，不显示勾选按钮
        if (manager.config.singleSelect) {
            [cell configSelectButtonHidden];
        }
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 如果是单张选择
    if ([HLImagePickerManager shared].config.singleSelect) {
        // 拍照
        if (indexPath.row == 0) {
            [self takePhoto];
            return;
        }
        
        // 单张预览
        HLAsset *asset = self.assets[indexPath.row - 1];
        [self selectSingleAssetToPreView:asset];
        
        return;
    }
    
    NSMutableArray *selectModels = [HLImagePickerManager shared].selectAssets;
    NSMutableArray *selectModelIds = [HLImagePickerManager shared].selectAssetIds;

    // 如果是多选
    if (indexPath.row == 0) {
        // 判断是否大于最大选中数量
        NSInteger maxSelectNum = [HLImagePickerManager shared].config.maxSelectNum;
        if (selectModels.count >= maxSelectNum) {
            NSString *errorTip = [NSString stringWithFormat:@"最多选择%ld张",(long)maxSelectNum];
            HLShowHint(errorTip, self.view);
            return;
        }
        
        [self takePhoto];
        return;
    }
    
    HLAsset *asset = self.assets[indexPath.row - 1];
    if (!asset.select) {
        
        // 判断是否大于最大选中数量
        NSInteger maxSelectNum = [HLImagePickerManager shared].config.maxSelectNum;
        if (selectModels.count >= maxSelectNum) {
            NSString *errorTip = [NSString stringWithFormat:@"最多选择%ld张",(long)maxSelectNum];
            HLShowHint(errorTip, self.view);
            return;
        }
        
        asset.select = YES;
        if (![selectModels containsObject:asset]) {
            [selectModels addObject:asset];
            [selectModelIds addObject:asset.asset.localIdentifier];
        }
        
        HLAssetCollectionViewCell *cell = (HLAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // 单个的话，直接修改cell
        [cell configSelectStateIndex:selectModels.count - 1];
        
        // 设置强制裁减 && 选中了 && 没有裁减过 就显示裁减提示lab（根据是否有缓存裁减图片判断）
        HLImagePickerManager *manager = [HLImagePickerManager shared];
        BOOL isResized = [manager hasImageCacheWithAssetId:asset.asset.localIdentifier];
        BOOL showResizeTip = manager.config.mustResize && asset.select && !isResized && !manager.config.singleSelect;
        [cell configResizeTipLab:showResizeTip];
    }
    
    // 多张图片预览
    [self selectMoreAssetsToPreViewCurrentIndex:[selectModelIds indexOfObject:asset.asset.localIdentifier]];
}

// 单张图片直接进入到预览
- (void)selectSingleAssetToPreView:(HLAsset *)asset{
    
    asset.select = YES;
    [[HLImagePickerManager shared] clearSelectAsset];
    [[HLImagePickerManager shared] addSelectAsset:asset];
    
    HLImagePreviewController *preview = [[HLImagePreviewController alloc] init];
    preview.currentIndex = 0;
    [self.navigationController pushViewController:preview animated:YES];
}

// 选择多张图片进入到预览
- (void)selectMoreAssetsToPreViewCurrentIndex:(NSInteger)currentIndex{
    HLImagePreviewController *preview = [[HLImagePreviewController alloc] init];
    preview.currentIndex = currentIndex;
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
    if (photo) {
        [HLImagePickerService savePhotoWithImage:photo meta:meta location:nil completion:^(PHAsset *asset, NSError *error) {
            if(asset){
                
                HLAsset *hl_asset = [[HLAsset alloc] init];
                hl_asset.asset = asset;
                hl_asset.select = YES;
                [[HLImagePickerManager shared] addSelectAsset:hl_asset];
                [self.assets insertObject:hl_asset atIndex:0];
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
                
                // 如果是单张预览
                if ([HLImagePickerManager shared].config.singleSelect) {
                    [self selectSingleAssetToPreView:hl_asset];
                }
            }else{
                NSLog(@"保存图片失败，请重试");
            }
        }];
    }
}

#pragma mark - Getter

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    return _imagePickerVc;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGFloat margin = 3;
        CGFloat columnCount = 4;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        CGFloat itemWidth = (ScreenW - (columnCount + 1) * margin) / columnCount - 1;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - kTooBarHeight - Height_Bottom_Margn) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[HLAssetCollectionViewCell class] forCellWithReuseIdentifier:@"HLAssetCollectionViewCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [self.view addSubview:_collectionView];
    }
    
    return _collectionView;
}

- (HLImagePickerToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[HLImagePickerToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), CGRectGetWidth(self.collectionView.frame), kTooBarHeight) type:HLImagePickerToolBarTypePreview];
        _toolBar.delegate = self;
    }
    return _toolBar;
}



@end
