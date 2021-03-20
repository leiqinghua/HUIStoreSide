//
//  HLAreaSelectView.m
//  MingPian
//
//  Created by HuiLife on 2018/12/25.
//  Copyright © 2018 HuiLife. All rights reserved.
//

#import "HLAreaSelectView.h"

#define kMainHeight (FitPTScreen(269) + Height_Bottom_Margn)
#define kAnimateTime 0.25

@interface HLAreaSelectView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger proIndex;
    NSInteger cityIndex;
    NSInteger areaIndex;
    UIView *topV;
    NSInteger currentPro;
    NSInteger currentCity;
    NSInteger currentArea;
    
    NSString *_province;
    NSString *_city;
    NSString *_area;
    
    NSString *_provinceId;
    NSString *_cityId;
    NSString *_areaId;
}
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *proArray;

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, strong) NSMutableArray *areaArray;

@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, strong) UIView *mainView;

//0 是店铺地址，1 是用户端 城市选择
@property(nonatomic,assign)NSInteger type;

@end

@implementation HLAreaSelectView

+ (void)showCurrentSelectArea:(NSString *)selectArea areas:(NSArray *)areas type:(NSInteger)type callBack:(HLAreaBlock)callBack{
    HLAreaSelectView *selctView = [[HLAreaSelectView alloc] initWithArr:areas selectArea:selectArea type:type];
    selctView.block = callBack;
    selctView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [selctView show];
}


+ (void)showCurrentSelectArea:(NSString *)selectArea areas:(NSArray *)areas callBack:(HLAreaBlock)callBack{
    HLAreaSelectView *selctView = [[HLAreaSelectView alloc] initWithArr:areas selectArea:selectArea type:0];
    selctView.block = callBack;
    selctView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [selctView show];
}

- (instancetype)initWithArr:(NSArray *)areas selectArea:(NSString *)selectArea type:(NSInteger)type
{
    self = [super init];
    if (self) {
        self.areas = areas;
        self.type = type;
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
    
        [self normalSelectWithSelectArea:selectArea];
        
        self.mainView = mainView;
    }
    return self;
}

- (void)normalSelectWithSelectArea:(NSString *)selectArea{
    
    NSArray *areaArr = [selectArea componentsSeparatedByString:@" "];
    if (areaArr.count == 3) {
        // 找到第一个的位置
        proIndex = [self firstSelectIndexWithCompont:0 selectName:areaArr[0]];
        cityIndex = [self firstSelectIndexWithCompont:1 selectName:areaArr[1]];
        areaIndex = [self firstSelectIndexWithCompont:2 selectName:areaArr[2]];
    }else if (areaArr.count == 2){
        proIndex = [self firstSelectIndexWithCompont:0 selectName:areaArr[0]];
        cityIndex = [self firstSelectIndexWithCompont:1 selectName:areaArr[0]];
        areaIndex = [self firstSelectIndexWithCompont:2 selectName:areaArr[1]];
    }
    
    [_pickerView selectRow:proIndex inComponent:0 animated:YES];
    [_pickerView selectRow:cityIndex inComponent:1 animated:YES];
    [_pickerView selectRow:areaIndex inComponent:2 animated:YES];
    
    [self pickerView:_pickerView didSelectRow:proIndex inComponent:0];
    [self pickerView:_pickerView didSelectRow:cityIndex inComponent:1];
    [self pickerView:_pickerView didSelectRow:areaIndex inComponent:2];
    
//    @WeakObj(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UILabel *label = (UILabel *)[selfWeak.pickerView viewForRow:self->proIndex forComponent:0];
//        [self setSelectLabel:label];
//
//        label = (UILabel *)[selfWeak.pickerView viewForRow:self->cityIndex forComponent:1];
//        [self setSelectLabel:label];
//
//        label = (UILabel *)[selfWeak.pickerView viewForRow:self->areaIndex forComponent:2];
//        [self setSelectLabel:label];
//
//        [self configCacheContent];
//    });
}

- (NSInteger)firstSelectIndexWithCompont:(NSInteger)compont selectName:(NSString *)name{
    NSArray *selectArr = @[];
    if (compont == 0) {
        selectArr = self.proArray;
    }
    if (compont == 1) {
        selectArr = self.cityArray;
    }
    if (compont == 2) {
        selectArr = self.areaArray;
    }
    
    NSInteger selectIndex = 0;
    for (NSInteger i = 0; i < selectArr.count; i++) {
        NSDictionary *dict = selectArr[i];
        if ([dict[@"name"] isEqualToString:name]) {
            selectIndex = i;
            break;
        }
    }
    return selectIndex;
}

#pragma mark -UIPickerView
#pragma mark UIPickerView的数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.proArray.count;
    }else if(component == 1) {
        return self.cityArray.count;
    }else {
        return self.areaArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return FitPTScreen(49);
}

#pragma mark -UIPickerView的代理

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        proIndex = row;
        cityIndex = cityIndex + 1 > self.cityArray.count ? self.cityArray.count - 1 : cityIndex;
        areaIndex = areaIndex + 1 > self.areaArray.count ? self.areaArray.count - 1 : areaIndex;
        if (areaIndex < 0 && self.areaArray.count > 0) {
            areaIndex = 0;
        }
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        if (cityIndex >= 0) {
            [pickerView selectRow:cityIndex inComponent:1 animated:YES];
        }
        if (areaIndex >= 0) {
            [pickerView selectRow:areaIndex inComponent:2 animated:YES];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            [self setSelectLabel:label];
            label = (UILabel *)[self.pickerView viewForRow:self->cityIndex forComponent:1];
            [self setSelectLabel:label];
            label = (UILabel *)[self.pickerView viewForRow:self->areaIndex forComponent:2];
            [self setSelectLabel:label];
            
            [self configCacheContent];

        });
        
//        NSLog(@"proindex => %ld, cityIndex => %ld, areaIndex => %ld",proIndex,cityIndex,areaIndex);
        
    }else if (component == 1) {
        cityIndex = row;
        areaIndex = areaIndex + 1 > self.areaArray.count ? self.areaArray.count - 1 : areaIndex;
        // 判断此时数据是否有区
        if (areaIndex < 0 && self.areaArray.count > 0) {
            areaIndex = 0;
        }
        [pickerView reloadComponent:2];
        if (areaIndex >= 0) {
            [pickerView selectRow:areaIndex inComponent:2 animated:NO];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            [self setSelectLabel:label];
            
            label = (UILabel *)[pickerView viewForRow:self->areaIndex forComponent:2];
            [self setSelectLabel:label];
            
            [self configCacheContent];
        });
//        NSLog(@"proindex => %ld, cityIndex => %ld, areaIndex => %ld",proIndex,cityIndex,areaIndex);

        
    }else {
        areaIndex = row;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            [self setSelectLabel:label];
    
            [self configCacheContent];
        });
//        NSLog(@"proindex => %ld, cityIndex => %ld, areaIndex => %ld",proIndex,cityIndex,areaIndex);

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
        genderLabel.text = self.proArray[row][@"name"];
    }else if (component == 1) {
        genderLabel.text = self.cityArray[row][@"name"];
    }else {
        genderLabel.text = self.areaArray[row][@"name"];
    }
    return genderLabel;
}

- (void)setSelectLabel:(UILabel *)label{
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(17)];
}

- (void)configCacheContent{
    
    _province = ((UILabel *)[_pickerView viewForRow:proIndex forComponent:0]).text;
    _city = ((UILabel *)[_pickerView viewForRow:cityIndex forComponent:1]).text?:@"";
    _area = ((UILabel *)[_pickerView viewForRow:areaIndex forComponent:2]).text?:@"";
    
    if (self.cityArray.count > cityIndex) {
        NSDictionary *cityDict = self.cityArray[cityIndex];
        _cityId = _type == 0?cityDict[@"code"]:cityDict[@"pid"];
    }else{
        _cityId = @"";
    }
    
    if (self.areaArray.count > areaIndex) {
        NSDictionary *areaDict = self.areaArray[areaIndex];
        _areaId = _type == 0?areaDict[@"id"]:areaDict[@"pid"];
    }else{
        _areaId = @"";
    }
    
    NSDictionary *dataDict = self.proArray[proIndex];
    _provinceId = _type == 0?dataDict[@"code"]:dataDict[@"pid"];
   
}

-(void)CancelClick:(UIButton *)sender{
    [self remove];
}

-(void)yesClick:(UIButton *)sender{
    if (_block && _province && _city && _area) {
        _block(_province,_city,_area,_provinceId,_cityId,_areaId);
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

- (NSMutableArray *)proArray {
    if (_proArray == nil) {
        _proArray = [NSMutableArray array];
        NSArray * provences = self.areas;
        [_proArray addObjectsFromArray:provences];
    }
    return _proArray;
}

- (NSMutableArray *)cityArray {
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    NSDictionary * city = self.proArray[proIndex];
    NSArray * citys = city[@"city"];
    [_cityArray removeAllObjects];
    [_cityArray addObjectsFromArray:citys];
    return _cityArray;
}

- (NSMutableArray *)areaArray {
    if (_areaArray == nil) {
        _areaArray = [NSMutableArray array];
    }
    NSDictionary * area = self.cityArray[cityIndex];
    NSArray * areas = _type == 0?area[@"area"]:area[@"city"];
    [_areaArray removeAllObjects];
    [_areaArray addObjectsFromArray:areas];
    return _areaArray;
}


@end
