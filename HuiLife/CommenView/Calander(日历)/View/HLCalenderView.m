//
//  HLCalenderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/21.
//

#import "HLCalenderView.h"
#import "HLCalendarHearder.h"
#import "NSDate+HLCalendar.h"
#import "HLCalendarDayModel.h"
#import "HLCalendarMonthModel.h"
#import "HLCalenderViewCell.h"
@interface HLCalenderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HLCalendarHearder *calendarHeader; //头部
@property(nonatomic,strong)UIView *calendarWeekView;//周
@property(nonatomic,strong)UICollectionView *collectionView;//日历
@property(nonatomic,strong)NSMutableArray *monthdataA;//当月的模型集合
@property(nonatomic,strong)NSDate *currentMonthDate;//当月的日期
@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipe;//右滑手势
@end

@implementation HLCalenderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentMonthDate = [NSDate date];
        [self setup];
    }
    return self;
}

-(void)dealData{
    [self responData];
}

-(void)setup{
    [self addSubview:self.calendarHeader];
    
    weakify(self);
    self.calendarHeader.leftClickBlock = ^{
        [weak_self rightSlide];
    };
    
    self.calendarHeader.rightClickBlock = ^{
        [weak_self leftSlide];
        
    };
    
    [self addSubview:self.calendarWeekView];
    
    [self addSubview:self.collectionView];
    
    self.lx_height = self.collectionView.lx_bottom;
    //添加左滑右滑手势
    self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:self.rightSwipe];
}

#pragma mark --左滑手势--
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    
    [self leftSlide];
}
#pragma mark --左滑处理--
-(void)leftSlide{
    
    NSDate * date = [self.currentMonthDate nextMonthDate];
    NSDate * curDate = [NSDate date];
    if ([date dateYear] > [curDate dateYear]) {
        return;
    }
    
    if (([date dateMonth]> [curDate dateMonth]) && (date.dateYear == [curDate dateYear])){
        return;
    }
    
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    
    [self performAnimations:kCATransitionFromRight];
    
    [self responData];
}
#pragma mark --右滑处理--
-(void)rightSlide{
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    [self responData];
}

#pragma mark --右滑手势--
-(void)rightSwipe:(UISwipeGestureRecognizer *)swipe{
    [self rightSlide];
}
#pragma mark--动画处理--
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.5;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}

#pragma mark--数据以及更新处理--
-(void)responData{
    [self.monthdataA removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    HLCalendarMonthModel *monthModel = [[HLCalendarMonthModel alloc]initWithDate:self.currentMonthDate];
    
    HLCalendarMonthModel *lastMonthModel = [[HLCalendarMonthModel alloc]initWithDate:previousMonthDate];
    
    HLCalendarMonthModel *nextMonthModel = [[HLCalendarMonthModel alloc]initWithDate:nextMonthDate];
    
    self.calendarHeader.dateStr = [NSString stringWithFormat:@"%ld年%ld月",monthModel.year,monthModel.month];
    
    NSInteger firstWeekday = monthModel.firstWeekday;
    
    NSInteger totalDays = monthModel.totalDays;
    
    for (int i = 0; i <42; i++) {
        
        HLCalendarDayModel *model =[[HLCalendarDayModel alloc]init];
        //配置外面属性
        [self configDayModel:model];
        model.firstWeekday = firstWeekday;
        model.totalDays = totalDays;
//        model.month = monthModel.month;
//        model.year = monthModel.year;
        //上个月的日期
        if (i < firstWeekday) {
            model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
            model.isLastMonth = YES;
            model.month = lastMonthModel.month;
            model.year = lastMonthModel.year;
        }
        //当月的日期
        if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
            model.day = i -firstWeekday +1;
            model.isCurrentMonth = YES;
            model.month = monthModel.month;
            model.year = monthModel.year;
            //标识是今天
            if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {
                if (i == [[NSDate date] dateDay] + firstWeekday - 1) {
                    model.isToday = YES;
                }
            }
        }
        //下月的日期
        if (i >= (firstWeekday + monthModel.totalDays)) {
            NSInteger index = 42 - (firstWeekday + monthModel.totalDays);
//            model.day = i -firstWeekday - nextMonthModel.totalDays;
            model.day = index-(42-i)+1;
            model.isNextMonth = YES;
            model.month = nextMonthModel.month;
            model.year = nextMonthModel.year;
        }
        [self.monthdataA addObject:model];
    }
    [self.collectionView reloadData];
}

-(void)configDayModel:(HLCalendarDayModel *)model{
    //配置外面属性
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    
    model.selectBackColor = self.selectBackColor;
    
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.todayTitleColor = self.todayTitleColor;
    
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthdataA.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLCalenderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLCalenderViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell =[[HLCalenderViewCell alloc]initWithFrame:CGRectZero];
    }
    cell.model = self.monthdataA[indexPath.row];
    cell.backgroundColor =[UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HLCalendarDayModel *model = self.monthdataA[indexPath.row];
    model.isSelected = YES;
    
    [self.monthdataA enumerateObjectsUsingBlock:^(HLCalendarDayModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != model) {
            obj.isSelected = NO;
        }
    }];
    
//
    NSString *year = [NSString stringWithFormat:@"%ld",model.year];
    NSString*month = [NSString stringWithFormat:@"%ld",model.month];
    if (month.integerValue<10) {
        month = [NSString stringWithFormat:@"0%ld",model.month];
    }
    
    NSString*day = [NSString stringWithFormat:@"%ld",model.day];
    if (day.integerValue<10) {
        day = [NSString stringWithFormat:@"0%ld",model.day];
    }
    if (self.selectDate) {
        self.selectDate(year,month,day);
    }
    [collectionView reloadData];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.calendarHeader.frame = CGRectMake(0, 0, self.lx_width, FitPTScreen(50));
//}

#pragma mark---懒加载
-(HLCalendarHearder *)calendarHeader{
    if (!_calendarHeader) {
        BOOL top = self.frame.origin.y == 0;
        CGRect frame = CGRectMake(0,top?HIGHT_NavBar_MARGIN:0, self.lx_width, FitPTScreen(44));
        _calendarHeader =[[HLCalendarHearder alloc]initWithFrame:frame];
        _calendarHeader.backgroundColor =[UIColor whiteColor];
    }
    return _calendarHeader;
}

-(UIView *)calendarWeekView{
    if (!_calendarWeekView) {
        _calendarWeekView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarHeader.frame), self.lx_width, FitPTScreen(50))];
        NSArray * weeks = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        CGFloat width = self.lx_width / 7;
        
        CGFloat hight = FitPTScreen(50);
        for (int i=0; i<weeks.count; i++) {
            UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(i*width, 0, width, hight)];
            lable.text = weeks[i];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor hl_StringToColor:@"#656565"];
            lable.font = [UIFont systemFontOfSize:FitPTScreen(17)];
            [_calendarWeekView addSubview:lable];
        }
    }
    return _calendarWeekView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        //325*403
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.sectionInset =UIEdgeInsetsMake(0 , 0, 0, 0);
        
        flow.itemSize = CGSizeMake(self.lx_width/7, FitPTScreen(50));
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.calendarWeekView.lx_bottom, self.lx_width, 6 * FitPTScreen(50)) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HLCalenderViewCell class] forCellWithReuseIdentifier:@"HLCalenderViewCell"];
    }
    return _collectionView;
}

-(NSMutableArray *)monthdataA{
    if (!_monthdataA) {
        _monthdataA =[NSMutableArray array];
    }
    return _monthdataA;
}

/*
 * 是否禁止手势滚动
 */
-(void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}

/*
 * 是否显示上月，下月的按钮
 */

-(void)setIsShowLastAndNextBtn:(BOOL)isShowLastAndNextBtn{
    _isShowLastAndNextBtn  = isShowLastAndNextBtn;
    self.calendarHeader.isShowLeftAndRightBtn = isShowLastAndNextBtn;
}

@end
