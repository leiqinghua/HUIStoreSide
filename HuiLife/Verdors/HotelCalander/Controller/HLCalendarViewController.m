//
//  HLCalendarViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/21.
//

#import "HLCalendarViewController.h"
#import "HLCalanderWeekView.h"
#import "HLCalanderTableViewCell.h"
#import "HLHotelCalanderHeader.h"
#import "HLBaseDateModel.h"

#define alertView_y 150

#define bottomView_h 60

#define durition 0.3

@interface HLCalendarViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)UIView * alertView;

@property(strong,nonatomic)UIView * bottomView;

@property(strong,nonatomic)HLBaseDateModel *baseDateModel;

@property(copy,nonatomic)HLCalanderComplete callBack;
@end

@implementation HLCalendarViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showAnimate];
}


-(instancetype)initWithCallBack:(HLCalanderComplete)callBack{
    if (self = [super init]) {
        _callBack = callBack;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}


-(void)completeClick{
    if (self.callBack) {
        if (!self.baseDateModel.startModel.date || !self.baseDateModel.endModel.date) {
            HLShowText(@"请选择开始和结束日期");
            return;
        }
        self.callBack(self.baseDateModel.startModel.date, self.baseDateModel.endModel.date);
        HLLog(@"start = %@,end = %@",self.baseDateModel.startModel.date,self.baseDateModel.endModel.date);
        [self hideAnimate];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)reloadDateList{
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self addNotification];
}

-(void)addNotification{
    [HLNotifyCenter addObserver:self selector:@selector(reloadDateList) name:HLCalanderSelectNotifi object:nil];
}

-(void)initSubView{
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];;
        
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH - FitPTScreenH(alertView_y))];
    _alertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_alertView];
    
    weakify(self);
    HLCalanderWeekView * weekView = [[HLCalanderWeekView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(100)) callBack:^{
        [weak_self hideAnimate];
        [weak_self dismissViewControllerAnimated:YES completion:nil];
    }];
    [_alertView addSubview:weekView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FitPTScreenH(100), ScreenW, _alertView.bounds.size.height - FitPTScreenH(80) - FitPTScreenH(bottomView_h)) style:UITableViewStylePlain];
    _tableView.backgroundColor =UIColor.whiteColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerClass:[HLHotelCalanderHeader class] forHeaderFooterViewReuseIdentifier:@"HLHotelCalanderHeader"];
    [self.alertView addSubview:_tableView];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = UIColor.whiteColor;
    [self.alertView addSubview:_bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self.alertView);
        make.height.equalTo(FitPTScreenH(bottomView_h));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor hl_StringToColor:@"#DDDDDD"];
    [_bottomView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.bottomView);
        make.height.equalTo(FitPTScreenH(1));
    }];
    
    UIButton * complete = [[UIButton alloc]init];
    complete.backgroundColor = [UIColor hl_StringToColor:@"#FF8D26"];
    [complete setTitle:@"完成" forState:UIControlStateNormal];
    complete.layer.cornerRadius = 8;
    complete.titleLabel.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    [_bottomView addSubview:complete];
    [complete makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.bottomView);
        make.width.equalTo(ScreenW - FitPTScreen(40));
        make.height.equalTo(FitPTScreenH(45));
    }];
    [complete addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.baseDateModel.months.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLCalanderTableViewCell * cell = [HLCalanderTableViewCell dequeueReusableCell:tableView];
    NSArray * datas = self.baseDateModel.months;
    cell.baseModel = self.baseDateModel;
    cell.model = datas[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * datas = self.baseDateModel.months;
    HLMonthModel * model = datas[indexPath.section];
    return model.hight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitPTScreenH(35);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * datas = self.baseDateModel.months;
    HLMonthModel * model = datas[section];
    HLHotelCalanderHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLHotelCalanderHeader"];
    header.title = model.title;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return FitPTScreenH(15);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray * datas = self.baseDateModel.months;
    if (section == datas.count -1) {
        return nil;
    }
    UIView * footer = [tableView footerViewForSection:section];
    [footer removeFromSuperview];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(15))];
    footerView.backgroundColor = [UIColor hl_StringToColor:@"#DDDDDD"];
    return footerView;
}

-(void)showAnimate{
    [UIView animateWithDuration:durition animations:^{
       self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        CGRect frame = self.alertView.frame;
        frame.origin.y = FitPTScreenH(alertView_y);
        self.alertView.frame = frame;
    }];
}

-(void)hideAnimate{
    [UIView animateWithDuration:durition animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}


-(HLBaseDateModel *)baseDateModel{
    if (!_baseDateModel) {
        _baseDateModel = [HLBaseDateModel shared];
        _baseDateModel.months = [self createModels];
        _baseDateModel.startModel = nil;
        _baseDateModel.endModel = nil;
        _baseDateModel.selectedDays = 0;
    }
    return _baseDateModel;
}


-(NSMutableArray *)createModels{
    //      现在的日期
    NSDate * date = [NSDate date];
    NSInteger curyear = [date dateYear];
    NSInteger curmonth = [date dateMonth];
    NSInteger curday = [date dateDay];
                        
    NSMutableArray * months = [NSMutableArray array];
    //推到两年
    for (int i=0; i<25; i++) {
        curmonth += (i == 0?0:1);
        if (curmonth >12) {
            curyear +=1;
            curmonth = 1;
        }
        if (i != 0) {
           date = [self dateWithYear:curyear month:curmonth day:1];
        }
        HLMonthModel * curModel = [[HLMonthModel alloc]init];
        curModel.year = curyear;
        curModel.month = curmonth;
        curModel.totalDay =i == 0?([date totalDaysInMonth] - curday + 1): [date totalDaysInMonth];
        curModel.firstWeekday = [date firstWeekDayInMonth];
        NSMutableArray<HLDayModel*> * dayModels = [NSMutableArray array];
        curModel.days = dayModels;
        
        for (int t = 0; t<curModel.firstWeekday; t++) {
            HLDayModel * emptyDay = [[HLDayModel alloc]init];
            [dayModels addObject:emptyDay];
        }
        
        for (NSInteger j=[date dateDay]; j<curModel.totalDay+[date dateDay]; j++) {
            HLDayModel * dayModel = [[HLDayModel alloc]init];
            dayModel.year = curyear;
            dayModel.month = curmonth;
            dayModel.day = j;
            dayModel.isToday = (i == 0 && j== [date dateDay]);
            dayModel.date = [self dateWithYear:curyear month:curmonth day:dayModel.day];
            [dayModels addObject:dayModel];
        }
        [months addObject:curModel];
    }
    return months;
}


-(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSString * monthStr = month<10?[NSString stringWithFormat:@"0%ld",month]:[NSString stringWithFormat:@"%ld",month];
    NSString * dayStr = day<10?[NSString stringWithFormat:@"0%ld",day]:[NSString stringWithFormat:@"%ld",day];
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%@-%@",year,monthStr,dayStr];
    NSDate * date = [HLTools dateWithFormatter:@"yyyy-MM-dd" dateStr:dateStr];
    return date;
}


@end
