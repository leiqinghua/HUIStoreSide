//
//  HLVoucherMarketAddHead.m
//  HuiLife
//
//  Created by 王策 on 2019/8/4.
//

#import "HLVoucherMarketAddHead.h"

const NSInteger kBigImgVTag = 101;
const NSInteger kSmallImgVTag = 102;


@interface HLVoucherMarketAddHead ()

@property (nonatomic, strong) UIView *firstItemView;
@property (nonatomic, strong) UIView *secondItemView;
@property (nonatomic, strong) UIView *thirdItemView;

@end

@implementation HLVoucherMarketAddHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    // 102
    _firstItemView = [self itemViewWithIndex:1 title:@"填写信息" bigImgName:@"voucher_tianxiexinxi_big" smallImgName:@""];
    [self addSubview:_firstItemView];
    [_firstItemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.top.equalTo(FitPTScreen(13));
        make.width.equalTo(FitPTScreen(87));
        make.height.equalTo(FitPTScreen(96));
    }];
    
    _thirdItemView = [self itemViewWithIndex:3 title:@"生成买单牌" bigImgName:@"" smallImgName:@"voucher_shengchengmaidan"];
    [self addSubview:_thirdItemView];
    [_thirdItemView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-17));
        make.top.width.height.equalTo(_firstItemView);
    }];
    
    _secondItemView = [self itemViewWithIndex:2 title:@"提交待审核" bigImgName:@"voucher_daishenhe_big" smallImgName:@"voucher_daishenhe_small"];
    [self addSubview:_secondItemView];
    [_secondItemView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.width.height.equalTo(_firstItemView);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(FitPTScreen(10));
    }];
    
    UIImageView *arrowImgV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_add_top"]];
    [view addSubview:arrowImgV1];
    [arrowImgV1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(13));
        make.top.equalTo(self.top).offset(FitPTScreen(51));
        make.left.equalTo(_firstItemView.right).offset(FitPTScreen(11));
    }];
    
    UIImageView *arrowImgV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_add_top"]];
    [view addSubview:arrowImgV2];
    [arrowImgV2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(13));
        make.top.equalTo(self.top).offset(FitPTScreen(51));
        make.left.equalTo(_secondItemView.right).offset(FitPTScreen(11));
    }];
}

- (void)configState:(NSInteger)state{
    if (state == 0) {
        UIImageView *secondBigImgV = [_secondItemView viewWithTag:kBigImgVTag];
        secondBigImgV.hidden = YES;
    }
    
    if (state == 1) {
        UIImageView *secondSmallImgV = [_secondItemView viewWithTag:kSmallImgVTag];
        secondSmallImgV.hidden = YES;
    }
}

- (UIView *)itemViewWithIndex:(NSInteger)index title:(NSString *)title bigImgName:(NSString *)bigImgName smallImgName:(NSString *)smallImgName{
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *bigImgV = [[UIImageView alloc] init];
    [view addSubview:bigImgV];
    [bigImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.height.equalTo(FitPTScreen(87));
    }];
    bigImgV.tag = kBigImgVTag;
    if (bigImgName.length > 0) {
        bigImgV.image = [UIImage imageNamed:bigImgName];
    }
    
    UIImageView *smallImgV = [[UIImageView alloc] init];
    [view addSubview:smallImgV];
    [smallImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(FitPTScreen(55));
        make.center.equalTo(bigImgV);
    }];
    smallImgV.tag = kSmallImgVTag;
    if (smallImgName.length > 0) {
        smallImgV.image = [UIImage imageNamed:smallImgName];
    }
    
    UILabel *indexLab = [[UILabel alloc] init];
    [view addSubview:indexLab];
    indexLab.textColor = UIColorFromRGB(0xFFB55A);
    indexLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    indexLab.textAlignment = NSTextAlignmentCenter;
    indexLab.layer.borderColor = UIColorFromRGB(0xFFD096).CGColor;
    indexLab.layer.cornerRadius = FitPTScreen(9);
    indexLab.layer.borderWidth = 1;
    indexLab.text = [NSString stringWithFormat:@"%ld",index];
    [indexLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(6));
        make.top.equalTo(0);
        make.width.height.equalTo(FitPTScreen(18));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    [view addSubview:titleLab];
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    titleLab.text = title;
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(0);
    }];
    
    return view;
}

@end
