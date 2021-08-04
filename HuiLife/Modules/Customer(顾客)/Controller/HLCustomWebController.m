//
//  HLCustomWebController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/16.
//

#import "HLCustomWebController.h"
@interface HLCustomWebController ()

@end

@implementation HLCustomWebController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setBackImage:@"back_oriange"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    本店收益 ,或离店收益
    [self addScriptMessageHandlerWithMethod:kiOSOnAOffStoreMethod];
    
    UIButton *manageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(60), FitPTScreen(20))];
    [manageBtn setTitle:@"会员管理" forState:UIControlStateNormal];
    manageBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [manageBtn setTitleColor:UIColorFromRGB(0xFD9E2F) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:manageBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [manageBtn addTarget:self action:@selector(manageClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hl_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:kiOSOnAOffStoreMethod]) {
        NSDictionary *body = message.body;
        NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
        [controllers removeObject:self];
        self.navigationController.viewControllers = controllers;
        [HLNotifyCenter postNotificationName:HLOrderStoreProfitNotifi object:body];
    }
}

- (void)manageClick {
    [HLTools pushAppPageLink:@"HLCardManageController" params:@{} needBack:NO];
}

@end
