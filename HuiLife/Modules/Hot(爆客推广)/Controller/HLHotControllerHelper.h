//
//  HLHotControllerHelper.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import <Foundation/Foundation.h>
#import "HLHotClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HLHotControllerDelegate <NSObject>
//将请求的大类结果返回
- (void)hl_mainRequestResultWithBigClasses:(nullable NSArray *)bigClasses;
//请求的小类结果
- (void)hl_mainRequestResultWithSubClasses:(nullable NSArray *)subClasses;

//请求列表回调
- (void)hl_mainList:(NSArray *)lists page:(NSInteger)page noMore:(BOOL)noMore ;

@end

@interface HLHotControllerHelper : NSObject

@property(nonatomic, weak) id<HLHotControllerDelegate>delegate;

//初始化方法
- (instancetype)initWithDelegate:(id<HLHotControllerDelegate>)delegate ;
/// 请求大类
/// @param loadCallBack 控制loading 显示 隐藏
- (void)hl_mainRequestBigClassWithLoading:(void(^)(BOOL))loadCallBack ;


/// 请求小类
/// @param bigId 对应的大类 Id
/// @param loadCallBack 控制loading 显示 隐藏
- (void)hl_mainRequestSubClassWithBigId:(NSString *)bigId loading:(void(^)(BOOL))loadCallBack;

/// 请求列表
/// @param bigId 大类id
/// @param subId 小类id
/// @param page 当前页
/// @param loadCallBack 控制loading 显示 隐藏
- (void)hl_mainRequestListWithBigId:(NSString *)bigId subId:(NSString *)subId page:(NSInteger)page loading:(void(^)(BOOL))loadCallBack ;


/// 请求裂变吐司
/// @param callBack 带回 pic ，content
- (void)hl_requestToastWithResult:(void(^)(NSArray *))callBack;

@end

NS_ASSUME_NONNULL_END
