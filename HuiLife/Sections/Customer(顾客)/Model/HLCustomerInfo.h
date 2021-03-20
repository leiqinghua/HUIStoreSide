//
//  HLCustomerInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCustomerInfo : NSObject
@property(nonatomic, copy) NSString *label;//标签
@property(nonatomic, copy) NSString *phone;//手机号
@property(nonatomic, copy) NSString *openType;//开卡方式
@property(nonatomic, copy) NSString *openProfit;//开卡收益
@property(nonatomic, copy) NSString *startTime;//办卡时间
@property(nonatomic, copy) NSString *endTime;//到期时间
@end

//导出记录
@interface HLExportRecordInfo : NSObject
@property(nonatomic, assign) NSInteger sum;//导出数量
@property(nonatomic, copy) NSString *fileName;//文件名
@property(nonatomic, copy) NSString *exportTime;//导出时间
@property(nonatomic, copy) NSString *fileUrl;//文件下载地址
@property(nonatomic, strong) NSString *filePath;//本地路径
@property(nonatomic, assign) BOOL done;//是否完成下载
@end


@interface HLMonthActiveInfo : NSObject
@property(nonatomic, copy) NSString *commission;//收益佣金
@property(nonatomic, copy) NSString *label;//会员标签
@property(nonatomic, copy) NSString *num;//消费总次数
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *price;//消费总金额
@end

NS_ASSUME_NONNULL_END
