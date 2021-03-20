//
//  HLFilterView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/15.
//

#import "HLFilterView.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "HLSelectShowViewCell.h"
#import "HLFilterReusableView.h"
#import "HLSelectTimeCell.h"

//#define AlertViewH 308
//
//#define CollectionViewH 259

#define AnimateDurition 0.3

static CGFloat CollectionView_H = 259;

static CGFloat AlertView_H = 308;

@implementation HLFilterModel

@end

@interface HLFilterView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic)UIView * bagView;

@property (strong,nonatomic)UICollectionView * collectionView;

@property(strong,nonatomic)UIButton * reset;

@property(strong,nonatomic)UIButton * concern;
//日期所在位置(>=0表示有日期)
@property(assign,nonatomic)NSInteger dateIndex;
//日期（起始日期，结束日期）
@property(strong,nonatomic)NSArray *dates;

@property(strong,nonatomic)NSArray *titles;

@property(strong,nonatomic)NSArray *dataSource;
//最初的日期
@property(strong,nonatomic)NSArray *originDates;

@property(strong,nonatomic)NSIndexPath *originIndexPath;
//位置
@property(assign,nonatomic)CGPoint origian;
//点击按钮的回调方法
@property(copy,nonatomic)DateSelectBlock selectBlock;

@property(strong,nonatomic)UIView *alertView;

@property(strong,nonatomic)NSMutableArray *frames;
//选中的item
@property(strong,nonatomic)NSIndexPath *selectIndexPath;

@property(strong,nonatomic)HLSelectTimeCell * timeCell;

@property(strong,nonatomic)NSMutableArray *selectItems;

@end

@implementation HLFilterView


+ (void)showSelectViewWithSectionTitles:(NSArray *)titles dataSource:(NSArray *)dataSource dates:(NSArray *)dates callBack:(DateSelectBlock)callBack{
    HLFilterView * filterView =  [self configerWithOrigin:CGPointMake(0, Height_NavBar) titles:titles dataSource:dataSource dates:dates dateIndex:2 callBack:callBack];
    [filterView showAnimate];
    HLBaseViewController * vc = [HLTools visiableController];
    [vc.view addSubview:filterView];
}


+ (instancetype)configerWithOrigin:(CGPoint)origin titles:(NSArray *)titles dataSource:(NSArray *)dataSource dates:(NSArray *)dates dateIndex:(NSInteger)index callBack:(DateSelectBlock)callBack{
    HLFilterView * filterView = [[HLFilterView alloc]initWithOrigin:origin titles:titles dataSource:dataSource dates:dates dateIndex:index callBack:callBack];
    return filterView;
}


- (instancetype)initWithOrigin:(CGPoint)origin titles:(NSArray *)titles dataSource:(NSArray *)dataSource dates:(NSArray *)dates dateIndex:(NSInteger)index callBack:(DateSelectBlock)callBack{
    if (self = [super initWithFrame:CGRectMake(0, origin.y, ScreenW, ScreenH - origin.y)]) {
        _titles = titles;
        _dates = dates;
        _dateIndex = index;
        _selectBlock = callBack;
        _origian = origin;
        self.dataSource = dataSource;
        self.originDates = [NSArray arrayWithArray:dates];
        [self initSubViews];
        [self initButtons];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 1) {
        [self hideAnimate];
        if (self.selectBlock) {
            self.selectBlock(sender.tag,self.dates?:@[], self.selectItems);
        }
        return;
    }
    
    HLFilterModel * selectModel = self.dataSource[_selectIndexPath.section][_selectIndexPath.row];
    if (_selectIndexPath && selectModel.selected ) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:_selectIndexPath];
    }
    if (_originIndexPath) {
        HLFilterModel * model = self.dataSource[_originIndexPath.section][_originIndexPath.row];
        model.selected = YES;
        [self.collectionView reloadData];
    }
    self.dates = [NSArray arrayWithArray:_originDates];
    _selectIndexPath = [NSIndexPath indexPathForRow:_originIndexPath.row inSection:_originIndexPath.section];
}

- (void)addModel:(HLFilterModel *)model {
    
    if ([self.selectItems containsObject:model]) {
        if (!model.selected) {
            [self.selectItems removeObject:model];
        }
    }else{
        if (model.selected) {
            [self.selectItems addObject:model];
        }
    }
}


- (void)initSubViews{

    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:_bagView];
    
//  可以计算高度根据DataSource，此时先用固定高度308
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0,-AlertView_H, ScreenW, AlertView_H)];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_alertView];
    
    JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:FitPTScreen(18)];
    //设置headerview尺寸大小
    flowLayout.headerReferenceSize = CGSizeMake(ScreenW, FitPTScreen(48));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = FitPTScreen(15);
    flowLayout.minimumInteritemSpacing = FitPTScreen(18);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.frame = CGRectMake(FitPTScreen(10), 0, ScreenW - FitPTScreen(20), CollectionView_H);
    [_collectionView registerClass:[HLSelectShowViewCell class] forCellWithReuseIdentifier:@"HLSelectShowViewCell"];
    [_collectionView registerClass:[HLSelectTimeCell class] forCellWithReuseIdentifier:@"HLSelectTimeCell"];
    [_collectionView registerClass:[HLFilterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HLFilterReusableView"];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = UIColor.whiteColor;
    [_alertView addSubview:_collectionView];
    
}


- (void)initButtons{
    _reset = [[UIButton alloc]init];
    [_reset setTitle:@"重置" forState:UIControlStateNormal];
    _reset.tag = 0;
    [_reset setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _reset.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [_alertView addSubview:_reset];
    [_reset addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    _concern = [[UIButton alloc]init];
    _concern.tag = 1;
    [_concern setTitle:@"确定" forState:UIControlStateNormal];
    [_concern setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _concern.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    [_concern setBackgroundImage:[UIImage imageNamed:@"concern_bg"] forState:UIControlStateNormal];
    [_alertView addSubview:_concern];
    [_concern addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xFF9916);
    [_reset addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.reset);
        make.height.equalTo(FitPTScreen(0.4));
    }];
    
    [_reset remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.alertView);
        make.width.equalTo(self.bounds.size.width/2);
        make.height.equalTo(FitPTScreen(49));
    }];

    [_concern remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.alertView);
        make.width.equalTo(self.bounds.size.width/2);
        make.height.equalTo(FitPTScreen(49));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == _dateIndex) return 1;
    NSArray * datas = self.dataSource[section];
    return datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dateIndex) {
        HLSelectTimeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLSelectTimeCell" forIndexPath:indexPath];
        cell.dates = self.dates;
        _timeCell = cell;
        HLFilterModel * model ;
        weakify(self);
        if (_selectIndexPath) {
            model = weak_self.dataSource[_selectIndexPath.section][_selectIndexPath.row];
        }
        _timeCell.dateSelected = ^{
            if (model.selected) model.selected = NO;
            weak_self.dates = cell.dates;
            [weak_self.collectionView reloadData];
        };
        return cell;
    }
    NSArray * datas = self.dataSource[indexPath.section];
    HLFilterModel * model = datas[indexPath.row];
    HLSelectShowViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLSelectShowViewCell" forIndexPath:indexPath];
    [self addModel:model];
    cell.model =model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dateIndex ) {
        return CGSizeMake(_collectionView.bounds.size.width, FitPTScreen(40));
    }
    if (self.frames.count > 0) {
        NSValue * value = self.frames[indexPath.section][indexPath.row];
        return [value CGRectValue].size;
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if ([self.titles[section] isEqualToString:@""]) {
        return  CGSizeMake(ScreenW, FitPTScreen(30));
    }
    return  CGSizeMake(ScreenW, FitPTScreen(48));
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HLFilterReusableView * headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HLFilterReusableView" forIndexPath:indexPath];
        headerView.text = self.titles[indexPath.section];
        return headerView;
    }
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dateIndex) {
        return;
    }
    if (self.dataSource.count == 0) {
        return;
    }
    
    HLFilterModel * lastModel = self.dataSource[_selectIndexPath.section][_selectIndexPath.row];
    HLFilterModel * model = self.dataSource[indexPath.section][indexPath.row];
    model.selected = !model.selected;
    
    if (![_selectIndexPath isEqual:indexPath] && lastModel.selected) {
        lastModel.selected = NO;
    }
    self.dates = nil;
    _selectIndexPath = indexPath;
    [_collectionView reloadData];
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    NSMutableArray * rows = [NSMutableArray array];
    weakify(self);
    [_dataSource enumerateObjectsUsingBlock:^(NSArray*  _Nonnull datas, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSMutableArray * hights = [NSMutableArray array];
        __block CGFloat width = 0.0;
        
        NSMutableArray * sectionFrames = [NSMutableArray array];
        [datas enumerateObjectsUsingBlock:^(HLFilterModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = [weak_self valueWithModel:model];
            [sectionFrames addObject:[NSValue valueWithCGRect:frame]];
            if (idx == 0) {
                [hights addObject:[NSValue valueWithCGRect:frame]];
            }
            if (model.selected) {
                NSInteger section = [self.dataSource indexOfObject:datas];
                NSInteger row = [datas indexOfObject:model];
                self.selectIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                self.originIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            }
            width += (frame.size.width + FitPTScreen(18)) ;
            if (width > ScreenW - FitPTScreen(40)) {
               [hights addObject:[NSValue valueWithCGRect:frame]];
            }
        }];
        [weak_self.frames addObject:sectionFrames];
        [rows addObject:hights];
    }];
    [self caculateHightWithRows:rows];
}

-(void)caculateHightWithRows:(NSArray*)rows{
    __block CGFloat sectionH = FitPTScreen(48)*_titles.count;
    [rows enumerateObjectsUsingBlock:^(NSArray *  _Nonnull hights, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [hights enumerateObjectsUsingBlock:^(NSValue *  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = value.CGRectValue;
            sectionH += (frame.size.height + FitPTScreen(15));
        }];
    }];
    if (_dateIndex >= 0) {
        sectionH += FitPTScreen(40);
    }
//    加距离底部的距离20
    sectionH += FitPTScreen(30);
    CollectionView_H = sectionH;
    AlertView_H = CollectionView_H + FitPTScreen(49);
}

-(CGRect)valueWithModel:(HLFilterModel *)model{
    CGRect frame = [self estamateFrameWithSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX) text:model.title];
    frame.size.width = frame.size.width + FitPTScreen(40);
    if (frame.size.width >= ScreenW - FitPTScreen(40)) {
        frame = [self estamateFrameWithSize:CGSizeMake(ScreenW - FitPTScreen(60),CGFLOAT_MAX) text:model.title];
    }
    frame.size.height = frame.size.height + FitPTScreen(16);
    return frame;
}

-(CGRect)estamateFrameWithSize:(CGSize)size text:(NSString *)text{
    CGRect frame = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:FitPTScreen(12)],NSFontAttributeName, nil] context:nil];
    return frame;
}

-(NSMutableArray *)frames{
    if (!_frames) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}

-(NSMutableArray *)selectItems{
    if (!_selectItems) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}

-(void)showAnimate{
    [UIView animateWithDuration:AnimateDurition animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = 0;
        self.alertView.frame = frame;
        self.bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}

-(void)hideAnimate{
    [UIView animateWithDuration:AnimateDurition animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = - frame.size.height;
        self.alertView.frame = frame;
        self.alertView.alpha = 0;
        self.bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+(void)remove{
    HLBaseViewController *vc = [HLTools visiableController];
    for (UIView * subView in vc.view.subviews) {
        if ([subView isKindOfClass:[HLFilterView class]]) {
            HLFilterView * filterView = (HLFilterView *)subView;
            [filterView hideAnimate];
            break;
        }
    }
}

@end

