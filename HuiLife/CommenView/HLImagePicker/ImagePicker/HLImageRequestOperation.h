//
//  HLImageRequestOperation.h
//  HuiLife
//
//  Created by 王策 on 2019/12/11.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLImageRequestOperation : NSOperation


typedef void(^TZImageRequestCompletedBlock)(UIImage *photo, NSDictionary *info, BOOL isDegraded);
typedef void(^TZImageRequestProgressBlock)(double progress, NSError *error, BOOL *stop, NSDictionary *info);

@property (nonatomic, copy, nullable) TZImageRequestCompletedBlock completedBlock;
@property (nonatomic, copy, nullable) TZImageRequestProgressBlock progressBlock;
@property (nonatomic, strong, nullable) PHAsset *asset;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

- (instancetype)initWithAsset:(PHAsset *)asset completion:(TZImageRequestCompletedBlock)completionBlock progressHandler:(TZImageRequestProgressBlock)progressHandler;
- (void)done;

@end

NS_ASSUME_NONNULL_END
