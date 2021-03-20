//
//  HLActivityMethodTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/20.
//

#import "HLActivityMethodTableCell.h"
#import "HLHotDetailMainModel.h"

@interface HLActivityMethodTableCell ()

@property(nonatomic, strong) UILabel *tipLb;

@end

@implementation HLActivityMethodTableCell

- (void)initSubView {
    
    [super initSubView];
    [self showArrow:false];
    self.backgroundColor = UIColor.clearColor;
    self.bagView.backgroundColor = UIColor.whiteColor;
    self.bagView.layer.cornerRadius = FitPTScreen(10);
    [self.bagView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(10), FitPTScreen(5), FitPTScreen(10)));
    }];

    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_left_tip"]];
    [self.bagView addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _tipLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    _tipLb.text = @"活动推广方法";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tipView);
    }];
}


- (void)initFunctionView {
    
    NSArray *functions = self.mainModel.generalizeFunList;
    CGFloat width = FitPTScreen(335) / 3;
    CGFloat hight = FitPTScreen(70);

    [functions enumerateObjectsUsingBlock:^(HLHotFunction *  _Nonnull fun, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *bottomView = [[UIView alloc]init];
        [self.bagView addSubview:bottomView];
        NSInteger row = idx / 3;
        NSInteger col = idx % 3;
        [bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(col * width);
            make.top.equalTo(self.tipLb.bottom).offset(row * hight + FitPTScreen(10));
            make.size.equalTo(CGSizeMake(width, hight));
        }];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:fun.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
        [bottomView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(10));
            make.centerX.equalTo(bottomView);
            make.size.equalTo(CGSizeMake(FitPTScreen(30), FitPTScreen(30)));
        }];
        
        UILabel *titleLb = [UILabel hl_regularWithColor:@"#777777" font:12];
        titleLb.text = fun.title;
        [bottomView addSubview:titleLb];
        [titleLb makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(imageView.bottom).offset(FitPTScreen(8));
            make.bottom.equalTo(-FitPTScreen(10));
            make.centerX.equalTo(bottomView);
        }];
    }];
}

- (void)setMainModel:(HLHotDetailMainModel *)mainModel {
    _mainModel = mainModel;
    [self initFunctionView];
}
@end
