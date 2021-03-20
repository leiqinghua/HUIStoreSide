//
//  HLAsset.h
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLAsset : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) BOOL select; // 是否选中

@property (nonatomic, strong) UIImage *orignImage;  // 原图

@end


@class PHFetchResult;
@interface HLAlbum : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) PHFetchResult *result;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, assign) BOOL isCameraRoll;

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets;

@end


NS_ASSUME_NONNULL_END
