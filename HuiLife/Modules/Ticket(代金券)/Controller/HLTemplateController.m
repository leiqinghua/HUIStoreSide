//
//  HLTemplateController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLTemplateController.h"
#import "HLTempleteCollectionCell.h"
#import "HLProductController.h"
#import "HLProduceReviewController.h"
#import "HLCardProductController.h"
#import "HLImagePickerController.h"

@interface HLTemplateController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,HLTempleteCollectionDelegate>

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(strong,nonatomic)UIImagePickerController * imagePicker;

@property(nonatomic,strong)HLTemplateModel * selectModel;

@property(nonatomic, assign)double mainScale;

@end

@implementation HLTemplateController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"选择主题"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self creatFootView];
    
    [self loadTempleteList];
    
    [self loadImageResizeScale];
}


- (void)loadImageResizeScale{
    [HLTools loadImageResizeScaleWithType:_isTicket?2:1 controller:self completion:^(double mainScale, double subScale) {
        self.mainScale = mainScale;
    }];
}

//确认主题
-(void)nextClick{
    if (!_isTicket) {// 卡，直接预览
        if (!_selectModel) {
            HLShowHint(@"请选择模板", self.view);
            return;
        }
        if (!_selectModel.selectImg) {
            [self.pargram setValue:_selectModel.Id forKey:@"themeId"];
        }
        
        HLCardProductController *cardProduct = [[HLCardProductController alloc] init];
        cardProduct.pargram = self.pargram;
        cardProduct.isTicket = self.isTicket;
        [self.navigationController pushViewController:cardProduct animated:YES];
        return;
    }
    
    //    代金券
    if (_selectModel.selectImg) {
        [self uploadImage];
        return;
    }
    if (_selectModel) {
        [self.pargram setValue:_selectModel.Id forKey:@"themeId"];
        HLProductController * product = [[HLProductController alloc]init];
        product.pargram = self.pargram;
        product.isTicket = _isTicket;
        [self hl_pushToController:product];
    }else{
        HLShowHint(@"请选择模板", self.view);
    }
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"确认主题" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLTempleteCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLTempleteCollectionCell" forIndexPath:indexPath];
    cell.model = self.datasource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//图库
        [self openAlbum];
        return;
    }
    HLTemplateModel * model = self.datasource[indexPath.row];
    if (![_selectModel isEqual:model]) {
        _selectModel.isUse = false;
        model.isUse = YES;
        _selectModel = model;
        [collectionView reloadData];
    }
}

- (void)openAlbum{
    HLImagePickerController *imagePicker = [[HLImagePickerController alloc] initWithNeedResize:NO maxSelectNum:1 singleSelect:YES mustResize:NO selectOrinal:NO resizeWHScale:_mainScale pickerBlock:^(NSArray<UIImage *> * _Nonnull images) {
        self.selectModel.isUse = false;
        HLTemplateModel * model0 = self.datasource[0];
        model0.selectImg = images.firstObject;
        model0.isUse = YES;
        self.selectModel = model0;
        [self.collectionView reloadData];
        if (!self.isTicket) {
            [self uploadImage];
        }
    }];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - HLTempleteCollectionDelegate
-(void)collectionCell:(HLTempleteCollectionCell *)cell deteleWithModel:(HLTemplateModel *)model{
    model.selectImg = nil;
    model.isUse = false;
    [self.collectionView reloadData];
}

#pragma mark - SET&GET
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        self.view.backgroundColor = UIColor.whiteColor;
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (ScreenW - FitPTScreen(6))/2;
        flowLayout.itemSize = CGSizeMake(width, FitPTScreen(144));
        flowLayout.minimumLineSpacing = 5.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(FitPTScreen(3), Height_NavBar, ScreenW - FitPTScreen(6), ScreenH - Height_NavBar - FitPTScreen(118)) collectionViewLayout:flowLayout];
        AdjustsScrollViewInsetNever(self, _collectionView);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[HLTempleteCollectionCell class] forCellWithReuseIdentifier:@"HLTempleteCollectionCell"];
    }
    return _collectionView;
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        HLTemplateModel * defaultModel = [[HLTemplateModel alloc]init];
        defaultModel.isDefault = YES;
        [_datasource addObject:defaultModel];
    }
    return _datasource;
}


-(void)loadTempleteList{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Couponmanager/getCouponTemp";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":self.isTicket?@(1):@(2)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            NSArray * datas = [HLTemplateModel mj_objectArrayWithKeyValuesArray:result.data];
            [self.datasource addObjectsFromArray:datas];
            [self.collectionView reloadData];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//上传图片
-(void)uploadImage{
    HLLoading(self.view);
    UIImage * selectImg = _selectModel.selectImg;
    NSData *fileData = [HLTools compressImage:selectImg toByte:2000 * 1024];
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Couponmanager/uploadFile";
        request.serverType = HLServerTypeStoreService;
        request.requestType = kXMRequestUpload;
        request.parameters = @{@"type":self.isTicket?@(1):@(2)};
        [request addFormDataWithName:@"fileImg" fileName:@"temp.jpg" mimeType:@"image/jpeg" fileData:fileData];
    } onProgress:^(NSProgress * _Nonnull progress) {
        
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self.pargram setValue:result.data[@"id"] forKey:@"themeId"];
            if (self.isTicket) {
                HLProductController * product = [[HLProductController alloc]init];
                product.pargram = self.pargram;
                product.isTicket = self.isTicket;
                [self hl_pushToController:product];
            }
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}



@end
