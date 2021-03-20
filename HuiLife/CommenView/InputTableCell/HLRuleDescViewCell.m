//
//  HLRuleDescViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLRuleDescViewCell.h"

@interface HLRuleDescViewCell ()

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)NSMutableArray * lables;

@property(nonatomic,strong)NSArray * rules;

@property(nonatomic,strong)UILabel * rightLb;

@property(nonatomic,strong)UIImageView * arrowImgV;

@end

@implementation HLRuleDescViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _rightLb = [[UILabel alloc]init];
    _rightLb.textColor =UIColorFromRGB(0x999999);
    _rightLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _rightLb.text = @"以下是已选择";
    [self.contentView addSubview:_rightLb];
    [_rightLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-27));
        make.centerY.equalTo(self.leftTipLab);
    }];
    
    _arrowImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_arrowImgV];
    _arrowImgV.image = [UIImage imageNamed:@"arrow_right_grey"];
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.rightLb);
    }];
   
}


-(void)setBaseInfo:(HLRuleDescTypeInfo *)baseInfo{
    
    if ([baseInfo.rules isEqual:_rules]) {
        return;
    }
    [super setBaseInfo:baseInfo];
    _rules = baseInfo.rules;
    _rightLb.text = baseInfo.placeHolder;
    
    
    [self.lables enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.lables removeAllObjects];
    
    
    if (baseInfo.rules.count) {
        [self.contentView addSubview:self.bagView];
        [self.bagView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftTipLab);
            make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(17));
            make.width.equalTo(FitPTScreen(350));
        }];
        NSInteger totalRow =  (baseInfo.rules.count -1) / 2 + 1;
        for (int i = 0; i<baseInfo.rules.count; i++) {
            NSString * rule = baseInfo.rules[i];
            UILabel * lable =  [[UILabel alloc]init];
            lable.textColor =UIColorFromRGB(0x666666);
            lable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
            lable.text = rule;
            lable.numberOfLines = 0;
            [self.bagView addSubview:lable];
            if (!_lables) _lables = [NSMutableArray array];
            [_lables addObject:lable];
            
            NSInteger row =  i / 2 + 1;
            NSInteger line = i % 2;
            UILabel * lastLb = self.lables[i>0?i-1:i];
            UILabel *lastLineLb;
            if (i>1) {
                lastLineLb = self.lables[i-2];
            }
            [lable makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(line==0?self.bagView:lastLb.right).offset(line==0?FitPTScreen(12):FitPTScreen(56));
                make.top.equalTo(lastLineLb?lastLineLb.bottom:self.bagView).offset(FitPTScreen(18));
                make.width.lessThanOrEqualTo(FitPTScreen(130));
                if (row == totalRow) {
                    make.bottom.equalTo(FitPTScreen(-18));
                }
            }];
        }
    }else{
        [self.bagView removeFromSuperview];
    }
}


-(UIView *)bagView{
    if (!_bagView) {
        _bagView = [[UIView alloc]init];
        _bagView.layer.cornerRadius = FitPTScreen(4);
        _bagView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
        _bagView.layer.borderWidth = FitPTScreen(1);
        [self.contentView addSubview:_bagView];
        [_bagView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftTipLab);
            make.top.equalTo(self.leftTipLab.bottom).offset(FitPTScreen(17));
            make.width.equalTo(FitPTScreen(350));
        }];
    }
    return _bagView;
}

@end


@implementation HLRuleDescTypeInfo

-(CGFloat)cellHeight{
    if (self.rules.count) {
        NSInteger totalRow =  (self.rules.count -1) / 2 + 1;
        __block NSInteger curRow = 0;
        __block CGFloat rowHight = 0.0;
        __block CGFloat totleHight = 0.0;
        [self.rules enumerateObjectsUsingBlock:^(NSString *  _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
             NSInteger row =  idx / 2;
            if (row>curRow) {
                curRow += 1;
                rowHight = 0.0;
            }else if (row == curRow) {
                CGFloat hight = [HLTools attrSizeWithString:rule lineSpace:0 kern:0 font:[UIFont systemFontOfSize:FitPTScreen(14)] width:FitPTScreen(130)].height;
                if (rowHight == 0.0) {
                    rowHight = hight;
                }else{
                    if(hight > rowHight){
                        rowHight = hight;
                    }
                    totleHight += rowHight;
                }
            }
        }];
        return totleHight + (totalRow +1)*FitPTScreen(18) + FitPTScreen(51) + FitPTScreen(20);
    }
    return FitPTScreen(51);
}

@end
