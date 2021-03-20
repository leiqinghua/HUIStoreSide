//
//  HLImagePickerManager.h
//  HuiLife
//
//  Created by 王策 on 2019/12/10.
//

#import <Foundation/Foundation.h>
#import "HLImagePickerConfig.h"
#import "HLAsset.h"

typedef void(^HLImagePickerBlock)(NSArray <UIImage *>*images);

NS_ASSUME_NONNULL_BEGIN

@interface HLImagePickerManager : NSObject

+ (instancetype)shared;

// 配置初始构建时的比例，是否裁减等信息
@property (nonatomic, strong, readonly) HLImagePickerConfig *config;

// 选择的回调
@property (nonatomic, copy) HLImagePickerBlock pickerBlock;

// 配置信息
- (void)setUpConfig:(HLImagePickerConfig *)config;

#pragma mark - Select

// 选中的assetmode数组
@property (nonatomic, strong) NSMutableArray<HLAsset *>* selectAssets;
// 选中的asset的id数组
@property (nonatomic, strong) NSMutableArray<NSString *>* selectAssetIds;

// 添加到选中数组中
- (void)addSelectAsset:(HLAsset *)asset;
// 从选中数组中移除
- (void)removeAsset:(HLAsset *)asset;
// 选中的在数组中的下标
- (NSInteger)indexWithAssetId:(NSString *)assetId;
// 清除选中的图片
- (void)clearSelectAsset;

#pragma mark - Cache
// 获取缓存图片
- (UIImage *)cacheImageWithAssetId:(NSString *)assetId;
// 保存缓存图片
- (void)saveImage:(UIImage *)image assetId:(NSString *)assetId;
// 清除缓存
- (void)clearCacheImageDict;
// 判断是否有缓存图片
- (BOOL)hasImageCacheWithAssetId:(NSString *)assetId;
// 清除指定缓存
- (void)removeCacheImageWithAssetId:(NSString *)assetId;

@end

NS_ASSUME_NONNULL_END
