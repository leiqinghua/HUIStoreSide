//
//  HLAreaCache.m
//  HuiLife
//
//  Created by HuiLife on 2018/9/20.
//

#import "HLAreaCache.h"

static BOOL isLoad = NO; // 静态变量

@implementation HLAreaCache

+ (void)loadAreaDataWithCallBack:(HLAreaCacheCallBack)callBack{
    // 如果本地有，那么直接取
    if ([self isExistAreaCache]) {
        if (callBack) {
            callBack([self loadAreaFromLocal]);
        }
        return;
    }
    HLLoading(nil);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/area.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(nil);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self cacheAreaData:result.data];
            if (callBack) {
                callBack(result.data);
            }
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(nil);
    }];
    
    
}

// 判断本地是否有 使用静态变量，app杀死进程，重新获取
+ (BOOL)isExistAreaCache{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL result = [fileManager fileExistsAtPath:[self cacheFilePath]];
//    NSLog(@"%@",[self cacheFilePath]);
    return isLoad;
}

// 从本地读取
+ (NSArray *)loadAreaFromLocal{
    NSArray *areaArray = [NSArray arrayWithContentsOfFile:[self cacheFilePath]];
    return areaArray;
}

// 写入本地plist
+ (void)cacheAreaData:(NSArray *)areaData{
    NSString *filePath = [self cacheFilePath];
    NSLog(@"%@",filePath);
    [areaData writeToFile:filePath atomically:YES];
    isLoad = YES;
}

// 获取缓存路径
+ (NSString *)cacheFilePath{
    //这个方法获取出的结果是一个数组.因为有可以搜索到多个路径.
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //在这里,我们指定搜索的是Cache目录,所以结果只有一个,取出Cache目录
    NSString *cachePath = array[0];
    //拼接文件路径
    NSString *filePathName = [cachePath stringByAppendingPathComponent:@"area.plist"];
    
    return filePathName;
}

@end
