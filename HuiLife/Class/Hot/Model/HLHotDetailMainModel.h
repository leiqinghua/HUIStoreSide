//
//  HLHotDetailMainModel.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//推广方法
@interface HLHotFunction : NSObject

@property(nonatomic, copy) NSString *Id;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *pic;

@end

//案例
@interface HLHotCaseInfo : NSObject

@property(nonatomic, copy) NSString *Id;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *pic;
//描述
@property(nonatomic, copy) NSString *brief;

@property(nonatomic, copy) NSString *path;

@end

//头部标签
@interface HLFeature : NSObject

@property(nonatomic, copy) NSString *Id;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *colour;

@end


@interface HLHotAlertInfo : NSObject

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *subTitle;

@property(nonatomic, copy) NSString *pic;
//描述
@property(nonatomic, copy) NSString *subTitlePic;

@property(nonatomic, copy) NSString *author;

@property(nonatomic, copy) NSString *authorPic;

@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *wechatNotice;

@property(nonatomic, copy) NSString *wechatPic;

@property(nonatomic, copy) NSString *wechatNumber;

@property(nonatomic, copy) NSString *but;

@property(nonatomic, strong) NSArray *components;

@property(nonatomic, assign) BOOL is_state;

@end


@interface HLHotDetailMainModel : NSObject

@property(nonatomic, copy) NSString *Id;
//活动标题
@property(nonatomic, copy) NSString *title;
//活动说明
@property(nonatomic, copy) NSString *brief;
//预览图
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *pic;
//商家使用数量
@property(nonatomic, copy) NSString *shopUseNum;
//订单完成数量
@property(nonatomic, copy) NSString *orderNum;
@property(nonatomic, copy) NSString *typeName;
//推广方法
@property(nonatomic, strong) NSArray<HLHotFunction *> *generalizeFunList;

@property(nonatomic, strong) NSArray<HLFeature *> *featureList;

@property(nonatomic, strong) HLHotAlertInfo *zhuanJiaInfo;
//案例说明
@property(nonatomic, strong) NSArray<HLHotCaseInfo *> *caseInfo;

@property(nonatomic, strong) NSDictionary *create;

@property(nonatomic, assign) CGFloat funHight;

@property(nonatomic, assign) CGFloat caseHight;

@property(nonatomic, assign) CGFloat contentHight;

@end
NS_ASSUME_NONNULL_END
