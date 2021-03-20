//
//  HLExportInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/10/12.
//

#import "HLCardExportInfo.h"

@implementation HLCardExportInfo

- (BOOL)done {
    if (_filePath.length) { //若本地文件存在，表示已经下载
        _done = YES;
    } else {
        //如果不存在，先查看本地是否有该目录
        NSString *dirPath = [HLFileManager pathWithDir:kcardExportDir];
        if (dirPath.length) {
            NSString *filePath = [dirPath stringByAppendingPathComponent:_cardUrl.lastPathComponent];
            if ([HLFileManager existFile:filePath]) { //如果存在
                _done = YES;
                _filePath = filePath;
            }
        }
    }
    return _done;
}

@end
