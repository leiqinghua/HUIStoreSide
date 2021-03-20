//
//  HLVoucherBankInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLVoucherBankInfo : NSObject

@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *inst_out_code;

@property (nonatomic, assign) BOOL select;

@end

NS_ASSUME_NONNULL_END
