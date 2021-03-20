//
//  HLUrl.m
//  HuiLife
//
//  Created by 雷清华 on 2018/7/11.
//

#import "HLUrl.h"

@implementation HLUrl

- (instancetype)init{
    if (self = [super init]) {
        _serviceType = HLNormalService;
    }
    return self;
}
- (instancetype)initWithType:(HLServiceType)type{
    if (self = [super init]) {
        _serviceType = type;
    }
    return self;
}

-(NSString *)H5url{
    switch (_serviceType) {
        case HLNormalService:
#if DEBUG
            return [HLUSER_DEFAULT objectForKey:NORMAL_SERVER_KEY] ?: NORMAL_TEST_SERVER;;
#else
            return @"https://sapi.51huilife.cn/HuiLife_Api";;
#endif
            break;
        case HLStoreService:
#if DEBUG
            return [HLUSER_DEFAULT objectForKey:STORE_SERVER_KEY] ?: STORE_SERVICE_TEST_SERVER;
#else
            return @"https://sp1api.51huilife.cn";
#endif
            break;
        default:
            break;
    }
}


//获取基地址
+(NSString *)baseUrlWithType:(HLServiceType)type{
    HLUrl * url = [[HLUrl alloc]init];
    url.serviceType = type;
    return url.H5url;
}


+ (NSString *)tongjiUrl{
    HLUrl * url = [[HLUrl alloc]init];
    if ([HLAccount shared].admin) {
         return [NSString stringWithFormat:@"%@%@?",url.H5url,@"/MerchantSide/Statistics.php"];
    }else if ([HLAccount shared].isDZ){
        return [NSString stringWithFormat:@"%@%@?",url.H5url,@"/MerchantSide/IncomeStatistics.php"];
    }
    return nil;
}

+ (NSString *)caiPinUrl{
    HLUrl * url = [[HLUrl alloc]init];
    return [NSString stringWithFormat:@"%@%@?%@",url.H5url,@"/FoodManager/index.php",[self commonParam]];

}

+ (NSString *)shopUrl{
    HLUrl * url = [[HLUrl alloc]init];
    return [NSString stringWithFormat:@"%@%@?%@",url.H5url,@"/GoodsManager/index.php",[self commonParam]];
}


+ (NSString *)uploadImageUrl{
    HLUrl * url = [[HLUrl alloc]init];
    return [NSString stringWithFormat:@"%@%@%@",url.H5url,@"/FoodManager/pic_upload.php?",self.commonParam];
}

+ (NSString *)commonParam{
    return [NSString stringWithFormat:@"token=%@&id=%@&platform=iOS&iType=%@",[HLAccount shared].token,[HLAccount shared].userid,[HLTools DeviceName]];

}


@end
