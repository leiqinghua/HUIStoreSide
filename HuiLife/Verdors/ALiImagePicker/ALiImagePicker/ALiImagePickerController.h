//
//  ALiImagePickerController.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALiConfig.h"


typedef void(^ALiTakePhotoCallBack)(UIImage *orinalImage);

@interface ALiImagePickerController : HLBaseViewController

/// 是否显示拍照
@property(nonatomic,assign) BOOL showTakephoto;

/// 选择是图片还是视频
@property (nonatomic, assign) EALiPickerResourceType sourceType;

/// 选择的相册的回调
@property (nonatomic, copy) void (^photoChooseBlock)(NSArray *selectAssets);

/// 拍照的回调
@property (nonatomic, copy) ALiTakePhotoCallBack takePhotoCallBack;

/// 是否需要清除所选中的图片
@property (nonatomic, assign) BOOL needCleanSelect;

//最多选几张
@property (nonatomic,assign)NSInteger maxSelectNum;

//当前选择了几张
@property (nonatomic,assign)NSInteger curSelectNum;

@end
