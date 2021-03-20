//
//  HomeViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/13.
//

#import "HomeViewController.h"
#import "HLHomeCollectionCell.h"
#import "HLHomeHeaderView.h"
#import "HLSetViewController.h"
#import "HLHomeShareController.h"
#import "HLGuideMask.h"
#import "HLGroupViewController.h"
#import "HLHomeGuideInfo.h"
#import "HLHeXiaoPassSetController.h"
#import "HLMarketController.h"
#import "MMScanViewController.h"
#import "HLReviewModel.h"
#import "HLReviewStatuAlert.h"
#import "HLReviewCheckController.h"
#import "HLReviewFailAlert.h"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HLHomeHeaderViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) NSDictionary *homeData;

@property (nonatomic, strong) HLGuideMask *guideMask;

@property (nonatomic, strong) HLHomeGuideInfo *guideInfo;
/// 用于半透明引导的记录
@property (nonatomic, assign) CGRect shareBtnFrame;

@property (nonatomic, assign) CGRect settingBtnFrame;

/// 是否在转场动画中
@property (nonatomic, assign) BOOL isTransAnimating;

@property(nonatomic, strong) HLReviewModel *reviewInfo; //审核信息

@end

@implementation HomeViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isTransAnimating = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    //设置导航栏透明
    [super viewWillAppear:animated];
    [self hl_setTransparentNavtion];
    _isTransAnimating = NO;
    [self controlShowStep1To3Guides];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadReviewWithHud:(self.dataSource.count == 0)];
}

- (void)hl_resetNetworkForAction{
    [self loadDataWithHud:NO];
}

//设置
- (void)setBtnClick {
//#if DEBUG
//    [HLTools pushAppPageLink:@"HLRedBagListController" params:@{} needBack:NO];
//#else
    HLSetViewController *setVC = [[HLSetViewController alloc] init];
    [self hl_pushToController:setVC];
//#endif
    
}

//分享
- (void)shareBtnClick{
#if DEBUG
    [HLTools pushAppPageLink:@"HLCompeteMainController" params:@{} needBack:NO];
#else
    [HLTools shareImageWithId:self.homeData[@"id"]?:@"" type:4 controller:self completion:^(NSDictionary * data) {
        HLHomeShareController * shareVC = [[HLHomeShareController alloc]init];
        shareVC.data = data;
        shareVC.Id = self.homeData[@"id"]?:@"";
        [self presentViewController:shareVC animated:false completion:nil];
    }];
#endif
}

// 展示1-5引导
- (void)showNo1To5Guides{
    
    if(isPad){return;};
    
    NSMutableArray *maskFrames = [NSMutableArray array];
    NSMutableArray *types = [NSMutableArray array];
    
    [types addObject:@(HLGuideMaskTypeNo1)];
    [maskFrames addObject:[NSValue valueWithCGRect:_shareBtnFrame]];
    
    [types addObject:@(HLGuideMaskTypeNo2)];
    [maskFrames addObject:[NSValue valueWithCGRect:[self collectionViewCellImageFrameWithIndex:3]]];
    
    [types addObject:@(HLGuideMaskTypeNo3)];
    [maskFrames addObject:[NSValue valueWithCGRect:[self collectionViewCellImageFrameWithIndex:0]]];
    
    [types addObject:@(HLGuideMaskTypeNo4)];
    [maskFrames addObject:[NSValue valueWithCGRect:[self collectionViewCellImageFrameWithIndex:6]]];
    
    [types addObject:@(HLGuideMaskTypeNo5)];
    [maskFrames addObject:[NSValue valueWithCGRect:[self collectionViewCellImageFrameWithIndex:5]]];
    
    weakify(self);
    [self.guideMask showMaskWithTypes:types maskFrames:maskFrames clickBlock:^(BOOL isFuncClick) {
        [HLGuideMask configShowGuide];
        if ([weak_self.guideInfo needShowStepGuide] ) {
            [self controlShowStep1To3Guides];
        }else{
            [weak_self.guideMask hideGuideView];
        }
    }];
}

/// 展示setp1 - stpe3引导
- (void)controlShowStep1To3Guides{
    
    if(isPad){return;};
    
    if (!self.guideInfo) {
        return;
    }
    
    if (![self.guideInfo needShowStepGuide]) {
        if (_guideMask) {
            [_guideMask hideGuideView];
            _guideMask = nil;
        }
        return;
    }
    
    if ([self controlShowStep1Mask]) {
        return;
    }
    
    if ([self controlShowStep2Mask]) {
        return;
    }
    
    if ([self controlShowStep3Mask]) {
        return;
    }
    
}

// 展示step1
- (BOOL)controlShowStep1Mask{
    // 判断接口返回是否显示，判断本地存储是否需要展示
    if ([self.guideInfo needShowStep1] && [HLGuideMask needShowStep1]) {
        [self.guideMask hideGuideView];
        weakify(self);
        [self.guideMask showMaskWithType:HLGuideMaskTypeStep1 maskFrame:_settingBtnFrame clickBlock:^(BOOL isFuncClick) {
            @strongify(self);
            [self.guideMask hideGuideView];
            [HLGuideMask configStep1ShowFlag];
            if (isFuncClick) {
                [self setBtnClick];
            }else{
                // 判断之后 2 3 是否需要展示
                if ([self controlShowStep2Mask]) {
                    return;
                }
                
                if ([self controlShowStep3Mask]) {
                    return;
                }
            }
        }];
        return YES;
    }
    return NO;
}

// 展示step2
- (BOOL)controlShowStep2Mask{
    weakify(self);
    if ([self.guideInfo needShowStep2] && [HLGuideMask needShowStep2]) {
        CGFloat maskWidth = 44;
        CGRect maskFrame = CGRectMake(ScreenW/4 * 3.5 - maskWidth/2, ScreenH - Height_Bottom_Margn - maskWidth,     maskWidth, maskWidth);
        [self.guideMask hideGuideView];
        [self.guideMask showMaskWithType:HLGuideMaskTypeStep2 maskFrame:maskFrame clickBlock:^(BOOL isFuncClick) {
            @strongify(self);
            [self.guideMask hideGuideView];
            [HLGuideMask configStep2ShowFlag];
            if(isFuncClick){
                [self.navigationController pushViewController:[HLHeXiaoPassSetController new] animated:YES];
            }else{
                // 判断3是否需要展示
                if ([self controlShowStep3Mask]) {
                    return;
                }
            }
        }];
        return YES;
    }
    return NO;
}

// 展示step3
- (BOOL)controlShowStep3Mask{
    weakify(self);
    if ([self.guideInfo needShowStep3]) {
        [self.guideMask hideGuideView];
        [self.guideMask showMaskWithType:HLGuideMaskTypeStep3 maskFrame:[self collectionViewCellImageFrameWithIndex:3] clickBlock:^(BOOL isFuncClick) {
            @strongify(self);
            
            self.guideInfo.three = NO;
            [self.guideMask hideGuideView];
            
            [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
                request.api = @"/Shopplus/Agentserver/guideThreeAdd";
                request.serverType = HLServerTypeStoreService;
                request.parameters = @{};
            }];
            
            if (isFuncClick) {
                [self.navigationController pushViewController:[HLMarketController new] animated:YES];
            }
        }];
        return YES;
    }
    return NO;
}

- (CGRect)collectionViewCellImageFrameWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    HLHomeCollectionCell *cell = (HLHomeCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect frame = [cell.topImageV convertRect:cell.topImageV.bounds toView:KEY_WINDOW];
    CGFloat margin = FitPTScreen(20);
    frame.size.width = frame.size.width + margin;
    frame.size.height = frame.size.height + margin;
    frame.origin.x = frame.origin.x - margin/2;
    frame.origin.y = frame.origin.y - margin/2;
    return frame;
}

#pragma notification
- (void)reloadUI:(NSNotification *)sender {
    [self loadDataWithHud:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册刷新界面的通知
    [HLNotifyCenter addObserver:self selector:@selector(reloadUI:) name:HLReloadHomeDataNotifi object:nil];
}

- (void)initView {
    if (_collectionView) return;
    self.view.backgroundColor = UIColor.whiteColor;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置headerview尺寸大小
    flowLayout.headerReferenceSize = CGSizeMake(ScreenW, FitPTScreen(197) + HIGHT_NavBar_MARGIN);
    flowLayout.itemSize = CGSizeMake(ScreenW / 3, FitPTScreen(110));
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - Height_TabBar) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = UIColor.whiteColor;
    [_collectionView registerClass:[HLHomeCollectionCell class] forCellWithReuseIdentifier:@"cellID"];
    [_collectionView registerClass:[HLHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    //防止cell被tabbar挡住而不能滑动
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //适配iOS11
    AdjustsScrollViewInsetNever(self, _collectionView);
    
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"set_withe_alpha"] forState:UIControlStateNormal];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    HLAccount *account = [HLAccount shared];
    // 如果是员工，那么就隐藏设置
    CGFloat maskW = 44;
    if (account.role == 3) {
        self.navigationItem.rightBarButtonItems = @[shareItem];
        _shareBtnFrame = CGRectMake(ScreenW - 13 - maskW , Height_StatusBar, maskW, maskW);
        _settingBtnFrame = CGRectZero;
    }else{
        self.navigationItem.rightBarButtonItems = @[setItem,shareItem];
        _shareBtnFrame = CGRectMake(ScreenW - maskW * 2 - 6, Height_StatusBar, maskW, maskW);
        _settingBtnFrame = CGRectMake(ScreenW - 13 - maskW , Height_StatusBar, maskW, maskW);
    }
    
    // 如果是ipad 隐藏分享
    if (isPad) {
        shareBtn.hidden = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.itemData = self.dataSource[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HLHomeHeaderView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        headerView.userInteractionEnabled = YES;
        headerView.dataDict = _homeData;
        headerView.reviewInfo = _reviewInfo;
        headerView.delegate = self;
        return headerView;
    }
    return nil;
}

#pragma mark - HLHomeHeaderViewDelegate
- (void)headerView:(HLHomeHeaderView *)headerView statu:(BOOL)statu {
    if (statu) {
        HLReviewStatuAlert *statuAlert = [[HLReviewStatuAlert alloc]init];
        statuAlert.statuInfos = _reviewInfo.censors;
        [self.navigationController presentViewController:statuAlert animated:NO completion:nil];
        return;
    }
    if (_reviewInfo.state == 0 || _reviewInfo.state == 8) {
        HLReviewCheckController *checkController = [[HLReviewCheckController alloc]init];
        checkController.statuInfos = _reviewInfo.explains;
        [self.navigationController presentViewController:checkController animated:NO completion:nil];
        return;
    }
    if (_reviewInfo.state == 5) {
        HLReviewFailAlert *failAlert = [[HLReviewFailAlert alloc]init];
        failAlert.info = _reviewInfo.history;
        weakify(self);
        failAlert.reCommitBlock = ^{
            dispatch_main_async_safe(^{
                HLReviewCheckController *checkController = [[HLReviewCheckController alloc]init];
                checkController.statuInfos = weak_self.reviewInfo.explains;
                [weak_self.navigationController presentViewController:checkController animated:NO completion:nil];
            });
        };
        [self.navigationController presentViewController:failAlert animated:NO completion:nil];
        return;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HLHomeModel *item = self.dataSource[indexPath.row];
    
    if (!item.iosArdess.length) {
        HLShowHint(@"敬请期待", self.view);
        return;
    }
    
    if ([item.iosArdess isEqualToString:@"MMScanViewController"]) {
        [self goToScanPage];
        return;
    }
    
    [HLTools pushAppPageLink:item.iosArdess params:item.iosParam needBack:false];
}

- (void)goToScanPage {
    weakify(self);
    MMScanViewController *scan = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        [weak_self scanOrderWithUrl:result];
    }];
    [self.navigationController pushViewController:scan animated:YES];
}

#pragma mark - request
- (void)loadDataWithHud:(BOOL)hud{
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/AppIndex.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
        request.httpMethod = kXMHTTPMethodPOST;
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initView];
            [self hl_hideNetFail];
            [self handleDataWithDict:result.data];
            return;
        }
        [self hl_showNetFail:self.view.bounds callBack:^{
            [self loadDataWithHud:YES];
        }];
        
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self hl_showNetFail:self.view.bounds callBack:^{
            [self loadDataWithHud:YES];
        }];
    }];
}

- (void)handleDataWithDict:(NSDictionary *)dict {
    _homeData = dict[@"storeInfo"];
    [HLAccount shared].store_id = _homeData[@"id"];
    [HLAccount shared].store_name = _homeData[@"name"];
    [HLAccount shared].store_address = _homeData[@"address"];
    [HLAccount saveAcount];
    _dataSource = [HLHomeModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    self.guideInfo = [HLHomeGuideInfo mj_objectWithKeyValues:dict[@"guideInfo"]];
    
    // 如果不是员工，才会展示引导图
    HLAccount *account = [HLAccount shared];
    if (account.role != 3) {
        // 如果当前不是最顶层，就不展示
        if (![[HLTools visiableController] isKindOfClass:[self class]] || self.isTransAnimating) {
            return;
        }
        if (![HLGuideMask alreadyShowGuide]) {
            [self showNo1To5Guides];
        }else{
            [self controlShowStep1To3Guides];
        }
    }
}

#pragma mark - 审核
- (void)loadReviewWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/ClientSide/UnionCard/AuditBusiness.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    }onSuccess:^(id responseObject) {
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            self.reviewInfo = [HLReviewModel mj_objectWithKeyValues:result.data];
        }
        [self loadDataWithHud:!self.dataSource.count];
    }onFailure:^(NSError *error) {
        [self loadDataWithHud:!self.dataSource.count];
    }];
}

#pragma mark - 扫一扫
- (void)scanOrderWithUrl:(NSString *)url {
    MMScanViewController *topScanVC = (MMScanViewController *)self.navigationController.topViewController;
    HLLoading(topScanVC.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/BusinessScan.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"url":url};
    } onSuccess:^(id responseObject) {
        HLHideLoading(topScanVC.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [HLTools pushAppPageLink:result.data[@"iosAddress"] params:result.data[@"iosParam"] needBack:false];
            NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
            [controllers removeObject:topScanVC];
            [self.navigationController setViewControllers:controllers];
            return;
        }
        [topScanVC restartScan];
    } onFailure:^(NSError *error) {
        HLHideLoading(topScanVC.view);
        [topScanVC restartScan];
    }];
}

#pragma mark - getter
- (HLGuideMask *)guideMask {
    if (!_guideMask) {
        _guideMask = [[HLGuideMask alloc] init];
    }
    return _guideMask;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HLReloadHomeDataNotifi object:nil];
}



@end
