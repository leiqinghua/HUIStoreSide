//
//  HLEmptyDataView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/8/20.
//

#import "HLEmptyDataView.h"

@interface HLEmptyDataView()

@property(copy,nonatomic)RequestBlock requestBlock;

@property(strong,nonatomic)UIImageView * imageview;

@property(strong,nonatomic)UILabel * desLable;
@end

@implementation HLEmptyDataView

+(void)emptyViewWithFrame:(CGRect)frame superView:(UIView*)superView type:(NSString*)type balock:(RequestBlock)block{
    HLEmptyDataView * emptyView = [[HLEmptyDataView alloc]initWithClickBlock:block frame:frame];
    emptyView.type = type;
    [superView addSubview:emptyView];
}

-(instancetype)initWithClickBlock:(RequestBlock)block frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _requestBlock = block;
        [self createUI:frame];
    }
    return self;
}

-(void)createUI:(CGRect)frame{
    self.frame = frame;
    UIView * bagView = [[UIView alloc]init];
    bagView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hl_nodata_image"]];
    [bagView addSubview:_imageview];
    [_imageview makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(FitPTScreen(-100));
    }];
    _desLable = [[UILabel alloc]init];
    _desLable.text = @"对不起，目前没有数据";
    _desLable.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    _desLable.textColor = UIColorFromRGB(0x656565);
    [bagView addSubview:_desLable];
    [_desLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageview);
        make.top.equalTo(self.imageview.mas_bottom).offset(FitPTScreen(60));
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [bagView addGestureRecognizer:tap];
}

#pragma Event Click
-(void)tapClick:(UITapGestureRecognizer *)sender{
    if (self.requestBlock) {
        _requestBlock();
    }
}
#pragma SET GET
-(void)setType:(NSString *)type{
    if ([type isEqualToString:@"0"]) {
        [_imageview setImage:[UIImage imageNamed:@"hl_nodata_image"]];
        _desLable.text = @"对不起，目前没有数据";
    }else{
        [_imageview setImage:[UIImage imageNamed:@"hl_nofindData_image"]];
        _desLable.text = @"没有找到相关的信息";
    }
}

#pragma public Function
-(void)remove{
    [self removeFromSuperview];
}

@end
