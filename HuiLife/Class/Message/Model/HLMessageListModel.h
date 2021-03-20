//
//  HLMessageListModel.h
//  HuiLife
//
//  Created by HuiLife on 2018/9/18.
//

#import <Foundation/Foundation.h>

@interface HLMessageListModel : NSObject

@property (assign, nonatomic) NSInteger Id;

@property (copy, nonatomic) NSString *input_time;

@property (assign, nonatomic) double money;   // 钱

@property (copy, nonatomic) NSString *order_id;

@property (assign, nonatomic) NSInteger sodm;   // 1 收款 2退款

@property (copy, nonatomic) NSString *source; // 内容

@property (assign, nonatomic) NSInteger store_id;

@property (copy, nonatomic) NSString *store_name;

@property (copy, nonatomic) NSString *time;  // 区分每一组

@property (copy, nonatomic) NSString *type;

@end
