//
//  HLImagePickerToolBar.m
//  HuiLife
//
//  Created by 王策 on 2019/11/7.
//

#import "HLImagePickerToolBar.h"

@interface HLImagePickerToolBar ()
{
    HLImagePickerToolBarType _type;
}
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *overBtn;
@property (nonatomic, strong) UIButton *orinalBtn;

@end

@implementation HLImagePickerToolBar

- (instancetype)initWithFrame:(CGRect)frame type:(HLImagePickerToolBarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        self.backgroundColor = UIColorFromRGB(0x343434);
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _leftBtn = [[UIButton alloc] init];
    [self addSubview:_leftBtn];
    _leftBtn.frame = CGRectMake(0, 0, 80, self.bounds.size.height);
    [_leftBtn setTitle:_type == HLImagePickerToolBarTypeEdit ? @"编辑" : @"预览" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat overBtnMarginY = 10;
    CGFloat overBtnMarginX = 12;
    CGFloat overBtnWidth = 70;
    CGFloat overBtnHeight = self.bounds.size.height - 2 * overBtnMarginY;
    
    _overBtn = [[UIButton alloc] init];
    [self addSubview:_overBtn];
    _overBtn.frame = CGRectMake(self.bounds.size.width - overBtnMarginX - overBtnWidth, overBtnMarginY, overBtnWidth, overBtnHeight);
    [_overBtn setTitle:@"选取" forState:UIControlStateNormal];
    _overBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _overBtn.backgroundColor = UIColorFromRGB(0xFFAB33);
    _overBtn.layer.cornerRadius = 4;
    _overBtn.layer.masksToBounds = YES;
    [_overBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_overBtn addTarget:self action:@selector(overBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _orinalBtn = [[UIButton alloc] init];
    [self addSubview:_orinalBtn];
    _orinalBtn.frame = CGRectMake(0, 0, 60, self.bounds.size.height);
    _orinalBtn.center = CGPointMake(self.lx_width/2, self.lx_height/2);
    [_orinalBtn setTitle:@" 原图" forState:UIControlStateNormal];
    [_orinalBtn setImage:[UIImage imageNamed:@"circle_solid_normal"] forState:UIControlStateNormal];
    [_orinalBtn setImage:[UIImage imageNamed:@"circle_solid_select"] forState:UIControlStateSelected];
    _orinalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_orinalBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_orinalBtn addTarget:self action:@selector(orinalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)orinalBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.delegate) {
        [self.delegate toolBar:self orinalSelect:sender.selected];
    }
}

- (void)overBtnClick{
    if (self.delegate) {
        [self.delegate selectButtonClickWithToolBar:self];
    }
}

- (void)leftBtnClick{
    if (self.delegate) {
        [self.delegate leftButtonClickWithToolBar:self];
    }
}

- (void)hideEditBtn{
    self.leftBtn.hidden = YES;
}

- (void)configSelectNum:(NSInteger)num{
    if (num == 0) {
        [_overBtn setTitle:@"选取" forState:UIControlStateNormal];
    }else{
        [_overBtn setTitle:[NSString stringWithFormat:@"选取(%ld)",num] forState:UIControlStateNormal];
    }
}

// 配置原图按钮是否勾选
- (void)configOrinalSelect:(BOOL)select{
    _orinalBtn.selected = select;
}

@end
