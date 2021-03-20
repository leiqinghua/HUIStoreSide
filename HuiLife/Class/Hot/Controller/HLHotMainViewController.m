//
//  HLHotMainViewController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/17.
//

#import "HLHotMainViewController.h"
#import "HLHotTitleScrollView.h"
#import "HLHotSubClassView.h"
#import "HLHotPromoteCollectionCell.h"
#import "HLHotControllerHelper.h"
#import "HLHotMainModel.h"
#import "HLHotToast.h"
#import "HLMemberChangeController.h"
#import "HLBLEManager.h"

@interface HLHotMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HLHotTitleScrollViewDelegate, HLHotSubClassViewDelegate, HLHotControllerDelegate, HLHotPromoteCollectionDelegate>
{
    NSTimer *_timer;
    BOOL _showdToast; //判断是不是第一次弹框
   __block NSInteger _toastIndex; //当前吐司索引
}
@property(nonatomic, strong) HLHotTitleScrollView *titleScrollView;

@property(nonatomic, strong) HLHotSubClassView *hotSubClassView;

@property(nonatomic, strong) UICollectionView *collectionView;
//一级分类
@property(nonatomic, strong) NSArray *bigClasses;

@property(nonatomic, strong) NSArray *subClasses;
//用于请求
@property(nonatomic, strong) HLHotControllerHelper *mainHelper;
//选择的bigClass
@property(nonatomic, strong) HLHotClass *selectBigClass;
//选择的subClass
@property(nonatomic, strong) HLHotClass *selectSubClass;
//数据源
@property(nonatomic, strong) NSMutableArray *hotMainModes;
//吐司
@property(nonatomic, strong) HLHotToast *tipToast;
///吐司提示
@property(nonatomic, strong) NSMutableArray *hotToasts;

@end

@implementation HLHotMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"爆客推广" andTitleColor:UIColorFromRGB(0x222222)];
    [self hl_setBackgroundColor:UIColor.whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_timer setFireDate:[NSDate date]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf4f5f4);
    _mainHelper = [[HLHotControllerHelper alloc]initWithDelegate:self];
    
    weakify(self);
    [_mainHelper hl_mainRequestBigClassWithLoading:^(BOOL loading) {
        if (loading) {
            HLLoading(weak_self.view);
        } else HLHideLoading(weak_self.view);
    }];
    
//    自动连接打印机
    if ([HLAccount shared].printSet) {
        [[HLBLEManager shared] autoConnectPrinter];
    }
}

- (void)initTitleView {
    if (_titleScrollView) return;
    _titleScrollView = [[HLHotTitleScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(40))];
    _titleScrollView.delegate = self;
    [self.view addSubview:_titleScrollView];
}

- (void)initHotSubClassView {
    if (_hotSubClassView) return;
    _hotSubClassView = [[HLHotSubClassView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), ScreenW, FitPTScreen(58))];
    _hotSubClassView.delegate = self;
    [self.view addSubview:_hotSubClassView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGFloat hight = ScreenH - CGRectGetMaxY(self.hotSubClassView.frame) - Height_TabBar;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(ScreenW, hight);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.hotSubClassView.frame), ScreenW, hight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromRGB(0xf4f5f4);
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        AdjustsScrollViewInsetNever(self, _collectionView);
        
        [_collectionView registerClass:[HLHotPromoteCollectionCell class] forCellWithReuseIdentifier:@"HLHotPromoteCollectionCell"];
    }
    return _collectionView;
}

#pragma mark - HLHotTitleScrollViewDelegate
//点击一级分类
- (void)hl_hotTitleView:(HLHotTitleScrollView *)titleView selectAtIndex:(NSInteger)index {
    HLHotClass *bigClass = self.bigClasses[index];
    if ([bigClass.Id isEqualToString:_selectBigClass.Id]) {
        return;
    }
    _selectBigClass = bigClass;
    //请求二级分类
    weakify(self);
    [_mainHelper hl_mainRequestSubClassWithBigId:bigClass.Id loading:^(BOOL loading) {
        if (loading) {
            HLLoading(weak_self.view);
        } else HLHideLoading(weak_self.view);
    }];
}

#pragma mark - HLHotSubClassViewDelegate
//点击二级分类
- (void)hl_hotSubView:(HLHotSubClassView *)hotSubView selectAtIndex:(NSInteger)index {
    [_collectionView setContentOffset:CGPointMake(index*ScreenW, 0) animated:NO];
    HLHotClass * subClass = self.subClasses[index];
    _selectSubClass = subClass;
    HLHotMainModel *mainModel = self.hotMainModes[index];
    NSArray *lists = mainModel.datasource;
    if (!lists.count) {
        weakify(self);
        [self.mainHelper hl_mainRequestListWithBigId:_selectBigClass.Id subId:subClass.Id page:mainModel.curPage loading:^(BOOL loading) {
            if (loading) {
                HLLoading(weak_self.view);
            } else HLHideLoading(weak_self.view);
        }];
    }
    
}

#pragma mark - HLHotControllerDelegate
//一级分类请求结果
- (void)hl_mainRequestResultWithBigClasses:(NSArray *)bigClasses {
    weakify(self);
    if (!bigClasses) {
        [self hl_showNetFail:self.view.bounds callBack:^{
            [_mainHelper hl_mainRequestBigClassWithLoading:^(BOOL loading) {
                if (loading) {
                    HLLoading(weak_self.view);
                } else HLHideLoading(weak_self.view);
            }];
        }];
        return;
    }
    [self hl_hideNetFail];
    [self initTitleView];
    _bigClasses = bigClasses;
    NSMutableArray *titles = [NSMutableArray array];
    for (HLHotClass *model in bigClasses) {
        [titles addObject:model.class_name];
    }
    _titleScrollView.titles = titles;
    
}
//二级分类请求结果
- (void)hl_mainRequestResultWithSubClasses:(NSArray *)subClasses {
   
    _subClasses = subClasses;
    NSMutableArray *titles = [NSMutableArray array];
    for (HLHotClass *model in subClasses) {
        [titles addObject:model.class_name];
    }
    
    [self.hotMainModes removeAllObjects];
    for (HLHotClass *sub in subClasses) {
        HLHotMainModel *mainModel = [[HLHotMainModel alloc]init];
        mainModel.bigId = _selectBigClass.Id;
        mainModel.subId = sub.Id;
        [self.hotMainModes addObject:mainModel];
    }
    //    必须放最后
    [self initHotSubClassView];
    _hotSubClassView.titles = titles;
}

//请求列表结果
- (void)hl_mainList:(NSArray *)lists page:(NSInteger)page noMore:(BOOL)noMore {
    
    if (!_collectionView) {
        [self.view addSubview:self.collectionView];
    }
    NSInteger index = [self.subClasses indexOfObject:self.selectSubClass];
    HLHotMainModel *mainModel = self.hotMainModes[index];
    mainModel.showNotView = YES;
    mainModel.curPage = page;
    mainModel.isMore = noMore;
    NSMutableArray *datasource = mainModel.datasource;
    if (page == 1) {
        [datasource removeAllObjects];
    }
    [datasource addObjectsFromArray:lists];
    [self.collectionView reloadData];
    
    if (!_timer && lists.count) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(requestToast) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}

//请求列表吐司
- (void)requestToast {
    if ([HLAccount shared].isLogin) {
        weakify(self);
        [_mainHelper hl_requestToastWithResult:^(NSArray * _Nonnull toasts) {
            [weak_self.hotToasts addObjectsFromArray:toasts];
            if (weak_self.hotToasts.count && !self->_showdToast) {
                   self->_showdToast = YES;
                   [weak_self showToast];
               }
        }];
    }
}

- (void)showToast {
    [self.view addSubview:self.tipToast];
    if (_toastIndex < self.hotToasts.count ) {
        HLHotToastModel *toast = self.hotToasts[_toastIndex];
        self.tipToast.model = toast;
    } else {
        _showdToast = NO;
        return;
    }
    [self.tipToast.layer removeAllAnimations];
    CATransition *animation = [[CATransition alloc]init];
    animation.duration = 0.3;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    self.tipToast.alpha = 1;
    [self.tipToast.layer addAnimation:animation forKey:@"animation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        self.tipToast.alpha = 0;
        [self.tipToast.layer addAnimation:animation forKey:@"animation2"];
        self->_toastIndex ++ ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self showToast];
           });
    });
}

//cell 的代理
#pragma mark - HLHotPromoteCollectionDelegate
//下拉刷新 上啦加载
- (void)hl_refreshListWithMainModel:(HLHotMainModel *)mainModel {
    [self.mainHelper hl_mainRequestListWithBigId:mainModel.bigId subId:mainModel.subId page:mainModel.curPage loading:^(BOOL loading) {
        
    }];
}

//进详情
- (void)hl_selectItemWithListModel:(HLHotListModel *)listModel {
    HLMemberChangeController *memberChangeVC = [[HLMemberChangeController alloc]init];
    memberChangeVC.Id = listModel.Id;
    [self.navigationController pushViewController:memberChangeVC animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotMainModes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLHotPromoteCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLHotPromoteCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.mainModel = self.hotMainModes[indexPath.row];
    return cell;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    [_hotSubClassView hotSubClassViewClickAtIndex:index];
}

#pragma mark - getter

- (NSMutableArray *)hotMainModes {
    if (!_hotMainModes) {
        _hotMainModes = [NSMutableArray array];
    }
    return _hotMainModes;
}

- (HLHotToast *)tipToast {
    if (!_tipToast) {
        _tipToast = [[HLHotToast alloc]initWithFrame:CGRectMake(0, ScreenH - Height_NavBar - FitPTScreen(50), FitPTScreen(210), FitPTScreen(30))];
        CGPoint center = _tipToast.center;
        center.x = CGRectGetMidX(self.view.bounds);
        _tipToast.center = center;
        _tipToast.alpha = 0;
    }
    return _tipToast;
}

- (NSMutableArray *)hotToasts {
    if (!_hotToasts) {
        _hotToasts = [NSMutableArray array];
    }
    return _hotToasts;
}


- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
