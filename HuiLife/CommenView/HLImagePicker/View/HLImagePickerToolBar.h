//
//  HLImagePickerToolBar.h
//  HuiLife
//
//  Created by 王策 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HLImagePickerToolBarTypePreview,
    HLImagePickerToolBarTypeEdit
} HLImagePickerToolBarType;

@class HLImagePickerToolBar;
@protocol HLImagePickerToolBarDelegate <NSObject>

// 点击左边按钮
- (void)leftButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar;

// 点击完成按钮
- (void)selectButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar;

// 原图按钮展示
- (void)toolBar:(HLImagePickerToolBar *)tooBar orinalSelect:(BOOL)orinalSelect;

@end

@interface HLImagePickerToolBar : UIView

@property (nonatomic, weak) id <HLImagePickerToolBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(HLImagePickerToolBarType)type;

// 配置选中的数量
- (void)configSelectNum:(NSInteger)num;

// 配置原图按钮是否勾选
- (void)configOrinalSelect:(BOOL)select;

// 隐藏编辑按钮
- (void)hideEditBtn;

@end

NS_ASSUME_NONNULL_END
