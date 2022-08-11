//
//  HLJDAPIManager.h
//  HuiLife
//
//  Created by 雷清华 on 2019/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLJDUploadResult)(NSString * uploadUrl,NSInteger result);

typedef void(^HLJDUploadProgress)(CGFloat progress);

@interface HLJDAPIManager : NSObject

+ (instancetype)manager;
 
- (void)registerJDAPI;

//上传文件
-(void)uploadFileWithFilePath:(NSString *)filePath video:(BOOL)video completion:(HLJDUploadResult)completion progress:(HLJDUploadProgress)progressBlock;

//重新上传文件
-(void)reUploadWithFileName:(NSString * )fileName video:(BOOL)video;

@end

NS_ASSUME_NONNULL_END
