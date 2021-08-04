//
//  HLReviewModel.h
//  HuiLife
//
//  Created by 雷清华 on 2020/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLStatuInfo;
@class HLStatuFailInfo;
@interface HLReviewModel : NSObject
@property(nonatomic, strong) NSArray<HLStatuInfo *> *censors;
@property(nonatomic, strong) NSArray<HLStatuInfo *> *explains;
//：0:初始化（未提审），5：审核失败，8：审核异常，10：审核中；15：审核成功；
@property(nonatomic, assign) NSInteger state;
@property(nonatomic, copy) NSString *tips;
@property(nonatomic, strong) HLStatuFailInfo *history; //失败的原因
@property(nonatomic, copy) NSString *optionTitle;
@property(nonatomic, strong) NSAttributedString *tipAttr;
@end


@interface HLStatuInfo : NSObject
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *value;
@property(nonatomic, assign) NSInteger state;
@end

@interface HLStatuFailInfo : NSObject
@property(nonatomic, assign) NSInteger state;
@property(nonatomic, copy) NSString *stateDesc;
@property(nonatomic, copy) NSString *audit_content;//(html)
@property(nonatomic, copy) NSString *create_time;
@end
NS_ASSUME_NONNULL_END
//"state": "15",
//    "stateDesc": "正常",
//    "audit_content": "undefined",
//    "create_time": "2020-12-09 15:06:17"
