//
//  HLImageSinglePickerController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/20.
//

#import "HLImageSinglePickerController.h"
#import "HLActionSheet.h"

@interface HLImageSinglePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,WHActionSheetDelegate>
{
    BOOL _edit;
    BOOL _show;
}

@property(strong,nonatomic)WHActionSheet * actionSheet;

@property (copy, nonatomic)HLImageCallBack callBack;

@property(strong,nonatomic)UIImagePickerController * imagePicker;


@end

@implementation HLImageSinglePickerController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_show) {
        return;
    }
    _show = YES;
    _actionSheet = [HLActionSheet showActionSheetWithDataSource:@[@"拍照",@"从手机相册选择"] delegate:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(instancetype)initWithAllowsEditing:(BOOL)allowsEditing callBack:(HLImageCallBack)callBack{
    if (self = [super init]) {
        _edit = allowsEditing;
        _callBack = callBack;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = _edit;
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _imagePicker;
}

#pragma mark - WHActionSheetDelegate

-(void)actionSheet:(WHActionSheet *)actionSheet clickButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openCamera];
    }else{
        [self openAlbum];
    }
}

- (void)actionSheetCancle:(WHActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ===== 选择图片代理 =====

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (_edit) {
        image = info[@"UIImagePickerControllerEditedImage"];
    }else{
        image = info[@"UIImagePickerControllerOriginalImage"];
    }
    if (self.callBack) {
        self.callBack(image);
    }
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_actionSheet dissmiss];
    [self.imagePicker dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)openAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //  指定数据源 图库
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)openCamera{
    //  指定数据源 图库
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

@end
