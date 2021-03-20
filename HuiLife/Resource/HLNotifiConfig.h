//
//  HLNotifiConfig.h
//  HuiLife
//
//  Created by 雷清华 on 2020/7/24.
//

#ifndef HLNotifiConfig_h
#define HLNotifiConfig_h

#define HLNotifyCenter [NSNotificationCenter defaultCenter]

#define HLUSER_DEFAULT [NSUserDefaults standardUserDefaults]

#define NOTIFY_LOGIN_STATE              @"notify_login_state"

#define HLReloadMineDataNotifi          @"HLReloadMineDataNotifi"

#define HLReloadShowTimeNotifi          @"HLReloadShowTimeNotifi"
//更新门店类别
#define HLModefyStoreClassNotifi        @"HLModefyStoreClassNotifi"
//刷新员工列表
#define HLReloadStaffDataNotifi         @"HLReloadStaffDataNotifi"
//刷新门店列表
#define HLReloadStoreDataNotifi         @"HLReloadStoreDataNotifi"
//刷新后台数据
#define HLReloadHomeDataNotifi          @"HLReloadHomeDataNotifi"
//刷新订单高度
#define HLReloadNewOrderHightNotifi     @"HLReloadNewOrderHightNotifi"
//点击订单的按钮
#define HLNewOrderClickedFunctionNotifi @"HLNewOrderClickedFunctionNotifi"
//刷新第一页数据
#define HLNewOrderReloadDataNotifi      @"HLNewOrderReloadDataNotifi"
//更新订单title的数量
#define HLNewOrderTitleNumsNotifi       @"HLNewOrderTitleNumsNotifi"
//本店收益，离店收益
#define HLOrderStoreProfitNotifi        @"HLOrderStoreProfitNotifi"
//更新蓝牙状态
#define HLUpdateBlueToothStateNotifi    @"HLUpdateBlueToothStateNotifi"
//添加打印机成功
#define HLAddPrinterSuccessNotifi       @"HLAddPrinterSuccessNotifi"
//蓝牙连接成功
#define HLConnectedBoolthNotifi         @"HLConnectedBoolthNotifi"
//蓝牙断开成功
#define HLDisConnectedBoolthNotifi      @"HLDisConnectedBoolthNotifi"
//隐藏状态栏
#define HLStatuBarHidenNotifi           @"HLStatuBarHidenNotifi"
//刷新消息页面
#define HLReloadMessagePageNotifi       @"HLReloadMessagePageNotifi"
//日期选择
#define HLCalanderSelectNotifi          @"HLCalanderSelectNotifi"
//更新卡列表
#define HLReloadCardListNotifi          @"HLReloadCardListNotifi"
//更新代金券列表
#define HLReloadTicketListNotifi        @"HLReloadTicketListNotifi"
//更新设置页面
#define HLReloadSetPageNotifi           @"HLReloadSetPageNotifi"

//微信登录授权后 更新微信头像
#define HLUpdateWXHeadeNotifi           @"HLUpdateWXHeadeNotifi"

//添加拼团成功
#define HLAddGroupNotifi                @"HLAddGroupNotifi"
//刷新爆客详情网页高度
#define HLHotReloadHtmlHightNotifi      @"HLHotReloadHtmlHightNotifi"
//推广工具
#define HLMarketToolReloadNotifi      @"HLMarketToolReloadNotifi"
//刷新锁客会员卡列表
#define HLReloadHUIMainListNotifi     @"HLReloadHUIMainListNotifi"
//刷新红包推广列表
#define HLReloadRedBagDataNotifi  @"HLReloadRedBagDataNotifi"

#endif /* HLNotifiConfig_h */
