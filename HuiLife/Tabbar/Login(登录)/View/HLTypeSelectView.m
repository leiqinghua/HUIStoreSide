//
//  HLAreaSelectView.m
//  MingPian
//
//  Created by HuiLife on 2018/12/25.
//  Copyright © 2018 HuiLife. All rights reserved.
//

#import "HLTypeSelectView.h"
#import "HLTypeModel.h"

#define kMainHeight (FitPTScreen(269) + Height_Bottom_Margn)
#define kAnimateTime 0.25

@interface HLTypeSelectView() <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger _oneIndex;
    NSInteger _twoIndex;
    
    UIView *topV;
    
    NSString *_oneTitle;
    NSString *_twoTitle;
    
    NSString *_oneSelectId;
    NSString *_twoSelectId;
}

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray <HLTypeModel *>*oneArr;

@property (nonatomic, strong) NSArray <HLTypeSubModel *>*twoArr;

@property (nonatomic, strong) NSArray <HLTypeModel *>*dataArr;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, copy) void(^selectBlock)(NSString *oneTitle, NSString *twoTitle, NSString *oneId, NSString *twoId);

@end

@implementation HLTypeSelectView

+ (void)showSelectViewWithArray:(NSArray <HLTypeModel *> *)array selectBlock:(void(^)(NSString *oneTitle, NSString *twoTitle, NSString *oneId, NSString *twoId))selectBlock{
    HLTypeSelectView *selectView = [[self alloc] initWithArr:array];
    selectView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    selectView.selectBlock = selectBlock;
    [selectView show];
}

- (instancetype)initWithArr:(NSArray <HLTypeModel *>*)dataArr
{
    self = [super init];
    if (self) {
        self.dataArr = dataArr;

        
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
        cancelBtn.frame = CGRectMake(0, 0, ScreenW/2, FitPTScreen(50));
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
        [controlView addSubview:cancelBtn];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.frame = CGRectMake(ScreenW/2, 0, ScreenW/2, FitPTScreen(50));
        [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
        [yesBtn setTitleColor:UIColorFromRGB(0xFF9900) forState:UIControlStateNormal];
        [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
        [controlView addSubview:yesBtn];
        
        [cancelBtn addTarget:self action:@selector(CancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [yesBtn addTarget:self action:@selector(yesClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/2 - FitPTScreen(0.5), FitPTScreen(10), FitPTScreen(1), FitPTScreen(30))];
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
        
        self.mainView = mainView;
        
        [_pickerView selectRow:_oneIndex inComponent:0 animated:YES];
        [_pickerView selectRow:_twoIndex inComponent:1 animated:YES];
        
        [self pickerView:_pickerView didSelectRow:_oneIndex inComponent:0];
        [self pickerView:_pickerView didSelectRow:_twoIndex inComponent:1];
    }
    return self;
}

#pragma mark -UIPickerView
#pragma mark UIPickerView的数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.oneArr.count;
    }else {
        return self.twoArr.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return FitPTScreen(49);
}

#pragma mark -UIPickerView的代理

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _oneIndex = row;
        _twoIndex = 0;
        [pickerView reloadAllComponents];
        [pickerView selectRow:_twoIndex inComponent:1 animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            [self setSelectLabel:label];
            label = (UILabel *)[pickerView viewForRow:self->_twoIndex forComponent:1];
            [self setSelectLabel:label];
            [self configCacheContent];
        });

    }else  {
        _twoIndex = row;
        UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
        [self setSelectLabel:label];
        [self configCacheContent];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = UIColorFromRGB(0x555555);
    genderLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    if (component == 0) {
        genderLabel.text = [self.oneArr[row] name];
    }else {
        genderLabel.text = [self.twoArr[row] name];
    }
    return genderLabel;
}

- (void)setSelectLabel:(UILabel *)label{
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(17)];
}

- (void)configCacheContent{
    
    _oneTitle = ((UILabel *)[_pickerView viewForRow:_oneIndex forComponent:0]).text;
    _twoTitle = ((UILabel *)[_pickerView viewForRow:_twoIndex forComponent:1]).text?:@"";
    
    _oneSelectId = [self.oneArr[_oneIndex] id];
    _twoSelectId = [self.twoArr[_twoIndex] id];
}

-(void)CancelClick:(UIButton *)sender{
    [self remove];
}

-(void)yesClick:(UIButton *)sender{
    if (self.selectBlock) {
        self.selectBlock(_oneTitle, _twoTitle, _oneSelectId, _twoSelectId);
    }
    [self remove];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = CGRectMake(0, ScreenH - kMainHeight, ScreenW, kMainHeight);
    }];
}

- (void)remove {
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Getter

- (NSArray <HLTypeModel *>*)oneArr{
    if (!_oneArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        [mArr addObjectsFromArray:self.dataArr];
        _oneArr = [mArr copy];
    }
    return _oneArr;
}

- (NSArray <HLTypeSubModel *>*)twoArr{
    _twoArr = [self.oneArr[_oneIndex] sub];
    return _twoArr;
}


@end

