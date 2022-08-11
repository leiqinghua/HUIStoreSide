//
//  HLSendOrderCodeInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSendOrderCodeInfo : NSObject

@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *tableNo;
@property (nonatomic, copy) NSString *cardNo1;
@property (nonatomic, copy) NSString *cardNo2;

@property (nonatomic, copy) NSArray *cardNoArr;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
