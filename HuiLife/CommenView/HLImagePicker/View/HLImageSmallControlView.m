//
//  HLImageSmallControlView.m
//  HuiLife
//
//  Created by 王策 on 2019/11/8.
//

#import "HLImageSmallControlView.h"
#import "HLAssetCollectionViewCell.h"
#import "HLImagePickerService.h"
#import "HLImagePickerManager.h"

@interface HLImageSmallControlView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,HLAssetCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation HLImageSmallControlView

- (instancetype)initWithFrame:(CGRect)frame assets:(NSArray *)assets
{
    self = [super initWithFrame:frame];
    if (self) {
        self.assets = assets;
        [self addSubview:self.collectionView];
        
        UIView *blackV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.bounds.size.width, FitScreenH(15))];
        [self addSubview:blackV];
        blackV.backgroundColor = UIColorFromRGB(0x343434);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(blackV.frame) - 0.6, self.bounds.size.width, 0.6)];
        [blackV addSubview:line];
        line.backgroundColor = UIColorFromRGB(0x4E4E4E);
    }
    return self;
}

#pragma mark - HLAssetCollectionViewCellDelegate

#pragma mark - Public Method

- (void)configSelectIndex:(NSInteger)index{
    self.selectIndex = index;
    [UIView performWithoutAnimation:^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLAssetCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.onlyPreview = YES;
    [cell configBorder:self.selectIndex == indexPath.row];
    HLAsset *asset = self.assets[indexPath.row];
    [cell configAsset:asset arrayIndex:[self.assets indexOfObject:asset]];
    
    // 设置强制裁减 && 选中了 && 没有裁减过 就显示裁减提示lab
    HLImagePickerManager *manager = [HLImagePickerManager shared];
    BOOL isResized = [manager hasImageCacheWithAssetId:asset.asset.localIdentifier];
    BOOL showResizeTip = manager.config.mustResize && asset.select && !isResized && !manager.config.singleSelect;
    [cell configResizeTipLab:showResizeTip];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self configSelectIndex:indexPath.row];
    if(self.delegate){
        [self.delegate controlView:self selectIndex:indexPath.row];
    }
}

#pragma mark - Getter

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGFloat marginH = FitPTScreen(13);
        
        CGFloat itemWidth = (self.lx_width - 6 * (marginH)) / 5.5;
        CGFloat itemHeight = itemWidth;
        
        CGFloat marginV = (self.lx_height - itemHeight) / 2;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = marginH;
        layout.minimumInteritemSpacing = marginH;
        layout.sectionInset = UIEdgeInsetsMake(marginV, marginH, marginV, marginH);
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, FitScreenH(85)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColorFromRGB(0x343434) colorWithAlphaComponent:0.8];
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[HLAssetCollectionViewCell class] forCellWithReuseIdentifier:@"HLAssetCollectionViewCell"];
    }
    
    return _collectionView;
}

@end
