//
//  HLImagePickerController.h
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import <UIKit/UIKit.h>
//#import "HLAsset.h"
#import "HLImagePickerService.h"
#import "HLImagePickerManager.h"

// 1.多张图片强制裁减
// 2.多张图片不强制裁减
// 3.单张图片强制裁减
// 4.单张图片不强制裁减

NS_ASSUME_NONNULL_BEGIN

@interface HLImagePickerController : UINavigationController

/// 构造
/// @param needResize 是否展示编辑按钮
/// @param mustResize 每一张图片，是否必须裁减
/// @param selectOrinal 是否勾选了选择原图
/// @param resizeWHScale 裁减比例
/// @param pickerBlock 选择回调
- (instancetype)initWithNeedResize:(BOOL)needResize maxSelectNum:(NSInteger)maxSelectNum singleSelect:(BOOL)singleSelect mustResize:(BOOL)mustResize selectOrinal:(BOOL)selectOrinal resizeWHScale:(CGFloat)resizeWHScale pickerBlock:(HLImagePickerBlock)pickerBlock;

@end

NS_ASSUME_NONNULL_END
