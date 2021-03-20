//
//  HLActionSheet.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/26.
//

#import <Foundation/Foundation.h>
#import "WHActionSheet.h"

@interface HLActionSheet : NSObject
/// 个人信息编辑页面展示样式
+ (WHActionSheet *)showActionSheetWithDataSource:(NSArray *)dataSource delegate:(id)delegate;

@end

