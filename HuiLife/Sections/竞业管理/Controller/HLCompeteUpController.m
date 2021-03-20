//
//  HLCompeteUpController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/10.
//

#import "HLCompeteUpController.h"
#import "HLCompeteUpCollectionCell.h"
#import "HLSortView.h"
#import "HLCompeteUpPageInfo.h"
#import "HLLocationManager.h"

@interface HLCompeteUpController ()<UICollectionViewDelegate, UICollectionViewDataSource, HLSortViewDelegate, HLCompeteCollectionDelegate>
@property(nonatomic, strong) HLSortView *sortView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *sorts;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *datasource;
@end

@implementation HLCompeteUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserLocation];
//    下架或搜索页面 点击 上架 的通知
    [HLNotifyCenter addObserver:self selector:@selector(updateUpStateNotifi:) name:@"KupdateCompeteUpNotifi" object:nil];
//搜索页面 点完 下架的通知
    [HLNotifyCenter addObserver:self selector:@selector(downReloadDataNotifi:) name:@"KdownReloadDataNotifi" object:nil];
}

#pragma mark - Request
- (void)loadUserLocation{
    HLLoading(self.view);
    [[HLLocationManager shared] startLocationWithCallBack:^(BMKLocation *location) {
        [self loadClassData];
    }];
}

- (void)loadClassData {
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidCatory.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"big_id":@"1"};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handleClassData:result.data];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleClassData:(NSArray *)classes {
    NSArray *classInfos = [HLCompeteClassInfo mj_objectArrayWithKeyValuesArray:classes];
    NSMutableArray *titles = [NSMutableArray array];
    for (HLCompeteClassInfo *info in classInfos) {
        [titles addObject:info.class_name];
        HLCompeteUpPageInfo *pageInfo = [[HLCompeteUpPageInfo alloc]init];
        pageInfo.classInfo = info;
        [self.datasource addObject:pageInfo];
    }
    _sortView.datasource = titles;
    [_sortView sortViewSelectIndex:_page];
}

//请求列表
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    
    HLAccount *account = [HLAccount shared];
    HLCompeteUpPageInfo *pageInfo = self.datasource[_page];
    NSDictionary *pargram = @{
        @"big_id":@"1",
        @"class_id": pageInfo.classInfo.Id,
        @"pageNo"  : @(pageInfo.page),
        @"latitude":account.latitude?:@"",
        @"longitude": account.longitude?:@"",
        @"location" : account.locateJSON
    };
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handPageList:result.data[@"stores"]];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handPageList:(NSArray *)list {
    HLCompeteUpPageInfo *pageInfo = self.datasource[_page];
    NSArray *stores = [HLCompeteStoreInfo mj_objectArrayWithKeyValuesArray:list];
    pageInfo.noMoreData = !stores.count;
    pageInfo.showNodataView = YES;
    if (pageInfo.page == 1) {
        [pageInfo.stores removeAllObjects];
    }
    [pageInfo.stores addObjectsFromArray:stores];
    [self.collectionView reloadData];
}

//更新
- (void)updateWithPageInfo:(HLCompeteUpPageInfo *)pageInfo storeInfo:(HLCompeteStoreInfo *)storeInfo{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/StoreForbidEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"store_id":storeInfo.store_id,@"action":storeInfo.state==1?@(1):@(2)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            
            storeInfo.state = 1-storeInfo.state;
            [HLNotifyCenter postNotificationName:@"KcompeteDownReloadNotifi" object:storeInfo];
            
            HLCompeteUpPageInfo *pageInfo = self.datasource[_page];
            [pageInfo.stores removeObject:storeInfo];
            [self.collectionView reloadData];
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}


#pragma mark - Method
- (void)loadPageData {
    HLCompeteUpPageInfo *pageInfo = self.datasource[_page];
    if (!pageInfo.stores.count) {
        pageInfo.page = 1;
        [self loadListWithHud:YES];
    }
}

#pragma mark - Event
- (void)updateUpStateNotifi:(NSNotification *)sender {
    HLCompeteStoreInfo *storeInfo = (HLCompeteStoreInfo *)sender.object;
    for (HLCompeteUpPageInfo *pageInfo in self.datasource) {
        if ([storeInfo.hui_class_id isEqualToString:pageInfo.classInfo.Id]) {
            [pageInfo.stores insertObject:storeInfo atIndex:0];
            [self.collectionView reloadData];
            return;
        }
    }
}

- (void)downReloadDataNotifi:(NSNotification *)sender {
    HLCompeteStoreInfo *storeInfo = (HLCompeteStoreInfo *)sender.object;
    for (HLCompeteUpPageInfo *pageInfo in self.datasource) {
        if ([storeInfo.hui_class_id isEqualToString:pageInfo.classInfo.Id]) {
            HLCompeteStoreInfo *deleteInfo;
            for (HLCompeteStoreInfo *goodInfo in pageInfo.stores) {
                if ([goodInfo.store_id isEqualToString:storeInfo.store_id]) {
                    deleteInfo = goodInfo;
                    break;
                }
            }
            if (deleteInfo) {
                [pageInfo.stores removeObject:deleteInfo];
                [self.collectionView reloadData];
            }
            return;
        }
    }
}

#pragma mark - HLCompeteCollectionDelegate
- (void)upCollectionCell:(HLCompeteUpCollectionCell *)cell down:(BOOL)down {
    HLCompeteUpPageInfo *pageInfo = self.datasource[_page];
    if (down) pageInfo.page = 1;
    else pageInfo.page +=1;
    [self loadListWithHud:NO];
}

- (void)upCollectionCellUpdate:(HLCompeteStoreInfo *)storeInfo {
    HLCompeteUpPageInfo *pageInfo = self.datasource[_page];
    [self updateWithPageInfo:pageInfo storeInfo:storeInfo];
}
#pragma mark - HLSortViewDelegate
- (void)sortView:(HLSortView *)sortView selectAtIndex:(NSInteger)index {
    _page = index;
    [self.collectionView setContentOffset:CGPointMake(ScreenW *_page, 0)];
    [self loadPageData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / ScreenW;
    [_sortView sortViewSelectIndex:page];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLCompeteUpCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLCompeteUpCollectionCell" forIndexPath:indexPath];
    HLCompeteUpPageInfo *pageInfo = self.datasource[indexPath.row];
    cell.delegate = self;
    cell.pageInfo = pageInfo;
    return cell;
}


#pragma mark - UIView
- (void)initSubView {
    _sortView = [[HLSortView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(50))];
    _sortView.backgroundColor = UIColorFromRGB(0xf5f6f9);
    _sortView.delegate = self;
    [self.view addSubview:_sortView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ScreenW, CGRectGetMaxY(self.view.bounds) - CGRectGetMaxY(_sortView.frame));
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_sortView.frame), ScreenW, CGRectGetMaxY(self.view.bounds) - CGRectGetMaxY(_sortView.frame)) collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = UIColor.whiteColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    [self.view addSubview:_collectionView];
    AdjustsScrollViewInsetNever(self, _collectionView);
    
    
    [_collectionView registerClass:[HLCompeteUpCollectionCell class] forCellWithReuseIdentifier:@"HLCompeteUpCollectionCell"];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)dealloc {
    [HLNotifyCenter removeObserver:self];
}
@end
