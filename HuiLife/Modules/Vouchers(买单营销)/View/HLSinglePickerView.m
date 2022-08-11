//
//  HLSinglePickerView.m
//  HuiLife
//
//  Created by 王策 on 2019/9/2.
//

#import "HLSinglePickerView.h"

#define kMainHeight (FitPTScreen(269) + Height_Bottom_Margn)
#define kAnimateTime 0.1

@interface HLSinglePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, copy) HLSinglePickerBlock pickerBlock;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSString *currentTitle;
@end

@implementation HLSinglePickerView

+ (void)showCurrentTitle:(NSString *)currentTitle titles:(NSArray *)titles pickerBlock:(HLSinglePickerBlock)pickerBlock {
    HLSinglePickerView *pickerView = [[HLSinglePickerView alloc] initWithCurrentTitle:currentTitle titles:titles];
    pickerView.pickerBlock = pickerBlock;
    pickerView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [pickerView show];
}

- (instancetype)initWithCurrentTitle:(NSString *)currentTitle titles:(NSArray *)titles {
    self = [super init];
    if (self) {
        
        _titles = titles;
        _currentTitle = currentTitle;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, kMainHeight)];
        [self addSubview:mainView];
        mainView.backgroundColor = [UIColor whiteColor];
        _mainView = mainView;
        
        // 顶部View
        UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(50))];
        [_mainView addSubview:controlView];
        controlView.backgroundColor = UIColor.whiteColor;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, ScreenW / 2, FitPTScreen(50));
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
        [controlView addSubview:cancelBtn];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.frame = CGRectMake(ScreenW / 2, 0, ScreenW / 2, FitPTScreen(50));
        [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
        [yesBtn setTitleColor:UIColorFromRGB(0xFF9900) forState:UIControlStateNormal];
        [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
        [controlView addSubview:yesBtn];
        
        [cancelBtn addTarget:self action:@selector(CancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [yesBtn addTarget:self action:@selector(yesClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenW / 2 - FitPTScreen(0.5), FitPTScreen(10), FitPTScreen(1), FitPTScreen(30))];
        [controlView addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xEDEDED);
        
        // view
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, controlView.frame.size.height - FitPTScreen(0.8), ScreenW, FitPTScreen(0.8))];
        [controlView addSubview:topLine];
        topLine.backgroundColor = UIColorFromRGB(0xEDEDED);
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(controlView.frame), ScreenW, _mainView.frame.size.height - CGRectGetMaxY(controlView.frame))];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [mainView addSubview:_pickerView];
        
        [self configDefaultSelectTitle];
        
        self.mainView = mainView;
    }
    return self;
}

/// 配置初始选中的数据
- (void)configDefaultSelectTitle {
    if (!_currentTitle || _currentTitle.length == 0) {
        _selectIndex = 0;
    } else {
        _selectIndex = [_titles indexOfObject:_currentTitle];
    }
    
    [_pickerView selectRow:_selectIndex inComponent:0 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[_pickerView viewForRow:_selectIndex forComponent:0];
        [self setSelectLabel:label];
    });
}

#pragma mark UIPickerView的数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titles.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return FitPTScreen(49);
}

#pragma mark -UIPickerView的代理

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectIndex = row;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
        [self setSelectLabel:label];
    });
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = UIColorFromRGB(0x555555);
    genderLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    genderLabel.text = self.titles[row];
    return genderLabel;
}

- (void)setSelectLabel:(UILabel *)label {
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(17)];
}

- (void)CancelClick:(UIButton *)sender {
    [self remove];
}

- (void)yesClick:(UIButton *)sender {
    if (self.pickerBlock) {
        self.pickerBlock(_selectIndex);
    }
    [self remove];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.mainView.frame = CGRectMake(0, ScreenH - kMainHeight, ScreenW, kMainHeight);
                     }];
}

- (void)remove {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainHeight);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
@end
