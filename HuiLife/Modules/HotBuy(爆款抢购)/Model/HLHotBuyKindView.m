//
//  HLHotBuyKindView.m
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLHotBuyKindView.h"

#define kMainHeight (FitPTScreen(295) + Height_Bottom_Margn)

@interface HLHotBuyKindView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger _selectOneIndex;
    NSInteger _selectTwoIndex;
    NSInteger _selectThreeIndex;
}

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UILabel *showLab; // 展示lab
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *controlView;

@property (nonatomic, copy) NSArray *allDatas; // 所有的数据

@property (nonatomic, copy) HLHotBuyKindCallBack callBack;

@end

@implementation HLHotBuyKindView

+ (void)showHotBuyKindView:(NSArray *)kinds allDatas:(NSArray *)allDatas callBack:(HLHotBuyKindCallBack)callBack{
    HLHotBuyKindView *kindView = [[HLHotBuyKindView alloc] init];
    kindView.callBack = callBack;
    [kindView configSelectKinds:kinds allDatas:allDatas];
    [[[UIApplication sharedApplication].delegate window] addSubview:kindView];
    [kindView show];
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

// 配置选中的数据 和 所有数据
- (void)configSelectKinds:(NSArray *)kinds allDatas:(NSArray *)allDatas{
    self.allDatas = allDatas;
    [self.pickerView reloadAllComponents];
    
    if (kinds.count == 3) {
        _selectOneIndex = [self findSelectOneIndexWithName:kinds[0]];
        _selectTwoIndex = [self findSelectTwoIndexWithName:kinds[1]];
        _selectThreeIndex = [self findSelectThreeIndexWithName:kinds[2]];
    }
    
    [_pickerView selectRow:_selectOneIndex inComponent:0 animated:NO];
    [_pickerView selectRow:_selectTwoIndex inComponent:1 animated:NO];
    [_pickerView selectRow:_selectThreeIndex inComponent:2 animated:NO];
    
    [self setShowLabText];
}

// 找到第三级分类对应的下表
- (NSInteger)findSelectThreeIndexWithName:(NSString *)name{
    HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
    HLHotBuyKindModel *level2Model = level1Model.child[_selectTwoIndex];
    __block NSInteger index = 0;
    [level2Model.child enumerateObjectsUsingBlock:^(HLHotBuyKindModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.cat_name isEqualToString:name]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}


// 找到第二级分类对应的下表
- (NSInteger)findSelectTwoIndexWithName:(NSString *)name{
    HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
    __block NSInteger index = 0;
    [level1Model.child enumerateObjectsUsingBlock:^(HLHotBuyKindModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.cat_name isEqualToString:name]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

// 找到第一级分类对应的下表
- (NSInteger)findSelectOneIndexWithName:(NSString *)name{
    __block NSInteger index = 0;
    [self.allDatas enumerateObjectsUsingBlock:^(HLHotBuyKindModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.cat_name isEqualToString:name]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)initSubViews{

    // 主要的View
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, kMainHeight)];
    _mainView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_mainView];
    [_mainView hl_addTarget:nil action:nil];
    
    // 展示已选的
    _showLab = [[UILabel alloc] init];
    [_mainView addSubview:_showLab];
    _showLab.textColor = UIColorFromRGB(0xFF9900);
    _showLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _showLab.text = @"已经：生活用品>家庭用纸>手帕纸";
    _showLab.frame = CGRectMake(FitPTScreen(12.5), 0, ScreenW - FitPTScreen(25), FitPTScreen(45));
    
    // 选择view
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_showLab.frame), ScreenW, FitPTScreen(190))];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_mainView addSubview:_pickerView];

    // 顶部View
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pickerView.frame), ScreenW, FitPTScreen(60))];
    [_mainView addSubview:_controlView];
    _controlView.backgroundColor = UIColor.whiteColor;
    _controlView.layer.shadowColor = UIColor.blackColor.CGColor;
    _controlView.layer.shadowOpacity = 0.08;

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_controlView addSubview:cancelBtn];
    cancelBtn.layer.borderWidth = 0.7;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = FitPTScreen(7);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = UIColorFromRGB(0xBFBFBF).CGColor;
    [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreen(14)]];
    cancelBtn.frame = CGRectMake(0, 0, FitPTScreen(95.5), FitPTScreen(35));
    cancelBtn.center = CGPointMake(CGRectGetWidth(_controlView.frame)/4, CGRectGetHeight(_controlView.frame)/2);

    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_controlView addSubview:yesBtn];
    yesBtn.layer.masksToBounds = YES;
    yesBtn.layer.cornerRadius = FitPTScreen(30);
    [yesBtn setBackgroundImage:[UIImage imageNamed:@"bottom_view_ok"] forState:UIControlStateNormal];
    [yesBtn setBackgroundImage:[UIImage imageNamed:@"bottom_view_ok"] forState:UIControlStateHighlighted];
    yesBtn.frame = CGRectMake(0, 0, FitPTScreen(122), FitPTScreen(58));
    yesBtn.center = CGPointMake(CGRectGetWidth(_controlView.frame)/4*3, CGRectGetHeight(_controlView.frame)/2 + FitPTScreen(2));

    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [yesBtn addTarget:self action:@selector(yesClick) forControlEvents:UIControlEventTouchUpInside];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/2 - FitPTScreen(0.5), FitPTScreen(15), FitPTScreen(1), FitPTScreen(30))];
    [_controlView addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
}

- (void)setSelectLabel:(UILabel *)label{
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(20)];
}

#pragma mark - UIPickerView的数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.allDatas.count;
    }
    if(component == 1) {
        HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
        return level1Model.child.count;
    }
    
    HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
    HLHotBuyKindModel *level2Model = level1Model.child[_selectTwoIndex];
    return level2Model.child.count;
}


#pragma mark - UIPickerView的代理

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return FitPTScreen(49);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            CGRect frame = CGRectMake(FitPTScreen(13), singleLine.frame.origin.y, ScreenW - FitPTScreen(13) * 2, 0.6);
            singleLine.frame = frame;
            singleLine.backgroundColor = UIColorFromRGB(0xFFA120);
        }
    }

    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = UIColorFromRGB(0x999999);
    genderLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    
    if (component == 0) {
        HLHotBuyKindModel *level1Model = self.allDatas[row];
        genderLabel.text = level1Model.cat_name;
    }else if (component == 1) {
        HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
        HLHotBuyKindModel *level2Model = level1Model.child[row];
        genderLabel.text = level2Model.cat_name;
    }else {
        HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
        HLHotBuyKindModel *level2Model = level1Model.child[_selectTwoIndex];
        HLHotBuyKindModel *level3Model = level2Model.child[row];
        genderLabel.text = level3Model.cat_name;
    }
    return genderLabel;
}

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _selectOneIndex = row;
        _selectTwoIndex = 0;
        _selectThreeIndex = 0;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:_selectTwoIndex inComponent:1 animated:NO];
        [pickerView selectRow:_selectThreeIndex inComponent:2 animated:NO];
        [self setShowLabText];
        return;
    }

    if (component == 1) {
        _selectTwoIndex = row;
        _selectThreeIndex = 0;
        [pickerView reloadComponent:2];
        [pickerView selectRow:_selectThreeIndex inComponent:2 animated:NO];
        [self setShowLabText];
        return;
    }

    if(component == 2){
        _selectThreeIndex = row;
        [self setShowLabText];
        return;
    }
}

// 设置需要展示的文字
- (void)setShowLabText{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UILabel *label = (UILabel *)[_pickerView viewForRow:_selectOneIndex forComponent:0];
        [self setSelectLabel:label];
        NSString *first = label.text;
               
        label = (UILabel *)[_pickerView viewForRow:_selectTwoIndex forComponent:1];
        [self setSelectLabel:label];
        NSString *second = label.text;

        label = (UILabel *)[_pickerView viewForRow:_selectThreeIndex forComponent:2];
        [self setSelectLabel:label];
        NSString *third = label.text;

        _showLab.text = [NSString stringWithFormat:@"已经：%@>%@>%@",first,second,third];
    });
}

// 点击取消按钮
-(void)cancelClick{
    [self remove];
}

// 点击确定按钮
-(void)yesClick{
    if (self.callBack) {
        HLHotBuyKindModel *level1Model = self.allDatas[_selectOneIndex];
        HLHotBuyKindModel *level2Model = level1Model.child[_selectTwoIndex];
        HLHotBuyKindModel *level3Model = level2Model.child[_selectThreeIndex];
        NSString *selectName = [NSString stringWithFormat:@"%@>%@>%@",level1Model.cat_name,level2Model.cat_name,level3Model.cat_name];
        self.callBack(selectName,level1Model.cat_id,level2Model.cat_id,level3Model.cat_id);
    }
    [self remove];
}

// 移除视图
- (void)remove {
    [UIView animateWithDuration:0.25 animations:^{
        _mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 展示视图
- (void)show{
    // 展示出来
    [UIView animateWithDuration:0.25 animations:^{
        _mainView.frame = CGRectMake(0, ScreenH - kMainHeight, ScreenW, kMainHeight);
    }];
}

@end

