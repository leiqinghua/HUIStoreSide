//
//  HLImagePreviewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/11/7.
//

#import "HLImagePreviewCell.h"
#import "HLImagePreview.h"

@interface HLImagePreviewCell ()

@property (nonatomic, strong) HLImagePreview *preview;

@end

@implementation HLImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    _preview = [[HLImagePreview alloc] initWithFrame:self.bounds];
    [_preview hl_addTarget:self action:@selector(previewClick)];
    
    __weak typeof(self) weakSelf = self;
    [self.preview setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.imageProgressUpdateBlock) {
            strongSelf.imageProgressUpdateBlock(progress);
        }
    }];
    
    [self.contentView addSubview:_preview];
}

- (void)previewClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setAsset:(HLAsset *)asset{
    _asset = asset;
    _preview.asset = asset.asset;
}

- (void)recoverSubviews {
    [_preview recoverSubviews];
}

- (UIImage *)image{
    return _preview.image;
}

@end
