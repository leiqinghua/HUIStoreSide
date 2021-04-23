//
//  HLVideoProductModel.h
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLVideoProductModel : NSObject

@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double sale;
@property (nonatomic, copy) NSString *content;
// 0 未选择 1 已使用  已选择，需要上级页面回显
@property (nonatomic, assign) NSInteger state;

@end

NS_ASSUME_NONNULL_END
