//
//  ALiImagePickerController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerController.h"
#import "ALiImageBrowserController.h"
#import "ALiImagePickerService.h"
#import "UIButton+ALi.h"
#import "ALiImageCell.h"
#import "ALiAsset.h"
#define kBottomBarHeight  44.

static  NSString *kArtImagePickerCellIdentifier = @"ALiImageCell";
static  NSString *kArtAssetsFooterViewIdentifier = @"ALiImagePickFooterView";
#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
@interface ALiImagePickerController () <UICollectionViewDelegate,UICollectionViewDataSource,ALiImageCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//UI
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

//Data
@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, strong) NSMutableArray *selectAssets;

@property (nonatomic, strong) ALiImagePickerService *pickerService;

@end

@implementation ALiImagePickerController

#pragma mark - Custom Method

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSelectAssets:(ALiAsset *)asset
{
    if (asset.isSelected) {
        [self.selectAssets addObject:asset];
    } else {
        [self.selectAssets removeObject:asset];
    }
}


- (void)sendSelectAsset
{
    
    if(self.selectAssets.count == 0) return;
    
    if (self.photoChooseBlock) {
        self.photoChooseBlock(self.selectAssets);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load Data

- (void)fetchImagesInLibary
{
    WEAKSELF(weakSelf);
    [self.pickerService fectchAssetsWithMediaType:EALiPickerResourceTypeImage  completion:^(NSString *title,NSArray *assets) {
        NSMutableArray *arrM = [NSMutableArray array];
        if (weakSelf.showTakephoto) {
           [arrM addObject:@"takephoto"];
        }
        [arrM addObjectsFromArray:assets];
        weakSelf.assets = [arrM copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    }];
}


- (void)askForAuthorize
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pickerService fetchAllImages];
                [self buildUI];
                [self fetchImagesInLibary];//获取所有图片
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self buildRestrictedUI];
            });
        }
    }];
}

- (void)openAuthorization
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册权限未开启" message:@"相册权限未开启，请在设置中选择当前应用,开启相册功能" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:open];
    [alert addAction:cancel];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Load View

- (void)buildUI
{
    self.selectAssets = [NSMutableArray array];
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - Height_Bottom_Margn-FitPTScreen(85));
    
    UIButton * uploadBtn = [[UIButton alloc]init];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload_btn"] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"确认" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:uploadBtn];
    [uploadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(FitPTScreen(-13) + Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    
    [uploadBtn addTarget:self action:@selector(sendSelectAsset) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buildRestrictedUI
{
    UIButton *tipBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    tipBtn.titleLabel.numberOfLines = 2;
    tipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [tipBtn setTitle:@"相册权限未开启，请在设置中选择当前应用,开启相册功能 \n 点击去设置" forState:UIControlStateNormal];
    tipBtn.frame = CGRectMake(0, (SCREEN_H/2.)-25, SCREEN_W, 50);
    tipBtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:tipBtn];
    [self.view bringSubviewToFront:tipBtn];
    [tipBtn addTarget:self action:@selector(openAuthorization) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 如果需要回显就是单利
    if (!self.needCleanSelect) {
        self.pickerService = [ALiImagePickerService shared];
    }else{
        self.pickerService = [[ALiImagePickerService alloc] init];
    }
    
    [self askForAuthorize];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_hideBack:false];
    [self hl_setTitle:@"选择图片" andTitleColor:UIColorFromRGB(0x333333)];
}


-(void)hl_goback{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    HLLog(@"%s",__func__);
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALiAsset *asset = self.assets[indexPath.item];
    ALiImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kArtImagePickerCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell configImageCell:asset];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark- UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    if (self.takePhotoCallBack) {
        self.takePhotoCallBack(info[UIImagePickerControllerOriginalImage]);
    }
    UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ALiImageCellDelegate

- (void)imageDidSelect:(ALiAsset *)asset select:(UIButton *)sender
{
    if (_maxSelectNum == 0) {
         sender.selected = !sender.selected;
         asset.selected = sender.isSelected;
        [self addSelectAssets:asset];
        return;
    }
    
    if (sender.selected) {
        _curSelectNum -= 1;
    }else{
      _curSelectNum += 1;
    }
    if ( _curSelectNum > _maxSelectNum) {
        _curSelectNum = _maxSelectNum;
        NSString * hint = [NSString stringWithFormat:@"最多只能选择%ld张图片哦",_maxSelectNum];
        HLShowHint(hint,self.view);
        return;
    }
    sender.selected = !sender.selected;
    asset.selected = sender.isSelected;
    [self addSelectAssets:asset];
}

- (void)imageDidTapped:(ALiAsset *)asset select:(BOOL)isSelect
{
    if ([asset isKindOfClass:[NSString class]]) {
        //拍照
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    } else if ([asset isKindOfClass:[ALiAsset class]]) {
        //看大图
//        ALiImageBrowserController *browserVc = [[ALiImageBrowserController alloc] init];
//        WEAKSELF(weakSelf);
//        browserVc.photoChooseBlock = ^(NSArray *assets){
//            weakSelf.selectAssets = [assets mutableCopy];
//            [weakSelf.collectionView reloadData];
//        };
//
//        browserVc.allAssets = [NSMutableArray arrayWithArray:self.assets];
//        browserVc.selectedAsset = self.selectAssets;
//        browserVc.curIndex = [self.assets indexOfObject:asset];
//        [self.navigationController pushViewController:browserVc animated:YES];
    }
}

#pragma mark - Lazy Load

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ALiImageCell class] forCellWithReuseIdentifier:kArtImagePickerCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];

    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 2.0;
        _layout.minimumInteritemSpacing = 2.0;
        _layout.itemSize = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
        _layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

@end
