//
//  HLSelectArea.m
//  Test
//
//  Created by 闻喜惠生活 on 2018/8/28.
//  Copyright © 2018年 闻喜惠生活. All rights reserved.
//

#import "HLSelectArea.h"
#import "HLAreaCache.h"

@interface HLSelectArea ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSInteger proIndex;
    
    NSInteger cityIndex;
    
    NSInteger areaIndex;
    
    UIView *topV;
    
    NSInteger currentPro;
    
    NSInteger currentCity;
    
    NSInteger currentArea;
}
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *proArray;

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, strong) NSMutableArray *areaArray;
//
@property (nonatomic, strong) NSArray *areas;
@end

@implementation HLSelectArea

- (NSMutableArray *)proArray {
    
    if (_proArray == nil) {
        
        _proArray = [NSMutableArray array];
        //解析省市区
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
    NSArray * areas = area[@"area"];
    [_areaArray removeAllObjects];
    [_areaArray addObjectsFromArray:areas];
    return _areaArray;
}

- (instancetype)initWithArr:(NSArray *)areas
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        self.areas = areas;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        topV = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenH, ScreenW, FitPTScreenH(40))];
        topV.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self addSubview:topV];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, FitPTScreen(100), FitPTScreenH(40));
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreenH(16)]];
        [topV addSubview:cancelBtn];
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - FitPTScreen(100), 0, FitPTScreen(100), FitPTScreenH(40));
        //        yesBtn.frame = CGRectZero;
        [yesBtn setTitle:@"完成" forState:UIControlStateNormal];
        [yesBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
        [yesBtn.titleLabel setFont:[UIFont systemFontOfSize:FitPTScreenH(16)]];
        [topV addSubview:yesBtn];
        
        [cancelBtn addTarget:self action:@selector(CancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [yesBtn addTarget:self action:@selector(yesClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topV.frame), [UIScreen mainScreen].bounds.size.width, FitPTScreenH(207))];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
        [_pickerView selectRow:proIndex inComponent:0 animated:YES];
        [_pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [_pickerView selectRow:areaIndex inComponent:2 animated:YES];
        
        [self pickerView:_pickerView didSelectRow:proIndex inComponent:0];
        [self pickerView:_pickerView didSelectRow:cityIndex inComponent:1];
        [self pickerView:_pickerView didSelectRow:areaIndex inComponent:2];
        
        MJWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[weakSelf.pickerView viewForRow:self->proIndex forComponent:0];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
            label = (UILabel *)[weakSelf.pickerView viewForRow:self->cityIndex forComponent:1];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
            label = (UILabel *)[weakSelf.pickerView viewForRow:self->areaIndex forComponent:2];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
        });
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self->topV.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - FitPTScreenH(247), [UIScreen mainScreen].bounds.size.width,FitPTScreenH(40));
            //topV.bottom
            self->_pickerView.frame = CGRectMake(0, CGRectGetMaxY(self->topV.frame), [UIScreen mainScreen].bounds.size.width, FitPTScreenH(207));
        }];
        
    }
    return self;
}

#pragma mark -UIPickerView
#pragma mark UIPickerView的数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.proArray.count;
        
    }else if(component == 1) {
        
        return self.cityArray.count;
        
    }else {
        return self.areaArray.count;
    }
}


- (void)remove {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self->topV.frame = CGRectMake(0,  [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width,FitPTScreenH(40));
        self->_pickerView.frame = CGRectMake(0, CGRectGetMaxY(self->topV.frame),  [UIScreen mainScreen].bounds.size.width, FitPTScreenH(207));
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}
#pragma mark -UIPickerView的代理

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        proIndex = row;
        cityIndex = 0;
        areaIndex = 0;
        [pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [pickerView selectRow:areaIndex inComponent:2 animated:YES];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
            label = (UILabel *)[self.pickerView viewForRow:self->cityIndex forComponent:1];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
            label = (UILabel *)[self.pickerView viewForRow:self->areaIndex forComponent:2];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
        });
        
    }else if (component == 1) {
        
        cityIndex = row;
        areaIndex = 0;
        [pickerView reloadComponent:2];
        [pickerView selectRow:areaIndex inComponent:2 animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
            label = (UILabel *)[pickerView viewForRow:self->areaIndex forComponent:2];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
        });
    }else {
        
        areaIndex = row;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = UIColorFromRGB(0xFF8D26);
            label.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
            
        });
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor =[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    genderLabel.font = [UIFont systemFontOfSize:FitPTScreenH(16)];
    if (component == 0) {
        
        genderLabel.text = self.proArray[row][@"name"];
        
    }else if (component == 1) {
        
        genderLabel.text = self.cityArray[row][@"name"];
    }else {
        
        genderLabel.text = self.areaArray[row][@"name"];
    }
    
    return genderLabel;
}

-(void)CancelClick:(UIButton *)sender{
    if (_block) {
        _block(nil,nil);
    }
    [self remove];
}

-(void)yesClick:(UIButton *)sender{
    
    if (_block && (((UILabel *)[_pickerView viewForRow:proIndex forComponent:0]).text && ((UILabel *)[_pickerView viewForRow:cityIndex forComponent:1]).text && ((UILabel *)[_pickerView viewForRow:areaIndex forComponent:2]).text )) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@",((UILabel *)[_pickerView viewForRow:proIndex forComponent:0]).text, ((UILabel *)[_pickerView viewForRow:cityIndex forComponent:1]).text, ((UILabel *)[_pickerView viewForRow:areaIndex forComponent:2]).text];
        NSArray * areas;
        if (timeStr) {
            NSDictionary * city = self.cityArray[cityIndex];
            NSDictionary * areaDict = self.areaArray[areaIndex];
            areas= @[city[@"code"],city[@"code"],areaDict[@"id"]];
        }
        _block(timeStr,areas);
        
    }
    [self remove];
}
@end
