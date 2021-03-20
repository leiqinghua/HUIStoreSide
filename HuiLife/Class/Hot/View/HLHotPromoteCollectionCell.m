//
//  HLHotPromoteCollectionCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/19.
//

#import "HLHotPromoteCollectionCell.h"


@interface HLHotPromoteCollectionCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic,strong)UIView * nodataView;

@end

@implementation HLHotPromoteCollectionCell

- (void)initSubView {
    [super initSubView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    NSInteger width = (ScreenW - FitPTScreen(12)) / 2;
    layout.itemSize = CGSizeMake(width, FitPTScreen(313));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(FitPTScreen(6), 0, ScreenW - FitPTScreen(12), CGRectGetMaxY(self.contentView.bounds)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:_collectionView];
    [_collectionView registerClass:[HLHotActivityCollectionCell class] forCellWithReuseIdentifier:@"HLHotActivityCollectionCell"];
    
    weakify(self);
    [_collectionView headerNormalRefreshingBlock:^{
        weak_self.mainModel.curPage = 1;
//        请求数据
        if ([weak_self.delegate respondsToSelector:@selector(hl_refreshListWithMainModel:)]) {
            [weak_self.delegate hl_refreshListWithMainModel:weak_self.mainModel];
        }
    }];
    
    [_collectionView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        weak_self.mainModel.curPage ++;
        if ([weak_self.delegate respondsToSelector:@selector(hl_refreshListWithMainModel:)]) {
            [weak_self.delegate hl_refreshListWithMainModel:weak_self.mainModel];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mainModel.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLHotActivityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLHotActivityCollectionCell" forIndexPath:indexPath];
    cell.listModel = self.mainModel.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        HLHotListModel * listModel = self.mainModel.datasource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(hl_selectItemWithListModel:)]) {
        [self.delegate hl_selectItemWithListModel:listModel];
    }
}

#pragma mark - setter

- (void)setMainModel:(HLHotMainModel *)mainModel {
    _mainModel = mainModel;
    [self.collectionView endRefresh];
    if (mainModel.isMore) {
        [self.collectionView endNomorData];
    }
    [self.collectionView hideFooter:!mainModel.datasource.count];
    
    [self.collectionView reloadData];
    
    if (!self.mainModel.datasource.count && self.mainModel.showNotView) {
        [self showNodataView];
    } else {
        [_nodataView removeFromSuperview];
    }
}

- (void)showNodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:self.collectionView.bounds];
        _nodataView.backgroundColor = UIColor.clearColor;

        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_ticket_default"]];
        [_nodataView addSubview:imageV];
        [imageV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(162));
            make.centerX.equalTo(self.nodataView);
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x999999);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        tipLb.text = @"暂无数据";
        [_nodataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nodataView);
            make.top.equalTo(imageV.bottom).offset(FitPTScreen(20));
        }];
    }
    
    [self.collectionView addSubview:_nodataView];
}
@end
