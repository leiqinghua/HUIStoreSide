//
//  HLHotBuyKindModel.h
//  HuiLife
//
//  Created by 王策 on 2019/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHotBuyKindModel : NSObject

@property (nonatomic, copy) NSString *cat_name; // 分类名称
@property (nonatomic, assign) NSInteger cat_id; // 分类名称
@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, strong) NSMutableArray *child;

@end

NS_ASSUME_NONNULL_END
