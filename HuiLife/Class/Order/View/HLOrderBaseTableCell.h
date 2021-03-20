//
//  HLOrderBaseTableCell.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/22.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseTableViewCell.h"
#import "HLSubOrderLayout.h"
#import "HLOrderOpetionDelegate.h"
#import "HLOrderFunctionView.h"
NS_ASSUME_NONNULL_BEGIN

/// 子类需要实现的协议（协议的定义最好写在类的前面）
@protocol HLOrderCellDelegate <NSObject>

@optional

- (NSInteger)hl_numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)hl_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)hl_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)hl_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)hl_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (UIView *)hl_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (CGFloat)hl_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

- (CGFloat)hl_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

@end


@interface HLOrderBaseTableCell : HLBaseTableViewCell <HLOrderCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) HLBaseOrderLayout *orderLayout;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, weak) id <HLOrderOpetionDelegate>delegate;

@property(nonatomic, assign) NSInteger index;

@property(nonatomic, strong)HLOrderFunctionView *functionView;

@end

NS_ASSUME_NONNULL_END
