//
//  HLTimeSingleSelectView.m
//  HuiLife
//
//  Created by 王策 on 2019/8/5.
//

#import "HLTimeSingleSelectView.h"

#define kMainHeight (FitPTScreen(269) + Height_Bottom_Margn)

@interface HLTimeSingleSelectView ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSInteger yearIndex;
    
    NSInteger monthIndex;
    
    NSInteger dayIndex;
    
    NSInteger currentYear;
    
    NSInteger currentMonth;
    
    NSInteger currentDay;
}

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *controlView; // 展示lab

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, copy) HLTimeCallBack callBack;

/// 是否已今天为开始
@property (nonatomic, assign) BOOL startWithToday;

@property (copy, nonatomic) NSString *selectDate; // 选择的时间哦，用来处理快速滚动无法选中的问题

@end

@implementation HLTimeSingleSelectView

+ (void)showEditTimeView:(NSString *)date startWithToday:(BOOL)startWithToday callBack:(HLTimeCallBack)callBack{
    HLTimeSingleSelectView *timeView = [[HLTimeSingleSelectView alloc] init];
    timeView.startWithToday = startWithToday;
    [timeView selectWithDate:date];
    timeView.callBack = callBack;
    [[[UIApplication sharedApplication].delegate window] addSubview:timeView];
}

- (instancetype)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self initSubViews];
        [self hl_addTarget:self action:@selector(remove)];
    }
    return self;
}

- (void)selectWithDate:(NSString *)date{
    
    if (!date || date.length == 0 || [date isEqualToString:@"0000-00-00"]) {
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |  NSCalendarUnitDay;
        // 获取不同时间字段的信息
        NSDateComponents *comp = [gregorian components:unitFlags fromDate:dt];
        
        NSString *nowDate = [NSString stringWithFormat:@"%ld-%2ld-%2ld",comp.year,comp.month,comp.day];

        date = nowDate;
    }
    
    // 记住时间
    _selectDate = date;
    
    NSArray *dateArr = [date componentsSeparatedByString:@"-"];
    if (dateArr.count != 3) {
        return;
    }
    
    for (NSString * time in dateArr) {
        if ([time integerValue] == 0) {
            return;
        }
    }
    
    yearIndex = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld", [dateArr[0] integerValue]]];
    monthIndex = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld", [dateArr[1] integerValue]]];
    dayIndex = [self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld", [dateArr[2] integerValue]]];
    
    [_pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [_pickerView selectRow:monthIndex inComponent:1 animated:YES];
    [_pickerView selectRow:dayIndex inComponent:2 animated:YES];
    
    [self pickerView:_pickerView didSelectRow:yearIndex inComponent:0];
    [self pickerView:_pickerView didSelectRow:monthIndex inComponent:1];
    [self pickerView:_pickerView didSelectRow:dayIndex inComponent:2];
    
    //        MJWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[self.pickerView viewForRow:self->yearIndex forComponent:0];
        [self setSelectLabel:label];
        
        label = (UILabel *)[self.pickerView viewForRow:self->monthIndex forComponent:1];
        [self setSelectLabel:label];
        
        label = (UILabel *)[self.pickerView viewForRow:self->dayIndex forComponent:2];
        [self setSelectLabel:label];
        
        [self setShowLabText];
    });
}

- (void)initSubViews{
    
    // 主要的View
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, kMainHeight)];
    _mainView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_mainView];
    
    [_mainView hl_addTarget:self action:nil];
    
    // 顶部View
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(50))];
    [_mainView addSubview:_controlView];
    _controlView.backgroundColor = UIColor.whiteColor;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, ScreenW/2, FitPTScreen(49));
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
    [_controlView addSubview:cancelBtn];
    
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBtn.frame = CGRectMake(ScreenW/2, 0, ScreenW/2, FitPTScreen(49));
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yesBtn setTitleColor:UIColorFromRGB(0xFF9900) forState:UIControlStateNormal];
    [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
    [_controlView addSubview:yesBtn];
    
    [cancelBtn addTarget:self action:@selector(CancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [yesBtn addTarget:self action:@selector(yesClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/2 - FitPTScreen(0.5), FitPTScreen(10), FitPTScreen(1), FitPTScreen(30))];
    [_controlView addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    
    // view
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, _controlView.frame.size.height - FitPTScreen(0.8), ScreenW, FitPTScreen(0.8))];
    [_controlView addSubview:topLine];
    topLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    
    // 选择view
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_controlView.frame), ScreenW, _mainView.frame.size.height - CGRectGetMaxY(_controlView.frame) - Height_Bottom_Margn)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_mainView addSubview:_pickerView];
    
    // 展示出来
    [UIView animateWithDuration:0.25 animations:^{
        _mainView.frame = CGRectMake(0, ScreenH - kMainHeight, ScreenW, kMainHeight);
    }];
}

- (void)setSelectLabel:(UILabel *)label{
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(20)];
}

#pragma mark - UIPickerView的数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray.count;
        
    }else if(component == 1) {
        
        return self.monthArray.count;
        
    }else {
        
        switch (monthIndex + 1) {
                
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12: return 31;
                
            case 4:
            case 6:
            case 9:
            case 11: return 30;
                
            default: {
                NSString *year = ((UILabel *)[_pickerView viewForRow:yearIndex forComponent:0]).text;
                return [year integerValue] %4 == 0 ? 29 : 28;
            }
        }
    }
}


- (void)remove {
    [UIView animateWithDuration:0.25 animations:^{
        _mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setShowLabText{
    NSString *year = ((UILabel *)[_pickerView viewForRow:yearIndex forComponent:0]).text;
    NSString *month = ((UILabel *)[_pickerView viewForRow:monthIndex forComponent:1]).text;
    NSString *day = ((UILabel *)[_pickerView viewForRow:dayIndex forComponent:2]).text;
    
    // 已label显示的时间为准
    _selectDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

#pragma mark - UIPickerView的代理

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        yearIndex = row;
        
        [self.pickerView reloadComponent:2];
        if (monthIndex + 1 == 4 || monthIndex + 1 == 6 || monthIndex + 1 == 9 || monthIndex + 1 == 11) {
            if (dayIndex + 1 == 31) {
                dayIndex--;
            }
        }else if (monthIndex + 1 == 2) {
            if (dayIndex + 1 > 28) {
                dayIndex = 27;
            }
        }
        [pickerView selectRow:dayIndex inComponent:2 animated:YES];
        
        UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
        [self setSelectLabel:label];
        
        label = (UILabel *)[pickerView viewForRow:self->dayIndex forComponent:2];
        [self setSelectLabel:label];
        
        [self setShowLabText];

        
        return;
    }
    
    if (component == 1) {
        monthIndex = row;
        [pickerView reloadComponent:2];
        if (monthIndex + 1 == 4 || monthIndex + 1 == 6 || monthIndex + 1 == 9 || monthIndex + 1 == 11) {
            if (dayIndex + 1 == 31) {
                dayIndex--;
            }
        }else if (monthIndex + 1 == 2) {
            if (dayIndex + 1 > 28) {
                dayIndex = 27;
            }
        }
        [pickerView selectRow:dayIndex inComponent:2 animated:YES];
        
        UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
        [self setSelectLabel:label];
        
        label = (UILabel *)[pickerView viewForRow:self->dayIndex forComponent:2];
        [self setSelectLabel:label];
        
        [self setShowLabText];
        return;
    }
    
    if(component == 2){
        dayIndex = row;
        UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
        [self setSelectLabel:label];
        
        [self setShowLabText];
        return;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return FitPTScreen(49);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            CGRect frame = CGRectMake(FitPTScreen(13), singleLine.frame.origin.y, ScreenW - FitPTScreen(13) * 2, FitPTScreen(0.8));
            singleLine.frame = frame;
            singleLine.backgroundColor = UIColorFromRGB(0xEDEDED);
        }
    }
    
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = UIColorFromRGB(0x999999);
    genderLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:FitPTScreen(16)];
    
    if (component == 0) {
        genderLabel.text = self.yearArray[row];
    }else if (component == 1) {
        genderLabel.text = self.monthArray[row];
    }else {
        genderLabel.text = self.dayArray[row];
    }
    return genderLabel;
}

-(void)CancelClick:(UIButton *)sender{
    
    [self remove];
}

-(void)yesClick:(UIButton *)sender{
    
    // 判断选择的时间和当前日期的比对
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    if (!_selectDate || _selectDate.length == 0) {
        _selectDate = self.startWithToday ? @"2019-09-17" : @"2009-09-17";
    }
    
    NSString *selectDateStr = [_selectDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (self.startWithToday && selectDateStr.integerValue < currentDateStr.integerValue) {
        HLShowText(@"选择日期不能早于当前时间");
        return;
    }
    
    if (self.callBack) {
        self.callBack(_selectDate);
    }
    [self remove];
}

#pragma mark - Getter

- (NSMutableArray *)yearArray {
    if (_yearArray == nil) {
        _yearArray = [NSMutableArray array];
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear;
        // 获取不同时间字段的信息
        NSDateComponents *comp = [gregorian components:unitFlags fromDate:dt];
        
        if (self.startWithToday) {
            for (NSInteger year = comp.year; year <= comp.year + 90 ; year++) {
                NSString *str = [NSString stringWithFormat:@"%ld", (long)year];
                [_yearArray addObject:str];
            }
        }else{
            for (NSInteger year = 1900; year <= comp.year ; year++) {
                NSString *str = [NSString stringWithFormat:@"%ld", year];
                [_yearArray addObject:str];
            }
        }
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray array];
        for (int month = 1; month <= 12 ; month++) {
            NSString *str = [NSString stringWithFormat:@"%02d", month];
            [_monthArray addObject:str];
        }
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray {
    if (_dayArray == nil) {
        _dayArray = [NSMutableArray array];
        for (int day = 1; day <= 31; day++) {
            NSString *str = [NSString stringWithFormat:@"%02d", day];
            [_dayArray addObject:str];
        }
    }
    return _dayArray;
}


@end
