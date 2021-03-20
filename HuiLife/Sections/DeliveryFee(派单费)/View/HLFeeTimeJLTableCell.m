//
//  HLFeeTimeJLTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLFeeTimeJLTableCell.h"
#import "HLFeeInputView.h"
#import "HLFeeMainInfo.h"
#import "HLSellTimeSelectView.h"

@interface HLFeeTimeJLTableCell () <HLFeeInputViewDelegate>
@property(nonatomic, strong) HLFeeInputView *inputView;
@property(nonatomic, strong) UIButton *endBtn;
@property(nonatomic, strong) UIButton *startBtn;
@property(nonatomic, assign) NSInteger startIndex;
@property(nonatomic, assign) NSInteger endIndex;
@end

@implementation HLFeeTimeJLTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _inputView = [[HLFeeInputView alloc]init];
    _inputView.title = @"则加派单费 ¥";
    _inputView.inputWidth = FitPTScreen(55);
    _inputView.delegate = self;
    [self.contentView addSubview:_inputView];
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.centerY.height.equalTo(self.contentView);
    }];
    
    _endBtn = [[UIButton alloc]init];
    _endBtn.layer.cornerRadius = FitPTScreen(3);
    _endBtn.layer.masksToBounds = YES;
    _endBtn.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    _endBtn.layer.borderWidth = 0.5;
    [_endBtn setTitle:@"00:00" forState:UIControlStateNormal];
    [_endBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _endBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.contentView addSubview:_endBtn];
    [_endBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_inputView.left).offset(FitPTScreen(-9));
        make.centerY.equalTo(self.inputView);
        make.size.equalTo(CGSizeMake(FitPTScreen(80), FitPTScreen(30)));
    }];
    
    UIImageView *endImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey"]];
    [_endBtn addSubview:endImV];
    [endImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.endBtn);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.endBtn.left).offset(FitPTScreen(-9));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(12), FitPTScreen(0.5)));
    }];
    
    _startBtn = [[UIButton alloc]init];
    _startBtn.layer.cornerRadius = FitPTScreen(3);
    _startBtn.layer.masksToBounds = YES;
    _startBtn.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    _startBtn.layer.borderWidth = 0.5;
    [_startBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_startBtn setTitle:@"00:00" forState:UIControlStateNormal];
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.contentView addSubview:_startBtn];
    [_startBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line.left).offset(FitPTScreen(-9));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(80), FitPTScreen(30)));
    }];
    
    [_startBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *startImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey"]];
    [_startBtn addSubview:startImV];
    [startImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.startBtn);
    }];
}

#pragma mark - setter
- (void)setTimeInfo:(HLFeeTimeInfo *)timeInfo {
    _timeInfo = timeInfo;
    [_startBtn setTitle:(timeInfo.start_time.length?timeInfo.start_time:@"00:00") forState:UIControlStateNormal];
    [_endBtn setTitle:(timeInfo.end_time.length?timeInfo.end_time:@"00:00") forState:UIControlStateNormal];
    _inputView.title = timeInfo.label;
    _inputView.text = timeInfo.distance_amount;
}
#pragma mark - Method
- (NSInteger)compareWithStart:(NSString *)startTime end:(NSString *)endTime format:(NSString *)format {
    NSString *start = startTime;
    NSString *end = endTime;
    if ([start isEqualToString:@"24:00"]) {
        start = @"23:59";
    }
    if ([end isEqualToString:@"24:00"]) {
        end = @"23:59";
    }
    return [HLTools compareWithFirst:start another:end formate:format];
}
#pragma mark - Event
- (void)selectTime:(UIButton *)sender {
    
    if (self.HLFeeTimeSelectBack) self.HLFeeTimeSelectBack();
    HLFeeTimeInfo *timeInfo = (HLFeeTimeInfo *)_timeInfo;
    BOOL start = [sender isEqual:self.startBtn];
    
    weakify(self);
    [HLSellTimeSelectView showWithTitles:_titles selectIndex:start?_startIndex:_endIndex dependView:sender completion:^(NSInteger index) {
        NSString *title = weak_self.titles[index];
        if (start) {
            // 判断 begin<end
            NSInteger result =  [self compareWithStart:title end:timeInfo.end_time format:@"HH:mm"];
            if ((result == 1 && timeInfo.end_time.length) || !timeInfo.end_time.length) {
                timeInfo.start_time = title;
                [timeInfo.pargrams setObject:timeInfo.start_time forKey:timeInfo.startTimeKey];
                weak_self.startIndex = index;
                [sender setTitle:title forState:UIControlStateNormal];
            } else HLShowHint(@"起始时间应小于结束时间", nil);
            return;
        }
        NSInteger result = [self compareWithStart:timeInfo.start_time end:title format:@"HH:mm"];
        if ((result == 1 && timeInfo.start_time.length) || !timeInfo.start_time.length) {
            timeInfo.end_time = title;
            [timeInfo.pargrams setObject:timeInfo.end_time forKey:timeInfo.endTimeKey];
            weak_self.endIndex = index;
            [sender setTitle:title forState:UIControlStateNormal];
        } else HLShowHint(@"结束时间应大于起始时间", nil);
    }];
}

#pragma mark - HLFeeInputViewDelegate

- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text {
    HLFeeTimeInfo *timeInfo = (HLFeeTimeInfo *)_timeInfo;
    timeInfo.distance_amount = text;
    [timeInfo.pargrams setObject:timeInfo.distance_amount forKey:timeInfo.distanceKey];
}

@end
