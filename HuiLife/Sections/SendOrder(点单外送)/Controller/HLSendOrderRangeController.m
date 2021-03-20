//
//  HLSendOrderRangeController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderRangeController.h"
#import "HLSendOrderRangeHead.h"
#import "HLSendOrderRangeInfo.h"
#import "HLSendOrderRangeDistanceCell.h"

@interface HLSendOrderRangeController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HLSendOrderRangeHeadDelegate>

/// 头部视图
@property (nonatomic, strong) HLSendOrderRangeHead *rangeHead;

/// 提供数据支持
@property (nonatomic, strong) HLSendOrderRangeInfo *rangeInfo;

/// 自定义view
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITextField *numInput;

/// 推荐view
@property (nonatomic, strong) UICollectionView *collectionView;

/// 是否选中了自定义的
@property (nonatomic, assign) BOOL isSelectCustom;

@end

@implementation HLSendOrderRangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"配送范围设置";
    
    _rangeHead = [[HLSendOrderRangeHead alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(75))];
    _rangeHead.delegate = self;
    [self.view addSubview:_rangeHead];
    
    // 创建自定义view
    [self creatCustomView];
    
    // 创建推荐选择的view
    [self creatCollectionView];
    
    [self creatFootViewWithButtonTitle:@"保存"];
    
    [self loadData];
}

/// 加载数据
- (void)loadData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/SendRage.php";
        request.parameters = @{@"type":self.type};
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            _rangeInfo = [HLSendOrderRangeInfo mj_objectWithKeyValues:[XMResult dataDict:responseObject]];
            [_rangeHead configDataWithRangeInfo:_rangeInfo];
            //
            if([_rangeInfo isCustumRange]){
                // 配置数据
                self.numInput.text = [NSString stringWithFormat:@"%ld",_rangeInfo.custom];
            }
            [_collectionView reloadData];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 保存数据
- (void)saveButtonClick{
    
    // 判断是否是自定义
    NSDictionary *params = nil;
    if (self.isSelectCustom) {
        if (self.numInput.text.integerValue <= 0) {
            HLShowHint(@"请输入配送范围", self.view);
            return;
        }
        params = @{@"isCustom":@"1",@"custom":self.numInput.text,@"type":self.type?:@"1",@"sendId":_rangeInfo.sendId};
    }else{
        // 判断是否有勾选
        HLSendOrderRangeSuggestionInfo *info = [self.rangeInfo selectRangeSuggestionInfo];
        if (!info) {
            HLShowHint(@"请选择配送范围", self.view);
            return;
        }
        params = @{@"isCustom":@"0",@"recommendId":info.itemId,@"sendId":_rangeInfo.sendId,@"type":self.type?:@"1",@"custom":@""};
    }
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.serverType = HLServerTypeNormal;
        request.api = @"/MerchantSideA/SendRageSet.php";
        request.parameters = params;
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(self.view);
        
        if ([(XMResult *)responseObject code] == 200) {
            HLShowText(@"保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 减1
- (void)jianBtnClick{
    NSInteger num = self.numInput.text.integerValue;
    if (num > 0) {
        self.numInput.text = [NSString stringWithFormat:@"%ld",--num];
    }
}

/// 加1
- (void)jiaBtnClick{
    NSInteger num = self.numInput.text.integerValue;
    self.numInput.text = [NSString stringWithFormat:@"%ld",++num];
}

/// 创建collectionView
- (void)creatCollectionView{
    self.collectionView.hidden = YES;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(_rangeHead.bottom);
    }];
    AdjustsScrollViewInsetNever(self, self.collectionView);
}

/// 创建zidingyiview
- (void)creatCustomView{
    _customView = [[UIView alloc] init];
    [self.view addSubview:_customView];
    [_customView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(_rangeHead.bottom);
    }];
    _customView.hidden = YES;
    //
    UIButton *jianBtn = [[UIButton alloc] init];
    [_customView addSubview:jianBtn];
    [jianBtn setBackgroundImage:[UIImage imageNamed:@"sendOrder_jian"] forState:UIControlStateNormal];
    [jianBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(92));
        make.top.equalTo(_rangeHead.bottom).offset(FitPTScreen(62));
        make.width.height.equalTo(FitPTScreen(28));
    }];
    [jianBtn addTarget:self action:@selector(jianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _numInput = [[UITextField alloc] init];
    [_customView addSubview:_numInput];
    _numInput.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _numInput.textColor = UIColorFromRGB(0x444444);
    _numInput.text = @"0";
    _numInput.placeholder = @"0";
    _numInput.layer.cornerRadius = FitPTScreen(3);
    _numInput.layer.masksToBounds = YES;
    _numInput.layer.borderWidth = 1;
    _numInput.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _numInput.textAlignment = NSTextAlignmentCenter;
    _numInput.keyboardType = UIKeyboardTypeNumberPad;
    [_numInput makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jianBtn.right).offset(FitPTScreen(15));
        make.centerY.equalTo(jianBtn);
        make.width.equalTo(FitPTScreen(74));
        make.height.equalTo(FitPTScreen(33));
    }];
    
    UIButton *jiaBtn = [[UIButton alloc] init];
    [_customView addSubview:jiaBtn];
    [jiaBtn setBackgroundImage:[UIImage imageNamed:@"add_square_border"] forState:UIControlStateNormal];
    [jiaBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numInput.right).offset(FitPTScreen(15));
        make.centerY.equalTo(jianBtn);
        make.width.height.equalTo(FitPTScreen(28));
    }];
    [jiaBtn addTarget:self action:@selector(jiaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *unitLab = [[UILabel alloc] init];
    [_customView addSubview:unitLab];
    unitLab.text = @"公里";
    unitLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    unitLab.textColor = UIColorFromRGB(0xC2C2C2);
    [unitLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jiaBtn.right).offset(FitPTScreen(6));
        make.bottom.equalTo(jiaBtn.bottom);
    }];
}

/// 构建底部的view
- (void)creatFootViewWithButtonTitle:(NSString *)title{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:title forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - HLSendOrderRangeHeadDelegate

/// 切换视图
- (void)rangeHead:(HLSendOrderRangeHead *)rangeHead isCustom:(BOOL)isCustom{
    self.customView.hidden = !isCustom;
    self.collectionView.hidden = isCustom;
    
    self.isSelectCustom = isCustom;
    
    // 重置输入
//    self.numInput.text = @"0";
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rangeInfo.items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HLSendOrderRangeDistanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLSendOrderRangeDistanceCell" forIndexPath:indexPath];
    cell.info = self.rangeInfo.items[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HLSendOrderRangeSuggestionInfo *info = self.rangeInfo.items[indexPath.row];
    if (info.select) {
        return;
    }
    [self.rangeInfo.items enumerateObjectsUsingBlock:^(HLSendOrderRangeSuggestionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select = (obj == info);
    }];
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(FitPTScreen(63), FitPTScreen(28));
        layout.minimumLineSpacing = FitPTScreen(10);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(FitPTScreen(20), FitPTScreen(15), FitPTScreen(20), FitPTScreen(15));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[HLSendOrderRangeDistanceCell class] forCellWithReuseIdentifier:@"HLSendOrderRangeDistanceCell"];
    }
    return _collectionView;
}

@end
