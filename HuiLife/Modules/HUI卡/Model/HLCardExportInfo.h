//
//  HLCardExportInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCardExportInfo : NSObject
@property(nonatomic, assign) NSInteger cardCount;//卡数量
@property(nonatomic, copy) NSString *cardName;//联名卡名称
@property(nonatomic, copy) NSString *createTime;//生成时间
@property(nonatomic, copy) NSString *cardUrl;//文件地址(服务器)
@property(nonatomic, copy) NSString *filePath;//本地文件地址
@property(nonatomic, assign) BOOL done;//是否已经下载
@end

NS_ASSUME_NONNULL_END
