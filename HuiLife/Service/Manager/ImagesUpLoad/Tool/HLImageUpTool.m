//
//  HLImageUpTool.m
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import "HLImageUpTool.h"

@interface HLImageUpTool ()


@property (nonatomic, assign) BOOL alreadyUpload;

@end

@implementation HLImageUpTool


- (void)asyncConcurrentGroupUploadArray:(NSArray<HLBaseUploadModel *> *)modelArray uploading:(void(^)(void))uploading completion:(void (^)(void))completion {
    
    if (!modelArray || modelArray.count<1) {
        return;
    }

    NSAssert((modelArray && modelArray.count>0), @"图片model数组nil");

    dispatch_group_t uploadGroup = dispatch_group_create();

    for (HLBaseUploadModel *model in modelArray) {
        if (!model.image || model.imgUrl || model.uploadStatus == HLBaseUploadStatusUploaded) { continue;}

        dispatch_group_enter(uploadGroup);
        [model asyncConcurrentUploadSuccess:^() {
            dispatch_group_leave(uploadGroup);
        } progress:^(CGFloat progress) {
            if (uploading) { uploading(); }
        } failure:^() {
            dispatch_group_leave(uploadGroup);
        }];
    }
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}


@end
