//
//  HLStoreImageController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLStoreImageController.h"
#import "HLMutableImageCell.h"
#import "ALiImagePickerController.h"
#import "ALiAsset.h"
#import "HLImageSinglePickerController.h"
#import "HLHotSekillImageModel.h"
#import "HLImageUpTool.h"
#import "HLImagePickerController.h"

@interface HLStoreImageController ()<UITableViewDelegate,UITableViewDataSource,HLPickerImageDelegate>

@property(nonatomic,strong)UITableView * tableView;

//保存单张图片
@property(nonatomic,strong)NSMutableArray * singleImages;

//保存多张图片
@property(nonatomic,strong)NSMutableArray * mutableImages;

@property(nonatomic,strong) HLBaseUploadModel *singleImgModel;

@property(nonatomic,strong) NSMutableArray<HLBaseUploadModel *> *mutImgModels;

@property (nonatomic, strong) HLImageUpTool *imageUpTool;

@property(nonatomic, assign)double mainScale;

@end

@implementation HLStoreImageController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"门店图册" andTitleColor:UIColorFromRGB(0x222222)];
    [self hl_hideBack:YES];
}

- (HLBaseUploadModel *)builImageModelWithImage:(UIImage *)image{
    HLBaseUploadModel *imageModel = [[HLBaseUploadModel alloc] init];
    imageModel.image = image;
    imageModel.saveName = @"ul";
    imageModel.postParams = @{@"type" : @"1"};
    imageModel.uploadedImgUrlKey = @"imgPath";
    imageModel.requestApi = @"/MerchantSide/UploadImage.php?dev=1";
    return imageModel;
}

- (HLBaseUploadModel *)imageModelWithData:(NSDictionary *)data pic:(NSString *)pic{
    if (!data.count) {
        return nil;
    }
    HLBaseUploadModel *imageModel = [[HLBaseUploadModel alloc] init];
    imageModel.saveName = @"ul";
    imageModel.postParams = @{@"type" : @"1"};
    imageModel.uploadedImgUrlKey = @"imgPath";
    imageModel.requestApi = @"/MerchantSide/UploadImage.php?dev=1";
    imageModel.imgUrl = pic;
    imageModel.responseData = data;
    return imageModel;
}

//取消
-(void)cancelBtnClick{
    [self hl_goback];
}

//上传
- (void)uploadBtnClick{
    
    if (!_singleImgModel) {
        HLShowHint(@"请上传店铺logo", self.view);
        return;
    }
    
    if (!self.mutImgModels.count) {
        [self updateImages];
        return;
    }
    
    HLLoading(self.view);
    weakify(self);
    [self.imageUpTool asyncConcurrentGroupUploadArray:self.mutImgModels uploading:^{
        
    } completion:^{
        HLHideLoading(weak_self.view);
        [weak_self updateImages];
    }];
}


- (void)updateImages{
    
    NSMutableArray * album = [NSMutableArray array];
    [self.mutImgModels enumerateObjectsUsingBlock:^(HLBaseUploadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.imgUrl.length) {
            [album addObject:obj.responseData];
        }
    }];
    NSString * logo = _singleImgModel.imgUrl;
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UpdateStoreAlbum.php?dev=1";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"logo":logo?:@"",@"album":[album mj_JSONString]};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLNotifyCenter postNotificationName:HLReloadSetPageNotifi object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


#pragma mark - HLNotifyCenter
- (void)reload{
    [self.tableView reloadData];
}

- (void)loadImageResizeScale{
    [HLTools loadImageResizeScaleWithType:5 controller:self completion:^(double mainScale, double subScale) {
        self.mainScale = mainScale;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCancel];
    [self creatFootView];
    
    _singleImgModel = [self imageModelWithData:@{@"id":@"",@"imgPath":_storePic} pic:_storePic];
    
    [self loadDefaultDatas];
    
    [HLNotifyCenter addObserver:self selector:@selector(reload) name:HLDeleteImageNotifi object:nil];
    
    [self loadImageResizeScale];
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton * uploadBtn = [[UIButton alloc]init];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload_btn"] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [footView addSubview:uploadBtn];
    [uploadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initCancel{
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.estimatedRowHeight = FitPTScreen(135);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        AdjustsScrollViewInsetNever(self, _tableView);
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLMutableImageCell * cell = [HLMutableImageCell dequeueReusableCell:tableView];
    cell.single = indexPath.section == 0;
    cell.delegate = self;
    cell.images = indexPath.section == 0?self.singleImages:self.mutableImages;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [tableView headerViewForSection:section];
    if (!headerView) {
        headerView = [[UIView alloc]init];
        headerView.backgroundColor = UIColor.whiteColor;
        UILabel * titleLb = [[UILabel alloc]init];
        titleLb.tag = 1000;
        titleLb.textColor = UIColorFromRGB(0x333333);
        titleLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [headerView addSubview:titleLb];
        [titleLb makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(27));
            make.centerY.equalTo(headerView);
        }];
    }
    
    UILabel * lable = [headerView viewWithTag:1000];
    lable.text = section == 0?@"店铺图册":@"店内环境图册";
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreen(51);
}


#pragma mark - HLPickerImageDelegate

//删除
-(void)deleteImageWithIndex:(NSInteger)index single:(BOOL)single{
    if (single) {
        _singleImgModel = nil;
    }else{
        [self.mutImgModels removeObjectAtIndex:index];
    }
    
    if (self.mutImgModels.count <9) {
        id obj = self.mutableImages.lastObject;
        if ([obj isKindOfClass:[NSString class]]) {
            if (![obj isEqualToString:@"add_photo"]) {
                [self.mutableImages addObject:@"add_photo"];
            }
        }else if ([obj isKindOfClass:[UIImage class]]){
            [self.mutableImages addObject:@"add_photo"];
        }
    }
}


- (void)imageCell:(HLMutableImageCell *)cell pickerWithSingle:(BOOL)single{
    if (single) {
        weakify(self);
        HLImageSinglePickerController * picker = [[HLImageSinglePickerController alloc]initWithAllowsEditing:YES callBack:^(UIImage * _Nonnull image) {
            [weak_self.singleImages removeAllObjects];
            [weak_self.singleImages addObject:image];
            [weak_self.tableView reloadData];
            weak_self.singleImgModel = [weak_self builImageModelWithImage:image];
            HLLoading(weak_self.view);
            [weak_self.imageUpTool asyncConcurrentGroupUploadArray:@[weak_self.singleImgModel] uploading:^{
            } completion:^{
                HLHideLoading(weak_self.view);
            }];
        }];
        [self.navigationController presentViewController:picker animated:YES completion:nil];
        return;
    }
    
    HLImagePickerController *imagePickerVC = [[HLImagePickerController alloc] initWithNeedResize:YES maxSelectNum:(9 - self.mutImgModels.count) singleSelect:NO mustResize:NO selectOrinal:NO resizeWHScale:_mainScale pickerBlock:^(NSArray<UIImage *> * _Nonnull images) {
        [self addImageWithArray:images single:single];
    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

-(void)addImageWithArray:(NSArray *)assets single:(BOOL)single{
    if (single) {
        return;
    }
    [self.mutableImages removeLastObject];
    [assets enumerateObjectsUsingBlock:^(UIImage* _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.mutableImages addObject:asset];
        HLBaseUploadModel *ImgModel = [self builImageModelWithImage:asset];
        [self.mutImgModels addObject:ImgModel];
    }];
    if (self.mutableImages.count < 9) {
        [self.mutableImages addObject:@"add_photo"];
    }
    [self.tableView reloadData];
}


#pragma mark - SET&GET
-(NSMutableArray *)singleImages{
    if (!_singleImages) {
        _singleImages = [NSMutableArray array];
        //        默认按钮
        [_singleImages addObject:_storePic.length?_storePic:@"logo_grey"];
    }
    return _singleImages;
}

-(NSMutableArray *)mutableImages{
    if (!_mutableImages) {
        _mutableImages = [NSMutableArray array];
    }
    return _mutableImages;
}

-(HLImageUpTool *)imageUpTool{
    if (!_imageUpTool) {
        _imageUpTool = [[HLImageUpTool alloc] init];
    }
    return _imageUpTool;
}

-(NSMutableArray<HLBaseUploadModel *> *)mutImgModels{
    if (!_mutImgModels) {
        _mutImgModels = [NSMutableArray array];
    }
    return _mutImgModels;
}

-(void)loadDefaultDatas{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/BusinessAlbum.php?dev=1";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self.view addSubview:self.tableView];
            NSArray * pics = result.data[@"album"];
            for (NSDictionary * pic in pics) {
                [self.mutImgModels addObject:[self imageModelWithData:pic pic:pic[@"imgPath"]]];
                [self.mutableImages addObject:pic[@"imgPath"]];
            }
            
            if (self.mutableImages.count < 9) {
                [self.mutableImages addObject:@"add_photo"];
            }
            [self.tableView reloadData];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


@end
