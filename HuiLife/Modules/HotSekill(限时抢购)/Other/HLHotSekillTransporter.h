//
//  HLHotSekillTransporter.h
//  HuiLife
//
//  Created by 王策 on 2021/8/8.
//

#import <Foundation/Foundation.h>

/// 添加&编辑爆款秒杀涉及到 列表页->详情添加页->套餐详情页->图片上传页多个页面，这里使用单例存储数据

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillTransporter : NSObject

/// 最后添加&编辑保存的参数
@property (nonatomic, strong) NSMutableDictionary *uploadParams;

/// 是否为编辑状态
@property (nonatomic, assign) BOOL isEdit;

/// 编辑时获取的商品详情的所有信息
@property (nonatomic, copy) NSDictionary *editModelData;

/// 单例
+ (instancetype)sharedTransporter;

/// 拼接参数
- (void)appendParams:(NSDictionary *)params;

/// 释放所有数据
- (void)resetAllParams;

@end

NS_ASSUME_NONNULL_END
