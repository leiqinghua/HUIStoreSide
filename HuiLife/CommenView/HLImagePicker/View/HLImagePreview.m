//
//  HLImagePreview.m
//  HuiLife
//
//  Created by 王策 on 2019/11/7.
//

#import "HLImagePreview.h"
#import "HLImagePickerService.h"
#import "HLImagePickerManager.h"

@interface HLImagePreview () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MBProgressHUD *progressView;

@property (nonatomic, assign) int32_t imageRequestID;

@end

@implementation HLImagePreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] init];
        // 设置放大、缩小的最大比例
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        // 多点触控
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_scrollView addSubview:_imageView];
        
        [self configProgressView];

    }
    return self;
}

- (void)configProgressView {
    _progressView = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _progressView.mode = MBProgressHUDModeAnnularDeterminate;
    _progressView.label.text = @"下载中...";
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)setAsset:(PHAsset *)asset{
    
    
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    _asset = asset;
    [_scrollView setZoomScale:1.0 animated:NO];
    
    UIImage *cacheImage = [[HLImagePickerManager shared] cacheImageWithAssetId:asset.localIdentifier];
    if(cacheImage){
        self.imageView.image = cacheImage;
    }else{
        [HLImagePickerService getPhotoWithAsset:asset photoWidth:ScreenW completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
            if (![asset isEqual:self->_asset]) return;
            self.imageView.image = photo;
            [self resizeSubviews];

            self->_progressView.hidden = YES;
            if (self.imageProgressUpdateBlock) {
                self.imageProgressUpdateBlock(1);
            }
            if (!isDegraded) {
                self.imageRequestID = 0;
            }
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            if (![asset isEqual:self->_asset]) return;
            self->_progressView.hidden = NO;
            [self bringSubviewToFront:self->_progressView];
            progress = progress > 0.02 ? progress : 0.02;
            self->_progressView.progress = progress;
            if (self.imageProgressUpdateBlock && progress < 1) {
                self.imageProgressUpdateBlock(progress);
            }
            
            if (progress >= 1) {
                self->_progressView.hidden = YES;
                self.imageRequestID = 0;
            }
        } networkAccessAllowed:YES];
    }
    
    [self configMaximumZoomScale];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    
    _imageView.lx_origin = CGPointZero;
    _imageView.lx_width = self.scrollView.lx_width;

    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.lx_height / self.scrollView.lx_width) {
        _imageView.lx_height = floor(image.size.height / (image.size.width / self.scrollView.lx_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.lx_width;
        if (height < 1 || isnan(height)) height = self.lx_height;
        height = floor(height);
        _imageView.lx_height = height;
        _imageView.lx_centerY = self.lx_height / 2;
    }
    if (_imageView.lx_height > self.lx_height && _imageView.lx_height - self.lx_height <= 1) {
        _imageView.lx_height = self.lx_height;
    }
    CGFloat contentSizeH = MAX(_imageView.lx_height, self.lx_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.lx_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageView.lx_height <= self.lx_height ? NO : YES;
}

- (UIImage *)image{
    return _imageView.image;
}

- (void)configMaximumZoomScale {
    
    _scrollView.maximumZoomScale = 2.5;

    if ([self.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = self.asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        // 优化超宽图片的显示
        if (aspectRatio > 1.5) {
            self.scrollView.maximumZoomScale *= aspectRatio / 1.5;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 初始的frame
    _scrollView.frame = CGRectMake(10, 0, self.lx_width - 20, self.lx_height);
    [self recoverSubviews];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.lx_width > _scrollView.contentSize.width) ? ((_scrollView.lx_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.lx_height > _scrollView.contentSize.height) ? ((_scrollView.lx_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end
