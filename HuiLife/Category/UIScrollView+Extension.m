//
//  UITableView+Extension.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error;
        BOOL result = [[self class] jr_swizzleMethod:@selector(initWithFrame:style:)
                                          withMethod:@selector(hl_initWithFrame:style:)
                                               error:&error];
        if (!result || error) {
            HLLog(@"Can't swizzle methods - %@", [error description]);
        }
    });
}

//- (instancetype)hl_initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
//    UITableView * tableView = [self hl_initWithFrame:frame style:style];
//        tableView.estimatedRowHeight = 0;
//        tableView.estimatedSectionHeaderHeight = 0;
//        tableView.estimatedSectionFooterHeight = 0;
//    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
//    tableView.sectionIndexColor = [UIColor darkGrayColor];
//    return tableView;
//}

- (void)headerWithRefreshingBlock:(void(^)(void))block{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        block();
    }];
    self.mj_header = header;
}

- (void)footerWithRefreshingBlock:(void(^)(void))block{
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        block();
    }];
    
    self.mj_footer = footer;
}


- (void)headerNormalRefreshingBlock:(void(^)(void))block{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        block();
    }];
    header.stateLabel.textColor = UIColorFromRGB(0x999999);
    header.stateLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = [UIImage new];
    self.mj_header = header;
}


-(void)footerWithEndText:(NSString *)text refreshingBlock:(void (^)(void))block{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        block();
    }];
    footer.stateLabel.textColor = UIColorFromRGB(0x999999);
    footer.stateLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [footer setTitle:text forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
}

- (void)endRefresh{
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void)endNomorData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)hideFooter:(BOOL)hide{
    self.mj_footer.hidden = hide;
}

- (void)resetFooter {
    [self.mj_footer resetNoMoreData];
}
@end
