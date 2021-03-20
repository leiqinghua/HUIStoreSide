//
//  HLImagePreviewNav.m
//  HuiLife
//
//  Created by 王策 on 2019/11/8.
//

#import "HLImagePreviewNav.h"

@interface HLImagePreviewNav ()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UIButton *indexBtn;

@end

@implementation HLImagePreviewNav

+ (instancetype)previewNav
{
    HLImagePreviewNav *navBar = [[HLImagePreviewNav alloc] initWithFrame:CGRectMake(0, 0, ScreenW, Height_NavBar)];
    navBar.backgroundColor = UIColorFromRGB(0x343434);
    return navBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _backBtn = [[UIButton alloc] init];
    [self addSubview:_backBtn];
    _backBtn.frame = CGRectMake(0, self.lx_height - 44, 44, 44);
    [_backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttonW = 23;
    _selectBtn = [[UIButton alloc] init];
    _selectBtn.frame = CGRectMake(0, 0, buttonW, buttonW);
    _selectBtn.center = CGPointMake(self.lx_width - 30, _backBtn.lx_centerY);
    [self addSubview:_selectBtn];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"circle_solid_big_normal"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _indexBtn = [[UIButton alloc] init];
    _indexBtn.frame = _selectBtn.frame;
    _indexBtn.backgroundColor = UIColorFromRGB(0xFFAB33);
    _indexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _indexBtn.layer.cornerRadius = buttonW/2;
    _indexBtn.layer.masksToBounds = YES;
    [self addSubview:_indexBtn];
    [_indexBtn addTarget:self action:@selector(indexBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _indexBtn.hidden = YES;
}

// 隐藏右上角
- (void)hidenIndexView{
    _indexBtn.hidden = YES;
    _selectBtn.hidden = YES;
}

- (void)configIndex:(NSInteger)index{
    if (index <= 0) {
        _selectBtn.hidden = NO;
        _indexBtn.hidden = YES;
    }else{
        _selectBtn.hidden = YES;
        _indexBtn.hidden = NO;
        [_indexBtn setTitle:[NSString stringWithFormat:@"%ld",index] forState:UIControlStateNormal];
    }
}

- (void)backBtnClick{
    if (self.delegate) {
        [self.delegate pageBackWithPreviewNav:self];
    }
}

- (void)selectBtnClick{
    if (self.delegate) {
        [self.delegate previewNav:self changedSelected:YES];
    }
}

- (void)indexBtnClick{
    if (self.delegate) {
        [self.delegate previewNav:self changedSelected:NO];
    }
}

@end
