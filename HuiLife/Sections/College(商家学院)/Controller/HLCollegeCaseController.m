//
//  HLCollegeCaseController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/28.
//

#import "HLCollegeCaseController.h"
#import "HLCaseListModel.h"
#import "HLPlayManager.h"

@interface HLCollegeCaseController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger page;

@end

@implementation HLCollegeCaseController

/// 这个不能去掉，因为修改导航栏样式是在 baseVC viewWillAppear,嵌套的是不需要实现该方法
- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatSubUI];
    self.page = 1;
}

#pragma mark - Private Method

/// 加载数据
- (void)loadData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
        request.api = @"/Shopplus/Shotcollege/caseList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(self.page)};
    }
    onSuccess:^(XMResult *_Nullable responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            [self handleResponseResult:responseObject];
        }else{
            self.page > 1 ? 1 : --self.page;
        }
    }
    onFailure:^(NSError *_Nullable error) {
        HLHideLoading(self.view);
        self.page > 1 ? 1 : --self.page;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

/// 处理数据
- (void)handleResponseResult:(XMResult *)result {
    
    NSArray *models = [HLCaseListModel mj_objectArrayWithKeyValuesArray:result.data[@"items"]];
        
    // 如果是第一页
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (models.count == 0) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.collectionView.mj_footer endRefreshing];
        _collectionView.mj_footer.hidden = NO;
    }
    
    [self.dataSource addObjectsFromArray:models];
    [self.collectionView reloadData];
}

/// 创建视图
- (void)creatSubUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = FitPTScreen(4);
    layout.itemSize = CGSizeMake(FitPTScreen(173), FitPTScreen(209));
    layout.sectionInset = UIEdgeInsetsMake(FitPTScreen(17), FitPTScreen(12), FitPTScreen(17), FitPTScreen(12));
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = UIColor.whiteColor;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    AdjustsScrollViewInsetNever(self, _collectionView);
    
    weakify(self);
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self loadData];
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    
    _collectionView.mj_header = mj_header;
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weak_self.page++;
        [weak_self loadData];
    }];
    _collectionView.mj_footer.hidden = YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell.contentView viewWithTag:999];
    if (!imageView) {
        imageView = [self creatSubImageViewWithSuperView:cell.contentView];
    }
    HLCaseListModel *listModel = self.dataSource[indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:listModel.cover_image] placeholderImage:[UIImage imageNamed:@"logo_default2"]];
    return cell;
}

- (UIImageView *)creatSubImageViewWithSuperView:(UIView *)superView {
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    imageView.layer.cornerRadius = FitPTScreen(7);
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 999;
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    return imageView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HLCaseListModel *listModel = self.dataSource[indexPath.row];
    HLPlayManager *playManager = [[HLPlayManager alloc] initWithVideoUrl:listModel.video preImgUrl:@""];
    playManager.centerTitle = listModel.title;
    [self.navigationController pushViewController:playManager animated:YES];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
