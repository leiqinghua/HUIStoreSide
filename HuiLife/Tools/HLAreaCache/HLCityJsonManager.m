//
//  HLCityJsonManager.m
//  HuiLifeUserSide
//
//  Created by 王策 on 2019/7/4.
//  Copyright © 2019 wce. All rights reserved.
//

#import "HLCityJsonManager.h"

#define kCityJsonName @"allcity.json"
#define kCityUpCodeKey @"cityUpCodeKey"

@implementation HLCityJsonManager

+ (NSString *)citySaveUpCode{
    return [HLUSER_DEFAULT objectForKey:kCityUpCodeKey] ?:@"";
}

+ (void)saveUpCode:(NSString *)upCode{
    [HLUSER_DEFAULT setObject:upCode forKey:kCityUpCodeKey];
    [HLUSER_DEFAULT synchronize];
}

+ (void)loadAreaDataWithController:(HLBaseViewController *)controller callBack:(HLCityJsonCallBack)callBack{
    
//    if ([self loadAreaFromLocal].count) {
//        callBack([self loadAreaFromLocal]);
//        return;
//    }
    // 如果没有那么就拉取，存到本地
    HLLoading(controller.view);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"https://sapi.51huilife.cn/city.json";
        request.downloadSavePath = [self cacheFilePath];
        request.requestType = kXMRequestDownload;
        request.hideError = YES;
    } onSuccess:^(id  _Nullable responseObject) {
        HLHideLoading(controller.view);
        if (callBack) {
            callBack([self loadAreaFromLocal]);
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(controller.view);
        if (callBack) {
            callBack([self loadAreaFromLocal]);
        }
    }];
}


// 判断本地是否有 使用静态变量，app杀死进程，重新获取
+ (BOOL)isExistAreaCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:[self cacheFilePath]];
    return result;
}


// 从本地读取
+ (NSArray *)loadAreaFromLocal{
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self cacheFilePath]];
    if (!data) {
        return nil;
    }
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
}

// 写入本地plist
+ (void)cacheAreaData:(NSArray *)areaData{
    NSString *filePath = [self cacheFilePath];
    [areaData writeToFile:filePath atomically:YES];
}

// 获取缓存路径
+ (NSString *)cacheFilePath{
    //这个方法获取出的结果是一个数组.因为有可以搜索到多个路径.
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //拼接文件路径
    NSString *filePathName = [docPath stringByAppendingPathComponent:kCityJsonName];
    NSLog(@"%@",filePathName);
    return filePathName;
}


@end
