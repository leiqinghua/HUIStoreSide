//
//  HLVoucherAddRangeCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import "HLVoucherAddRangeCell.h"

NSInteger const kShowLabTag = 999;

@interface HLVoucherAddRangeCell ()

@property (nonatomic, strong) UIView *firstSelectView;
@property (nonatomic, strong) UIView *secondSelectView;
@property (nonatomic, strong) UIView *thirdSelectView;


@end

@implementation HLVoucherAddRangeCell

-(void)initSubUI{
    [super initSubUI];
    
    [self.leftTipLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.top.equalTo(FitPTScreen(21));
    }];
    
//    _firstSelectView = [self buildSelectView];
//    [self.contentView addSubview:_firstSelectView];
//    [_firstSelectView makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-20));
//        make.height.equalTo(FitPTScreen(38));
//        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(13));
//        make.left.equalTo(FitPTScreen(20));
//    }];
//    [_firstSelectView hl_addTarget:self action:@selector(firstSelectViewClick:)];
    
    _secondSelectView = [self buildSelectView];
    [self.contentView addSubview:_secondSelectView];
    [_secondSelectView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.height.equalTo(FitPTScreen(38));
        make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(13));
        make.left.equalTo(FitPTScreen(20));
    }];
    [_secondSelectView hl_addTarget:self action:@selector(secondSelectViewClick:)];
    
    _thirdSelectView = [self buildSelectView];
    [self.contentView addSubview:_thirdSelectView];
    [_thirdSelectView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.height.equalTo(FitPTScreen(38));
        make.top.equalTo(self.secondSelectView.bottom).offset(FitPTScreen(13));
        make.left.equalTo(FitPTScreen(20));
    }];
    [_thirdSelectView hl_addTarget:self action:@selector(thirdSelectViewClick:)];
}


/// 二级分类
- (void)secondSelectViewClick:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        [self.delegate rangeCell:self secondDependView:tap.view];
    }
}

/// 三级分类
- (void)thirdSelectViewClick:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        [self.delegate rangeCell:self thirdDependView:tap.view];
    }
}

-(void)setBaseInfo:(HLVoucherAddRangeInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    UILabel *secondShowLab = [_secondSelectView viewWithTag:kShowLabTag];
    UILabel *thridShowLab = [_thirdSelectView viewWithTag:kShowLabTag];
    secondShowLab.text = baseInfo.secondSubInfo ? baseInfo.secondSubInfo.manage_name : @"请选择经营范围";
    thridShowLab.text = baseInfo.thirdSubInfo ? baseInfo.thirdSubInfo.manage_name : @"请选择经营范围";
}

- (UIView *)buildSelectView{
    
    UIView *selectView = [[UIView alloc] init];
    selectView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    selectView.layer.cornerRadius = FitPTScreen(5);
    selectView.layer.masksToBounds = YES;
    selectView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    selectView.layer.borderWidth = 0.6;
    
    UILabel *showLab = [[UILabel alloc] init];
    [selectView addSubview:showLab];
    showLab.tag = kShowLabTag;
    showLab.textColor = UIColorFromRGB(0x333333);
    showLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [showLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(selectView);
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    [selectView addSubview:arrowImgV];
    arrowImgV.image = [UIImage imageNamed:@"arrow_down_grey"];
    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.centerY.equalTo(selectView);
        make.width.equalTo(FitPTScreen(9));
        make.height.equalTo(FitPTScreen(5));
    }];
    
    return selectView;
}



@end

@implementation HLVoucherAddRangeInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"secondArr":@"HLVoucherAddRangeSubInfo",
             @"thirdArr":@"HLVoucherAddRangeSubInfo"
             };
}

/// 选择完一级之后，如果二级三级有数据，就置为空
- (void)cleanSecondAndThirdData{
    // 如果此时已经选择了1级分类，并且新选择的一级分类和旧的相等，那么就不用去清理数据，controller会有判断
    self.secondArr = nil;
    self.secondSubInfo = nil;
    self.secondTitleArr = nil;
    self.thirdArr = nil;
    self.thirdSubInfo = nil;
    self.thirdTitleArr = nil;
}

/// 判断当前二级分类是否 == 新的
- (BOOL)secondSubInfoEqualTo:(HLVoucherAddRangeSubInfo *)subInfo{
    if (!self.secondSubInfo) {
        return NO;
    }
    if ([self.secondSubInfo.manage_id isEqualToString:subInfo.manage_id] && [self.secondSubInfo.manage_name isEqualToString:subInfo.manage_name] && [self.secondSubInfo.manage_code isEqualToString:subInfo.manage_code]) {
        return YES;
    }
    return NO;
}

/// 选择完二级之后，如果三级有数据，置为空
- (void)cleanThridData{
    self.thirdArr = nil;
    self.thirdSubInfo = nil;
    self.thirdTitleArr = nil;
}

/// 构建要提交的params
- (void)buildRangParams{
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    if (self.thirdSubInfo) {
        [mParams setValue:self.thirdSubInfo.manage_code forKey:@"business"];
    }
    self.mParams = [mParams copy];
}

-(BOOL)checkParamsIsOk{
    if (self.mParams.count == 0) {
        return NO;
    }
    return YES;
}

-(NSArray *)secondTitleArr{
    if (!_secondTitleArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        [self.secondArr enumerateObjectsUsingBlock:^(HLVoucherAddRangeSubInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mArr addObject:obj.manage_name];
        }];
        _secondTitleArr = [mArr copy];
    }
    return _secondTitleArr;
}

-(NSArray *)thirdTitleArr{
    if (!_thirdTitleArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        [self.thirdArr enumerateObjectsUsingBlock:^(HLVoucherAddRangeSubInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mArr addObject:obj.manage_name];
        }];
        _thirdTitleArr = [mArr copy];
    }
    return _thirdTitleArr;
}

@end

@implementation HLVoucherAddRangeSubInfo

@end
