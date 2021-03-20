//
//  HLSelectTimeCell.m
//  HuiLife
//
//  Created by 雷清华 on 2018/7/19.
//

#import "HLSelectTimeCell.h"
#import "LZPickViewManager.h"

@interface HLSelectTimeCell()

@property(nonatomic,copy)NSString *beginDate;

@property(nonatomic,copy)NSString *endDate;
@end

@implementation HLSelectTimeCell


- (void)selectTime:(UITapGestureRecognizer*)sender{
    NSInteger tag = sender.view.tag;
    NSString * max = [HLTools formatterWithDate:[NSDate date] formate:@"yyyy-MM-dd"];
    
    [[LZPickViewManager initLZPickerViewManager] showWithMaxDateString:max withMinDateString:@"2010-01-01" didSeletedDateStringBlock:^(NSString *dateString) {
        if (tag == 0) {
            self.beginDate = dateString;
            [self configerDateForBegin];
        }else{
            self.endDate = dateString;
            [self configerDateForEnd];
        }
    }];
}

- (void)reset{
    _beginDate = nil;
    _endDate = nil;
}

-(void)configerDateForBegin{
    if (!_endDate) {
        _begin.text = _beginDate;
        self.dates = @[_beginDate,_endDate?:@""];
        if (self.dateSelected) {
            self.dateSelected();
        }
        
        return;
    }
    NSInteger compare = [HLTools compareWithFirst:_beginDate another:_endDate formate:@"yyyy-MM-dd"];
    if (compare == 1 || compare == 0) {
        _begin.text = _beginDate;
        self.dates = @[_beginDate,_endDate?:@""];
        if (self.dateSelected) {
            self.dateSelected();
        }
    }else{
        [HLTools showWithText:@"起始日期不能大于结束日期"];
    }
    
}

-(void)configerDateForEnd{
    if (!_beginDate) {
        _end.text = _endDate;
        self.dates = @[_beginDate?:@"",_endDate?:@""];
        if (self.dateSelected) {
            self.dateSelected();
        }
        return;
    }
    NSInteger compare = [HLTools compareWithFirst:_beginDate another:_endDate formate:@"yyyy-MM-dd"];
    if (compare == 1 || compare == 0) {
        _end.text = _endDate;
        self.dates = @[_beginDate?:@"",_endDate?:@""];
        if (self.dateSelected) {
            self.dateSelected();
        }
    }else{
        [HLTools showWithText:@"结束日期不能小于起始日期"];
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _begin = [[UILabel alloc]init];
    _begin.tag = 0;
    _begin.textAlignment = NSTextAlignmentCenter;
    _begin.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _begin.text = @"开始日期";
    _begin.textColor = UIColorFromRGB(0x999999);
    _begin.backgroundColor = UIColor.whiteColor;
    _begin.layer.cornerRadius = 5;
    _begin.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _begin.layer.borderWidth = FitPTScreen(0.7);
    _begin.clipsToBounds = YES;
    self.clipsToBounds = YES;
    _begin.userInteractionEnabled = YES;
    [self.contentView addSubview:_begin];
    [_begin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(150));
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTime:)];
    [_begin addGestureRecognizer:tap];
    
    UILabel *center = [[UILabel alloc]init];;
    center.text = @"至";
    center.textColor = UIColorFromRGB(0x999999);
    center.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self.contentView addSubview:center];
    [center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.begin.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.contentView);
    }];
    
    _end = [[UILabel alloc]init];
    _end.tag = 1;
    _end.textAlignment = NSTextAlignmentCenter;
    _end.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _end.text = @"结束日期";
    _end.textColor = UIColorFromRGB(0x999999);
    _end.backgroundColor = UIColor.whiteColor;
    _end.layer.cornerRadius = 5;
    _end.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _end.layer.borderWidth = FitPTScreen(0.7);
    _end.clipsToBounds = YES;
    _end.userInteractionEnabled = YES;
    [self.contentView addSubview:_end];
    [_end mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(self.begin);
    }];
    
    UITapGestureRecognizer * tapEnd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTime:)];
    [_end addGestureRecognizer:tapEnd];
}

-(void)setDates:(NSArray *)dates
{
    _dates = dates;
    
    _begin.text = [dates.firstObject hl_isAvailable]?dates.firstObject:@"开始日期";
    _end.text = [dates.lastObject hl_isAvailable]?dates.lastObject:@"结束日期";
}


-(NSArray *)configerDates{
    NSMutableArray * dates = [NSMutableArray array];
    if (![_begin.text isEqualToString:@"开始日期"]) {
        [dates addObject:_begin.text];
    }
    if (![_end.text isEqualToString:@"结束日期"]) {
        [dates addObject:_end.text];
    }
    return dates;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
