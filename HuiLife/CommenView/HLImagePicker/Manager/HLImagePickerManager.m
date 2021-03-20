//
//  HLImagePickerManager.m
//  HuiLife
//
//  Created by 王策 on 2019/12/10.
//

#import "HLImagePickerManager.h"

@interface HLImagePickerManager ()

@property (nonatomic, strong) HLImagePickerConfig *config;
@property (nonatomic, strong) NSMutableDictionary *cacheImageDict; // 存放的是缓存的裁减的图片

@end

static HLImagePickerManager *manager = nil;

@implementation HLImagePickerManager

#pragma mark - 初始化方法

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 配置配置信息
- (void)setUpConfig:(HLImagePickerConfig *)config{
    _config = config;
}

// 添加选中的Asset
- (void)addSelectAsset:(HLAsset *)asset{
    [self.selectAssets addObject:asset];
    [self.selectAssetIds addObject:asset.asset.localIdentifier];
}

// 清除选中的图片
- (void)clearSelectAsset{
    [self.selectAssetIds removeAllObjects];
    [self.selectAssets removeAllObjects];
}

// 移除选中的Asset
- (void)removeAsset:(HLAsset *)asset{
    __block HLAsset *delAsset = nil;
    [self.selectAssets enumerateObjectsUsingBlock:^(HLAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.asset.localIdentifier isEqualToString:asset.asset.localIdentifier]) {
            delAsset = obj;
            *stop = YES;
        }
    }];
    if (delAsset) {
        [self.selectAssets removeObject:delAsset];
        [self.selectAssetIds removeObject:asset.asset.localIdentifier];
    }
}

// 获取下标
- (NSInteger)indexWithAssetId:(NSString *)assetId{
    if ([self.selectAssetIds containsObject:assetId]) {
        return [self.selectAssetIds indexOfObject:assetId];
    }
    return -1;
}

#pragma mark - Cache

// 获取缓存图片
- (UIImage *)cacheImageWithAssetId:(NSString *)assetId{
    if (self.cacheImageDict[assetId]) {
        return self.cacheImageDict[assetId];
    }
    return nil;
}

// 保存缓存图片
- (void)saveImage:(UIImage *)image assetId:(NSString *)assetId{
    self.cacheImageDict[assetId] = image;
}

// 清除缓存
- (void)clearCacheImageDict{
    [self.cacheImageDict removeAllObjects];
}

// 判断是否有缓存图片
- (BOOL)hasImageCacheWithAssetId:(NSString *)assetId{
    return self.cacheImageDict[assetId] != nil;
}

// 清除指定缓存
- (void)removeCacheImageWithAssetId:(NSString *)assetId{
    [self.cacheImageDict removeObjectForKey:assetId];
}

#pragma mark - Getter

- (NSMutableDictionary *)cacheImageDict{
    if (!_cacheImageDict) {
        _cacheImageDict = [NSMutableDictionary dictionary];
    }
    return _cacheImageDict;
}

- (HLImagePickerConfig *)config{
    if (!_config) {
        // 默认的配置信息
        _config = [[HLImagePickerConfig alloc] init];
        _config.mustResize = YES;
        _config.resizeWHScale = 1;
        _config.maxSelectNum = 9;
    }
    return _config;
}

- (NSMutableArray<HLAsset *> *)selectAssets{
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}

- (NSMutableArray<NSString *> *)selectAssetIds{
    if (!_selectAssetIds) {
        _selectAssetIds = [NSMutableArray array];
    }
    return _selectAssetIds;
}

@end
