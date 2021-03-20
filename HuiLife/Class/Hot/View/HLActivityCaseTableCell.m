//
//  HLActivityCaseTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/20.
//

#import "HLActivityCaseTableCell.h"
#import "HLHotDetailMainModel.h"

@interface HLActivityCaseTableCell ()

@property(nonatomic, strong) UIImageView *picView;

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UILabel *descLb;

@end

@implementation HLActivityCaseTableCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:NO];
    
    [self.line remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.bottom.equalTo(self.bagView);
        make.width.equalTo(FitPTScreen(235));
        make.height.equalTo(FitPTScreen(0.8));
    }];
    
    _picView = [[UIImageView alloc]init];
    _picView.image = [UIImage imageNamed:@"hot_case_default"];
    [self.bagView addSubview:_picView];
    [_picView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self.bagView);
        make.size.equalTo(CGSizeMake(FitPTScreen(80), FitPTScreen(80)));
    }];
    
    _titleLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    _titleLb.text = @"案例标题";
    [self.bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView).offset(FitPTScreen(8));
        make.left.equalTo(self.picView.right).offset(FitPTScreen(17));
    }];
    
    _descLb = [UILabel hl_lableWithColor:@"#777777" font:12 bold:NO numbers:2];
    _descLb.text = @"某餐厅通过发布店内招牌菜拼团抢购活动人数不同拼团价不同，顾客发起拼团，邀请...";
    [self.bagView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(17));
        make.width.lessThanOrEqualTo(FitPTScreen(227));
    }];
}

- (void)setCaseInfo:(HLHotCaseInfo *)caseInfo {
    _caseInfo = caseInfo;
    [_picView sd_setImageWithURL:[NSURL URLWithString:caseInfo.pic] placeholderImage:[UIImage imageNamed:@"logo_default"]];
    _titleLb.text = caseInfo.title;
    _descLb.text = caseInfo.brief;
}

@end
