//
//  HLCardDiscountController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
//

#import "HLCardDiscountController.h"
#import "HLCalculateDiscountView.h"

@interface HLCardDiscountController ()

@property(nonatomic, copy) NSString *type;

@property(nonatomic, strong) NSMutableArray *disButtons;

@property(nonatomic, strong) UIView *bagView;

@property(nonatomic, strong)HLDiscountButton *lastSelectDisBtn;

@property(nonatomic, strong)HLCalculateDiscountView *calculateView;

@property(nonatomic, strong)NSArray *discounts;

@property(nonatomic, copy) NSString *minValue;

@end

@implementation HLCardDiscountController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];;
    } completion:^(BOOL finished) {
        
    }];
}

- (instancetype)initWithType:(NSString *)type {
    if (self = [super init]) {
        _type = type;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return self;
}

#pragma mark -event
- (void)cancleClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.bagView.alpha = 0.0;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];;
    } completion:^(BOOL finished) {
       [self dismissViewControllerAnimated:false completion:nil];
    }];
}

//点击折扣
- (void)discountBtnClick:(HLDiscountButton *)sender {
    sender.selected = YES;
    if (![sender isEqual:_lastSelectDisBtn]) {
        _lastSelectDisBtn.selected = false;
    }
    _lastSelectDisBtn = sender;
    NSArray *values = [self valuesWithValueText:self.discounts[sender.tag]];
    [_calculateView setValueWithInt:[values.firstObject integerValue] dotValue:[values.lastObject integerValue]];
}

//重置
- (void)resetClick:(UIButton *)sender {
    NSArray *values = [self valuesWithValueText:_minValue];
    [_calculateView setValueWithInt:[values.firstObject integerValue] dotValue:[values.lastObject integerValue]];
}

//保存
- (void)saveClick:(UIButton *)sender {
    NSArray *values = [_calculateView getDiscountValues];
    NSString *discount = [NSString stringWithFormat:@"%@.%@",values.firstObject,values.lastObject];
    [self modifyDiscountWithValue:discount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDiscountDatas];
}

#pragma mark - request

- (void)modifyDiscountWithValue:(NSString *)value {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadSetAc.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"set":value,@"type":_type?:@""};
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (self.modifyDiscountBlock) {
                self.modifyDiscountBlock(value);
            }
            [self cancleClick];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        
    }];
}

- (void)loadDiscountDatas {
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HuiCardSpreadSet.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":_type?:@""};
    }onSuccess:^(id responseObject) {
        dispatch_main_async_safe(^{
            HLHideLoading(self.view);
        });
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            dispatch_main_async_safe(^{
               [self initSubViewWithDict:result.data];
            });
            return;
        }
        [self cancleClick];
        
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self cancleClick];
    }];
}



- (void)initSubViewWithDict:(NSDictionary *)dict {
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    bagView.layer.cornerRadius = FitPTScreen(9.5);
    _bagView = bagView;
    [self.view addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.equalTo(FitPTScreen(327));
    }];
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.textColor = UIColorFromRGB(0x000000);
    titleLb.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    titleLb.text = @"设置折扣";
    [bagView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bagView);
        make.top.equalTo(FitPTScreen(17));
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setImage:[UIImage imageNamed:@"colse_x_light_grey"] forState:UIControlStateNormal];
    [bagView addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLb);
        make.right.equalTo(FitPTScreen(-10));
        make.width.equalTo(FitPTScreen(30));
        make.height.equalTo(FitPTScreen(30));
    }];
    [cancelBtn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(45));
        make.left.width.equalTo(bagView);
        make.height.equalTo(0.8);
    }];
    
    UILabel *recommendLb = [[UILabel alloc]init];
    recommendLb.textColor = UIColorFromRGB(0x000000);
    recommendLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    recommendLb.text = dict[@"title"];
    [bagView addSubview:recommendLb];
    [recommendLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(line.bottom).offset(FitPTScreen(17));
    }];
    
    UILabel *descLb = [[UILabel alloc]init];
    descLb.textColor = UIColorFromRGB(0x999999);
    descLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    descLb.text = dict[@"content"];
    [bagView addSubview:descLb];
    [descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendLb);
        make.top.equalTo(recommendLb.bottom).offset(FitPTScreen(9));
    }];
    
    UIView *disBagView = [[UIView alloc]init];
    [bagView addSubview:disBagView];
    [disBagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(bagView);
        make.top.equalTo(descLb.bottom);
    }];
    
    _disButtons = [NSMutableArray array];
    _discounts = dict[@"discount"];
    for (int i = 0; i < _discounts.count; i ++ ) {
        HLDiscountButton *disBtn = [[HLDiscountButton alloc]init];
        disBtn.tag = i;
        NSString *discount = [NSString stringWithFormat:@"%@",_discounts[i]];
        disBtn.discount = [NSString stringWithFormat:@"%@%@",discount,dict[@"unit"]];
        if (!discount.floatValue) disBtn.discount = @"无折扣";
        [disBagView addSubview:disBtn];
        NSInteger row = i / 4;
        NSInteger col = i % 4;
        CGFloat width = FitPTScreen(57);
        CGFloat hight = FitPTScreen(27);
        [disBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(16) + (width + FitPTScreen(21)) *col);
            make.top.equalTo(descLb.bottom).offset(FitPTScreen(22) + (hight + FitPTScreen(14)) * row);
            make.width.equalTo(width);
            make.height.equalTo(hight);
            if (row == (_discounts.count - 1) / 4) {
                make.bottom.equalTo(FitPTScreen(-14));
            }
        }];
        [_disButtons addObject:disBtn];
        
        [disBtn addtarget:self selector:@selector(discountBtnClick:)];
    }
    
    NSArray *values = [self valuesWithValueText:dict[@"set"]];
    _calculateView = [[HLCalculateDiscountView alloc]init];
    [_calculateView setValueWithInt:[values.firstObject integerValue] dotValue:[values.lastObject integerValue]];
    _calculateView.maxValue = dict[@"max_set"];
    _calculateView.minValue = dict[@"min_set"];
    _minValue = dict[@"min_set"];
    
    [bagView addSubview:_calculateView];
    [_calculateView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(bagView);
        make.top.equalTo(disBagView.bottom);
        make.height.equalTo(FitPTScreen(61));
    }];
    
    UIButton *resetBtn = [[UIButton alloc]init];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:UIColorFromRGB(0xFF9900) forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    resetBtn.layer.borderColor = UIColorFromRGB(0xFF9900).CGColor;
    resetBtn.layer.borderWidth = 0.5;
    resetBtn.layer.cornerRadius = 6;
    [bagView addSubview:resetBtn];
    [resetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(36));
        make.bottom.equalTo(FitPTScreen(-21));
        make.top.equalTo(self.calculateView.bottom).offset(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(120));
        make.height.equalTo(FitPTScreen(40));
    }];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"bag_btn_min_oriange"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    saveBtn.layer.cornerRadius = 6;
    [bagView addSubview:saveBtn];
    [saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-36));
        make.bottom.equalTo(FitPTScreen(-21));
        make.top.equalTo(self.calculateView.bottom).offset(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(120));
        make.height.equalTo(FitPTScreen(40));
    }];
    
    [resetBtn addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
}


//将数值拆分成整数和小数两部分
- (NSArray *)valuesWithValueText:(NSString *)text {
    NSMutableArray *values = [NSMutableArray array];
    if ([text isEqualToString:@"无折扣"]) {
        [values addObject:@"0"];
        [values addObject:@"0"];
    }else if ([text containsString:@"."]) {
       [values addObjectsFromArray:[text componentsSeparatedByString:@"."]];
    } else {
        [values addObject:text];
        [values addObject:@"0"];
    }
    return values;
}

@end


#pragma mark - HLDiscountButton

@interface HLDiscountButton ()

@property(nonatomic, strong)UILabel *titleLb;

@property(nonatomic, strong)UIImageView *selectView;

@property(nonatomic, weak) id target;

@property(nonatomic, assign) SEL selector;

@end

@implementation HLDiscountButton

- (instancetype)init {
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
    }];
    
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = UIColorFromRGB(0xC7C7C7).CGColor ;
    
    _selectView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success_sector"]];
    [self addSubview:_selectView];
    [_selectView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
    }];
    _selectView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.layer.borderColor = selected ? UIColorFromRGB(0xFFCA85).CGColor : UIColorFromRGB(0xC7C7C7).CGColor ;
    _titleLb.textColor = selected ? UIColorFromRGB(0xFF860F) : UIColorFromRGB(0x333333);
    _selectView.hidden = !selected;
}

- (void)setDiscount:(NSString *)discount {
    _discount = discount;
    _titleLb.text = discount;
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    if (self.target) {
        [self.target performSelector:_selector withObject:self];
    }
}

- (void)addtarget:(id)target selector:(SEL)selector {
    _target = target;
    _selector = selector;
}
@end
