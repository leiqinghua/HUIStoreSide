//
//  HLCalanderTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/22.
//

#import "HLCalanderTableViewCell.h"
#import "HLBaseDateModel.h"

@interface HLCalanderDayCell()

@property(strong,nonatomic)UILabel * lable;

@end

@implementation HLCalanderDayCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _lable = [[UILabel alloc]init];
        _lable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
        [self.contentView addSubview:_lable];
        [_lable makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)setDayModel:(HLDayModel *)dayModel{
    _dayModel = dayModel;
    if (dayModel.day == 0) {
        _lable.text = @"";
        _lable.backgroundColor = UIColor.whiteColor;
        return;
    }
    
    _lable.text = [NSString stringWithFormat:@"%ld",dayModel.day];
    if (dayModel.isToday) {
        _lable.text = @"今天";
    }
    
    HLBaseDateModel * mainModel = [HLBaseDateModel shared];
    if (!mainModel.startModel) {
        _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
        _lable.backgroundColor = UIColor.whiteColor;
        return;
    }
    
    
    BOOL overStart = false;
//    和起始日期比较
    switch ([dayModel.date compare:mainModel.startModel.date]) {
        case NSOrderedSame://相同
            _lable.textColor = UIColor.whiteColor;
            _lable.backgroundColor = [UIColor hl_StringToColor:@"F3AA35"];
            break;
        case NSOrderedAscending://小于
            _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
            _lable.backgroundColor = UIColor.whiteColor;
            break;
        case NSOrderedDescending://大于
            overStart = YES;
            break;
        default:
            break;
    }
    
    if (!mainModel.endModel) {
        if (overStart) {
            _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
            _lable.backgroundColor = UIColor.whiteColor;
        }
        return;
    }
    
    BOOL lessEnd = false;
//    和结束日期比较
    switch ([dayModel.date compare:mainModel.endModel.date]) {
        case NSOrderedSame://相同
            _lable.textColor = UIColor.whiteColor;
            _lable.backgroundColor = [UIColor hl_StringToColor:@"F3AA35"];
            break;
        case NSOrderedAscending://小于
            lessEnd = YES;
            break;
        case NSOrderedDescending://大于
            _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
            _lable.backgroundColor = UIColor.whiteColor;
            break;
        default:
            break;
    }
    
    if (overStart && lessEnd) {
        _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
        _lable.backgroundColor = [UIColor hl_StringToColor:@"fce4ab"];
    }
    
    
//    if (dayModel.isSelected) {
//        _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
//        _lable.backgroundColor = [UIColor hl_StringToColor:@"fce4ab"];
//    }else{
//        if (dayModel.isEnd || dayModel.isStart) {
//            _lable.textColor = UIColor.whiteColor;
//            _lable.backgroundColor = [UIColor hl_StringToColor:@"F3AA35"];
//        }else{
//            _lable.textColor = [UIColor hl_StringToColor:@"2a3630"];
//            _lable.backgroundColor = UIColor.whiteColor;
//        }
//    }
}

@end

@interface HLCalanderTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic)UICollectionView *collectionView;

@end

@implementation HLCalanderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(ScreenW / 7, FitPTScreen(50));
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[HLCalanderDayCell class] forCellWithReuseIdentifier:@"HLCalanderDayCell"];
    _collectionView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.days.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLCalanderDayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLCalanderDayCell" forIndexPath:indexPath];
    HLDayModel * dayModel = self.model.days[indexPath.row];
//    if (self.baseModel.startModel && self.baseModel.endModel) {
//        if ([self.baseModel.startModel.date compare:dayModel.date] == -1 && [self.baseModel.endModel.date compare:dayModel.date] == 1) {
//            dayModel.isSelected = YES;
//        }
//    }else{
//        dayModel.isSelected = NO;
//    }
    cell.dayModel = dayModel;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* dates = self.model.days;
    HLDayModel * dayModel = dates[indexPath.row];
    
    if (dayModel.day == 0) { //点击空白部分
        return;
    }
    
    HLDayModel *start = self.baseModel.startModel;
    
    HLDayModel *end = self.baseModel.endModel;
//    1 >,-1 <
    NSInteger compare = [start.date compare:dayModel.date];
    
    if (!self.baseModel.startModel) {
        self.baseModel.startModel = dayModel;
    }else{
        if (end) {
            start.isStart = NO;
            self.baseModel.endModel = nil;
            self.baseModel.startModel = dayModel;
            [self.collectionView reloadData];
            [HLNotifyCenter postNotificationName:HLCalanderSelectNotifi object:nil];
            return;
        }
        
        if (compare == -1) {//start <daymodel
            self.baseModel.endModel = dayModel;
        }
        
        if (compare == 1) {
            start.isStart = NO;
            self.baseModel.startModel = dayModel;
        }
    }
   [self.collectionView reloadData];
   [HLNotifyCenter postNotificationName:HLCalanderSelectNotifi object:nil];
}

-(void)setModel:(HLMonthModel *)model{
    _model = model;
    [self.collectionView reloadData];
}
@end
