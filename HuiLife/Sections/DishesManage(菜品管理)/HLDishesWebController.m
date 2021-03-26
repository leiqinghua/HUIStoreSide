//
//  HLDishesWebController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/19.
//

#import "HLDishesWebController.h"
#import "HLUrl.h"

@interface HLDishesWebController ()<UIImagePickerControllerDelegate>

@property(strong,nonatomic)UIImagePickerController * pickerVC;

@property(nonatomic,copy)NSString * upLoadImageUrl;

@end

@implementation HLDishesWebController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(UIImagePickerController *)pickerVC{
    if (!_pickerVC) {
        _pickerVC = [[UIImagePickerController alloc]init];
        _pickerVC.delegate = self;
        // 是否允许编辑（YES：图片选择完成进入编辑模式）
        _pickerVC.allowsEditing = YES;
    }
    return _pickerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_interactivePopGestureRecognizerUseable];
    self.view.backgroundColor = UIColor.whiteColor;
    self.webview.scrollView.mj_header.hidden = YES;
    
    // 全屏显示
    [self resetWebViewFrame:self.view.bounds];
    [self setProgressFrame:CGRectMake(0, 0, ScreenW, 2)];
    
}

-(void)hl_webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    // 处理的url
    HLLog(@"处理的url ===> %@",webView.URL.absoluteString);
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"goback://"]) {
        [self hl_goback];
        decisionHandler(WKNavigationActionPolicyAllow);
    }else if ([navigationAction.request.URL.absoluteString hasPrefix:@"foodpackage://"]){
        _upLoadImageUrl = @"path=food_combo&appupload=apppic";
        [self getImage];
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if ([navigationAction.request.URL.absoluteString hasPrefix:@"getimage://"]){
        _upLoadImageUrl = @"path=common_pic&appupload=apppic";
        [self getImage];
        decisionHandler(WKNavigationActionPolicyAllow);
    }else if ([navigationAction.request.URL.absoluteString hasSuffix:@"token_404://huilift"]) {//多设备同时登录
        [HLTools shwoMutableDeviceLogin:nil];
        [self hl_goback];
        decisionHandler(WKNavigationActionPolicyAllow);
    }else if ([navigationAction.request.URL.absoluteString hasSuffix:@"token_405://huilift"]){
        [HLTools showExpireTokenView];
    }else{
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - UIImagePickerController
- (void)getImage {
    weakify(self);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"图片选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1;
    UIAlertAction * imageAction;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weak_self goCamera];
        }];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imageAction = [UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weak_self goImage];
        }];
    }
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if (action1) {
        [alert addAction:action1];
    }if (imageAction) {
        [alert addAction:imageAction];
    }
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//照片
- (void)goCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        //筛选出的资源类型
        [self presentViewController:self.pickerVC animated:YES completion:nil];
    }
}

//图片
- (void)goImage {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //筛选出的资源类型
        [self.navigationController presentViewController:self.pickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * editImage = info[@"UIImagePickerControllerEditedImage"];
    NSData * data = UIImageJPEGRepresentation(editImage, 0.5);
    [self upLoadImage:data];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - request
- (void)upLoadImage:(NSData *)imageData {
    NSString * url = [NSString stringWithFormat:@"%@&%@",[HLUrl uploadImageUrl],_upLoadImageUrl];
    [HLTools uploadImage:imageData name:@"upFile" url:url pargram:@{@"upFile":imageData} callBack:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error) {
            [HLTools showWithText:@"上传图片失败"];
            return ;
        }
        NSString * imgUrl = result[@"file_url"];
        NSString *js = [NSString stringWithFormat:@"reback_img('%@')",imgUrl];
        [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        }];
    }];
}

- (void)dealloc {
    NSLog(@"网页销毁");
    [self clearStorage];
}

- (void)clearStorage {
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {}
}
@end
