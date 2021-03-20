//
//  HLUploadProgress.m
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import "HLUploadProgress.h"

@interface HLUploadProgress ()
@property(nonatomic, strong)UIImageView *bgimg;
@property(nonatomic, strong)UIImageView *leftimg;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation HLUploadProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bgimg.layer.borderColor = [UIColor clearColor].CGColor;
        _bgimg.layer.borderWidth =  1;
        _bgimg.layer.cornerRadius = self.frame.size.height/2;
        [_bgimg.layer setMasksToBounds:YES];
        [self addSubview:_bgimg];
        
        _leftimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.1, _bgimg.frame.size.height)];
        _leftimg.layer.borderColor = [UIColor clearColor].CGColor;
        [_leftimg.layer setMasksToBounds:YES];
        [_bgimg addSubview:_leftimg];
        
        _presentlab = [[UILabel alloc] initWithFrame:_bgimg.bounds];
        _presentlab.textAlignment = NSTextAlignmentCenter;
        _presentlab.textColor = [UIColor whiteColor];
        [_bgimg addSubview:_presentlab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgimg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _bgimg.layer.cornerRadius = self.frame.size.height/2;
    //_leftimg.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    _presentlab.frame = _bgimg.bounds;
    _leftimg.frame = CGRectMake(0, 0, _bgimg.frame.size.width*(self.progress/self.maxValue), _bgimg.frame.size.height);
}

- (CGFloat)maxValue {
    if (!_maxValue) {
        _maxValue = 1.0f;
    }
    return _maxValue;
}

-(void)setPresent:(CGFloat)present
{
    if (present-self.maxValue>0) {
        present = self.maxValue;
    }
    _presentlab.text = [NSString stringWithFormat:@"%.1f％",(present/self.maxValue)*100];
    self.progress = present;
    _leftimg.frame = CGRectMake(0, 0, _bgimg.frame.size.width*(self.progress/self.maxValue), _bgimg.frame.size.height);
}

- (void)configProgressBgColor:(UIColor *)bgColor progressColor:(UIColor *)progressColor {
    if (bgColor) { _bgimg.backgroundColor = bgColor; }
    if (progressColor) {
        _leftimg.backgroundColor = progressColor; }
}


@end
