//
//  HLOrderLayoutManager.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/25.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSubOrderLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLOrderLayoutManager : NSObject


/// 生成数据Model
/// @param dataDict 服务端订单数据
+ (HLBaseOrderLayout *)orderLayoutWithDict:(NSDictionary *)dataDict tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
