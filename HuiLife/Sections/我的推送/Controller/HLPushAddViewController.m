//
//  HLPushAddViewController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLPushAddViewController.h"

#import <IQKeyboardManager/IQTextView.h>
#import "HLVideoProductSelectController.h"
#import "HLVideoProductModel.h"
#import "HLJDAPIManager.h"
#import "HLPushHistoryViewController.h"

typedef enum : NSUInteger {
    HLPicUploadNormal,          // 默认状态
    HLPicUploading,             // 图片上传中
    HLPicUploadFailed,       // 图片上传失败
    HLPicUploadSuccess          // 上传成功
} HLPicUploadState;

// 保存用的参数
#define KEY_TYPE @"type"
#define KEY_PROID @"pro_id"
#define KEY_NAME @"name"
#define KEY_TITLE @"title"
#define KEY_DESCRIBE @"describe"
#define KEY_IMAGE @"image"


@interface HLPushAddViewController () <UIImagePickerControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIImagePickerController * imagePicker;

// 上传状态
@property (nonatomic, assign) HLPicUploadState uploadState;
@property (nonatomic, strong) NSString *picPath;


// 最后构造的参数
@property (nonatomic, strong) NSMutableDictionary *mParams;

// 商品选择视图
@property (nonatomic, strong) UITextField *goodNameLab;
@property (nonatomic, strong) UITextView *titleInput;
@property (nonatomic, strong) UITextView *descInput;

// 视频上传视图
@property (nonatomic, strong) UIImageView *videoImgV;
@property (nonatomic, strong) IQTextView *titleTextView;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *upStateLab;

// 描述
@property (nonatomic, strong) IQTextView *descTextView;
@property (nonatomic, strong) UILabel *inputNumLab;

// 预计推送的人数
@property (nonatomic, strong) UILabel *pushNumLab;

// 被拒的原因
@property (nonatomic, strong) UILabel *reasonLab;


@end

@implementation HLPushAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.pushId ? @"修改推送" : @"创建推送";
    if(self.pushId.length){
        [self loadPushDetailData];
    }else{
        [self loadDefautData];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Method

/// 加载预计推送人数
- (void)loadDefautData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/pushDetail.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            [self creatSubViews];
            self.reasonLab.hidden = YES;
            self.pushNumLab.text = [NSString stringWithFormat:@"预计%ld位HUI卡会员能接收到",[responseObject.data[@"total"] integerValue]];
        }else{
            weakify(self);
            [self hl_showNetFail:self.view.bounds callBack:^{
                [weak_self loadDefautData];
            }];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
        weakify(self);
        [self hl_showNetFail:self.view.bounds callBack:^{
            [weak_self loadDefautData];
        }];
    }];
}

/// 加载推送详情 https://sapi.51huilife.cn/HuiLife_Api/push/pushDetail.php
- (void)loadPushDetailData{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/pushDetail.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"push_id":self.pushId};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            //
            HLPushEditDataModel *dataModel = [HLPushEditDataModel mj_objectWithKeyValues:responseObject.data];
            
            // 参数构建
            self.mParams[KEY_IMAGE] = dataModel.image;
            self.mParams[KEY_TITLE] = dataModel.title;
            self.mParams[KEY_DESCRIBE] = dataModel.push_desc;
            self.mParams[KEY_PROID] = dataModel.pro_id;
            self.mParams[KEY_NAME] = dataModel.name;
            self.mParams[@"push_id"] = self.pushId;
            [self creatSubViews];
            self.uploadState = HLPicUploadSuccess;
            self.pushNumLab.text = [NSString stringWithFormat:@"预计%ld位HUI卡会员能接收到",[responseObject.data[@"total"] integerValue]];
            [self.videoImgV sd_setImageWithURL:[NSURL URLWithString:dataModel.image]];
            self.delBtn.hidden = NO;
            self.goodNameLab.text = dataModel.name;
            self.titleTextView.text = dataModel.title;
            self.descTextView.text = dataModel.push_desc;
            self.inputNumLab.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)self.descTextView.text.length];
            self.inputNumLab.hidden = NO;
            self.reasonLab.hidden = NO;
            self.reasonLab.text = dataModel.reason;
        }else{
            weakify(self);
            [self hl_showNetFail:self.view.bounds callBack:^{
                [weak_self loadDefautData];
            }];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
        weakify(self);
        [self hl_showNetFail:self.view.bounds callBack:^{
            [weak_self loadDefautData];
        }];
    }];
}

/// 选择商品
- (void)selectGoods{
    if(self.pushId){
        HLShowText(@"修改推送信息，不能更改商品类型");
        return;
    }
    HLVideoProductSelectController *selectGoods = [[HLVideoProductSelectController alloc] init];
    selectGoods.mode = 0;
    selectGoods.pro_id = self.mParams[KEY_PROID] ?: @"";
    selectGoods.type = self.mParams[KEY_TYPE] ? [self.mParams[KEY_TYPE] integerValue] : 0;
    selectGoods.productSelectBlock = ^(HLVideoProductModel * _Nonnull model, NSInteger type) {
        // 视图配置
        self.goodNameLab.text = model.name;

        // 请求参数配置
        self.mParams[KEY_PROID] = model.pro_id;
        self.mParams[KEY_NAME] = model.name;
        self.mParams[KEY_TYPE] = @(type); // 0 外卖 1 秒杀
    };
    [self.navigationController pushViewController:selectGoods animated:YES];
}

/// 保存
- (void)addButtonClick{
    if(!self.mParams[KEY_PROID]){
        HLShowText(@"请选择推送商品");
        return;
    }
    
    if(self.titleTextView.text.length == 0){
        HLShowText(@"请输入推送标题");
        return;
    }
    self.mParams[KEY_TITLE] = self.titleTextView.text;
    
    if (self.uploadState == HLPicUploadNormal) {
        HLShowText(@"请选择推送图片");
        return;
    }
    
    if (self.uploadState == HLPicUploadFailed) {
        HLShowText(@"图片上传失败，点击重新上传");
        return;
    }
    
    if (self.uploadState == HLPicUploading) {
        HLShowText(@"正在上传图片，请稍后");
        return;
    }
    
    if(self.descTextView.text.length == 0){
        HLShowText(@"请输入推送描述");
        return;
    }
    
    if(self.descTextView.text.length < 5){
        HLShowText(@"推送描述最少输入5个字");
        return;
    }
    self.mParams[KEY_DESCRIBE] = self.descTextView.text;
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/myPush.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.mParams;
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            if (self.pushId) {
                HLShowText(@"修改成功");
            }else{
                HLShowText(@"创建成功");
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
        case HLPicUploadNormal:
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
            break;
        case HLPicUploadFailed:
            self.uploadState = HLPicUploading;
            [[HLJDAPIManager manager] reUploadWithFileName:_picPath.lastPathComponent video:false];
            break;
        default:
            break;
    }
}

/// 删除选择的视频
- (void)deleteSelectVideo{
    self.uploadState = HLPicUploadNormal;
    self.picPath = nil;
    [self.mParams removeObjectForKey:KEY_IMAGE];
    self.videoImgV.image = [UIImage imageNamed:@"push_add_select"];
    self.delBtn.hidden = YES;
    self.upStateLab.hidden = YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(IQTextView *)textView{
    NSInteger maxInputCount = 20;
    if(textView == self.descTextView){
        maxInputCount = 20;
    }
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
            if (toBeString.length > maxInputCount) {
                textView.text = [toBeString substringToIndex:maxInputCount];
            }
        }
    }else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > maxInputCount) {
            textView.text = [toBeString substringToIndex:maxInputCount];
        }
    }
    if (textView == self.descTextView) {
        self.inputNumLab.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textView.text.length];
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{

    // 先删除之前的缩略图
    if(self.picPath.length > 0){
        [[NSFileManager defaultManager] removeItemAtPath:self.picPath error:nil];
    }
    
    UIImage *selectImage = info[@"UIImagePickerControllerOriginalImage"];
    self.picPath = [HLTools saveImageWithImage:[HLTools compressImage:selectImage toByte:800 * 1024]];
    // UI设置
    self.videoImgV.image = selectImage;
    self.delBtn.hidden = NO;
    // 上传视频
    self.uploadState = HLPicUploading;
    self.upStateLab.text = @"准备上传";
    self.upStateLab.hidden = NO;
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        [[HLJDAPIManager manager] uploadFileWithFilePath:self.picPath video:NO completion:^(NSString * _Nonnull uploadUrl, NSInteger result) {
            dispatch_main_async_safe(^{
                NSLog(@"图片地址:%@",uploadUrl);
                if (result < 0) { // 上传失败
                    self.uploadState = HLPicUploadFailed;
                    self.upStateLab.text = @"重新上传";
                }else if (uploadUrl.length){
                    self.uploadState = HLPicUploadSuccess;
                    // 上传成功
                    self.mParams[KEY_IMAGE] = uploadUrl;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.upStateLab.text = @"准备上传";
                        self.upStateLab.hidden = YES;
                    });
                }
            });
        } progress:^(CGFloat progress) {
            dispatch_main_async_safe((^{
                self.upStateLab.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
            }));
        }];
    }];
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
    [addButton setTitle:self.pushId ? @"确定修改" : @"创建推送" forState:UIControlStateNormal];
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
    
    self.reasonLab = [[UILabel alloc] init];
    [self.scrollView addSubview:self.reasonLab];
    self.reasonLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    self.reasonLab.textColor = UIColor.redColor;
    self.reasonLab.numberOfLines = 0;
    self.reasonLab.textAlignment = NSTextAlignmentCenter;
    [self.reasonLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(FitPTScreen(340));
        make.top.equalTo(addButton.bottom).offset(FitPTScreen(0));
    }];
    
    self.uploadState = HLPicUploadNormal;
    self.delBtn.hidden = YES;
    self.upStateLab.hidden = YES;
}

// 底部视图
- (UIView *)createDescInputViewWithTopView:(UIView *)topView{
    UIView *descInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenW, FitPTScreen(160))];
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
    tipLab.text = @"推广描述：";
    tipLab.textColor = UIColorFromRGB(0x666666);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(16));
        make.left.equalTo(FitPTScreen(12));
    }];
    
    self.descTextView = [[IQTextView alloc] init];
    [descInputView addSubview:self.descTextView];
    self.descTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.descTextView.placeholder = @"请输入推广描述（最少5个字/最多50字以内）";
    self.descTextView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.descTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(0));
        make.right.equalTo(FitPTScreen(-12));
        make.height.equalTo(FitPTScreen(80));
    }];
    self.descTextView.delegate = self;
    
    UIView *pushNumView = [[UIView alloc] init];
    [descInputView addSubview:pushNumView];
    pushNumView.backgroundColor = UIColorFromRGB(0xFFF2E7);
    [pushNumView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descTextView.bottom).offset(FitPTScreen(10));
        make.left.right.bottom.equalTo(0);
    }];
    
    self.pushNumLab = [[UILabel alloc] init];
    [pushNumView addSubview:self.pushNumLab];
    self.pushNumLab.textColor = UIColorFromRGB(0xFF9900);
    self.pushNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.pushNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pushNumView);
        make.centerX.equalTo(pushNumView.centerX).offset(FitPTScreen(5));
    }];
    
    UIImageView *pushTipImgV = [[UIImageView alloc] init];
    [descInputView addSubview:pushTipImgV];
    pushTipImgV.image = [UIImage imageNamed:@"push_add_huangguan"];
    [pushTipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pushNumLab.left).offset(FitPTScreen(-7));
        make.centerY.equalTo(pushNumView);
    }];
    
    self.inputNumLab = [[UILabel alloc] init];
    [descInputView addSubview:self.inputNumLab];
    self.inputNumLab.text = @"0/50";
    self.inputNumLab.textColor = UIColorFromRGB(0x999999);
    self.inputNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.inputNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.bottom.equalTo(FitPTScreen(-46));
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
    tipLab.text = @"推送标题";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starLab);
        make.left.equalTo(starLab.right).offset(FitPTScreen(4));
    }];
    
    self.videoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push_add_select"]];
    [videoSelectView addSubview:self.videoImgV];
    self.videoImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImgV.clipsToBounds = YES;
    [self.videoImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.width.equalTo(FitPTScreen(90));
        make.height.equalTo(FitPTScreen(90));
        make.top.equalTo(line.bottom).offset(FitPTScreen(45));
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
    
    self.titleTextView = [[IQTextView alloc] init];
    [videoSelectView addSubview:self.titleTextView];
    self.titleTextView.placeholder = @"请输入推广标题(最多20个字)";
    self.titleTextView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.titleTextView.delegate = self;
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
        _imagePicker.allowsEditing = YES;
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _imagePicker;
}

@end

//https://sapi.51huilife.cn/HuiLife_Api/push/pushDetail.php


@implementation HLPushEditDataModel

@end
