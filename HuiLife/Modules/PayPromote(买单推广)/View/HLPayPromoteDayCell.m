//
//  HLPayPromoteDayCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLPayPromoteDayCell.h"

@interface HLPayPromoteDayCell ()

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIImageView *arrowImgV;

@end

@implementation HLPayPromoteDayCell

- (void)initSubUI{
    [super initSubUI];
    
    _selectView = [[UIView alloc] init];
    [self.contentView addSubview:_selectView];
    [_selectView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.width.equalTo(FitPTScreen(193));
        make.top.bottom.equalTo(0);
    }];
    [_selectView hl_addTarget:self action:@selector(selectViewClick:)];
    
    _arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down_darkBlack"]];
    [_selectView addSubview:_arrowImgV];
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_selectView);
        make.right.equalTo(0);
        make.width.equalTo(FitPTScreen(11));
        make.height.equalTo(FitPTScreen(6));
    }];
    
    _textLab = [[UILabel alloc]init];
    _textLab.textColor = UIColorFromRGB(0x333333);
    _textLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_selectView addSubview:_textLab];
    [_textLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowImgV.left).offset(FitPTScreen(-12));
        make.centerY.equalTo(_selectView);
    }];
}

- (void)selectViewClick:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        [self.delegate dayCell:self depentView:tap.view];
    }
    // 旋转
    [UIView animateWithDuration:0.2 animations:^{
        _arrowImgV.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)resetImageViewAnimate{
    [UIView animateWithDuration:0.2 animations:^{
        _arrowImgV.transform = CGAffineTransformIdentity;
    }];
}

-(void)setBaseInfo:(HLPayPromoteDayInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _textLab.text = baseInfo.selectInfo ? baseInfo.selectInfo.name : baseInfo.placeHorder;
    _textLab.textColor = baseInfo.selectInfo ? UIColorFromRGB(0x333333) : UIColorFromRGB(0x999999);
}

@end

@implementation HLPayPromoteDayInfo

-(NSArray *)titles{
    if (!_titles.count) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (HLPayPromoteDaySubInfo *subInfo in self.subInfos) {
            [mArr addObject:subInfo.name];
        }
        _titles = mArr;
    }
    return _titles;
}

@end

@implementation HLPayPromoteDaySubInfo

@end
