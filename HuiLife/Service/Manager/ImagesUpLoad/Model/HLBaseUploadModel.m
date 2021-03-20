//
//  HLBaseUploadModel.m
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import "HLBaseUploadModel.h"

@implementation HLBaseUploadModel


- (void)asyncConcurrentUploadSuccess:(HLBaseUploadSuccess)successBlcok progress:(HLBaseUploadProgress)progressBlock failure:(HLBaseUploadFailure)failureBlock {
    [HLBaseUploadModel uploadWithModel:self success:successBlcok progress:progressBlock failure:failureBlock];
}

/**
 抽取的公共的上传方法
 */
+ (void)uploadWithModel:(HLBaseUploadModel *)model success:(HLBaseUploadSuccess)successBlcok progress:(HLBaseUploadProgress)progressBlock failure:(HLBaseUploadFailure)failureBlock {
    
    if (!model) { return; }
    NSAssert(model, @"model为nil");
    
    model.uploadStatus = HLBaseUploadStatusUploading;
    
    // 压缩图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [HLTools compressImage:model.image toByte:2000 * 1024];
        dispatch_main_async_safe(^{
            [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
                request.hideError = YES;
                request.api = model.requestApi;
                request.requestType = kXMRequestUpload;
                request.serverType = model.isStoreService ? HLServerTypeStoreService : HLServerTypeNormal;
                request.parameters = model.postParams ? : @{};
                // 后台会生成图片名称
                [request addFormDataWithName:model.saveName fileName:@"data.jpg" mimeType:@"image/jpeg" fileData:data];
            } onProgress:^(NSProgress * _Nonnull progress) {
                dispatch_main_async_safe(^{
                    model.progress = (CGFloat)progress.completedUnitCount/progress.totalUnitCount;
                    if (progressBlock) {progressBlock(model.progress);}
                    if (model.uploadProgressBlock) {model.uploadProgressBlock(model.progress);}
                });
            } onSuccess:^(id  _Nullable responseObject) {
                
                XMResult *result = (XMResult *)responseObject;
                
                if ([(XMResult *)responseObject checkIsTokenExpire]) {
                    // 上传失败
                    model.uploadStatus = HLBaseUploadStatusFailure;
                    if (failureBlock) {failureBlock();}
                    if (model.uploadFailureBlock) {model.uploadFailureBlock();}
                    return;
                }
                
                if (result.code == 200) {
                    NSString *imgUrl = result.data[model.uploadedImgUrlKey];
                    if (!imgUrl) {
                        imgUrl = [result.data allValues].firstObject;
                    }
                    model.imgUrl = imgUrl;
                    
                    model.uploadStatus = HLBaseUploadStatusUploaded;
                    model.responseData = result.data;
                    if (successBlcok) {successBlcok();}
                    if (model.uploadSuccessBlock) {model.uploadSuccessBlock();}
                }else{
                    // 上传失败
                    model.uploadStatus = HLBaseUploadStatusFailure;
                    if (failureBlock) {failureBlock();}
                    if (model.uploadFailureBlock) {model.uploadFailureBlock();}
                }
            } onFailure:^(NSError * _Nullable error) {
                // 上传失败
                model.uploadStatus = HLBaseUploadStatusFailure;
                if (failureBlock) {failureBlock();}
                if (model.uploadFailureBlock) {model.uploadFailureBlock();}
            }];
        });
    });
}

@end
