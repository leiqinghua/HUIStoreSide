//
//  HLVideoMarketAddController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketAddController.h"
#import <IQKeyboardManager/IQTextView.h>
#import "HLVideoProductSelectController.h"
#import "HLVideoProductModel.h"
#import "HLJDAPIManager.h"

typedef enum : NSUInteger {
    HLVideoUploadNormal,        // 默认状态
    HLVideoUploadVideoing,      // 视频上传中..
    HLVideoUploadVideoSuccess,  // 视频上传成功，图片还没上传
    HLVideoUploadVideoFailed,   // 视频上传失败
    HLVideoUploadPicing,        // 视频上传成功，图片上传中
    HLVideoUploadPicFailed,     // 视频上传成功，图片上传失败
    HLVideoUploadAllSuccess     // 视频&缩略图都上传成功
} HLVideoUploadState;

@interface HLVideoMarketAddController () <UIImagePickerControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIImagePickerController * imagePicker;
// 视频在APP中的路径
@property(nonatomic, copy) NSString *videoPath;
// 预览图
@property (nonatomic, copy) NSString *picPath;
// 上传状态
@property (nonatomic, assign) HLVideoUploadState uploadState;

// 最后构造的参数
@property (nonatomic, strong) NSMutableDictionary *mParams;

// 商品选择视图
@property (nonatomic, strong) UITextField *goodNameLab;
@property (nonatomic, strong) UITextView *titleInput;
@property (nonatomic, strong) UITextView *descInput;

// 视频上传视图
@property (nonatomic, strong) UIImageView *videoImgV;
@property (nonatomic, strong) IQTextView *titleTextView;
@property (nonatomic, strong) UIImageView *videoTimeImgV;
@property (nonatomic, strong) UILabel *videoTimeLab;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *upStateLab;

// 描述
@property (nonatomic, strong) IQTextView *descTextView;
@property (nonatomic, strong) UILabel *inputNumLab;


@end

@implementation HLVideoMarketAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建短视频";
    [self creatSubViews];
    self.uploadState = HLVideoUploadNormal;
    self.delBtn.hidden = YES;
    self.videoTimeImgV.hidden = YES;
    self.upStateLab.hidden = YES;
    
    // 如果是编辑
    if (self.marketModel) {
        self.uploadState = HLVideoUploadAllSuccess;
        
        // 数据回显
        self.delBtn.hidden = NO;
        self.goodNameLab.text = self.marketModel.name;
        self.titleTextView.text = self.marketModel.title;
        self.descTextView.text = self.marketModel.content;
        self.mParams[@"product_id"] = self.marketModel.proId;
        self.mParams[@"videoUrl"] = self.marketModel.videoUrl;
        self.mParams[@"pic"] = self.marketModel.pic;
        [self.videoImgV sd_setImageWithURL:[NSURL URLWithString:self.marketModel.pic]];
        self.mParams[@"product_source"] = 0;
        self.mParams[@"video_id"] = self.marketModel.id;
        self.inputNumLab.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)self.descTextView.text.length];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Method

/// 选择商品
- (void)selectGoods{
    HLVideoProductSelectController *selectGoods = [[HLVideoProductSelectController alloc] init];
    selectGoods.mode = 1;
    selectGoods.pro_id = self.mParams[@"product_id"] ?: @"";
    selectGoods.type = self.mParams[@"product_source"] ? [self.mParams[@"product_source"] integerValue] : 0;
    selectGoods.productSelectBlock = ^(HLVideoProductModel * _Nonnull model, NSInteger type) {
        // 视图配置
        self.goodNameLab.text = model.name;
        self.titleTextView.text = model.name;
        if (type == 1) { // 秒杀
            self.descTextView.text = model.content;
        }
        // 请求参数配置
        self.mParams[@"product_id"] = model.pro_id;
        self.mParams[@"product_source"] = @(type); // 0 外卖 1 秒杀
        self.inputNumLab.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)self.descTextView.text.length];
    };
    [self.navigationController pushViewController:selectGoods animated:YES];
}

/// 保存
- (void)addButtonClick{
    if(!self.mParams[@"product_id"]){
        HLShowText(@"请选择推送商品");
        return;
    }
    
    if(self.titleTextView.text.length == 0){
        HLShowText(@"请输入分享标题");
        return;
    }
    self.mParams[@"title"] = self.titleTextView.text;
    
    if (self.uploadState == HLVideoUploadNormal) {
        HLShowText(@"请上传视频");
        return;
    }
    
    if (self.uploadState == HLVideoUploadVideoFailed || self.uploadState == HLVideoUploadPicFailed) {
        HLShowText(@"视频上传失败，点击重新上传");
        return;
    }
    
    if (self.uploadState == HLVideoUploadVideoing || self.uploadState == HLVideoUploadPicing) {
        HLShowText(@"正在上传视频，请稍后");
        return;
    }
    
    if(self.descTextView.text.length == 0){
        HLShowText(@"请输入视频描述");
        return;
    }
    
    if(self.descTextView.text.length < 5){
        HLShowText(@"视频描述最少输入5个字");
        return;
    }
    self.mParams[@"describe"] = self.descTextView.text;
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/sortVideo/add.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            if (self.marketModel) {
                HLShowText(@"保存成功");
            }else{
                HLShowText(@"添加成功");
            }
            if (self.addBlock) {
                self.addBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
    }];
}

/// 选择视频
- (void)selectVideo{
    switch (self.uploadState) {
        case HLVideoUploadNormal:
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
            break;
        case HLVideoUploadVideoFailed:
            self.uploadState = HLVideoUploadNormal;
            [[HLJDAPIManager manager] reUploadWithFileName:_videoPath.lastPathComponent video:YES];
            break;;
        case HLVideoUploadPicFailed:
            self.uploadState = HLVideoUploadPicing;
            [[HLJDAPIManager manager] reUploadWithFileName:_picPath.lastPathComponent video:false];
            break;
        default:
            break;
    }
}

/// 删除选择的视频
- (void)deleteSelectVideo{
    self.uploadState = HLVideoUploadNormal;
    self.videoPath = nil;
    self.picPath = nil;
    [self.mParams removeObjectForKey:@"videoUrl"];
    [self.mParams removeObjectForKey:@"pic"];
    self.videoImgV.image = [UIImage imageNamed:@"video_upload_place"];
    self.delBtn.hidden = YES;
    self.videoTimeImgV.hidden = YES;
    self.upStateLab.hidden = YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(IQTextView *)textView{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 50) {
                textView.text = [toBeString substringToIndex:50];
            }
        }
    }else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 50) {
            textView.text = [toBeString substringToIndex:50];
        }
    }
    self.inputNumLab.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textView.text.length];
}

#pragma mark - UIImagePickerControllerDelegate

// 选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    // 先删除之前的
    if (self.videoPath.length > 0){
        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
    }
    // 先删除之前的缩略图
    if(self.picPath.length > 0){
        [[NSFileManager defaultManager] removeItemAtPath:self.picPath error:nil];
    }
    self.videoPath = [HLTools filePathWithSystemPath:info[UIImagePickerControllerMediaURL]];
    // 获取视频缩略图
    UIImage *videoImage = [HLTools getScreenShotImageFromVideoPath:self.videoPath];
    self.picPath = [HLTools saveImageWithImage:[HLTools compressImage:videoImage toByte:800 * 1024]];
    // 拿到视频长度更新
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.videoPath] options:nil];
    // UI设置
    self.videoImgV.image = videoImage;
    self.videoTimeImgV.hidden = NO;
    self.delBtn.hidden = NO;
    self.videoTimeLab.text = [HLTools convertStrToTime:[NSString stringWithFormat:@"%lf",CMTimeGetSeconds(audioAsset.duration) *1000]];
    // 上传视频
    self.uploadState = HLVideoUploadVideoing;
    self.upStateLab.text = @"准备上传";
    self.upStateLab.hidden = NO;
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        [[HLJDAPIManager manager] uploadFileWithFilePath:self.videoPath video:YES completion:^(NSString * _Nonnull uploadUrl, NSInteger result) {
            dispatch_main_async_safe(^{
                if (result < 0) { // 上传失败
                    self.uploadState = HLVideoUploadVideoFailed;
                    self.upStateLab.text = @"重新上传";
                }else if (uploadUrl.length){
                    self.uploadState = HLVideoUploadVideoSuccess;
                    // 上传成功
                    self.mParams[@"videoUrl"] = uploadUrl;
                    [self uploadVideoImage];
                }
            });
        } progress:^(CGFloat progress) {
            dispatch_main_async_safe((^{
                self.upStateLab.text = [NSString stringWithFormat:@"%.0f%%",(progress > 0.9 ? 0.9 : progress) * 100];
            }));
        }];
    }];
}

// 上传缩略图
- (void)uploadVideoImage{
    self.uploadState = HLVideoUploadPicing;
    [[HLJDAPIManager manager] uploadFileWithFilePath:self.picPath video:false completion:^(NSString * _Nonnull uploadUrl, NSInteger result) {
        dispatch_main_async_safe(^{
            if (result < 0) { // 上传失败
                self.uploadState = HLVideoUploadPicFailed;
                self.upStateLab.text = @"重新上传";
            }else if (uploadUrl.length){
                self.uploadState = HLVideoUploadAllSuccess;
                self.upStateLab.text = @"100%";
                // 上传成功
                self.mParams[@"pic"] = uploadUrl;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.upStateLab.text = @"准备上传";
                    self.upStateLab.hidden = YES;
                });
            }
        });
    } progress:^(CGFloat progress) {}];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - View

// 创建视图
- (void)creatSubViews{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.scrollView.contentSize = self.scrollView.bounds.size;
    AdjustsScrollViewInsetNever(self, self.scrollView);
    // 选择商品
    UIView *goodSelectView = [self creatGoodNameSelectView];
    [goodSelectView hl_addTarget:self action:@selector(selectGoods)];
    // 选择视频
    UIView *videoSelectView = [self createVideoSelectViewWithTopView:goodSelectView];
    // 底部输入框
    UIView *descInputView = [self createDescInputViewWithTopView:videoSelectView];
    
    // 加按钮
    UIButton *addButton = [[UIButton alloc] init];
    [self.scrollView addSubview:addButton];
    [addButton setTitle:self.marketModel ? @"保存" : @"发布" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [addButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateHighlighted];
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(descInputView.bottom).offset(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

// 底部视图
- (UIView *)createDescInputViewWithTopView:(UIView *)topView{
    UIView *descInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenW, FitPTScreen(120))];
    descInputView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:descInputView];
    
    UIView *line = [[UIView alloc] init];
    [descInputView addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [descInputView addSubview:tipLab];
    tipLab.text = @"视频描述：";
    tipLab.textColor = UIColorFromRGB(0x666666);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(16));
        make.left.equalTo(FitPTScreen(12));
    }];
    
    self.descTextView = [[IQTextView alloc] init];
    [descInputView addSubview:self.descTextView];
    self.descTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.descTextView.placeholder = @"请输入视频描述（最少5个字/最多50字以内）";
    self.descTextView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.descTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(0));
        make.right.equalTo(FitPTScreen(-12));
        make.height.equalTo(FitPTScreen(80));
    }];
    self.descTextView.delegate = self;
    
    self.inputNumLab = [[UILabel alloc] init];
    [descInputView addSubview:self.inputNumLab];
    self.inputNumLab.text = @"0/50";
    self.inputNumLab.textColor = UIColorFromRGB(0x999999);
    self.inputNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.inputNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.bottom.equalTo(FitPTScreen(-12));
    }];
    
    return descInputView;
}

// 中间选择视频
- (UIView *)createVideoSelectViewWithTopView:(UIView *)topView{
    
    UIView *videoSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenW, FitPTScreen(168))];
    videoSelectView.backgroundColor = UIColor.whiteColor;
    videoSelectView.userInteractionEnabled = YES;
    [self.scrollView addSubview:videoSelectView];
    
    UIView *line = [[UIView alloc] init];
    [videoSelectView addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(10));
    }];

    UILabel *starLab = [[UILabel alloc] init];
    [videoSelectView addSubview:starLab];
    starLab.text = @"*";
    starLab.textColor = UIColorFromRGB(0xEB1731);
    starLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [starLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(FitPTScreen(15));
        make.left.equalTo(FitPTScreen(12));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [videoSelectView addSubview:tipLab];
    tipLab.text = @"视频标题";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starLab);
        make.left.equalTo(starLab.right).offset(FitPTScreen(4));
    }];
    
    self.videoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_upload_place"]];
    [videoSelectView addSubview:self.videoImgV];
    self.videoImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImgV.clipsToBounds = YES;
    [self.videoImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.width.equalTo(FitPTScreen(75));
        make.height.equalTo(FitPTScreen(100));
        make.top.equalTo(line.bottom).offset(FitPTScreen(43));
    }];
    [self.videoImgV hl_addTarget:self action:@selector(selectVideo)];
    
    self.delBtn = [[UIButton alloc] init];
    [videoSelectView addSubview:self.delBtn];
    [self.delBtn setBackgroundImage:[UIImage imageNamed:@"video_select_del"] forState:UIControlStateNormal];
    [self.delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoImgV.right);
        make.centerY.equalTo(self.videoImgV.top);
        make.width.height.equalTo(FitPTScreen(21));
    }];
    [self.delBtn addTarget:self action:@selector(deleteSelectVideo) forControlEvents:UIControlEventTouchUpInside];
    
    _videoTimeImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_bag"]];
    [self.videoImgV addSubview:_videoTimeImgV];
    [_videoTimeImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.videoImgV);
        make.height.equalTo(FitPTScreen(21.5));
    }];
    
    UIImageView *tipImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"little_video"]];
    [_videoTimeImgV addSubview:tipImgV];
    [tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoTimeImgV);
        make.left.equalTo(FitPTScreen(9));
        make.height.equalTo(FitPTScreen(8.5));
        make.width.equalTo(FitPTScreen(13));
    }];
    
    _videoTimeLab = [[UILabel alloc]init];
    _videoTimeLab.textColor = UIColorFromRGB(0xFFFFFF);
    _videoTimeLab.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [self.videoTimeImgV addSubview:_videoTimeLab];
    [_videoTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-9));
        make.centerY.equalTo(self.videoTimeImgV);
    }];

    self.titleTextView = [[IQTextView alloc] init];
    [videoSelectView addSubview:self.titleTextView];
    self.titleTextView.placeholder = @"请输入分享标题";
    self.titleTextView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.titleTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.bottom.equalTo(self.videoImgV);
        make.top.equalTo(self.videoImgV.top).offset(FitPTScreen(-4));
        make.right.equalTo(self.videoImgV.left).offset(FitPTScreen(-10));
    }];
    
    self.upStateLab = [[UILabel alloc] init];
    [self.videoImgV addSubview:self.upStateLab];
    self.upStateLab.textColor = UIColorFromRGB(0xFFFFFF);
    self.upStateLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.upStateLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImgV);
    }];
    
    return videoSelectView;
}

// 顶部视图
- (UIView *)creatGoodNameSelectView{
    
    UIView *goodNameSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(50))];
    goodNameSelectView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:goodNameSelectView];
    
    UILabel *starLab = [[UILabel alloc] init];
    [goodNameSelectView addSubview:starLab];
    starLab.text = @"*";
    starLab.textColor = UIColorFromRGB(0xEB1731);
    starLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [starLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodNameSelectView);
        make.left.equalTo(FitPTScreen(12));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [goodNameSelectView addSubview:tipLab];
    tipLab.text = @"选择推广商品";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodNameSelectView);
        make.left.equalTo(starLab.right).offset(FitPTScreen(4));
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_darkGrey"]];
    [goodNameSelectView addSubview:arrowImgV];
    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(goodNameSelectView);
        make.width.equalTo(FitPTScreen(6));
        make.height.equalTo(FitPTScreen(11));
    }];
    
    _goodNameLab = [[UITextField alloc] init];
    [goodNameSelectView addSubview:_goodNameLab];
    _goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.placeholder = @"请选择推送商品(秒杀/外卖)";
    _goodNameLab.enabled = NO;
    _goodNameLab.textAlignment = NSTextAlignmentRight;
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(125));
        make.right.equalTo(arrowImgV.left).offset(FitPTScreen(-5));
        make.top.bottom.equalTo(0);
    }];
    
    return goodNameSelectView;
}

#pragma mark - Getter

- (NSMutableDictionary *)mParams{
    if (!_mParams) {
        _mParams = [[NSMutableDictionary alloc] init];
    }
    return _mParams;
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie",  nil];
    }
    return _imagePicker;
}

@end


 
