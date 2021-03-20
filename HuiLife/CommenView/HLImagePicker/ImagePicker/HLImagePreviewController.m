//
//  HLImagePreviewController.m
//  HuiLife
//
//  Created by 王策 on 2019/11/7.
//

#import "HLImagePreviewController.h"
#import "HLImagePreviewCell.h"
#import "HLImagePreviewNav.h"
#import "HLImagePickerToolBar.h"
#import "HLImageSmallControlView.h"
#import "JPImageresizerView.h"
#import "HLImagePickerManager.h"
#import "HLImagePickerService.h"
#import "HLImagePickerManager.h"
#import "HLImageRequestOperation.h"

#define kCellMargin 10

@interface HLImagePreviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,HLImagePreviewNavDelegate, HLImageSmallControlViewDelegate,HLImagePickerToolBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HLImagePreviewNav *previewNav;

@property (nonatomic, strong) HLImageSmallControlView *controlView;

@property (nonatomic, strong) HLImagePickerToolBar *toolBar;

@property (nonatomic, strong) JPImageresizerView *resizeView;

@property (nonatomic, assign) BOOL hideControlViews;

@property (nonatomic, assign) double progress;

// 这个是HLImagePickerManager 单例的 selectAssets
@property (nonatomic, strong) NSMutableArray<HLAsset *>* selectAssets;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, assign) BOOL isResizeing; // 正在裁减中

@end

@implementation HLImagePreviewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 配置底部原图是否选中
    [self.toolBar configOrinalSelect:[HLImagePickerManager shared].config.selectOrinal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    // 这个必须放在最开始
    self.selectAssets = [HLImagePickerManager shared].selectAssets;
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    AdjustsScrollViewInsetNever(self, self.collectionView);

    [self.view addSubview:self.previewNav];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.controlView];
    
    // 配置默认显示0
    [self refreshNaviBarAndBottomBarState];
    // 改变底部数量
    [self changeToolBarSelectNum];
    // 改变底部小控制视图的当前选择
    [self.controlView configSelectIndex:_currentIndex];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:NO];
    
    // 单选则隐藏右上角
    if ([HLImagePickerManager shared].config.singleSelect) {
        [self.previewNav hidenIndexView];
    }
    
    // 如果是单选并且强制裁减，直接进入编辑
    if ([HLImagePickerManager shared].config.singleSelect && [HLImagePickerManager shared].config.mustResize) {
        _currentIndex = 0;
        self.toolBar.hidden = YES;
        self.controlView.hidden = YES;
        [self leftButtonClickWithToolBar:self.toolBar];
    }
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 3;
}

#pragma mark - Private Method

// 刷新顶部
- (void)refreshNaviBarAndBottomBarState{
    // 更改顶部的状态
    HLAsset *asset = self.selectAssets[self.currentIndex];
    // 判断当前的asset是选中的第几个
    NSInteger assetIndex = 0;
    for (HLAsset *subAsset in self.selectAssets) {
        if (subAsset == asset) {
            break;
        }
        if (subAsset.select) {
            assetIndex++;
        }
    }
    // 0 就不显示下标了
    [self.previewNav configIndex:asset.select ? assetIndex + 1 : 0];
}

// 改变底部数量
- (void)changeToolBarSelectNum{
    NSInteger selectNum = 0;
    for (HLAsset *subAsset in self.selectAssets) {
        if (subAsset.select) {
            selectNum++;
        }
    }
    // 底部数量展示
    [self.toolBar configSelectNum:selectNum];
}

#pragma mark - 展示裁减

// 展示裁减
- (void)showResizeView:(UIImage *)image{
    [self creatResizeViewWithImage:image];
    self.resizeView.isLockResizeFrame = YES;
    [self.view addSubview:_resizeView];
    self.toolBar.hidden = YES;
    self.isResizeing = YES;
}

// 隐藏裁减
- (void)hideResizeView{
    self.isResizeing = NO;

    // 如果是单选，并且强制裁减，点击取消回到上一页面
    if ([HLImagePickerManager shared].config.singleSelect && [HLImagePickerManager shared].config.mustResize) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self.resizeView removeFromSuperview];
    self.resizeView = nil;
    self.toolBar.hidden = NO;
}

// 旋转
- (void)rotateResizeView{
    [self.resizeView rotation];
}

// 点击确定裁减
- (void)resizeButtonClick{
    HLLoading(self.view);
    [self.resizeView originImageresizerWithComplete:^(UIImage *resizeImage) {
        HLHideLoading(self.view);
        self.isResizeing = NO;
        self.toolBar.hidden = NO;
        HLAsset *asset = self.selectAssets[self.currentIndex];
        // 这里使用缓存存储
        [[HLImagePickerManager shared] saveImage:resizeImage assetId:asset.asset.localIdentifier];
        
        // 如果是单选并且强制裁减，直接返回了
        if ([HLImagePickerManager shared].config.singleSelect) {
            [self handleSelectAssetsAndBack];
            return;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        // 改变底部的
        [self.controlView configSelectIndex:self.currentIndex];
        [self.resizeView removeFromSuperview];
    }];
}

#pragma mark - HLImagePickerToolBarDelegate

// 点击编辑按钮
- (void)leftButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar{
    HLAsset *asset = self.selectAssets[_currentIndex];
    
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1) {
        HLShowHint(@"正在从iColoud同步照片", self.view);
        return;
    }
    
    HLLoading(self.view);
    [HLImagePickerService getPhotoWithAsset:asset.asset photoWidth:ScreenW completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isDegraded) {
                HLHideLoading(self.view);
                if (!photo) {
                    HLShowHint(@"未获取到源图片，请选取其他图片", self.view);
                }else{
                    [self showResizeView:photo];
                }
            }
        });
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    } networkAccessAllowed:YES];
}

// 原图
- (void)toolBar:(HLImagePickerToolBar *)tooBar orinalSelect:(BOOL)orinalSelect{
    [HLImagePickerManager shared].config.selectOrinal = YES;
}

// 选中
- (void)selectButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar{
    
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1) {
        HLShowHint(@"正在从iColoud同步照片", self.view);
        return;
    }
    
    // 如果有选中，并且需要强制裁减，没有裁减的，那么就记住
    __block BOOL allIsResized = YES;
    // 判断此时未选中的数量
    __block NSInteger selectCount = 0;
    
    [self.selectAssets enumerateObjectsUsingBlock:^(HLAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.select) {
            selectCount++;
            if (![[HLImagePickerManager shared] hasImageCacheWithAssetId:obj.asset.localIdentifier]) {
                allIsResized = NO;
            }
        }
    }];
    
    if (selectCount == 0) {
        HLShowHint(@"至少选择一张图片", self.view);
        return;
    }
    
    // 如果是必须要裁减，这里进行判断
    if ([HLImagePickerManager shared].config.mustResize && !allIsResized) {
        HLShowHint(@"请裁减所选择的图片", self.view);
        return;
    }
    
    // 移除未选中的
    for (NSInteger i = 0; i < self.selectAssets.count; i++) {
        HLAsset *asset = self.selectAssets[i];
        if (!asset.select) {
            // 这里再释放掉裁减后的图片
            [[HLImagePickerManager shared] removeCacheImageWithAssetId:asset.asset.localIdentifier];
            [[HLImagePickerManager shared] removeAsset:asset];
            i--;
        }
    }
    
    // 处理成image并返回
    [self handleSelectAssetsAndBack];
}

// 处理返回的结果
- (void)handleSelectAssetsAndBack{
//    HLImagePickerManager *manager = [HLImagePickerManager shared];
//    HLLoading(self.view);
//    [HLImagePickerService imagesWithAssets:self.selectAssets needOrinalImage:manager.config.selectOrinal finishBlock:^(NSArray * _Nonnull images) {
//        HLHideLoading(self.view);
//        if (manager.pickerBlock) {
//            manager.pickerBlock(images);
//        }
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    }];
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger i = 0; i < self.selectAssets.count; i++) { [photos addObject:@1];}
    __block BOOL havenotShowAlert = YES;
    __block UIAlertController *alertView;
    HLLoading(self.view);
    for (NSInteger i = 0; i < self.selectAssets.count; i++) {
        HLAsset *model = self.selectAssets[i];
        HLImageRequestOperation *operation = [[HLImageRequestOperation alloc] initWithAsset:model.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
            if (isDegraded) return;
            
            if (photo) {
                [photos replaceObjectAtIndex:i withObject:photo];
            }
            // 如果是强制裁减，并且有缓存图片
            UIImage *cacheImage = [[HLImagePickerManager shared] cacheImageWithAssetId:model.asset.localIdentifier];
            if (cacheImage) {
                [photos replaceObjectAtIndex:i withObject:cacheImage];
            }
            
            for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
            
            if (havenotShowAlert) {
                [self hideAlertView:alertView];
                
                HLHideLoading(self.view);
                HLImagePickerManager *manager = [HLImagePickerManager shared];
                if (manager.pickerBlock) {
                    manager.pickerBlock(photos);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            // 如果图片正在从iCloud同步中,提醒用户
            if (progress < 1 && havenotShowAlert && !alertView) {
                havenotShowAlert = NO;
                return;
            }
            if (progress >= 1) {
                havenotShowAlert = YES;
            }
        }];
        [self.operationQueue addOperation:operation];
    }
}

- (void)hideAlertView:(UIAlertController *)alertView {
    [alertView dismissViewControllerAnimated:YES completion:nil];
    alertView = nil;
}

- (UIAlertController *)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

#pragma mark - HLImagePreviewNavDelegate

// 页面返回
- (void)pageBackWithPreviewNav:(HLImagePreviewNav *)previewNav{
    [self.navigationController popViewControllerAnimated:YES];
}

// 控制是否选中
-(void)previewNav:(HLImagePreviewNav *)previewNav changedSelected:(BOOL)selected{
    HLAsset *asset = self.selectAssets[self.currentIndex];
    // 更改选中x状态，暂时不移除
    asset.select = selected;
    
    if (!selected) {
        // 直接取消选中
        [previewNav configIndex:0];
    }else{
        [self refreshNaviBarAndBottomBarState];
    }
    
    // 改变底部数量
    [self changeToolBarSelectNum];
    
    // 改变底部小控制视图的当前选择
    [self.controlView configSelectIndex:_currentIndex];
}

#pragma mark - HLImageSmallControlViewDelegate

// 点击小的
- (void)controlView:(HLImageSmallControlView *)controlView selectIndex:(NSInteger)index{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:NO];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectAssets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLImagePreviewCell" forIndexPath:indexPath];
    HLAsset *asset = self.selectAssets[indexPath.row];
     __weak typeof(self) weakSelf = self;
    [cell setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.progress = progress;
    }];
    cell.asset = asset;
    weakify(self);
    cell.clickBlock = ^{
        if (!weakSelf.isResizeing) {
            weak_self.hideControlViews = !self.hideControlViews;
            weak_self.previewNav.hidden = self.hideControlViews;
            weak_self.toolBar.hidden = self.hideControlViews;
            weak_self.controlView.hidden = self.hideControlViews;
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[HLImagePreviewCell class]]) {
        [(HLImagePreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[HLImagePreviewCell class]]) {
        [(HLImagePreviewCell *)cell recoverSubviews];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth + (self.collectionView.lx_width * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.collectionView.lx_width);
    if (currentIndex < self.selectAssets.count && self.currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 改变底部小控制视图的当前选择
    [self.controlView configSelectIndex:_currentIndex];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 改变底部小控制视图的当前选择
    [self.controlView configSelectIndex:_currentIndex];
}

#pragma mark - Getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat collectionViewWidth = self.view.bounds.size.width + 2 * kCellMargin;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(collectionViewWidth, self.view.bounds.size.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kCellMargin, 0, collectionViewWidth, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(collectionViewWidth * self.selectAssets.count, self.view.bounds.size.height);
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[HLImagePreviewCell class] forCellWithReuseIdentifier:@"HLImagePreviewCell"];
    }
    return _collectionView;
}

- (HLImagePreviewNav *)previewNav{
    if (!_previewNav) {
        _previewNav = [HLImagePreviewNav previewNav];
        _previewNav.delegate = self;
    }
    return _previewNav;
}

- (HLImageSmallControlView *)controlView{
    if (!_controlView) {
        _controlView = [[HLImageSmallControlView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.toolBar.frame) - FitPTScreen(100), ScreenW, FitPTScreen(100)) assets:self.selectAssets];
        _controlView.delegate = self;
    }
    return _controlView;
}

-(HLImagePickerToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[HLImagePickerToolBar alloc] initWithFrame:CGRectMake(0, ScreenH - 50 - Height_Bottom_Margn, ScreenW, 50) type:HLImagePickerToolBarTypeEdit];
        _toolBar.delegate = self;
        if (![HLImagePickerManager shared].config.needResize) {
            [_toolBar hideEditBtn];
        }
    }
    return _toolBar;
}

-(JPImageresizerView *)creatResizeViewWithImage:(UIImage *)image{
    
    UIButton *okButton = [[UIButton alloc] init];
    
    CGFloat resizeWHScale = [HLImagePickerManager shared].config.resizeWHScale;
    _resizeView = [[JPImageresizerView alloc] initWithResizeImage:image frame:CGRectMake(0, 0, ScreenW, ScreenH) maskType:(JPNormalMaskType) frameType:(JPConciseFrameType) animationCurve:(JPAnimationCurveEaseInOut) strokeColor:UIColor.whiteColor bgColor:UIColor.blackColor maskAlpha:0.5 verBaseMargin:10 horBaseMargin:0 resizeWHScale:resizeWHScale contentInsets:UIEdgeInsetsZero borderImage:nil borderImageRectInset:CGPointZero imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        okButton.backgroundColor = isPrepareToScale ? UIColor.lightGrayColor : UIColorFromRGB(0xFFAB33);
        okButton.userInteractionEnabled = !isPrepareToScale;
    }];
    
    [_resizeView addSubview:okButton];
    okButton.tag = 10001;
    [okButton setTitle:@"选取" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    okButton.backgroundColor = UIColorFromRGB(0xFFAB33);
    okButton.layer.cornerRadius = 4;
    okButton.layer.masksToBounds = YES;
    [okButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [okButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-Height_Bottom_Margn -FitPTScreen(13));
        make.right.equalTo(- FitPTScreen(13));
        make.height.equalTo(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(61));
    }];
    [okButton addTarget:self action:@selector(resizeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [_resizeView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-Height_Bottom_Margn -FitPTScreen(13));
        make.left.equalTo(FitPTScreen(10));
        make.height.equalTo(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(61));
    }];
    [cancelButton addTarget:self action:@selector(hideResizeView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rotateButton = [[UIButton alloc] init];
    [_resizeView addSubview:rotateButton];
    [rotateButton setImage:[UIImage imageNamed:@"image_resize_rotate"] forState:UIControlStateNormal];
    [rotateButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelButton.top).offset(-FitPTScreen(5));
        make.centerX.equalTo(cancelButton);
        make.height.equalTo(FitPTScreen(40));
        make.width.equalTo(FitPTScreen(40));
    }];
    [rotateButton addTarget:self action:@selector(rotateResizeView) forControlEvents:UIControlEventTouchUpInside];
    return _resizeView;
}


@end
