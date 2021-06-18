//
//  HLTools+Request.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLTools+Request.h"
#import "HLUpdateAlert.h"
#import <AFNetworking.h>

@implementation HLTools (Request)

+ (void)wifiPrintWithOrderId:(NSString *)orderId wifiSn:(NSString *)wifiSn {
    NSDictionary *pargram = @{
        @"order_id":orderId,
        @"type":@"",
        @"printer_sn":wifiSn
    };
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/PrinterProgress.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        // 处理数据
    } onFailure:^(NSError *error) {
        
    }];
}



+ (void)printDataWithOrderId:(NSString *)orderId type:(NSInteger)type success:(Success)success fail:(void(^)(void))fail {
  
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/PrinterProgressA.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"order_id":orderId};
    } onSuccess:^(id responseObject) {
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            //byte 数组（十进制）
            NSString *serverStr = result.data;
            // base64 解码
            NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:serverStr options:0];
            NSString *base64Str = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
            //json 转数组
            NSArray *jsonArr = [base64Str mj_JSONObject];
            NSMutableData *printeData = [[NSMutableData alloc]init];
            //遍历大数组
            for (NSArray *bytes in jsonArr) {
                //每个小数组 就是小票的一行信息，转成byte 数组
                Byte byteArr[bytes.count];
                for (int i = 0; i < bytes.count; i ++) {
                    unsigned long num = [bytes[i] integerValue];
                    byteArr[i] = num;
                }
                // 拼接成数据,打印
                [printeData appendBytes:byteArr length:bytes.count];
            }
            if (success)success(printeData);
            return ;
        }
        if (fail)fail();
    } onFailure:^(NSError *error) {
    }];
}

//{
//    "data": {
//        "times": 1,
//        "type": "23",
//        "items": {
//            "title": "HUI生活外卖-9",
//            "small_title": "[外卖配送]订单号：3475834",
//            "list": [{
//                "店铺名称": "优思麦小馆",
//                "下单时间": "2021-06-17 15:46:22",
//                "配送方式": "蜂鸟配送"
//            }, {
//                "收货人": "张先生",
//                "电话": "150****3930",
//                "地址": "北京运通博奥汽车销售服务有限公司汽配室"
//            }, {
//                "备注": "暂无订单备注"
//            }, {
//                "goods": [{
//                    "title": "拯救者",
//                    "price": "1.00",
//                    "num": "x1",
//                    "prices": "1.00"
//                }, {
//                    "title": "安吉白茶",
//                    "price": "0.03",
//                    "num": "x1",
//                    "prices": "0.03"
//                }, {
//                    "title": "300G红灯笼清油火锅底料",
//                    "price": "6.80",
//                    "num": "x1",
//                    "prices": "6.80"
//                }, {
//                    "title": "天然湖盐",
//                    "price": "1.00",
//                    "num": "x1",
//                    "prices": "1.00"
//                }, {
//                    "title": "飞利浦剃须刀 PQ190",
//                    "price": "127.80",
//                    "num": "x1",
//                    "prices": "127.80"
//                }, {
//                    "title": "美汁源果粒橙1.8L",
//                    "price": "11.50",
//                    "num": "x1",
//                    "prices": "11.50"
//                }],
//                "total_price": "148.13"
//            }, {
//                "包装费": "+ 1.00",
//                "红包优惠": "- 3.92",
//                "会员折扣": "- 7.22",
//                "实付金额": "137.99"
//            }],
//            "qr_url": "https:\/\/hshabc.cn\/ho\/?c=3475834",
//            "button": "HUI到家骑手取货码"
//        }
//    },
//    "code": 200,
//    "msg": "success"
//}


+ (void)updateVersionFromServer{
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/IosUpdate.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"versionName":[HLTools currentVersion]};
        request.hideError = YES;
    } onSuccess:^(id responseObject) {
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            NSDictionary *dataDict = result.data;
            // 弹出提示框 0不用更新 1小更新 2强制更新
            NSInteger UpdateStatus = [dataDict[@"UpdateStatus"] integerValue];
            if (UpdateStatus == 0) { // 说明不用更新
                //                清除本地存储的date
                [HLTools storeDate:nil];
                return;
            }
            if (![HLTools compareOneDay]) {
                return;
            }
            
            [HLAccount shared].isUpdate = YES;
            BOOL mustUpdate = NO;
            if(UpdateStatus == 2){
                mustUpdate = YES;
            }
            [HLUpdateAlert showUpdateAlertVersion:dataDict[@"VersionName"] content:dataDict[@"ModifyContent"] ?:@"" mustUpdate:mustUpdate callBack:^{
                [HLTools gotoAppstore];
            }];
        }
    } onFailure:^(NSError *error) {
    }];
    
}

//上传图片
+(void)uploadImage:(NSData *)data name:(NSString *)name url:(NSString *)url pargram:(NSDictionary *)pargram callBack:(UpLoadImageResult)result{
    
    [HLTools startLoadingAnimation];
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/json",nil];
    
    //根据当前系统时间生成图片名称
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString * fileName = [NSString stringWithFormat:@"%@.png",dateStr];
    
    [manager POST:url parameters:pargram constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"打印:图片上传中....%f",progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HLTools endLoadingAnimation];
        if (result) {
            result(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HLTools endLoadingAnimation];
        if (result) {
            result(nil,error);
        }
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

//分享 小程序
+ (void)shareWithId:(NSString *)Id type:(NSInteger)type controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion{
    HLLoading(controller.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Shareinfo/getShareInfo";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":@(type),@"proId":Id};
    }onSuccess:^(id responseObject) {
        HLHideLoading(controller.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) {
                completion(result.data);
            }
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(controller.view);
    }];
}

//分享 海报
+ (void)shareImageWithId:(NSString *)Id type:(NSInteger)type controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion{
    HLLoading(controller.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Shareinfo/getBusinessPoster";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":@(type),@"proId":Id};
    }onSuccess:^(id responseObject) {
        HLHideLoading(controller.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) {
                completion(result.data);
            }
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(controller.view);
    }];
}

//二维码
+ (void)saveQRCodeWithId:(NSString *)Id type:(NSInteger)type controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion {
    HLLoading(controller.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Shareinfo/getXcxErWeiMa";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"type":@(type),@"proId":Id};
    }onSuccess:^(id responseObject) {
        HLHideLoading(controller.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) {
                completion(result.data);
            }
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(controller.view);
    }];
}

//新的分享 接口
+ (void)shareWXWithId:(NSString *)Id controller:(HLBaseViewController *)controller completion:(void(^)(NSDictionary *))completion {
    HLLoading(controller.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/UnionCard/CardMore.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"cardId":Id};
    }onSuccess:^(id responseObject) {
        HLHideLoading(controller.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            if (completion) {
                completion(result.data);
            }
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(controller.view);
    }];
}
@end
