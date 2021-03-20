
//
//  MainTabBarController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/13.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "HLMessageViewController.h"
#import "UITabBar+HLBadge.h"
#import "HLNewMineViewController.h"
#import "HLNewOrderViewController.h"
#import "HLNavigationController.h"
#import "HLHotMainViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property(nonatomic,strong)UIView * networkView;

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self configureDefault];
    //    注册离店 本店收益通知
    [HLNotifyCenter addObserver:self selector:@selector(storeProfitNotifiction:) name:HLOrderStoreProfitNotifi object:nil];
}


- (void)configureDefault{
    
    if (iOS13Later) {
           //未选中下的颜色(ios10以后才有)
              UITabBar.appearance.unselectedItemTintColor = UIColorFromRGB(0x222222);
              //选中下的颜色(代替selectedImageTintColor)
              UITabBar.appearance.tintColor = UIColorFromRGB(0xFF8301);
       }
    HLNavigationController * orderNavi = [self controllerWithRoot:[HLNewOrderViewController new] normalImg:@"order_normal" selectImg:@"order_select" title:@"订单"];
    
//    HLNavigationController * hotNavi = [self controllerWithRoot:[HLHotMainViewController new] normalImg:@"hot_normal" selectImg:@"hot_select" title:@"爆客推广"];
    
    HLNavigationController * homeNavi = [self controllerWithRoot:[HomeViewController new] normalImg:@"ht_normal" selectImg:@"ht_select" title:@"管理"];
    
    HLNavigationController * messageNavi = [self controllerWithRoot:[HLMessageViewController new] normalImg:@"message_normal" selectImg:@"message_select" title:@"消息"];
    
    HLNavigationController * setNavi = [self controllerWithRoot:[HLNewMineViewController new] normalImg:@"set_normal" selectImg:@"set_select" title:@"设置"];
    
    self.viewControllers = @[orderNavi,homeNavi,messageNavi,setNavi];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:Is_have_message]) {
        [self.tabBar showBadgeOnItemIndex:3];
    }
//    默认打开爆客
    [self setSelectedIndex:1];
}

- (HLNavigationController *)controllerWithRoot:(HLBaseViewController*)baseVC normalImg:(NSString *)normal selectImg:(NSString *)select title:(NSString *)title{

    baseVC.tabBarItem.image = [[UIImage imageNamed:normal]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    baseVC.tabBarItem.selectedImage = [[UIImage imageNamed:select]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    baseVC.tabBarItem.title = title;
    NSDictionary * normalAttrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0x222222),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(12)]};
    NSDictionary * selectAttrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0xFF8301),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(12)]};
    [baseVC.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [baseVC.tabBarItem setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
    
    HLNavigationController * navi = [[HLNavigationController alloc]initWithRootViewController:baseVC];
    return navi;
}

#pragma mark - Event
- (void)storeProfitNotifiction:(NSNotification *)sender {
    HLNavigationController *navi = (HLNavigationController *)self.viewControllers.firstObject;
    HLNewOrderViewController *orderVC = (HLNewOrderViewController *)navi.viewControllers.firstObject;
    orderVC.profitDict = sender.object;
    if (!_clickOrder) {
        [self setSelectedIndex:0];
        return;
    }
    [orderVC configStoreProfitData];
    [self setSelectedIndex:0];
}
#pragma -UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"消息"]) {
        if ([self.tabBar isHaveBadge:2]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMessagePageNotifi object:nil];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
