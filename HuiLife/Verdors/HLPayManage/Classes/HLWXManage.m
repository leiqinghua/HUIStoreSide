//
//  HLWXManage.m
//  HLPayManage_Example
//
//  Created by 王策 on 2019/9/2.
//  Copyright © 2019 王策. All rights reserved.
//

#import "HLWXManage.h"
#import "WXApi.h"

@interface HLWXManage () <WXApiDelegate>

@property (nonatomic, copy) HLPayFinishBlock payFinishBlock;

@property (nonatomic, copy) HLAuthFinishBlock authFinishBlock;
@end

@implementation HLWXManage

/// 注册WxAppKey
+ (void)registWxAppKey:(NSString *)wxAppKey urlLinks:(NSString *)urlLinks{
    [WXApi registerApp:wxAppKey universalLink:urlLinks];
}


/// 检查是否有微信客户端
- (BOOL)wxAppIsInstalled{
    return [WXApi isWXAppInstalled];
}

/// 处理url
- (BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

/// 准备支付
- (void)prepareWXPayWithPayParams:(NSDictionary *)payParams finishBlock:(HLPayFinishBlock)finishBlock{
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = payParams[@"partnerid"];
    request.prepayId = payParams[@"prepayid"];
    request.package = payParams[@"package"];
    request.nonceStr = payParams[@"noncestr"];
    request.timeStamp = [payParams[@"timestamp"] intValue];
    request.sign = payParams[@"sign"];
    request.openID = payParams[@"appid"];
    
    self.payFinishBlock = finishBlock;
    
    [WXApi sendReq:request completion:nil];
}

/// 分享文字消息, req.bText = YES
+ (void)shareToWXWithText:(NSString *)text scene:(HLSceneType)scene{
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = text;
    req.scene = scene==0?WXSceneSession:WXSceneTimeline;
    // 发送请求
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

/// 分享多媒体消息
+ (void)shareToWXWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image link:(NSString *)link scene:(HLSceneType)scene{
    
    NSData *thumbData = [self compressImage:image toByte:32 * 1024];
    UIImage *thumbImage = [UIImage imageWithData:thumbData];
    
    // 创建多媒体消息结构体
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;              //标题
    message.description = description;  //描述
    [message setThumbImage:thumbImage];      //设置预览图
    
    // 创建网页数据对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = link;
    message.mediaObject = webObj;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;         //不使用文本信息
    sendReq.message = message;
    sendReq.scene = scene==0?WXSceneSession:WXSceneTimeline;      //指定分享场景
    [WXApi sendReq:sendReq completion:nil];    //发送对象实例
}

/// 分享图片
+ (void)shareToWXWithImage:(UIImage *)image scene:(HLSceneType)scene{

    NSData *imageData = [self compressImage:image toByte:25 * 1024 * 1024];
    
    WXImageObject *imageObject = [[WXImageObject alloc] init];
    imageObject.imageData = imageData;
    
    WXMediaMessage *imageMessage = [WXMediaMessage message];
    imageMessage.mediaObject = imageObject;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;
    sendReq.scene = scene==0?WXSceneSession:WXSceneTimeline;
    sendReq.message = imageMessage;

    [WXApi sendReq:sendReq completion:nil];
}

/// 分享小程序
+ (void)shareToWXWithMiniProgramUserName:(NSString *)userName title:(NSString *)title description:(NSString *)description image:(UIImage *)image webpageUrl:(NSString *)webpageUrl path:(NSString *)path{
    
    NSData * hdImageData = [self compressImage:image toByte: 128 * 1024];
    NSData * thumbData = [self compressImage:image toByte: 32 * 1024];
    
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = webpageUrl;
    object.userName = userName;
    object.path = path;
    object.hdImageData = hdImageData;
    object.withShareTicket = YES;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.thumbData = thumbData;  //兼容旧版本节点的图片，小于32KB，新版本优先
    //使用WXMiniProgramObject的hdImageData属性
    message.mediaObject = object;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    [WXApi sendReq:req completion:nil];
}

+ (void)jumpToWXMiniProgramWithUserName:(NSString *)userName path:(NSString *)path json:(NSString *)json {
    WXLaunchMiniProgramReq *object = [WXLaunchMiniProgramReq object];
    object.userName = userName;
    object.path = path;
    object.extMsg = json;
//    object.miniProgramType =
    
    [WXApi sendReq:object completion:nil];
}

#pragma mark - 压缩图片

// 压缩图片
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

- (void)sendAuthRequestWithScope:(NSString *)scope state:(NSString *)state  finishBlock:(HLAuthFinishBlock)finishBlock{
    
    self.authFinishBlock = finishBlock;
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = scope;
    req.state = state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:nil];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void)onReq:(BaseReq*)req{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 *resp具体的回应内容，是自动释放的
 */
-(void)onResp:(BaseResp *)resp{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSInteger result = 0;
        switch (resp.errCode) {
            case WXSuccess:
                result = 0;
                if (self.payFinishBlock) {self.payFinishBlock(YES, @"支付成功");};
                break;
            case WXErrCodeUserCancel:
                if (self.payFinishBlock) {self.payFinishBlock(NO, @"用户取消支付");};
                result = 1;
                break;
            default:
                if (self.payFinishBlock) {self.payFinishBlock(NO, @"支付失败");};
                result = 2;
                break;
        }
    }
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * authResp = (SendAuthResp *)resp;
        switch (resp.errCode) {
            case WXSuccess:
                if (self.authFinishBlock) {self.authFinishBlock(authResp.code, @"用户同意授权", authResp.state);};
                break;
            case WXErrCodeAuthDeny:
                if (self.authFinishBlock) {self.authFinishBlock(authResp.code, @"用户拒绝授权", authResp.state);};
                break;
            default:
                if (self.authFinishBlock) {self.authFinishBlock(authResp.code, @"用户取消授权", authResp.state);};
                break;
        }
    }
}

@end
