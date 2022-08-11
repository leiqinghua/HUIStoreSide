//
//  HLImageCollectionCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLImageCollectionCell.h"

@interface HLImageCollectionCell ()

@property(nonatomic,strong)UIImageView * imageView;

@property(nonatomic,strong)UIButton * deleteBtn;

@end

@implementation HLImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    self.layer.masksToBounds = false;
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"store_mul_default"]];
    _imageView.layer.cornerRadius = FitPTScreen(4);
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.height.equalTo(FitPTScreen(103));
    }];
    
    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete_red"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageView.right).offset(FitPTScreen(4));
        make.top.equalTo(self.imageView.top).offset(FitPTScreen(-6));;
    }];
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
}

//删除
-(void)deleteClick{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
    _deleteBtn.hidden = false;
}

-(void)setImageStr:(NSString *)imageStr{
     _imageStr = imageStr;
    if ([imageStr hasPrefix:@"http"] ||[imageStr hasPrefix:@"https"]  ) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
        _deleteBtn.hidden = false;
    }else{
        _imageView.image = [UIImage imageNamed:imageStr];
        _deleteBtn.hidden = YES;
    }
}

@end
