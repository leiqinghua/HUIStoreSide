//
//  HLImagePickerConfig.h
//  HuiLife
//
//  Created by 王策 on 2019/12/10.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HLImagePickerConfig : NSObject

// 是否是单选模式，为YES，则忽略maxSelectNum
@property (nonatomic, assign, getter = isSingleSelect) BOOL singleSelect;

// 本次最多选取的图片
@property (nonatomic, assign) NSInteger maxSelectNum;

// 裁减的宽高比
@property (nonatomic, assign) CGFloat resizeWHScale;

// 是否需要展示裁减，如果mustResize为YES，needResize也为YES
@property (nonatomic, assign) BOOL needResize;

// 是否所有图片必须裁减
@property (nonatomic, assign) BOOL mustResize;

// 当前是否选择的原图
@property (nonatomic, assign) BOOL selectOrinal;



@end

NS_ASSUME_NONNULL_END
