//
//  HLHotSekillPickImageController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/3.
//

#import "HLHotSekillPickImageController.h"
#import "HLHotSekillImageViewCell.h"
#import "HLHotBuyImageHeader.h"
#import "HLImagePickerController.h"

@interface HLHotSekillPickImageController ()<UICollectionViewDelegate,UICollectionViewDataSource,HLHotSekillImageViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) dispatch_semaphore_t semaphore_t;
@property (nonatomic, strong) dispatch_queue_t uploadQueue;

@property (nonatomic, assign) double mainScale;
@property (nonatomic, assign) double subScale;

@end

@implementation HLHotSekillPickImageController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"秒杀商品图册" andTitleColor:UIColorFromRGB(0x333333)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.collectionView);
    [self creatFootViewWithButtonTitle:@"确定上传"];
    
    [self loadImageResizeScale];
}

#pragma mark - Event
/// 保存数据
- (void)saveButtonClick{
    // 找到主图
    NSString *firstImage = nil;
    NSMutableArray *picArr = [NSMutableArray array];
    
    if ([self.dataSource.firstObject count] < 3) {
        HLShowText(@"主图最少上传3张");
        return;
    }
    
    for (HLHotSekillImageModel *imageModel in self.dataSource[0]) {
        
        if (imageModel.uploadStatus == HLBaseUploadStatusUploading) {
            HLShowText(@"还有图片在上传，请稍等...")
            return;
        }
        
        if (imageModel.isNormal || imageModel.uploadStatus != HLBaseUploadStatusUploaded) {
            continue;
        }
        
        if (imageModel.isFirst) {
            firstImage = imageModel.imgUrl;
        }
        [picArr addObject:imageModel.responseData];
    }
    
    // 说明没有任何图片
    if (picArr.count == 0) {
        HLShowText(@"未选择图片或图片上传失败，请重试");
        return;
    }
    
    if (!firstImage) {
        HLShowText(@"请选择商品主图")
        return;
    }
    
    // 拿到详情图数组
    NSMutableArray *detailPicArr = [NSMutableArray array];
    for (HLHotSekillImageModel *imageModel in self.dataSource[1]) {
        
        if (imageModel.uploadStatus == HLBaseUploadStatusUploading) {
            HLShowText(@"还有图片在上传，请稍等...")
            return;
        }
        
        if (imageModel.uploadStatus != HLBaseUploadStatusUploaded || imageModel.imgUrl.length == 0) {
            continue;
        }
        [detailPicArr addObject:imageModel.responseData];
    }
    
    if (detailPicArr.count == 0) {
        HLShowText(@"请选择商品详情图")
        return;
    }

    [self.buildParams setValue:firstImage forKey:@"logo"];
    [self.buildParams setValue:[picArr mj_JSONString] forKey:@"album"];
    [self.buildParams setValue:[detailPicArr mj_JSONString] forKey:@"master"];
    
    HLLoading(self.view);
   [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
       request.api = @"/MerchantSide/SeckillInsert.php?dev=1";
       request.serverType = HLServerTypeNormal;
       request.parameters = self.buildParams;
   } onSuccess:^(XMResult *  _Nullable responseObject) {
       HLHideLoading(self.view);
       if ([responseObject code] == 200) {
           HLShowText(@"保存成功");
           [HLNotifyCenter postNotificationName:@"hotSekillListReloadData" object:nil];
           [HLNotifyCenter postNotificationName:@"dayDealListReloadData" object:nil];
           [self hl_popToControllerWithClassName:@[@"HLHotSekillListController",@"HLDayDealGoodController"]];
       }
   } onFailure:^(NSError * _Nullable error) {
       HLHideLoading(self.view);
   }];
}

#pragma mark - Method
// 加载数据
- (void)loadImageResizeScale{
    [HLTools loadImageResizeScaleWithType:3 controller:self completion:^(double mainScale, double subScale) {
        self.mainScale = mainScale;
        self.subScale = subScale;
    }];
}

/// 选择的图片回调
- (void)handleSelectImages:(NSArray *)images indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *uploadModels = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(UIImage* _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HLHotSekillImageModel *imageModel = [self buildSekillImageModelWithImage:image];
        NSMutableArray *sectionArr = self.dataSource[indexPath.section];

        // 如果此时indexPath.section == 0 && 对应的section0Arr的数量为1，就自动设置为主图
        if (sectionArr.count == 1 && indexPath.section == 0) {
            imageModel.isFirst = YES;
        }
        [uploadModels addObject:imageModel];
        
        [sectionArr insertObject:imageModel atIndex:0];
    }];
    [self.collectionView reloadData];
    [self uploadImageModels:uploadModels];
}

// 通过Image构建HLHotSekillImageModel
- (HLHotSekillImageModel *)buildSekillImageModelWithImage:(UIImage *)image{
    HLHotSekillImageModel *imageModel = [[HLHotSekillImageModel alloc] init];
    imageModel.image = image;
    imageModel.saveName = @"ul";
    imageModel.postParams = @{@"type" : @"2"};
    imageModel.uploadedImgUrlKey = @"imgPath";
    imageModel.requestApi = @"/MerchantSide/UploadImage.php?dev=1";
    return imageModel;
}

/// 上传图片
- (void)uploadImageModels:(NSArray *)uploadImageModels{
    for (HLHotSekillImageModel *imageModel in uploadImageModels) {
        dispatch_async(self.uploadQueue, ^{
            dispatch_semaphore_wait(self.semaphore_t, DISPATCH_TIME_FOREVER);
            [imageModel asyncConcurrentUploadSuccess:^{
                dispatch_semaphore_signal(self.semaphore_t);
            } progress:nil failure:^{
                dispatch_semaphore_signal(self.semaphore_t);
            }];
        });
    }
}

#pragma mark - HLHotSekillImageViewCellDelegate
/// 删除
- (void)imageCell:(HLHotSekillImageViewCell *)cell deleteImageModel:(HLHotSekillImageModel *)imageModel{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSMutableArray *sectionArr = self.dataSource[indexPath.section];
    [sectionArr removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

/// 编辑主图
- (void)imageCell:(HLHotSekillImageViewCell *)cell editImageModel:(HLHotSekillImageModel *)imageModel{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    // section1 或者是主图就直接return
    if (indexPath.section == 1 || imageModel.isFirst) {
        return;
    }
    
    NSMutableArray *sectionArr = self.dataSource[indexPath.section];
    [sectionArr enumerateObjectsUsingBlock:^(HLHotSekillImageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isFirst = (imageModel == obj);
    }];
    [self.collectionView reloadData];
}

/// 点击重新上传
- (void)imageCell:(HLHotSekillImageViewCell *)cell reUploadImageModel:(HLHotSekillImageModel *)imageModel{
    imageModel.uploadStatus = HLBaseUploadStatusNone;
    [self uploadImageModels:@[imageModel]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray *sectionArr = self.dataSource[section];
    return sectionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLHotSekillImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLHotSekillImageViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.hideSelect = indexPath.section == 1;
    cell.imageModel = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 判断是否是+号的cell,不是的话，直接return
    HLHotSekillImageModel *imageModel = self.dataSource[indexPath.section][indexPath.row];
    if (imageModel.isNormal) {
        
        // 数量限制 默认有个＋号的
        if ([self.dataSource.firstObject count] >= 7 && indexPath.section == 0) {
            HLShowText(@"主图最多上传6张");
            return;
        }
        
        if ([self.dataSource.lastObject count] >= 21 && indexPath.section == 1) {
            HLShowText(@"商品详情图，最多20张");
            return;
        }
        
        // 计算最大选择数
        BOOL mustResize = indexPath.section == 0;
        double resizeScale = indexPath.section == 0 ? self.mainScale : self.subScale;
        
        NSInteger maxNum = 9;
        if(indexPath.section == 0){
            NSInteger nowNum = [self.dataSource.firstObject count] - 1;
            NSInteger sumNum = 6;
            maxNum = sumNum - nowNum > 9 ? 0 : sumNum - nowNum;
        }else{
            NSInteger sumNum = 20;
            NSInteger nowNum = [self.dataSource.lastObject count] - 1;
            maxNum = sumNum - nowNum > 9 ? 9 : sumNum - nowNum;
        }
        
        HLImagePickerController *imagePicker = [[HLImagePickerController alloc] initWithNeedResize:YES maxSelectNum:maxNum singleSelect:NO mustResize:mustResize selectOrinal:NO resizeWHScale:resizeScale pickerBlock:^(NSArray <UIImage *>*images) {
            [self handleSelectImages:images indexPath:indexPath];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HLHotBuyImageHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HLHotBuyImageHeader" forIndexPath:indexPath];
    header.title = indexPath.section == 0 ? @"推荐导读图" : @"商品详情图";
    header.subTitle = indexPath.section == 0 ? @"最少上传3张" : @"";
    return header;
}

#pragma mark - UIView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = FitPTScreen(15);
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(ScreenW, FitPTScreen(34));
        layout.sectionInset = UIEdgeInsetsMake(FitPTScreen(19), FitPTScreen(14), FitPTScreen(19), FitPTScreen(5));
        layout.itemSize = CGSizeMake(FitPTScreen(114), FitPTScreen(104));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[HLHotSekillImageViewCell class] forCellWithReuseIdentifier:@"HLHotSekillImageViewCell"];
        [_collectionView registerClass:[HLHotBuyImageHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HLHotBuyImageHeader"];
    }
    return _collectionView;
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    self.collectionView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(110));
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSMutableArray *section0Arr = [NSMutableArray array];
        NSMutableArray *section1Arr = [NSMutableArray array];

        HLHotSekillImageModel *normalImgModel = [[HLHotSekillImageModel alloc] init];
        normalImgModel.isNormal = YES;
        [section0Arr addObject:normalImgModel];

        HLHotSekillImageModel *normalImgModel2 = [[HLHotSekillImageModel alloc] init];
        normalImgModel2.isNormal = YES;
        [section1Arr addObject:normalImgModel];
        
        [_dataSource addObject:section0Arr];
        [_dataSource addObject:section1Arr];
    }
    return _dataSource;
}

-(dispatch_semaphore_t)semaphore_t{
    if (!_semaphore_t) {
        _semaphore_t = dispatch_semaphore_create(5);
    }
    return _semaphore_t;
}

- (dispatch_queue_t)uploadQueue{
    if (!_uploadQueue) {
        _uploadQueue = dispatch_queue_create("com.hotgoodimage.upload", DISPATCH_QUEUE_CONCURRENT);
    }
    return _uploadQueue;
}


@end
