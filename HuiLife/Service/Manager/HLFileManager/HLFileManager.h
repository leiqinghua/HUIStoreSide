//
//  HLFileManager.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLFileManager : NSObject

//创建文件夹
+ (BOOL)createDir:(NSString *)filePath;

//创建文件
+ (BOOL)createFile:(NSString *)filePath ;

//文件是否存在
+ (BOOL)existFile:(NSString *)filePath;

//删除某个文件/或者某个目录下的所有文件
+ (BOOL)deleteFile:(NSString *)filePath;

//获取我的顾客存放导出文件的文件夹
+ (NSString *)cusExportDir;
//获取文件夹路径
+ (NSString *)pathWithDir:(NSString *)dirName;
@end

NS_ASSUME_NONNULL_END
