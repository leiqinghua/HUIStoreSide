//
//  HLHotSekillImageViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import "HLHotSekillImageViewCell.h"
#import "HLUploadProgress.h"

@interface HLHotSekillImageViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *delImgV;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *statusBtn;

@property (nonatomic, strong) HLUploadProgress *progressView;

@end

@implementation HLHotSekillImageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    _imageView.layer.cornerRadius = FitPTScreen(6);
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(FitPTScreen(0), FitPTScreen(0), FitPTScreen(0), FitPTScreen(10)));
    }];
    _imageView.userInteractionEnabled = YES;
    
    _statusBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_statusBtn];
    [_statusBtn setTitle:@"点击重新上传" forState:UIControlStateNormal];
    [_statusBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _statusBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _statusBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_statusBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_imageView);
    }];
    [_statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _delImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_delImgV];
    _delImgV.image = [UIImage imageNamed:@"delete_red"];
    [_delImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imageView.top).offset(FitPTScreen(3));
        make.centerX.equalTo(_imageView.right);
        make.height.width.equalTo(FitPTScreen(20));
    }];
    [_delImgV hl_addTarget:self action:@selector(delImgVClick)];
    
    _progressView = [[HLUploadProgress alloc] init];
    [_progressView configProgressBgColor:[UIColor colorWithWhite:0. alpha:.5] progressColor:UIColorFromRGB(0xFF9900)];
    _progressView.hidden = YES;
    _progressView.presentlab.font = [UIFont systemFontOfSize:FitPTScreen(7)];
    [self.contentView addSubview:_progressView];
    [_progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.left).offset(FitPTScreen(10));
        make.right.equalTo(self.imageView.right).offset(FitPTScreen(-10));
        make.height.equalTo(FitPTScreen(8));
        make.centerY.equalTo(self.imageView.centerY);
    }];
    
    _selectBtn = [[UIButton alloc] init];
    [_imageView addSubview:_selectBtn];
    [_selectBtn setImage:[UIImage imageNamed:@"circle_little_normal"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"success_yellow_light"] forState:UIControlStateSelected];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"buygoods_bottom_shadow"] forState:UIControlStateNormal];
    [_selectBtn setTitle:@" 设为主图" forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [_selectBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(FitPTScreen(21));
    }];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 除了imageView，别的都是隐藏的
    _delImgV.hidden = YES;
    _selectBtn.hidden = YES;
    _progressView.hidden = YES;
    _statusBtn.hidden = YES;
}

- (void)statusBtnClick{

    [self configStatusNoneLayout];

    if (self.delegate) {
        [self.delegate imageCell:self reUploadImageModel:self.imageModel];
    }
}

- (void)delImgVClick{
    if (self.delegate) {
        [self.delegate imageCell:self deleteImageModel:self.imageModel];
    }
}

- (void)selectBtnClick:(UIButton *)sender{
    if (self.delegate) {
        [self.delegate imageCell:self editImageModel:self.imageModel];
    }
}

-(void)setImageModel:(HLHotSekillImageModel *)imageModel{

    _imageModel = imageModel;
    
    // 如果是+号
    if (imageModel.isNormal) {
        [self configNormalLayout];
        return;
    }
    
    // 控制是否显示设置主图的按钮
    _selectBtn.selected = imageModel.isFirst;
    if (imageModel.image) {
        _imageView.image = imageModel.image;
    }else{
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imgUrl]];
    }
    
    [self configStatusUploadingLayout];
    
    switch (imageModel.uploadStatus) {
        case HLBaseUploadStatusNone:
            [self configStatusNoneLayout];
            break;
        case HLBaseUploadStatusUploading:
            
            break;
        case HLBaseUploadStatusUploaded:
            [self configStatusOverLayout];
            break;
        case HLBaseUploadStatusFailure:
            [self configStatusFailerLayout];
            break;
    }

}

#pragma mark - 控制各个状态的显示

// + 号图片
- (void)configNormalLayout{
    [self showCleanIcon:NO];
    [self showSelectBtn:NO];
    [self showProgress:NO];
    [self showStatusBtn:NO title:@"等待中" enable:NO];
    _imageView.image = [UIImage imageNamed:@"voucher_img_upload"];
}

// 等待状态
- (void)configStatusNoneLayout{
    [self showProgress:NO];
    [self showCleanIcon:NO];
    [self showStatusBtn:YES title:@"等待中" enable:NO];
    [self showSelectBtn:NO];
}

// 完成状态
- (void)configStatusOverLayout{
    [self showCleanIcon:YES];
    [self showProgress:NO];
    [self showStatusBtn:NO title:@"点击重新上传" enable:YES];
    [self showSelectBtn:!self.hideSelect];
}

// 失败状态
- (void)configStatusFailerLayout{
    [self showProgress:NO];
    [self showCleanIcon:YES];
    [self showStatusBtn:YES title:@"点击重新上传" enable:YES];
    [self showSelectBtn:NO];
}

// 上传中
- (void)configStatusUploadingLayout{
    // 如果正在上传中
    weakify(self);
    [self configCellProgress:0.01];
    _imageModel.uploadProgressBlock = ^(CGFloat progress) {
        [weak_self showProgress:YES];
        [weak_self showCleanIcon:NO];
        [weak_self showStatusBtn:NO title:@"点击重新上传" enable:YES];
        [weak_self showSelectBtn:NO];
        [weak_self configCellProgress:progress];
    };
    _imageModel.uploadSuccessBlock = ^{
        [weak_self configStatusOverLayout];
    };
    _imageModel.uploadFailureBlock = ^{
        [weak_self configStatusFailerLayout];
    };
}

#pragma mark - 控制是否显示

- (void)configCellProgress:(CGFloat)progress {
    [self.progressView setPresent:progress];
}

- (void)showSelectBtn:(BOOL)show{
    self.selectBtn.hidden = !show;
}

- (void)showStatusBtn:(BOOL)show title:(NSString *)title enable:(BOOL)enable{
    [self.statusBtn setTitle:title forState:UIControlStateNormal];
    self.statusBtn.hidden = !show;
    self.statusBtn.userInteractionEnabled = enable;
}

- (void)showProgress:(BOOL)show {
    self.progressView.hidden = !show;
}

- (void)showCleanIcon:(BOOL)show {
    self.delImgV.hidden = !show;
}


@end
