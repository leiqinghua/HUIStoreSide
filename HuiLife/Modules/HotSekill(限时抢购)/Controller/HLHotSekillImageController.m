//
//  HLHotSekillImageController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillImageController.h"
#import "HLHotSekillImageViewCell.h"
#import "HLImageUpTool.h"
#import "HLImagePickerController.h"

@interface HLHotSekillImageController () <UICollectionViewDelegate,UICollectionViewDataSource,HLHotSekillImageViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) dispatch_semaphore_t semaphore_t;
@property (nonatomic, strong) dispatch_queue_t uploadQueue;

@property (nonatomic, assign) double mainScale;

@end

@implementation HLHotSekillImageController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"图册"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图册";
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.collectionView);
    [self creatFootViewWithButtonTitle:@"完成发布"];
    [self loadImageResizeScale];
}

// 加载数据
- (void)loadImageResizeScale{
    [HLTools loadImageResizeScaleWithType:4 controller:self completion:^(double mainScale, double subScale) {
        self.mainScale = mainScale;
    }];
}

/// 保存数据
- (void)saveButtonClick{
    
    // 如果没有图片
    if (self.dataSource.count == 1) {
        HLShowHint(@"请选择图片", self.view);
        return;
    }
    
    // 是否有主图
    BOOL hasFirst = NO;
    for (HLHotSekillImageModel *imageModel in self.dataSource) {
        
        if (imageModel.uploadStatus == HLBaseUploadStatusUploading) {
            HLShowText(@"还有图片在上传，请稍等...")
            return;
        }
        
        if(imageModel.isFirst){
            hasFirst = YES;
        }
    }
    
    if (!hasFirst) {
        HLShowHint(@"请选择主图", self.view);
        return;
    }
   
    [self saveData];
}

/// 提交数据
- (void)saveData{
    
    // 主图url
    NSString *firstImageUrl = @"";
    // 其余图片
    NSMutableArray *mArr = [NSMutableArray array];
    for (HLHotSekillImageModel *model in self.dataSource) {
        
        if (model.isNormal) {
            continue;
        }
        
        if (model.isFirst) {
            firstImageUrl = model.imgUrl?:@"";
        }else{
            if (model.responseData.count) {
                [mArr addObject:model.responseData];
            }
        }
    }
    
    [self.buildParams setValue:firstImageUrl forKey:@"logo"];
    [self.buildParams setValue:[mArr mj_JSONString] forKey:@"album"];
//    [self.buildParams setValue:firstImageUrl forKey:@"master"];
    
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
            [self hl_popToControllerWithClassName:@[@"HLHotSekillListController"]];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
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

/// 选择的图片回调
- (void)handleSelectImages:(NSArray *)images indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *uploadModels = [NSMutableArray array];
        
    for (NSInteger i = images.count - 1; i >= 0; i--) {
        UIImage *image = images[i];
        HLHotSekillImageModel *imageModel = [self buildSekillImageModelWithImage:image];
        [uploadModels addObject:imageModel];
        [self.dataSource insertObject:imageModel atIndex:0];
    }
    
    [self.collectionView reloadData];
    [self uploadImageModels:uploadModels];
}

- (HLHotSekillImageModel *)buildSekillImageModelWithImage:(UIImage *)image{
    HLHotSekillImageModel *imageModel = [[HLHotSekillImageModel alloc] init];
    imageModel.image = image;
    imageModel.saveName = @"ul";
    imageModel.postParams = @{@"type" : @"2"};
    imageModel.uploadedImgUrlKey = @"imgPath";
    imageModel.requestApi = @"/MerchantSide/UploadImage.php?dev=1";
    return imageModel;
}


#pragma mark - HLHotSekillImageViewCellDelegate

/// 删除
- (void)imageCell:(HLHotSekillImageViewCell *)cell deleteImageModel:(HLHotSekillImageModel *)imageModel{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

/// 编辑主图
-(void)imageCell:(HLHotSekillImageViewCell *)cell editImageModel:(HLHotSekillImageModel *)imageModel{
    if (imageModel.isFirst) {
        return;
    }
    [self.dataSource enumerateObjectsUsingBlock:^(HLHotSekillImageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isFirst = (imageModel == obj);
    }];
    [self.collectionView reloadData];
}

/// 点击重新上传
- (void)imageCell:(HLHotSekillImageViewCell *)cell reUploadImageModel:(HLHotSekillImageModel *)imageModel{
    imageModel.uploadStatus = HLBaseUploadStatusNone;
    [self uploadImageModels:@[imageModel]];
}

#pragma mark - UICollectionViewCell

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLHotSekillImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLHotSekillImageViewCell" forIndexPath:indexPath];
    cell.imageModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 判断是否是+号的cell,不是的话，直接return
    HLHotSekillImageModel *imageModel = self.dataSource[indexPath.row];
    if (imageModel.isNormal) {
        
        // 默认有个+号的
        if(self.dataSource.count >= 10){
            HLShowHint(@"最多上传9张图片", self.view);
            return;
        }
        
        // 计算最大选择数

        NSInteger nowNum = [self.dataSource count] - 1;
        NSInteger maxNum = 9 - nowNum;
        
        HLImagePickerController *imagePicker = [[HLImagePickerController alloc] initWithNeedResize:YES maxSelectNum:maxNum singleSelect:NO mustResize:YES selectOrinal:NO resizeWHScale:self.mainScale pickerBlock:^(NSArray * _Nonnull images) {
                [self handleSelectImages:images indexPath:indexPath];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = FitPTScreen(15);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(FitPTScreen(19), FitPTScreen(14), FitPTScreen(19), FitPTScreen(5));
        layout.itemSize = CGSizeMake(FitPTScreen(114), FitPTScreen(104));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[HLHotSekillImageViewCell class] forCellWithReuseIdentifier:@"HLHotSekillImageViewCell"];
    }
    return _collectionView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        HLHotSekillImageModel *normalImgModel = [[HLHotSekillImageModel alloc] init];
        normalImgModel.isNormal = YES;
        [_dataSource addObject:normalImgModel];
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

