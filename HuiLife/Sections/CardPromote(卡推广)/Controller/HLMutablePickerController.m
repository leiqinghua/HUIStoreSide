//
//  HLMutablePickerController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/19.
//

#import "HLMutablePickerController.h"
#define kMainHeight (FitPTScreen(269) + Height_Bottom_Margn)
#define kAnimateTime 0.1

@interface HLMutablePickerController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIPickerView *pickerView;
//一级分类
@property (nonatomic, strong) HLMutablePickerModel *selectModel;
//二级分类
@property (nonatomic, strong) HLMutablePickerModel *subModel;

@property (nonatomic, assign) NSInteger subRow;//二级分类位置

@property(nonatomic, strong) NSArray<HLMutablePickerModel *> *pickerDatasource;

@end

@implementation HLMutablePickerController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];;
        self.mainView.frame = CGRectMake(0, ScreenH - kMainHeight, ScreenW, kMainHeight);
    } completion:^(BOOL finished) {
         
    }];
}


- (void)CancelClick:(UIButton *)sender {
    [self remove];
}

- (void)yesClick:(UIButton *)sender {
    if (self.pickerBlock) {
        self.pickerBlock(_selectModel.name, _subModel.name, _selectModel.Id, _subModel.Id);
    }
    [self remove];
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView {
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, kMainHeight)];
    [self.view addSubview:mainView];
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
        
}


- (void)configDataSource:(NSArray<HLMutablePickerModel *> *)pickerDatasource bigId:(NSString *)bigId subId:(NSString *)subId {
    _pickerDatasource = pickerDatasource;
    NSInteger bigRow = 0;
    _subRow = 0;
    for (HLMutablePickerModel*model in _pickerDatasource) {
        if ([model.Id isEqualToString:bigId]) {
            _selectModel = model;
            bigRow = [_pickerDatasource indexOfObject:model];
            
            for (HLMutablePickerModel *subModel in model.sub) {
                if ([subModel.Id isEqualToString:subId]) {
                    _subRow = [model.sub indexOfObject:subModel];
                    break;
                }
            }
            
            break;
        }
    }
    
    _selectModel = _pickerDatasource[bigRow];
    _subModel = _selectModel.sub[_subRow];
    [self.pickerView reloadAllComponents];
    [_pickerView selectRow:bigRow inComponent:0 animated:false];
    [_pickerView selectRow:_subRow inComponent:1 animated:false];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickerDatasource.count;
    }
    return self.selectModel.sub.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return FitPTScreen(49);
}

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectModel = self.pickerDatasource[row];
        [pickerView reloadComponent:1];
    } else {
        _subModel = _selectModel.sub[row];
        _subRow = row;
    }
    
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
    
    if (component == 0) {
        HLMutablePickerModel *model = self.pickerDatasource[row];
        genderLabel.text = model.name;
    } else {
        HLMutablePickerModel *submodel = _selectModel.sub[row];
        genderLabel.text = submodel.name;
        
        if (_selectModel.sub.count < _subRow + 1) {
            _subModel = _selectModel.sub.lastObject;
        } else if (_subRow == row ) {
            _subModel = submodel;
        }
        
    }
    return genderLabel;
}


- (void)setSelectLabel:(UILabel *)label {
    label.textColor = UIColorFromRGB(0x555555);
    label.font = [UIFont systemFontOfSize:FitPTScreen(17)];
}

- (void)remove {
    [UIView animateWithDuration:0.25
                     animations:^{
        self.mainView.frame = CGRectMake(0, ScreenH, ScreenW, kMainHeight);
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];;
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

@end



@implementation HLMutablePickerModel

+ (NSDictionary *)objectClassInArray {
    return @{
        @"sub": @"HLMutablePickerModel"
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id":@"id",
             };
}

@end
