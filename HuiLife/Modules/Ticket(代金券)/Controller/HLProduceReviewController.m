//
//  HLProduceReviewController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/16.
//

#import "HLProduceReviewController.h"
#import "HLTicketListController.h"
#import "HLCarMarketController.h"
//发布成功
#define HLiOSProduceSuccess @"HLiOSProduceSuccess"

@interface HLProduceReviewController ()

@end

@implementation HLProduceReviewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_interactivePopGestureRecognizerUseable];
    self.view.backgroundColor = UIColor.whiteColor;
    [self addScriptMessageHandlerWithMethod:HLiOSProduceSuccess];
}


-(void)hl_goFront{
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"你还完成发布 是否继续完成" buttonTitles:@[@"取消",@"继续发布"] buttonColors:@[UIColorFromRGB(0x333333),UIColorFromRGB(0xFF9F16)] callBack:^(NSInteger index) {
        if (index == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//交互管理
-(void)hl_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:HLiOSProduceSuccess]) {
        
        for (HLBaseViewController * vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[HLTicketListController class]]  && _isTicket) {
                [HLNotifyCenter postNotificationName:HLReloadTicketListNotifi object:nil];
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }else if ([vc isKindOfClass:[HLCarMarketController class]]  && !_isTicket){
                [HLNotifyCenter postNotificationName:HLReloadCardListNotifi object:nil];
                [self.navigationController popToViewController:vc animated:YES];
                 return;
            }
        }
    }
}

@end
