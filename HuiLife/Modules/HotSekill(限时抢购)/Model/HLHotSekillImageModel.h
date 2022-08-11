//
//  HLHotSekillImageModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import <Foundation/Foundation.h>
#import "HLBaseUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillImageModel : HLBaseUploadModel

@property (nonatomic, assign) BOOL isFirst;  // 是否主图
@property (nonatomic, assign) BOOL isNormal; // 是默认的那张图

@end

NS_ASSUME_NONNULL_END
