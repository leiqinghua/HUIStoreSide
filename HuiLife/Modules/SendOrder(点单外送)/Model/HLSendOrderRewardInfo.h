//
//  HLSendOrderRewardInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSendOrderRewardInfo : NSObject

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, copy) NSString *money;

@end

NS_ASSUME_NONNULL_END
