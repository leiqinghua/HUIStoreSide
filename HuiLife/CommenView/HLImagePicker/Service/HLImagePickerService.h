//
//  HLImagePickerService.h
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import <Foundation/Foundation.h>
#import "HLAsset.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLFetchAssetBlock)(NSArray <HLAsset *>*assets);

typedef void(^HLLoadImageBlock)(UIImage *image, BOOL isDegraded);
typedef void(^HLLoadImageProgress)(double progress, NSError *error, BOOL *stop, NSDictionary *info);

@interface HLImagePickerService : NSObject

// collectionView中加载大图使用用的
+ (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;

// 获取指定宽度的图片
+ (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

//// 同步获取原图
//+ (UIImage *)loadOrinalImageWithAsset:(PHAsset *)asset;

// 保存图片到相册
+ (void)savePhotoWithImage:(UIImage *)image meta:(NSDictionary *)meta location:(CLLocation *)location completion:(void (^)(PHAsset *asset, NSError *error))completion;

// 通过assets数组获取图片，needOrinalImage 是否需要获取原图
+ (void)imagesWithAssets:(NSArray *)assets needOrinalImage:(BOOL)needOrinalImage finishBlock:(void(^)(NSArray *images))finishBlock;

// 获取所有相册
+ (void)getAllImageAlbumsWithNeedFetchAssets:(BOOL)needFetchAssets completion:(void (^)(NSArray<HLAlbum *> *))completion;

// 获取封面图
+ (PHImageRequestID)getPostImageWithAlbumModel:(HLAlbum *)model completion:(void (^)(UIImage *))completion;

// 获取相册里面的所有图片
+ (void)getAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSArray<HLAsset *> *))completion;

@end

NS_ASSUME_NONNULL_END
