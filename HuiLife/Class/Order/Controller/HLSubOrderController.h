//
//  HLSubOrderController.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/27.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLSubOrderController : HLBaseViewController

//0待处理 1配送中 2已完成 3退款 4未使用
@property(assign,nonatomic)NSInteger type;
//当前的日期
@property(copy,nonatomic)NSString *currentDate;

-(void)reloadDataWithDates:(NSArray *)dates tag:(NSInteger)tag;

-(void)loadList;

-(void)updateFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
