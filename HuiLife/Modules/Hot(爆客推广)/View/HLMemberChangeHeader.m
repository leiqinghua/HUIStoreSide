//
//  HLMemberChangeHeader.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/19.
//

#import "HLMemberChangeHeader.h"
#import "HLHotDetailMainModel.h"

@interface HLMemberChangeHeader ()

@property(nonatomic, strong) UIImageView *picView;

@property(nonatomic, strong) UIView *bagView;

@property(nonatomic, strong) UILabel *nameLb;

@property(nonatomic, strong) UILabel *descLb;

@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) UIScrollView *bottomScroll;

@property(nonatomic, strong) NSMutableArray *tagViews;

@end

@implementation HLMemberChangeHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _picView = [[UIImageView alloc]init];
    _picView.image = [UIImage imageNamed:@"member_change_heade"];
    [self addSubview:_picView];
    [_picView makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(ScreenW);
        make.left.top.equalTo(self);
    }];
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.cornerRadius = FitPTScreen(10);
    [self addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.bottom).offset(FitPTScreen(-40));
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.bottom.equalTo(FitPTScreen(-5));
    }];
    
    _nameLb = [UILabel hl_singleLineWithColor:@"#222222" font:19 bold:YES];
    _nameLb.text = @"爆客推广拼团活动";
    [_bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(25));
        make.centerX.equalTo(self.bagView);
    }];
    
    _descLb = [UILabel hl_lableWithColor:@"#444444" font:13 bold:NO numbers:0];
    [_bagView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView);
        make.top.equalTo(self.nameLb.bottom).offset(FitPTScreen(15));
        make.width.lessThanOrEqualTo(FitPTScreen(309));
    }];
    
    _tipLb = [UILabel hl_regularWithColor:@"#888888" font:12];
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bagView);
        make.top.equalTo(self.descLb.bottom).offset(FitPTScreen(20));
    }];
    
    _bottomScroll = [[UIScrollView alloc]init];
    _bottomScroll.showsHorizontalScrollIndicator = NO;
    [self.bagView addSubview:_bottomScroll];
    [_bottomScroll makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.bottom.equalTo(-FitPTScreen(20));
        make.height.equalTo(FitPTScreen(25));
    }];
    

}


- (void)setMainModel:(HLHotDetailMainModel *)mainModel {
    _mainModel = mainModel;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(13)],NSParagraphStyleAttributeName:style};
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:_mainModel.brief attributes:attributes];
    _descLb.attributedText = attr;
    
    [_picView sd_setImageWithURL:[NSURL URLWithString:_mainModel.pic]];
    _nameLb.text = _mainModel.title;
    
    NSString *tip = [NSString stringWithFormat:@"%@个商家在用,完成%@笔订单",_mainModel.shopUseNum,_mainModel.orderNum];
    _tipLb.text = tip;
    
     CGFloat totleWidth = 0;
    for (int i = 0; i< mainModel.featureList.count; i++) {
        HLFeature *feature = mainModel.featureList[i];
    
        UIView *bottomV = [[UIView alloc]init];
        [self.bottomScroll addSubview:bottomV];
        
        bottomV.layer.cornerRadius = FitPTScreen(10);
        bottomV.layer.masksToBounds = YES;
        bottomV.backgroundColor = [HLTools hl_toColorByColorStr:feature.colour];
        
        [self.tagViews addObject:bottomV];
        UIView *lastV = i > 0?self.tagViews[i-1]:nil;
        [bottomV makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.bottomScroll);
            if (i == 0) {
                make.left.equalTo(self.bottomScroll);
            } else {
                make.left.equalTo(lastV.right).offset(FitPTScreen(10));
            }
        }];
        
        UILabel *lable = [UILabel hl_regularWithColor:@"#FFFFFF" font:12];
        lable.text = feature.title;
        lable.textAlignment = NSTextAlignmentCenter;
        [bottomV addSubview:lable];
        [lable makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(FitPTScreen(4), FitPTScreen(8), FitPTScreen(4), FitPTScreen(8)));
        }];
    }
    [self.bottomScroll layoutIfNeeded];
    UIView *lastView = self.tagViews.lastObject;
    totleWidth = CGRectGetMaxX(lastView.frame) + FitPTScreen(10);
    [_bottomScroll setContentSize:CGSizeMake(totleWidth, 0)];
}

- (NSMutableArray *)tagViews {
    if (!_tagViews) {
        _tagViews = [NSMutableArray array];
    }
    return _tagViews;
}
@end
