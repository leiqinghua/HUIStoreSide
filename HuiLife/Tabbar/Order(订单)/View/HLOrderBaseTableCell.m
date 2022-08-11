//
//  HLOrderBaseTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/22.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderBaseTableCell.h"


@interface HLOrderBaseTableCell () <HLOrderFunctionViewDelegate>

@end

@implementation HLOrderBaseTableCell


- (void)initSubView {
    [super initSubView];
    
    self.backgroundColor = UIColor.clearColor;
    
    self.bagView.layer.cornerRadius = FitPTScreen(7);
    self.bagView.layer.masksToBounds = YES;
    [self.bagView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(12), 0, FitPTScreen(12)));
    }];
    
   [self.bagView addSubview:self.tableView];
   [self.tableView makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.bagView);
   }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _functionView = [[HLOrderFunctionView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(350), FitPTScreen(57))];
        _functionView.delegate = self;
        _tableView.tableFooterView = _functionView;
    }
    return _tableView;
}

- (void)setOrderLayout:(HLBaseOrderLayout *)orderLayout {
    _orderLayout = orderLayout;
    CGRect frame = _functionView.frame;
    frame.size = CGSizeMake(FitPTScreen(350), orderLayout.functionHight);
    _functionView.frame = frame;
    _functionView.functions = orderLayout.orderModel.functions;
}

#pragma mark - HLOrderFunctionViewDelegate

- (void)functionView:(HLOrderFunctionView *)functionView typeIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(hl_functionWithTypeIndex:orderLayout:)]) {
        [self.delegate hl_functionWithTypeIndex:index orderLayout:_orderLayout];
    }
}

- (void)functionView:(HLOrderFunctionView *)functionView funName:(NSString *)name {
    if ([self.delegate respondsToSelector:@selector(hl_functionWithName:orderLayout:)]) {
        [self.delegate hl_functionWithName:name orderLayout:_orderLayout];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(hl_numberOfSectionsInTableView:)]) {
        return [self hl_numberOfSectionsInTableView:tableView];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(hl_tableView:numberOfRowsInSection:)]) {
        return [self hl_tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(hl_tableView:cellForRowAtIndexPath:)]) {
        return [self hl_tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(hl_tableView:heightForRowAtIndexPath:)]) {
        return [self hl_tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(hl_tableView:viewForHeaderInSection:)]) {
        return [self hl_tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(hl_tableView:viewForFooterInSection:)]) {
        return [self hl_tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(hl_tableView:heightForFooterInSection:)]) {
        return [self hl_tableView:tableView heightForFooterInSection:section];
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(hl_tableView:heightForHeaderInSection:)]) {
        return [self hl_tableView:tableView heightForHeaderInSection:section];
    }
    return 0.0;
}
@end
