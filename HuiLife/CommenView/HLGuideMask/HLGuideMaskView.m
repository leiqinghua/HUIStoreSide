//
//  HLGuideMaskView.m
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import "HLGuideMaskView.h"

@interface HLGuideMaskView ()

@property (nonatomic, strong) UIImageView *textImgV;
@property (nonatomic, strong) UIImageView *clickBtnImgV;
@property (nonatomic, strong) UIImageView *hideBtnImgV; // 只在最后一张图会显示，移除整个视图

@property (nonatomic, strong) NSMutableArray <HLGuideLayout *>*guideLayouts;

@property (nonatomic, copy) HLGuideMaskClickBlock clickBlock;

@end

@implementation HLGuideMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)drawWithGuideLayout:(HLGuideLayout *)guideLayout clickBlock:(HLGuideMaskClickBlock)clickBlock{
    
    if (clickBlock != nil) {
        self.clickBlock = clickBlock;
    }
    
    self.textImgV.image = [UIImage imageNamed:guideLayout.textImage];
    self.textImgV.frame = guideLayout.textImageFrame;
    
    self.clickBtnImgV.image = [UIImage imageNamed:guideLayout.clickBtnImage];
    self.clickBtnImgV.frame = guideLayout.clickBtnImageFrame;
    
    if (guideLayout.hideBtnImage.length) {
        self.hideBtnImgV.image = [UIImage imageNamed:guideLayout.hideBtnImage];
        self.hideBtnImgV.frame = guideLayout.hideBtnImageFrame;
    }
    self.hideBtnImgV.hidden = guideLayout.hideBtnImage.length == 0;
    
    CGRect maskFrame = guideLayout.maskFrame;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:maskFrame cornerRadius:maskFrame.size.width/2] bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
}

- (void)drawWithGuideLayoutArr:(NSArray <HLGuideLayout *>*)guideLayouts clickBlock:(HLGuideMaskClickBlock)clickBlock{
    
    self.clickBlock = clickBlock;
    
    // 多个绘制
    self.guideLayouts = [guideLayouts mutableCopy];
    if (guideLayouts.count == 0) {
        [self removeFromSuperview];
        return;
    }
    // 绘制第一个
    [self drawWithGuideLayout:self.guideLayouts.firstObject clickBlock:nil];
    [self.guideLayouts removeObjectAtIndex:0];
}

- (void)clickBtnClick{
    // 判断是否是多个绘制
    if (self.guideLayouts.count > 0) {
        // 绘制第一个
        [self drawWithGuideLayout:self.guideLayouts.firstObject clickBlock:nil];
        [self.guideLayouts removeObjectAtIndex:0];
    }else{
        // 单次绘制，直接回调
        if (self.clickBlock) {
            self.clickBlock(YES);
        }
    }
}

- (void)hide{
    if (self.clickBlock) {
        self.clickBlock(NO);
    }
}

- (UIImageView *)clickBtnImgV{
    if (!_clickBtnImgV) {
        _clickBtnImgV = [[UIImageView alloc] init];
        [self addSubview:_clickBtnImgV];
        
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtnClick)];
        _clickBtnImgV.userInteractionEnabled = YES;
        [_clickBtnImgV addGestureRecognizer:click];
    }
    return _clickBtnImgV;
}

- (UIImageView *)hideBtnImgV{
    if (!_hideBtnImgV) {
        _hideBtnImgV = [[UIImageView alloc] init];
        [self addSubview:_hideBtnImgV];
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _hideBtnImgV.userInteractionEnabled = YES;
        [_hideBtnImgV addGestureRecognizer:click];
    }
    return _hideBtnImgV;
}

- (UIImageView *)textImgV{
    if (!_textImgV) {
        _textImgV = [[UIImageView alloc] init];
        [self addSubview:_textImgV];
    }
    return _textImgV;
}

@end
