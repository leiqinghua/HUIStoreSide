//
//  HLSendOrderMainInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderSecondFuncInfo;
@class HLSendOrderSecondInfo;
@interface HLSendOrderMainInfo : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *butName;
@property (nonatomic, copy) NSString *iosArdess;
@property (nonatomic, copy) NSDictionary *iosParam;
@property (nonatomic, copy) NSArray <HLSendOrderSecondInfo *>*second;

///  iosArdess iosParam
@property (nonatomic, copy) NSDictionary *manageShow;

@end

@interface HLSendOrderSecondInfo : NSObject

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, copy) NSString *savekey; // 需要保存提交的参数
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSArray <HLSendOrderSecondFuncInfo *>*items;

/// 存储的是长度
@property (nonatomic, copy) NSArray *itemWidthArr;

@property (nonatomic, assign) CGFloat cellHight;

/// 获取需要保存的数据
- (NSDictionary *)buildParams;

@end

@interface HLSendOrderSecondFuncInfo : NSObject

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iosArdess;
@property (nonatomic, copy) NSDictionary *iosParam;

@end

NS_ASSUME_NONNULL_END
