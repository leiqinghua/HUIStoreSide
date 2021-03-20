//
//  HLCustomerInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/9.
//

#import "HLCustomerInfo.h"

@implementation HLCustomerInfo

@end

@implementation HLExportRecordInfo

- (BOOL)done {
    if (_filePath.length) { //若本地文件存在，表示已经下载
        _done = YES;
    } else {
        //如果不存在，先查看本地是否有该目录
        NSString *dirPath = [HLFileManager pathWithDir:kcusExportDir];
        if (dirPath.length) {
            NSString *filePath = [dirPath stringByAppendingPathComponent:_fileUrl.lastPathComponent];
            if ([HLFileManager existFile:filePath]) { //如果存在
                _done = YES;
            }
        }
    }
    return _done;
}

@end

@implementation HLMonthActiveInfo

@end

