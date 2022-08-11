//
//  HLApiChangeController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/21.
//

#import "HLApiChangeController.h"
#import "HLDownSelectView.h"

#define kApiName @"apiName"


@interface HLApiChangeController ()

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, strong) NSDictionary *apiDict;

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *normalLab;
@property (nonatomic, strong) UILabel *storeLab;

@end

@implementation HLApiChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"切换环境";
    [self initSubViews];
    
    // 判断当前的环境
    NSString *apiName = [[NSUserDefaults standardUserDefaults] objectForKey:kApiName];
    if (!apiName || apiName.length == 0) {
        apiName = @"测试环境";
    }
    [self handleSelectTitle:apiName];
}

- (void)initSubViews{
    
    UIButton *selectButton = [[UIButton alloc] init];
    [self.view addSubview:selectButton];
    [selectButton setTitle:@"测试环境" forState:UIControlStateNormal];
    [selectButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    selectButton.layer.borderWidth = 1;
    selectButton.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    selectButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [selectButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(30);
        make.right.equalTo(-30);
        make.height.equalTo(45);
        make.top.equalTo(FitPTScreen(120));
    }];
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton = selectButton;
    
    UILabel *normalLab = [[UILabel alloc] init];
    [self.view addSubview:normalLab];
    normalLab.textColor = UIColor.blackColor;
    normalLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    normalLab.text = @"456";
    [normalLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton);
        make.top.equalTo(selectButton.bottom).offset(FitPTScreen(30));
    }];
    _normalLab = normalLab;
    
    UILabel *storeLab = [[UILabel alloc] init];
    [self.view addSubview:storeLab];
    storeLab.textColor = UIColor.blackColor;
    storeLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    storeLab.text = @"123";
    [storeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton);
        make.top.equalTo(normalLab.bottom).offset(FitPTScreen(30));
    }];
    _storeLab = storeLab;
}


- (void)selectButtonClick:(UIButton *)selectButton{
    [HLDownSelectView showSelectViewWithTitles:self.titles currentTitle:selectButton.currentTitle needShowSelect:YES showSeperator:YES itemHeight:FitPTScreen(45) dependView:selectButton showType:HLDownSelectTypeDown maxNum:5 hideCallBack:nil callBack:^(NSInteger index) {
        [self handleSelectTitle:self.titles[index]];
    }];
}

- (void)handleSelectTitle:(NSString *)title{
    NSArray *apiArr = self.apiDict[title];
    
    // 保存数据
    [[NSUserDefaults standardUserDefaults] setObject:apiArr[0] forKey:NORMAL_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:apiArr[1] forKey:STORE_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:apiArr[2] forKey:NORMAL_DOMEN_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:kApiName];
    BOOL result = [[NSUserDefaults standardUserDefaults] synchronize];
    if (result) {
        [self.selectButton setTitle:title forState:UIControlStateNormal];
        _normalLab.text = [NSString stringWithFormat:@"NORMAL: %@",apiArr[0]];
        _storeLab.text = [NSString stringWithFormat:@"STORE: %@",apiArr[1]];
    }
}

-(NSDictionary *)apiDict{
    if (!_apiDict) {
//        _apiDict = @{
//                     @"测试环境":@[NORMAL_TEST_SERVER,STORE_SERVICE_TEST_SERVER],
//                     @"中间环境":@[NORMAL_MID_SERVER,STORE_SERVICE_MID_SERVER],
//                     @"正式环境":@[NORMAL_PRODUCT_SERVER,STORE_SERVICE_PRODUCT_SERVER]
//                     };
        _apiDict = @{
                     @"测试环境":@[NORMAL_TEST_SERVER,STORE_SERVICE_TEST_SERVER,NORMAL_DOMEN_TEST_SERVER],
                     @"中间环境":@[NORMAL_MID_SERVER,STORE_SERVICE_MID_SERVER,NORMAL_DOMEN_MID_SERVER],
                     @"正式环境":@[NORMAL_PRODUCT_SERVER,STORE_SERVICE_PRODUCT_SERVER,NORMAL_DOMEN_PRODUCT_SERVER]
                     };
    }
    return _apiDict;
}

-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"测试环境",@"中间环境",@"正式环境"];
    }
    return _titles;
}


@end
