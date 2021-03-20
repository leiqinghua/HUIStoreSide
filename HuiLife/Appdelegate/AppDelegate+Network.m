//
//  AppDelegate+Network.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/9.
//

#import "AppDelegate+Network.h"
#import "HLUserExpireView.h"

// 用户有效期过了的提示，是否展示了
static BOOL showExpireUpdateView = NO;

@implementation AppDelegate (Network)

- (void)hl_configNetWork{
    
    /*
     generalServer      公共服务端地址
     generalHeaders     公共请求头
     generalParameters  公共参数
     generalUserInfo    公共用户信息
     callbackQueue      请求的回调 Block 执行的 dispatch 队列（线程
     engine             底层请求的引擎
     consoleLog         是否在控制台输出请求和响应的信息
     */
    
    [XMCenter setupConfig:^(XMConfig * _Nonnull config) {
#if DEBUG
        config.consoleLog = YES;
#endif
        config.generalHeaders = @{};
        // 公共的请求数据
        config.generalParameters = @{};
        config.generalUserInfo = nil;
        config.callbackQueue = dispatch_get_main_queue();
        config.engine = [XMEngine sharedEngine];
    }];
    
    
    [XMCenter setRequestProcessBlock:^(XMRequest * _Nonnull request) {

        HLAccount *account = [HLAccount shared];
        if (account.token.length > 0) {
            NSMutableDictionary *mParams = [request.parameters mutableCopy];
            [mParams setValue:account.token forKey:@"token"];
            [mParams setValue:account.userid forKey:@"id"];
            [mParams setValue:account.lmpt_userid?:@"" forKey:@"pid"];
            [mParams setValue:account.userIdBuss?:@"" forKey:@"userIdBuss"];
            [mParams setValue:account.userIdBuss?:@"" forKey:@"uid"];

            request.parameters = mParams;
        }
        // 超时时间
        request.timeoutInterval = 15;
        
       request.headers = @{
          @"device-name":[HLTools systemDeviceType],      // 手机型号 iphonex
          @"device-alias":[HLTools deviceName],           // xx的iPhone
          @"sdk-version":[HLTools systemVersion],         // 10.2
          @"device-os":@"iOS",                                    // 系统
          @"device-id":[NSString UUID],                           // uuid
          @"app-official":@"ok",
          @"app-version-name":[HLTools appVersion],       // 系统版本号
          @"app-version-code":[[HLTools appVersion] stringByReplacingOccurrencesOfString:@"." withString:@""],     // 构建版本号
          @"language":[HLTools appLanguages],             // app语言
          @"id":account.userid?:@"",
          @"token":account.token?:@"",
          @"pid":account.lmpt_userid?:@"" ,//平台id
          @"uid":account.userIdBuss?:@""
          };
        
        // 如果是下载的类型请求
        if (request.requestType == kXMRequestDownload) {
            
            return;
        }
#if DEBUG
        // url的配置
        switch (request.serverType) {
            case HLServerTypeNormal:
                request.server = [HLUSER_DEFAULT objectForKey:NORMAL_SERVER_KEY] ?: NORMAL_TEST_SERVER;
                break;
            case HLServerTypeStoreService:
                request.server = [HLUSER_DEFAULT objectForKey:STORE_SERVER_KEY] ?: STORE_SERVICE_TEST_SERVER;
                break;
            case HLServerTypeNormalDomen:
                request.server = [HLUSER_DEFAULT objectForKey:NORMAL_DOMEN_SERVER_KEY] ?: NORMAL_DOMEN_TEST_SERVER;
                break;
            default:
                request.server = NORMAL_TEST_SERVER;
                break;
        }
        if ([request.api hasPrefix:@"http"]) {
            request.url = request.api;

        }else{
            request.url = [NSString stringWithFormat:@"%@%@",request.server,request.api];
        }
#else
        // url的配置
        switch (request.serverType) {
            case HLServerTypeNormal:
                request.server = NORMAL_PRODUCT_SERVER;
                break;
            case HLServerTypeStoreService:
                request.server = STORE_SERVICE_PRODUCT_SERVER;
                break;
            case HLServerTypeNormalDomen:
                request.server = NORMAL_DOMEN_PRODUCT_SERVER;
                break;
            default:
                request.server = NORMAL_PRODUCT_SERVER;
                break;
        }
        if ([request.api hasPrefix:@"http"]) {
            request.url = request.api;
            
        }else{
            request.url = [NSString stringWithFormat:@"%@%@",request.server,request.api];
        }
#endif
        
    }];
    
    // 这里是对结果的提前处理
    [XMCenter setResponseProcessBlock:^id(XMRequest * _Nonnull request, id  _Nullable responseObject, NSError *__autoreleasing  _Nullable * _Nullable error) {
        XMResult *result = [XMResult mj_objectWithKeyValues:responseObject];
        HLLog(@"responseObject = %@",responseObject);
        if (result.code == 405 ||result.code == 404 ||result.code == 201404 ) {
            dispatch_main_async_safe(^{
              [HLTools showExpireTokenView];
            });
            return result;
        }
        
        if (result.code == 201406) {
            if(!showExpireUpdateView){
                dispatch_main_async_safe(^{
                    [HLUserExpireView showUserExpireUpdateAlertTip:[result.msg stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] clickBlock:^{
                        [HLTools pushAppPageLink:@"HLStoreBuyMainController" params:nil needBack:NO];
                        showExpireUpdateView = NO;
                    }];
                });
            }
            return result;
        }
        
        if (!result.data) {
            return result;
        }
        
        if (result.code != 200 && result.code != 404 && result.code != 405 && result.code != 201404 && result.code != 201406 && !request.hideError) {
            [HLTools showWithText:result.msg];
            return result;
        }
        
        return result;
    }];
    
    /// http错误的处理
    [XMCenter setErrorProcessBlock:^(XMRequest * _Nonnull request, NSError *__autoreleasing  _Nullable * _Nullable error) {
        if (error && !request.hideError) {
#if DEBUG
         [HLTools showWithText:@"网络错误，请检查网络后重试"];
#endif
        }
    }];
}

@end
