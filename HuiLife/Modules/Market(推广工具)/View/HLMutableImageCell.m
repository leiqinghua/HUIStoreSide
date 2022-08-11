//
//  HLMutableImageCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLMutableImageCell.h"
#import "HLImageCollectionCell.h"

#define imageCell_hight  (ScreenW-FitPTScreen(13*2 + 10)) / 3

@interface HLMutableImageCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation HLMutableImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.42].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,3);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(22);
    _bagView.layer.cornerRadius = 7;
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(13), FitPTScreen(10), FitPTScreen(13)));
    }];
    
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(floorf(imageCell_hight), floorf(imageCell_hight));
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = UIColor.whiteColor;
    //注册cell
    [_collectionView registerClass:[HLImageCollectionCell class] forCellWithReuseIdentifier:@"HLImageCollectionCell"];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    [self.bagView addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(5));
        make.right.equalTo(FitPTScreen(-5));
        make.top.equalTo(FitPTScreen(9));
        make.height.equalTo(imageCell_hight);
        make.bottom.equalTo(FitPTScreen(-7)).priorityLow();
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLImageCollectionCell" forIndexPath:indexPath];
    id image = _images[indexPath.row];
    if ([image isKindOfClass:[NSString class]]) {
        cell.imageStr = (NSString *)image;
    }else{
        cell.image = (UIImage *)image;
    }
    
    weakify(self);
    cell.deleteBlock = ^{
        [weak_self deleteImageWithImage:image index:indexPath];
    };
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_single) {
        if ([self.delegate respondsToSelector:@selector(imageCell:pickerWithSingle:)]) {
            [self.delegate imageCell:self pickerWithSingle:_single];
        }
        return;
    }
    
    id obj = self.images[indexPath.row];
    BOOL addBtn = false;
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj isEqualToString:@"add_photo"]) {
            addBtn = YES;
        }
    }
    if (indexPath.row == _images.count-1 && addBtn) {
        if ([self.delegate respondsToSelector:@selector(imageCell:pickerWithSingle:)]) {
            [self.delegate imageCell:self pickerWithSingle:_single];
        }
    }
}


-(void)setSingle:(BOOL)single{
    _single = single;
    [self.collectionView reloadData];
}

-(void)setImages:(NSMutableArray *)images{
     _images = images;
     [self updateHight];
}

-(void)deleteImageWithImage:(id)image index:(NSIndexPath *)index{
    [self.images removeObject:image];
    if (self.single) {
        [self.images addObject:@"logo_grey"];
    }
    [self updateHight];
    
    [HLNotifyCenter postNotificationName:HLDeleteImageNotifi object:nil];
    
    if ([self.delegate respondsToSelector:@selector(deleteImageWithIndex:single:)]) {
        [self.delegate deleteImageWithIndex:index.row single:_single];
    }
}

-(void)updateHight{
    NSInteger row = (_images.count -1)/3 + 1;
    CGFloat hight = row * imageCell_hight;
    [_collectionView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(hight);
    }];
    [self.collectionView reloadData];
}
@end
