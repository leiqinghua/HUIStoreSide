//
//  HLBottomControlView.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HLControlTypeWXCycle,  // 朋友圈
    HLControlTypeWXChat,   // 微信
    HLControlTypePush,     // 推送
    HLControlTypePreView,  // 预览
    HLControlTypeStateUp,    // 上架状态
    HLControlTypeStateDown,  // 下架状态
    HLControlTypeDataView, // 数据概览
    HLControlTypeQRCode, // 下载二维码
    HLControlTypeDisplay,//生成展架
    HLControlTypeDeleteCard, //删除会卡
    HLControlTypeEditCard, //修改HUI卡
    HLControlTypeCreateCard, //生成卡密
} HLControlType;

typedef void (^HLControlCallBack)(HLControlType type);

NS_ASSUME_NONNULL_BEGIN

@interface HLBottomControlView : UIView

/// 0 显示下架 1 显示上架
+ (void)showControlView:(NSInteger)upState onlyUpdate:(BOOL)onlyUpdate callBack:(HLControlCallBack)callBack;

+ (void)showControlViewWithItemTitles:(NSArray *)titles callBack:(HLControlCallBack)callBack;


@end

NS_ASSUME_NONNULL_END
