//
//  HLVoucherCodeController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/4.
//

#import "HLVoucherCodeController.h"
#import "HLVoucherCodeViewCell.h"
#import "MMScanViewController.h"
#import "HLMatterCodeController.h"

@interface HLVoucherCodeController () <UICollectionViewDataSource,UICollectionViewDelegate,HLVoucherCodeViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *placeView; // 占位图

@end

@implementation HLVoucherCodeController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"买单牌列表" andTitleColor:UIColorFromRGB(0x333333)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.placeView];

    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    AdjustsScrollViewInsetNever(self, self.collectionView);
    
    [self creatFootView];
    
    [self loadCodeList];
}

/// 加载数据
- (void)loadCodeList{
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Agentserver/payBillControl";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            self.dataSource = [HLVoucherCodeInfo mj_objectArrayWithKeyValuesArray:responseObject.data[@"items"]];
            [self.collectionView reloadData];
            
            self.placeView.hidden = self.dataSource.count > 0;
            self.collectionView.hidden = self.dataSource.count == 0;
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *scanBtn = [[UIButton alloc] init];
    [footView addSubview:scanBtn];
    [scanBtn setTitle:@"扫一扫 快速绑定" forState:UIControlStateNormal];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [scanBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [scanBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scanBtnClick{
    weakify(self);
    MMScanViewController *scan = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        [weak_self bindCodeWithCodeNum:result];
    }];
    [self.navigationController pushViewController:scan animated:YES];
}

/// 绑定
- (void)bindCodeWithCodeNum:(NSString *)codeNum{
    MMScanViewController *topScanVC = (MMScanViewController *)self.navigationController.topViewController;
    HLLoading(topScanVC.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/Shopplus/Agentserver/boundToPay";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"payId":codeNum};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(topScanVC.view);
        
        if ([responseObject code] == 200) {
            [self.navigationController popToViewController:self animated:YES];
            // 构建一个新的
            HLVoucherCodeInfo *codeInfo = [HLVoucherCodeInfo mj_objectWithKeyValues:responseObject.data];
            [self.dataSource addObject:codeInfo];
            [self.collectionView reloadData];
            
            self.placeView.hidden = self.dataSource.count > 0;
            self.collectionView.hidden = self.dataSource.count == 0;
        }else{
            [topScanVC restartScan];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(topScanVC.view);
        [topScanVC restartScan];
    }];
}

#pragma mark - HLVoucherCodeViewCellDelegate

/// 保存图片
- (void)codeViewCell:(HLVoucherCodeViewCell *)cell downImgUrl:(NSString *)imgUrl{
    HLLoading(self.view);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        HLHideLoading(self.view);
        if (image) {
            // 保存到本地
            [HLTools saveImageToLocal:image];
        }else{
            HLShowText(@"下载失败，请重试");
        }
    }];
}

/// 删除
-(void)codeViewCell:(HLVoucherCodeViewCell *)cell deleteCodeInfo:(HLVoucherCodeInfo *)codeInfo{
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"确定删除此项?" buttonTitles:@[@"取消",@"确认删除"] buttonColors:@[UIColorFromRGB(0x333333),UIColorFromRGB(0xFF9F16)] callBack:^(NSInteger index) {
        if (index == 1) {
            HLLoading(self.view);
            [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
                request.api = @"/Shopplus/Agentserver//delBillControl";
                request.serverType = HLServerTypeStoreService;
                request.parameters = @{@"plateId":codeInfo.Id};
            } onSuccess:^(XMResult *  _Nullable responseObject) {
                HLHideLoading(self.view);
                if ([responseObject code] == 200) {
                    [self.dataSource removeObject:codeInfo];
                    [self.collectionView reloadData];
                    
                    self.placeView.hidden = self.dataSource.count > 0;
                    self.collectionView.hidden = self.dataSource.count == 0;
                    HLShowHint(@"删除成功", self.view);
                }
            } onFailure:^(NSError * _Nullable error) {
                HLHideLoading(self.view);
            }];
        }
    }];
}

#pragma mark - UICollectionViewCell

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLVoucherCodeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLVoucherCodeViewCell" forIndexPath:indexPath];
    cell.codeInfo = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HLMatterCodeController *codePreView = [[HLMatterCodeController alloc] init];
    HLVoucherCodeInfo *codeInfo = self.dataSource[indexPath.row];
    codePreView.codeImgUrl = codeInfo.bigUrl;
    codePreView.navTitle = @"预览";
    [self.navigationController pushViewController:codePreView animated:YES];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = FitPTScreen(5);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(FitPTScreen(9), FitPTScreen(15), FitPTScreen(9), FitPTScreen(15));
        layout.itemSize = CGSizeMake(FitPTScreen(98), FitPTScreen(125));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(91)) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[HLVoucherCodeViewCell class] forCellWithReuseIdentifier:@"HLVoucherCodeViewCell"];
    }
    return _collectionView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (UIView *)placeView{
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _placeView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_order_default"]];
        [_placeView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(178));
            make.centerX.equalTo(_placeView);
            make.width.equalTo(FitPTScreen(104));
            make.height.equalTo(FitPTScreen(71));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        [_placeView addSubview:tipLab];
        tipLab.text = @"暂无买单牌子";
        tipLab.textColor = UIColorFromRGB(0x999999);
        tipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [tipLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.bottom).offset(FitPTScreen(19));
            make.centerX.equalTo(_placeView);
        }];
    }
    return _placeView;
}

@end
