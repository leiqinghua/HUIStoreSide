//
//  HLAccount.h
//  HuiLife
//
//  Created by 雷清华 on 2020/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HLAccount : NSObject <NSCoding>

+ (instancetype)shared ;

//===============================接口数据============================================
//员工id
@property(copy,nonatomic)NSString *userid;
//1管理员，2店长，3员工
@property(assign,nonatomic)NSInteger role;

@property(copy,nonatomic)NSString *token;
//是否有语音提示功能
@property(assign,nonatomic)BOOL is_yy;
//电话
@property(copy,nonatomic)NSString *mobile;
//用户名
@property(copy,nonatomic)NSString *name;
//店地址
@property(copy,nonatomic)NSString *store_address;
//店名
@property(copy,nonatomic) NSString *store_name;
//商户索引
@property(nonatomic, copy) NSString * userIdBuss;
//工号
@property(copy,nonatomic)NSString *user_name;

@property(copy,nonatomic)NSString *store_id;
//平台id
@property(copy,nonatomic)NSString *lmpt_userid;
//要推送的商户id
@property(strong,nonatomic)NSArray *push_store_id;
//0:未开启 1：开启（商家是否开启外卖到店点餐功能）
@property(assign,nonatomic)BOOL store_send;
//======================================自定义属性============================================
//是否管理员
@property(nonatomic, assign) BOOL admin;
//是否是店长
@property(assign,nonatomic)BOOL isDZ;

@property(assign,nonatomic)BOOL isUpdate;
//有没有登录
@property(nonatomic, assign) BOOL isLogin;
//1.自动 2.手动 3.自动和手动 4.都不选
@property (assign,nonatomic)NSInteger print_mode;
//打印模式1，所有订单 ，2.已支付订单
@property (assign,nonatomic)NSInteger order_mode;
//打印联数
@property (assign,nonatomic)NSInteger print_count;
//是否设置过打印机(存本地)
@property (nonatomic, assign) BOOL printSet;
//定位信息
@property(nonatomic, copy) NSString *latitude;
@property(nonatomic, copy) NSString *longitude;
@property(nonatomic, copy) NSString *locateJSON;

- (void)clearAll;
///退出登录
- (void)exitLogin;
//存放开启语音状态
- (void)saveYYStatu;
//存放打印机配置数据
+ (void)savePrinteData;
//保存数据到本地
+ (void)saveAcount;
@end

NS_ASSUME_NONNULL_END
