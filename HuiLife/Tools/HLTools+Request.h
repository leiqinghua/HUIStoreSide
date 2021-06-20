//
//  HLTools+Request.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLTools.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^Success)(NSDictionary *);

typedef void(^UpLoadImageResult)(NSDictionary *_Nullable result, NSError * _Nullable error);

@interface HLTools (Request)

//打印小票
//type:1 手动,2 自动
+ (void)printDataWithOrderId:(NSString *)orderId printerSn:(NSString *)printerSn mode:(NSString *)mode type:(NSInteger)type success:(Success)success fail:(void(^)(void))fail;

//wifi打印
+ (void)wifiPrintWithOrderId:(NSString *)orderId wifiSn:(NSString *)wifiSn;

//检查更新
+ (void)updateVersionFromServer;

//上传图片
+ (void)uploadImage:(NSData *)data name:(NSString *)name url:(NSString *)url pargram:(NSDictionary *)pargram callBack:(UpLoadImageResult)result;


//分享 小程序
+ (void)shareWithId:(NSString *)Id type:(NSInteger)type controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion;

//分享 海报
+ (void)shareImageWithId:(NSString *)Id type:(NSInteger)type controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion;

//二维码
+ (void)saveQRCodeWithId:(NSString *)Id type:(NSInteger)type controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion;

//新的分享 接口
+ (void)shareWXWithId:(NSString *)Id controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion;

@end
NS_ASSUME_NONNULL_END
