//
//  HLSelectArea.h
//  Test
//
//  Created by 闻喜惠生活 on 2018/8/28.
//  Copyright © 2018年 闻喜惠生活. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLSelectArea : UIView

@property (nonatomic, copy) void (^block)(NSString *,NSArray *);

- (instancetype)initWithArr:(NSArray *)areas;
@end
