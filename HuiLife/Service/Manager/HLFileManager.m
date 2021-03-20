//
//  HLFileManager.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/14.
//

#import "HLFileManager.h"

@implementation HLFileManager

+ (BOOL)createDir:(NSString *)filePath {
    if (!filePath.length) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = YES;
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (!isExist) {
        NSError *error;
        if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
            isSuccess = NO;
            HLLog(@"creat Directory Failed:%@",[error localizedDescription]);
        }
    }
    
    return isSuccess;
}

//创建文件
+ (BOOL)createFile:(NSString *)filePath {
    if (!filePath.length) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = YES;
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (!isExist) {
        NSError *error;
        if (![fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
            isSuccess = NO;
            HLLog(@"creat Directory Failed:%@",[error localizedDescription]);
        }
    }
    
    return isSuccess;
}

//文件是否存在
+ (BOOL)existFile:(NSString *)filePath {
    if (!filePath.length) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

//删除某个文件/或者某个目录下的所有文件
+ (BOOL)deleteFile:(NSString *)filePath {
    if (!filePath.length) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = NO;
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        isSuccess = [fileManager removeItemAtPath:filePath error:&error];
    }
    return isSuccess;
}

+ (NSString *)cusExportDir {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath = [cachePath stringByAppendingPathComponent:kcusExportDir];
    if (![HLFileManager existFile:dirPath]) {
        if (![HLFileManager createDir:dirPath]) return @"";
    }
    return dirPath;
}

+ (NSString *)pathWithDir:(NSString *)dirName {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath = [cachePath stringByAppendingPathComponent:dirName];
    if (![HLFileManager existFile:dirPath]) {
        if (![HLFileManager createDir:dirPath]) return @"";
    }
    return dirPath;
}
@end
