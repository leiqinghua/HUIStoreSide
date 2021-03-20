//
//  HLMatterMainController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterMainController.h"
#import "HLMatterCodeController.h"
#import "HLMatterHeadView.h"
#import "HLMatterItemViewCell.h"
#import "HLMatterMainInfo.h"
#import "HLMatterNoteController.h"
#import "HLMatterPreviewController.h"

@interface HLMatterMainController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) HLMatterHeadView *headView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *collectionViewTipLab;

@property (nonatomic, strong) UIView *noteView;

@property (nonatomic, strong) HLMatterMainInfo *mainInfo; // 提供数据的mainInfo

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page;

@end

@implementation HLMatterMainController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hl_setTitle:@"商家素材" andTitleColor:UIColorFromRGB(0x333333)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _noteView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _noteView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self creatSubUI];
    
    [self loadData];
    
    _noteView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW - FitPTScreen(125), 0, FitPTScreen(115), 44)];
    [self.navigationController.navigationBar addSubview:_noteView];
    [_noteView hl_addTarget:self action:@selector(showNoteView)];
    
    UIImageView *tipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ask_grey"]];
    [_noteView addSubview:tipImgV];
    [tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_noteView);
        make.right.equalTo(FitPTScreen(-0));
        make.height.width.equalTo(FitPTScreen(12));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [_noteView addSubview:tipLab];
    tipLab.text = @"素材使用说明";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tipImgV.left).offset(FitPTScreen(-7));
        make.centerY.equalTo(_noteView);
    }];
}

#pragma mark - User Action

/// 查看提示
- (void)showNoteView {
    HLMatterNoteController *matterNote = [[HLMatterNoteController alloc] init];
    matterNote.textArr = self.mainInfo.noteList;
    [self presentViewController:matterNote animated:NO completion:nil];
}

/// 头部点击查看二维码
- (void)headViewClick {
    
    if (!self.mainInfo) {
        HLShowHint(@"当前页面暂无数据", self.view);
        return;
    }
    
    HLMatterCodeController *codePreView = [[HLMatterCodeController alloc] init];
    codePreView.codeImgUrl = self.mainInfo.codeUrl;
    codePreView.navTitle = @"小程序二维码";
    [self.navigationController pushViewController:codePreView animated:YES];
}

#pragma mark - Private Method

/// 加载数据
- (void)loadData {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *_Nonnull request) {
        request.api = @"/Shopplus/Huibusimaterial/materialList";
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
    }];
}

/// 处理数据
- (void)handleResponseResult:(XMResult *)result {
    _mainInfo = [HLMatterMainInfo mj_objectWithKeyValues:result.data];
    _collectionViewTipLab.text = @"店内宣传展架";
    [_headView configTitle:@"二维码" desc:@"店铺小程序二维码" codeUrl:_mainInfo.codeUrl];
    
    [self.collectionView.mj_header endRefreshing];
    
    // 如果是第一页
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    
    if (_mainInfo.itemList.count == 0) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.collectionView.mj_footer endRefreshing];
        _collectionView.mj_footer.hidden = NO;
    }
    
    [self.dataSource addObjectsFromArray:_mainInfo.itemList];
    [self.collectionView reloadData];
}

/// 创建视图
- (void)creatSubUI {
    
    _headView = [[HLMatterHeadView alloc] init];
    [self.view addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Height_NavBar + FitPTScreen(22));
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(FitPTScreen(-13));
        make.height.equalTo(FitPTScreen(78));
    }];
    [_headView hl_addTarget:self action:@selector(headViewClick)];
    
    _collectionViewTipLab = [[UILabel alloc] init];
    [self.view addSubview:_collectionViewTipLab];
    _collectionViewTipLab.text = @"店内宣传展架";
    _collectionViewTipLab.textColor = UIColorFromRGB(0x333333);
    _collectionViewTipLab.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_collectionViewTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(26));
        make.top.equalTo(_headView.bottom).offset(FitPTScreen(25));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = FitPTScreen(15);
    layout.itemSize = CGSizeMake(FitPTScreen(155), FitPTScreen(185));
    layout.sectionInset = UIEdgeInsetsMake(FitPTScreen(0), FitPTScreen(23), FitPTScreen(23), FitPTScreen(23));
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = UIColor.whiteColor;
    [_collectionView registerClass:[HLMatterItemViewCell class] forCellWithReuseIdentifier:@"HLMatterItemViewCell"];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.top.equalTo(_collectionViewTipLab.bottom).offset(FitPTScreen(20));
    }];
    AdjustsScrollViewInsetNever(self, _collectionView);
    
    weakify(self);
//    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weak_self.page = 1;
//        [weak_self loadData];
//    }];
//    mj_header.lastUpdatedTimeLabel.hidden = YES;
    
//    _collectionView.mj_header = mj_header;
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
    HLMatterItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLMatterItemViewCell" forIndexPath:indexPath];
    cell.itemInfo = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HLMatterMainItemInfo *info = self.dataSource[indexPath.row];
    HLMatterPreviewController *preview = [[HLMatterPreviewController alloc] init];
    preview.bigImgUrl = info.bigImgUrl;
    preview.downloadUrl = info.downloadUrl;
    [self.navigationController pushViewController:preview animated:YES];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
