//
//  HLMarketController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLMarketController.h"
#import "HLMarketCollectionCell.h"
#import "HLCarMarketController.h"
#import "HLCardPromotionController.h"


@interface HLMarketController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSArray * datasource;

@end

@implementation HLMarketController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"推广工具" andTitleColor:UIColorFromRGB(0x222222)];
    [self hl_interactivePopGestureRecognizerUseable];
}

- (void)reloadDataNotifi {
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [HLNotifyCenter addObserver:self selector:@selector(reloadDataNotifi) name:HLMarketToolReloadNotifi object:nil];
}

-(void)initView{
    if (_collectionView) return;
    self.view.backgroundColor = UIColor.whiteColor;
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];

    flowLayout.itemSize = CGSizeMake(FitPTScreen(114), FitPTScreen(114));
    flowLayout.minimumLineSpacing = FitPTScreen(4);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(FitPTScreen(16), Height_NavBar + FitPTScreen(15),FitPTScreen(114)*3, ScreenH - Height_NavBar-FitPTScreen(15)) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = UIColor.whiteColor;
    //注册cell
    [_collectionView registerClass:[HLMarketCollectionCell class] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    //防止cell被tabbar挡住而不能滑动
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //适配iOS11
    AdjustsScrollViewInsetNever(self, _collectionView);
}

#pragma mark -UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLMarketCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HLMarketMainModel * model = self.datasource[indexPath.row];
    if (!model.iosArdess.length) {
        [HLTools showHint:@"敬请期待" inView:self.view];
        return;
    }
    [HLTools pushAppPageLink:model.iosArdess params:model.iosParam needBack:false];
}

#pragma mark - request
- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/MarketingIndex.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self initView];
            [self handleDataWithDict:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleDataWithDict:(id )data{
    if ([data isKindOfClass:[NSArray class]]) {
       _datasource = [HLMarketMainModel mj_objectArrayWithKeyValuesArray:data];
    }
    [self.collectionView reloadData];
}

- (void)dealloc {
    [HLNotifyCenter removeObserver:self];
}
@end
