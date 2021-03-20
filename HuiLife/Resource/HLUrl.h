//
//  HLUrl.h
//  HuiLife
//
//  Created by 雷清华 on 2018/7/11.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HLNormalService,
    HLStoreService,
} HLServiceType;//服务器地址 类型

@interface HLUrl : NSObject

@property(nonatomic,assign)HLServiceType serviceType;

/*** H5页面地址前缀 ***/
@property (nonatomic,strong) NSString *H5url;
//h5url

//获取基地址
+(NSString *)baseUrlWithType:(HLServiceType)type;

//获取公共参数
+ (NSString *)commonParam;
//上传图片
+ (NSString *)uploadImageUrl;
//商品
+ (NSString *)shopUrl;
//菜品
+ (NSString *)caiPinUrl;
//统计
+ (NSString *)tongjiUrl;

@end
