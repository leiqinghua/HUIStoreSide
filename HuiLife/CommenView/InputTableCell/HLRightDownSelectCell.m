//
//  HLRightDownSelectCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLRightDownSelectCell.h"

@interface HLRightDownSelectCell ()

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UILabel *showLab;
@property (nonatomic, strong) UIImageView *arrowImgV;

@end

@implementation HLRightDownSelectCell

- (void)initSubUI{
    [super initSubUI];
    
    _selectView = [[UIView alloc] init];
    [self.contentView addSubview:_selectView];
    _selectView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    _selectView.layer.cornerRadius = FitPTScreen(5);
    _selectView.layer.masksToBounds = YES;
    [_selectView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.height.equalTo(FitPTScreen(38));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(114));
    }];
    [_selectView hl_addTarget:self action:@selector(selectViewClick:)];
    
    _showLab = [[UILabel alloc] init];
    [_selectView addSubview:_showLab];
    _showLab.textColor = UIColorFromRGB(0x333333);
    _showLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_showLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(_selectView);
        make.right.lessThanOrEqualTo(FitPTScreen(-30));
    }];
    
    _arrowImgV = [[UIImageView alloc] init];
    [_selectView addSubview:_arrowImgV];
    _arrowImgV.image = [UIImage imageNamed:@"arrow_down_grey"];
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.centerY.equalTo(_selectView);
        make.width.equalTo(FitPTScreen(9));
        make.height.equalTo(FitPTScreen(5));
    }];
}

- (void)selectViewClick:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        [self.delegate downSeletCell:self selectInfo:(HLDownSelectInfo *)self.baseInfo appendView:tap.view];
    }
}

-(void)setBaseInfo:(HLDownSelectInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _showLab.text = baseInfo.selectSubInfo ? baseInfo.selectSubInfo.name : @"请选择";
}

@end

@implementation HLDownSelectInfo

-(NSArray *)titles{
    if (!_titles.count) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (HLDownSelectSubInfo *subInfo in self.subInfos) {
            [mArr addObject:subInfo.name];
        }
        _titles = [mArr copy];
    }
    return _titles;
}

-(BOOL)checkParamsIsOk{
    return self.selectSubInfo ? YES : NO;
}

- (void)buildParams{
    if (!self.selectSubInfo) {
        self.mParams = nil;
    }else{
        self.mParams = @{self.saveKey : self.selectSubInfo.Id};
    }
}

@end

@implementation HLDownSelectSubInfo

+ (instancetype)subInfoWithId:(NSString *)Id name:(NSString *)name{
    HLDownSelectSubInfo *subInfo = [[HLDownSelectSubInfo alloc] init];
    subInfo.Id = Id;
    subInfo.name = name;
    return subInfo;
}

@end
