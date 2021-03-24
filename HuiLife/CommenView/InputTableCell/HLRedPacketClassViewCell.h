//
//  HLRedPacketClassViewCell.h
//  HuiLife
//
//  Created by 王策 on 2021/3/23.
//

#import "HLBaseInputViewCell.h"



NS_ASSUME_NONNULL_BEGIN

@interface HLRedPacketClassInfo : HLBaseTypeInfo

@property (nonatomic, assign) BOOL showTopPlace;    // 展示顶部站位区域
@property (nonatomic, assign) BOOL showBottomPlace; // 展示底部站位区域

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *gain_id;
@end

@interface HLRedPacketClassViewCell : HLBaseInputViewCell


@end

NS_ASSUME_NONNULL_END
