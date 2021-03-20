//
//  HLJDAPIManager.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/11.
//

#import "HLJDAPIManager.h"
#import <AWSCore.h>
#import <AWSS3.h>

// 配置自己应用的accessKey和secretKey，demo中这样做不安全，应该从加密接口中获取accessKey和secretKey
NSString *const accessKey = @"7EE8203013C7A021671B3C389F830789";
NSString *const secretKey = @"C60374220BABF769CBE900CD2C19A044";
//外网地址 endPoint
NSString *const serverUrl = @"https://s3.cn-north-1.jdcloud-oss.com";

NSString *const videoBucket = @"hui-v";
NSString *const imageBucket = @"hui-album";
NSString *const videoDomain = @"http://hui-v.s3.cn-north-1.jcloudcs.com";
NSString *const imageDomain = @"http://hui-album.s3.cn-north-1.jcloudcs.com";

@interface HLJDAPIManager ()

@property(nonatomic,copy)HLJDUploadResult completion;

@property(nonatomic,copy)HLJDUploadProgress progressBlock;

//保存上传失败的request
@property(nonatomic,strong)NSMutableDictionary * failRequests;

@end

@implementation HLJDAPIManager

static HLJDAPIManager * _instance;
+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HLJDAPIManager alloc]init];
    });
    return _instance;
}


-(void)registerJDAPI{
    [AWSDDLog addLogger:AWSDDTTYLogger.sharedInstance];
    AWSDDLog.sharedInstance.logLevel = AWSDDLogLevelInfo;
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:accessKey secretKey:secretKey];
    AWSEndpoint *endPoint = [[AWSEndpoint alloc] initWithURLString:serverUrl];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                                    endpoint:endPoint
                                                                         credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

//上传文件
-(void)uploadFileWithFilePath:(NSString *)filePath video:(BOOL)video completion:(HLJDUploadResult)completion progress:(HLJDUploadProgress)progressBlock{
    
    _completion = completion;
    _progressBlock = progressBlock;
    
    NSString *fileName = filePath.lastPathComponent;
    NSString *contentType;
    if ([fileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
        contentType = @"application/pdf";
    } else if ([fileName.pathExtension.lowercaseString isEqualToString:@"txt"]) {
        contentType = @"text/plain";
    } else {
        // demo中仅三种文件，若需要上传其他文件需配置相应的contentType，参见: http://tool.oschina.net/commons
        contentType = @"application/octet-stream";
    }
    // 当前用户的ID
    NSString *const currentUserId = [[NSUUID UUID] UUIDString];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = [currentUserId stringByAppendingPathComponent:fileName];
    uploadRequest.bucket = video?videoBucket:imageBucket;
    uploadRequest.contentType = contentType;
    __weak typeof(self) weakSelf = self;
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        CGFloat progress = totalBytesSent * 1.0 / totalBytesExpectedToSend;
        weakSelf.progressBlock(progress);
    };
//    开始上传
    [self upload:uploadRequest video:video fileName:fileName];
}


- (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest video:(BOOL)video fileName:(NSString *)name{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    __weak typeof(self) weakSelf = self;
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            
            [self.failRequests setValue:uploadRequest forKey:name];
            
            if (weakSelf.completion) {
                weakSelf.completion(@"", -1);
            }
            
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:{}
                        break;
                    default:
                        HLLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                HLLog(@"Upload failed: [%@]", task.error);
            }
            
        }
//        上传成功
        if (task.result) {
            NSString * url = [NSString stringWithFormat:@"%@/%@",video?videoDomain:imageDomain,uploadRequest.key];
            if (weakSelf.completion) {
                weakSelf.completion(url, 1);
            }
            
            [self.failRequests removeObjectForKey:name];
        }
        return nil;
    }];
}


-(void)reUploadWithFileName:(NSString * )fileName video:(BOOL)video{
    AWSS3TransferManagerUploadRequest * request = [self.failRequests objectForKey:fileName];
    if (request) {
        [self upload:request video:video fileName:fileName];
    }
}

-(NSMutableDictionary *)failRequests{
    if (!_failRequests) {
        _failRequests = [NSMutableDictionary dictionary];
    }
    return _failRequests;
}
@end
