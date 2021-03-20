//
//  HLInputImagesViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import "HLInputImagesViewCell.h"
#import "HLPickImageViewCell.h"

@implementation HLInputImagesInfo

- (CGFloat)cellHeight {
    CGFloat hight = FitPTScreen(47);
    if (!self.pics.count) {
        return hight + FitPTScreen(90);
    }
    NSInteger row = (self.pics.count / 4) + 1;
    return hight + FitPTScreen(90) *row;
}

-(BOOL)checkParamsIsOk{
    if (!self.needCheckParams) {
        return YES;
    }
    
    if (self.text.length == 0 && self.mParams.count == 0) {
        return NO;
    }
    
    return YES;
}
@end


@interface HLInputImagesViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, HLPickImageViewCellDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HLInputImagesViewCell

- (void)initSubUI {
    [super initSubUI];
    
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    NSInteger width = (ScreenW - FitPTScreen(18)) / 4;
    CGFloat hight = FitPTScreen(90);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, hight);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColor.whiteColor;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.contentView addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(9));
        make.right.equalTo(FitPTScreen(-9));
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(4));
        make.bottom.equalTo(FitPTScreen(-10));
    }];
    
    [_collectionView registerClass:[HLPickImageViewCell class] forCellWithReuseIdentifier:@"HLPickImageViewCell"];
    [_collectionView registerClass:[HLImageAddViewCell class] forCellWithReuseIdentifier:@"HLImageAddViewCell"];

}

- (void)setBaseInfo:(HLInputImagesInfo *)baseInfo {
    [super setBaseInfo:baseInfo];
    [self.collectionView reloadData];
}

#pragma mark - HLPickImageViewCellDelegate
- (void)deleteWithImage:(NSString *)pic {
    HLInputImagesInfo *imagesInfo = (HLInputImagesInfo *)self.baseInfo;
    NSMutableArray *images = [imagesInfo.pics mutableCopy];
    NSInteger index = [images indexOfObject:pic];
    [images removeObjectAtIndex:index];
    imagesInfo.pics = [images copy];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    if (imagesInfo.single) {
        imagesInfo.text = @"";
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HLInputImagesInfo *imagesInfo = (HLInputImagesInfo *)self.baseInfo;
    if (imagesInfo.single) {
        return imagesInfo.pics.count?:1;
    }
    
    return imagesInfo.pics.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLInputImagesInfo *imagesInfo = (HLInputImagesInfo *)self.baseInfo;
    if (imagesInfo.single) {
        if (imagesInfo.pics.count) {
            HLPickImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLPickImageViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.pic = imagesInfo.pics[indexPath.row];
            return cell;
        }
        HLImageAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLImageAddViewCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row == imagesInfo.pics.count) {
        HLImageAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLImageAddViewCell" forIndexPath:indexPath];
        return cell;
    }
    HLPickImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLPickImageViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.pic = imagesInfo.pics[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HLInputImagesInfo *imagesInfo = (HLInputImagesInfo *)self.baseInfo;
    if (imagesInfo.single) {
        if (!imagesInfo.pics.count) {
            if ([self.delegate respondsToSelector:@selector(imagesCell:imagesInfo:)]) {
                [self.delegate imagesCell:self imagesInfo:(HLInputImagesInfo *)self.baseInfo];
            }
        }
        return;
    }
    if (indexPath.row == imagesInfo.pics.count) { //添加图片
        if ([self.delegate respondsToSelector:@selector(imagesCell:imagesInfo:)]) {
            [self.delegate imagesCell:self imagesInfo:(HLInputImagesInfo *)self.baseInfo];
        }
    }
}
@end



