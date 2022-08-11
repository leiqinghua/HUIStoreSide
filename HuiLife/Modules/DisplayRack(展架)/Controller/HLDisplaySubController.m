//
//  HLDisplaySubController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import "HLDisplaySubController.h"
#import "HLDisplayCollectionCell.h"

@interface HLDisplaySubController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray *datasource;

@property(nonatomic, assign)NSInteger page;

@property(nonatomic, copy)NSString *classId;

@property(nonatomic, assign)NSInteger type;

@property(nonatomic, copy)NSString *proId;

@end

@implementation HLDisplaySubController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)resetFrame {
    CGRect frame = CGRectMake(FitPTScreen(22), 0, ScreenW - FitPTScreen(22)*2, CGRectGetMaxY(self.view.bounds));
    self.collectionView.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    _page = 1;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = FitPTScreen(5);
        
        NSInteger width = (ScreenW - FitPTScreen(22)*2 - FitPTScreen(5)) / 2;
        flowLayout.itemSize = CGSizeMake(width, FitPTScreen(263));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect frame = CGRectMake(FitPTScreen(22), 0, ScreenW - FitPTScreen(22)*2, CGRectGetMaxY(self.view.bounds));
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[HLDisplayCollectionCell class] forCellWithReuseIdentifier:@"HLDisplayCollectionCell"];
        AdjustsScrollViewInsetNever(self, _collectionView);
        
        
        [_collectionView headerNormalRefreshingBlock:^{
            self.page = 1;
            [self loadListWithClassId:self.classId type:self.type proId:self.proId loading:false];
        }];
        
        [_collectionView footerWithEndText:@"没有更多信息" refreshingBlock:^{
            self.page ++;
            [self loadListWithClassId:self.classId type:self.type proId:self.proId loading:false];
        }];
        [_collectionView hideFooter:YES];
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLDisplayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLDisplayCollectionCell" forIndexPath:indexPath];
    cell.displayModel = self.datasource[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(displayController:selectModel:)]) {
        [self.delegate displayController:self selectModel:self.datasource[indexPath.row]];
    }
}

#pragma mark - 列表

- (void)loadListWithClassId:(NSString *)classId type:(NSInteger)type proId:(NSString *)proId {
    _classId = classId;
    _type = type;
    _proId = proId;
    [self loadListWithClassId:classId type:type proId:proId loading:YES];
}

- (void)loadListWithClassId:(NSString *)classId type:(NSInteger)type proId:(NSString *)proId loading:(BOOL)loading{
    
    if (loading) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Zhanjia/bg";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":@(type),@"pro_id":proId,@"class_id":classId,@"page":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.collectionView endRefresh];
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleDataWithList:result.data];
            return;
        }
        
        if (self.page > 1) self.page --;
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.collectionView endRefresh];
        if (self.page > 1) self.page --;
    }];
}

- (void)handleDataWithList:(NSArray *)list {
    
    if (!_datasource)  _datasource = [NSMutableArray array];
    if (_page == 1) {
        [self.datasource removeAllObjects];
    }

    NSArray *datas = [HLDisplayModel mj_objectArrayWithKeyValuesArray:list];
    [self.datasource addObjectsFromArray:datas];
    
    if (self.datasource.count) {
        [self.collectionView hideFooter:false];
    }
    
    [self.collectionView reloadData];
}
@end
