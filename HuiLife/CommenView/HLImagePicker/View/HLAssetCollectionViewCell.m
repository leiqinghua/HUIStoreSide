//
//  HLAssetCollectionViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import "HLAssetCollectionViewCell.h"
#import "HLImagePickerService.h"
#import "HLImagePickerManager.h"

@interface HLAssetCollectionViewCell ()
{
    HLAsset *_asset;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *indexBtn;

@property (nonatomic, assign) int32_t imageRequestID;
@property (nonatomic, assign) int32_t bigImageRequestID;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, strong) UILabel *resizeTipLab;

@end

@implementation HLAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.7];
    [self.contentView addSubview:_maskView];
    _maskView.hidden = YES;
    
    _resizeTipLab = [[UILabel alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_resizeTipLab];
    _resizeTipLab.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    _resizeTipLab.textColor = UIColor.whiteColor;
    _resizeTipLab.text = @"待裁减";
    _resizeTipLab.hidden = YES;
    _resizeTipLab.textAlignment = NSTextAlignmentCenter;
    _resizeTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    
    CGFloat buttonW = 23;
    CGFloat margin = 5;
    _selectBtn = [[UIButton alloc] init];
    _selectBtn.frame = CGRectMake(self.bounds.size.width - buttonW - margin, margin, buttonW, buttonW);
    [self.contentView addSubview:_selectBtn];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"success_grey_border"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _indexBtn = [[UIButton alloc] init];
    _indexBtn.frame = _selectBtn.frame;
    _indexBtn.backgroundColor = UIColorFromRGB(0xFFAB33);
    _indexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _indexBtn.layer.cornerRadius = buttonW/2;
    _indexBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_indexBtn];
    [_indexBtn addTarget:self action:@selector(indexBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _indexBtn.hidden = YES;
}

- (void)configBorder:(BOOL)border{
    if (border) {
        self.imageView.layer.borderColor = UIColorFromRGB(0xFFAB33).CGColor;
        self.imageView.layer.borderWidth = 2;
    }else{
        self.imageView.layer.borderColor = UIColor.clearColor.CGColor;
        self.imageView.layer.borderWidth = 0;
    }
}

- (void)selectBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewCell:selected:)]) {
        [self.delegate assetCollectionViewCell:self selected:YES];
    }
    
    [self requestBigImage];
}

- (void)indexBtnClick{
    
    // 取消选中，直接取消
    _selectBtn.hidden = NO;
    _indexBtn.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewCell:selected:)]) {
        [self.delegate assetCollectionViewCell:self selected:NO];
    }
    [self cancelBigImageRequest];
}

- (void)configSelectButtonHidden{
    _selectBtn.hidden = YES;
    _indexBtn.hidden = YES;
}

- (void)configSelectStateIndex:(NSInteger)index{
    _selectBtn.hidden = YES;
     _indexBtn.hidden = NO;
    // 来一个动画
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        _indexBtn.transform = CGAffineTransformMakeScale(0.9,0.9);
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations: ^{
            _indexBtn.transform = CGAffineTransformMakeScale(1.2,1.2);
          }];

        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.5 animations: ^{
            _indexBtn.transform = CGAffineTransformMakeScale(1.0,1.0);
        }];
    } completion:nil];
    
    [_indexBtn setTitle:index >= 0 ? [NSString stringWithFormat:@"%ld",index + 1] : @"" forState:UIControlStateNormal];
}

- (void)configResizeTipLab:(BOOL)showTip{
    _resizeTipLab.hidden = !showTip;
}

- (void)configAsset:(HLAsset *)asset arrayIndex:(NSInteger)index{
    
    _asset = asset;
    
    if (!self.onlyPreview) {
        if (asset.select) {
            _selectBtn.hidden = YES;
            _indexBtn.hidden = NO;
           [_indexBtn setTitle:index >= 0 ? [NSString stringWithFormat:@"%ld",index + 1] : @"" forState:UIControlStateNormal];
           [self requestBigImage];
        }else{
            _selectBtn.hidden = NO;
            _indexBtn.hidden = YES;
            [self cancelBigImageRequest];
        }
    }else{
        _selectBtn.hidden = YES;
        _indexBtn.hidden = YES;
        _maskView.hidden = asset.select;
    }
     
    
    self.representedAssetIdentifier = asset.asset.localIdentifier;
    
    int32_t imageRequestID = 0;
    // 判断是否有裁减的图片
    UIImage *cacheImage = [[HLImagePickerManager shared] cacheImageWithAssetId:asset.asset.localIdentifier];
    if(cacheImage){
        self.imageView.image = cacheImage;
    }else{
        self.imageRequestID = [HLImagePickerService getPhotoWithAsset:asset.asset photoWidth:self.bounds.size.width completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
            if ([self.representedAssetIdentifier isEqualToString:asset.asset.localIdentifier]) {
                _imageView.image = photo;
            } else {
                [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
            }
            if (!isDegraded) {
                self.imageRequestID = 0;
            }
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            
        } networkAccessAllowed:YES];
    }
    
     if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
         [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
     }
     self.imageRequestID = imageRequestID;
    
    // 如果用户选中了该图片，提前获取一下大图
    if (asset.select) {
        [self requestBigImage];
    } else {
        [self cancelBigImageRequest];
    }
}

- (void)requestBigImage {
    if (_bigImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
    }
    
    _bigImageRequestID = [HLImagePickerService requestImageDataForAsset:_asset.asset completion:^(NSData * _Nonnull imageData, NSString * _Nonnull dataUTI, UIImageOrientation orientation, NSDictionary * _Nonnull info) {
        
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        if (!self.asset.select) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self cancelBigImageRequest];
        }
    }];
}

- (void)cancelBigImageRequest {
    if (_bigImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
    }
}

- (HLAsset *)asset{
    return _asset;
}

@end
