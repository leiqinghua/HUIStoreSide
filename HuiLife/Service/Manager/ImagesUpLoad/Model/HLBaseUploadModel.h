//
//  HLBaseUploadModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HLBaseUploadStatusNone, // 未上传
    HLBaseUploadStatusUploading, // 上传中
    HLBaseUploadStatusUploaded, // 上传完毕
    HLBaseUploadStatusFailure, // 上传失败
} HLBaseUploadStatus;

// 进度回调
typedef void(^HLBaseUploadProgress)(CGFloat progress);

// 成功回调
typedef void(^HLBaseUploadSuccess)(void);

// 失败回调
typedef void(^HLBaseUploadFailure)(void);

@interface HLBaseUploadModel : NSObject

/**上传成功后返回的url*/
@property (nonatomic, copy) NSString *imgUrl;

// 是否是京东服务器
@property (nonatomic, assign) BOOL isStoreService;

/**上传成功后返回的数据（需要多个参数）*/
@property (nonatomic, strong) NSDictionary *responseData;

/**选择后的图片*/
@property (nonatomic, strong) UIImage *image;
/**上传状态*/
@property (nonatomic, assign) HLBaseUploadStatus uploadStatus;
/**进度0~1*/
@property (nonatomic, assign) CGFloat progress;
/**当前是第几张图片*/
@property (nonatomic, copy) NSString *index;

/**进度回调*/
@property (nonatomic, copy) HLBaseUploadProgress uploadProgressBlock;
/**成功回调*/
@property (nonatomic, copy) HLBaseUploadSuccess uploadSuccessBlock;
/**失败回调*/
@property (nonatomic, copy) HLBaseUploadFailure uploadFailureBlock;

/// 需要请求的url
@property (nonatomic, copy) NSString *requestApi;
@property (nonatomic, copy) NSString *saveName;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *uploadedImgUrlKey;
@property (nonatomic, copy) NSDictionary *postParams;

- (void)asyncConcurrentUploadSuccess:(HLBaseUploadSuccess)successBlcok progress:(HLBaseUploadProgress)progressBlock failure:(HLBaseUploadFailure)failureBlock;

@end

NS_ASSUME_NONNULL_END
